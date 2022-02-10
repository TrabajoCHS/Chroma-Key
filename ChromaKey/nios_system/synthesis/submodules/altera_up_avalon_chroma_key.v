// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS
// IN THIS FILE.

/******************************************************************************
 *                                                                            *
 * This module combines two video streams by overlaying one onto the          *
 *  other using alpha blending.  The foreground image must include alpha      *
 *  bits to be used in the blending formula: Cn = (1 - a)Cb + (a)Cf           *
 *  Cn - new color                                                            *
 *  a  - alpha                                                                *
 *  Cb - background colour                                                    *
 *  Cf - foreground colour                                                    *
 *                                                                            *
 ******************************************************************************/

module altera_up_avalon_chroma_key (
	// Inputs
	clk,
	reset,
	chipselect,
	address,
	write,
	writedata,
	read,

	pixel_fondo,
	pixel_fondo_startofpacket,
	pixel_fondo_endofpacket,
	pixel_fondo_empty,
	pixel_fondo_valid,
	
	pixel_video,
	pixel_video_startofpacket,
	pixel_video_endofpacket,
	pixel_video_empty,
	pixel_video_valid,

	output_ready,

	// Outputs
	pixel_fondo_ready,

	pixel_video_ready,
	
	output_data,
	output_startofpacket,
	output_endofpacket,
	output_empty,
	output_valid,
	
	readdata
);

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input						clk;
input						reset;
input						chipselect;
input			[2 : 0]	address;
input 					write;
input			[31: 0]	writedata;
input 					read;

input			[29: 0]	pixel_fondo;
input						pixel_fondo_startofpacket;
input						pixel_fondo_endofpacket;
input			[ 1: 0]	pixel_fondo_empty;
input						pixel_fondo_valid;

input			[29: 0]	pixel_video; //Se ha cambiado de formato con transparencia a sin transparencia
input						pixel_video_startofpacket;
input						pixel_video_endofpacket;
input			[ 1: 0]	pixel_video_empty;
input						pixel_video_valid;

input						output_ready;

// Bidirectionals

// Outputs
output					pixel_fondo_ready;

output					pixel_video_ready;

output		[29: 0]	output_data;
output					output_startofpacket;
output					output_endofpacket;
output		[ 1: 0]	output_empty;
output					output_valid;

output 		[31: 0]	readdata;




/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire			[ 9: 0]	new_red;
wire			[ 9: 0]	new_green;
wire			[ 9: 0]	new_blue;

wire						sync_pixel_video;
wire						sync_pixel_fondo;

wire						valid;


// Internal Registers

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
// Output Assignments
assign pixel_fondo_ready = (output_ready & output_valid) | sync_pixel_fondo;
assign pixel_video_ready = (output_ready & output_valid) | sync_pixel_video;

assign output_data				= {new_red, new_green, new_blue};
assign output_startofpacket 	= pixel_video_startofpacket;
assign output_endofpacket		= pixel_video_endofpacket;
assign output_empty				= 2'h0;
assign output_valid				= valid;

// Internal Assignments
assign sync_pixel_video = (pixel_video_valid & pixel_fondo_valid & ((pixel_fondo_startofpacket & ~pixel_video_startofpacket) |   (pixel_fondo_endofpacket & ~pixel_video_endofpacket)));
assign sync_pixel_fondo = (pixel_video_valid & pixel_fondo_valid & ((pixel_video_startofpacket & ~pixel_fondo_startofpacket) |   (pixel_video_endofpacket & ~pixel_fondo_endofpacket)));

assign valid =	pixel_video_valid & pixel_fondo_valid & ~sync_pixel_video & ~sync_pixel_fondo;
wire [31:0] reg0, reg1, reg3, reg2;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

 ChromaProces ChromaProces (
				.clk(clk),
				
				.rojoImagen(pixel_fondo[29:20]), 	//Color rojo de la imagen [9:0]
				.verdeImagen(pixel_fondo[19:10]), 	//Color verde de la imagen [9:0]
				.azulImagen(pixel_fondo[9:0]), 		//Color azul de la imagen [9:0]

				.rojoVideo(pixel_video[29:20]),		//la parte roja del pixel del video que entra [9:0]
				.verdeVideo(pixel_video[19:10]),		//la parte verde del pixel del video que entra [9:0]
				.azulVideo(pixel_video[9:0]),			//la parte azul del pixel del video que entra [9:0]
				
				.RojoOut(new_red),						//la parte roja de la salida  [9:0]
				.VerdeOut(new_green),					//la parte verde de la salida [9:0]
				.AzulOut(new_blue),						//la parte azul de la salida  [9:0]
				.videoActivo(reg3[0]),
				.imagenActiva(reg3[1]),
				.nivelVerde(reg0[9:0])
);

avalon_slave_MM_interface  AvalonS1MM (
                                 .reset(reset),
                                 .clock(clk),
                                 .chipselect(chipselect),
                                 .address(address), 
                                 .write(write),
                                 .writedata(writedata),
                                 .read(read),                                         
                                 .readdata(readdata),
                                 //Interface con nuestra logica.
                                   // Registros 0 y 1 de lectura 
                                 .reg0(reg0), 
											.reg1(reg1),
										   .reg3(reg3),
                                   // Datos para el registro interno reg3
                                 .data(reg2),
                                   // Write enable para el registro interno.
                                 .we(1'b1)								
);


endmodule

