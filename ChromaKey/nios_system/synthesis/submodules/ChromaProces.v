

module ChromaProces(	
				input wire			clk,
				input wire [9:0]	rojoImagen, 				//las parte roja del pixel de la imagen.
				input wire [9:0]	verdeImagen,				//las parte verde del pixel de la imagen.
				input wire [9:0]	azulImagen,					//las parte roja del pixel de la imagen.
				input wire [9:0] 	rojoVideo,					//la parte roja del pixel del video que entra.
				input wire [9:0] 	verdeVideo,					//la parte verde del pixel del video que entra.
				input wire [9:0] 	azulVideo,					//la parte azul del pixel del video que entra.
				input wire [9:0]  nivelVerde,					//threshold solo para el verde, el reto se ajustan a la mitad.										
				input wire videoActivo, imagenActiva,		//Segnales de activación de video y imagen. 				
				output [9:0] RojoOut, VerdeOut, AzulOut	//Salidas del chroma RGB.
		);

					

wire controlVerde;												//Segnal para comprobar si es verde.

/*		ANTERIOR VERSION		*/	
/*	
//wire [9:0] threshold;

//Aquí era umbral fijo, los he puesto como entradas para que sea variable
//wire [9:0] threshold_verde;
//wire [9:0] threshold_rojo;
//wire [9:0] threshold_azul;

//wire [9:0] threshold_azul = (nivelVerde << 2);
//wire [9:0] threshold_rojo = (nivelVerde << 2);

//assign controlVerde = (verdeVideo > threshold) & (rojoVideo < threshold) & (azulVideo < threshold);
*/

//Control de verde.
assign controlVerde = (verdeVideo > nivelVerde) & ((verdeVideo - rojoVideo) > (nivelVerde >> 2)) & ((verdeVideo - azulVideo) > (nivelVerde >> 2)); 					

//Asignamos a las salidas el video o la imagen segun las condiciones. 
assign RojoOut = (videoActivo && imagenActiva) ? (controlVerde ? rojoImagen : rojoVideo) : (videoActivo ? rojoVideo : (imagenActiva ? rojoImagen : 10'd2)); 		//Para rojo: Tenemos activado video e imagen? si, es verde? si, pues entonces pongo la imagen...
assign VerdeOut = (videoActivo && imagenActiva) ? (controlVerde ? verdeImagen : verdeVideo) : (videoActivo ? verdeVideo : (imagenActiva ? verdeImagen : 10'd2)); 	//Lo mismo verde.
assign AzulOut = (videoActivo && imagenActiva) ? (controlVerde ? azulImagen : azulVideo) : (videoActivo ? azulVideo : (imagenActiva ? azulImagen : 10'd2)); 		//Lo mismo azul.

endmodule
