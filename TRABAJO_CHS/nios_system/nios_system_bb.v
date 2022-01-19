
module nios_system (
	char_lcd_external_interface_DATA,
	char_lcd_external_interface_ON,
	char_lcd_external_interface_BLON,
	char_lcd_external_interface_EN,
	char_lcd_external_interface_RS,
	char_lcd_external_interface_RW,
	clk_50_2_in_clk,
	clk_50_in_clk,
	flash_bridge_out_tcm_address_out,
	flash_bridge_out_tcm_read_n_out,
	flash_bridge_out_tcm_write_n_out,
	flash_bridge_out_tcm_data_out,
	flash_bridge_out_tcm_chipselect_n_out,
	green_led_external_interface_export,
	mtl_clk_out_clk,
	mtl_controller_external_interface_CLK,
	mtl_controller_external_interface_HS,
	mtl_controller_external_interface_VS,
	mtl_controller_external_interface_DATA_EN,
	mtl_controller_external_interface_R,
	mtl_controller_external_interface_G,
	mtl_controller_external_interface_B,
	pushbuttons_external_interface_export,
	red_leds_external_interface_export,
	reset_bridge_in_reset_n,
	sdram_clk_out_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	sram_external_interface_DQ,
	sram_external_interface_ADDR,
	sram_external_interface_LB_N,
	sram_external_interface_UB_N,
	sram_external_interface_CE_N,
	sram_external_interface_OE_N,
	sram_external_interface_WE_N,
	switches_external_interface_export,
	sys_clk_out_clk,
	video_decoder_external_interface_TD_CLK27,
	video_decoder_external_interface_TD_DATA,
	video_decoder_external_interface_TD_HS,
	video_decoder_external_interface_TD_VS,
	video_decoder_external_interface_clk27_reset,
	video_decoder_external_interface_TD_RESET,
	video_decoder_external_interface_overflow_flag);	

	inout	[7:0]	char_lcd_external_interface_DATA;
	output		char_lcd_external_interface_ON;
	output		char_lcd_external_interface_BLON;
	output		char_lcd_external_interface_EN;
	output		char_lcd_external_interface_RS;
	output		char_lcd_external_interface_RW;
	input		clk_50_2_in_clk;
	input		clk_50_in_clk;
	output	[22:0]	flash_bridge_out_tcm_address_out;
	output	[0:0]	flash_bridge_out_tcm_read_n_out;
	output	[0:0]	flash_bridge_out_tcm_write_n_out;
	inout	[7:0]	flash_bridge_out_tcm_data_out;
	output	[0:0]	flash_bridge_out_tcm_chipselect_n_out;
	output	[8:0]	green_led_external_interface_export;
	output		mtl_clk_out_clk;
	output		mtl_controller_external_interface_CLK;
	output		mtl_controller_external_interface_HS;
	output		mtl_controller_external_interface_VS;
	output		mtl_controller_external_interface_DATA_EN;
	output	[7:0]	mtl_controller_external_interface_R;
	output	[7:0]	mtl_controller_external_interface_G;
	output	[7:0]	mtl_controller_external_interface_B;
	input	[3:0]	pushbuttons_external_interface_export;
	output	[17:0]	red_leds_external_interface_export;
	input		reset_bridge_in_reset_n;
	output		sdram_clk_out_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	inout	[15:0]	sram_external_interface_DQ;
	output	[19:0]	sram_external_interface_ADDR;
	output		sram_external_interface_LB_N;
	output		sram_external_interface_UB_N;
	output		sram_external_interface_CE_N;
	output		sram_external_interface_OE_N;
	output		sram_external_interface_WE_N;
	input	[17:0]	switches_external_interface_export;
	output		sys_clk_out_clk;
	input		video_decoder_external_interface_TD_CLK27;
	input	[7:0]	video_decoder_external_interface_TD_DATA;
	input		video_decoder_external_interface_TD_HS;
	input		video_decoder_external_interface_TD_VS;
	input		video_decoder_external_interface_clk27_reset;
	output		video_decoder_external_interface_TD_RESET;
	output		video_decoder_external_interface_overflow_flag;
endmodule
