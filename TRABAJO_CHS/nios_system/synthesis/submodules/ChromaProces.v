
module ChromaProces(	
				input wire			iCLK27,
				input wire [9:0]	imVGA_R, 	//la parte roja del pixel de la imagen que entra
				input wire [9:0]	imVGA_G,		//la parte verde del pixel de la imagen que entra
				input wire [9:0]	imVGA_B,		//la parte azul del pixel de la imagen que entra

				input wire [9:0] 	iRed,			//la parte roja del pixel del video que entra
				input wire [9:0] 	iGreen,		//la parte verde del pixel del video que entra
				input wire [9:0] 	iBlue,		//la parte azul del pixel del video que entra
				input wire [9:0]  iTransparencia,

				
				//output [9:0] gsRed, gsGreen, gsBlue,
				output [29:0] Cn
		);
	
wire isGreen;
wire imIsGreen;
wire [9:0] threshold;
wire [9:0] imRed, imGreen, imBlue;

//la salida es mezcla de las dos entradas Cn = alfa*cf+(1-alfa)Cb


assign threshold = 10'h1FF;
assign isGreen = (iGreen > threshold) & (iRed < threshold) & (iBlue < threshold);
assign alpha = iTransparencia/1023;


//image to display in green screen areas

assign imRed = imVGA_R;
assign imGreen = imVGA_G;
assign imBlue = imVGA_B;

// efecto verde pantalla
assign gsRed = alpha*(isGreen ? imRed : iRed); 				//Asignación de la imagen o del video
assign gsGreen = alpha*(isGreen  ? imGreen : iGreen); 		//Asignación de la imagen o del video
assign gsBlue = alpha*(isGreen ? imBlue : iBlue);			//Asignación de la imagen o del video

assign Cf = {gsRed, gsGreen, gsBlue};
assign Cb = {imRed, gsGreen, imBlue};

assign Cn = Cf +(1-alpha)*Cb;

endmodule 