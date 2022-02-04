
module ChromaProces(	
				input wire			iCLK27,
				input wire [9:0]	imVGA_R, //las pRTES de la imagen
				input wire [9:0]	imVGA_G,
				input wire [9:0]	imVGA_B,

				input wire [9:0] 	iRed,//la parte roja del pixel del video que entra
				input wire [9:0] 	iGreen,//la parte verde del pixel del video que entra
				input wire [9:0] 	iBlue,//la parte azul del pixel del video que entra
				
				output [9:0] gsRed, gsGreen, gsBlue
		);

					

wire isGreen;
wire imIsGreen;
wire [9:0] threshold;
wire [9:0] imRed, imGreen, imBlue;

assign threshold = 10'h1FF;
assign isGreen = (iGreen > threshold) & (iRed < threshold) & (iBlue < threshold);

// for checking green in image
assign imIsGreen = (imVGA_G == 10'h3FF) & (imVGA_R == 10'h1) & (imVGA_B == 10'h0); //esto es el verde a eliminar
//cuando todos son del tono que queremos TRUE si no False

//image to display in green screen areas

assign imRed = imVGA_R;
assign imGreen = imVGA_G;
assign imBlue = imVGA_B;

//green screen effect
assign gsRed = (isGreen ? imRed : iRed); 				//Es verde? si, entonces pongo la imagen de fondo
assign gsGreen = (isGreen ? imGreen : iGreen); 		//Lo mismo verde
assign gsBlue = (isGreen ? imBlue : iBlue);			//Lo mismo azul

endmodule 