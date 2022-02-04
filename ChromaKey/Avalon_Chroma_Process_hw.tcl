# TCL File Generated by Component Editor 17.1
# Fri Feb 04 17:16:44 CET 2022
# DO NOT MODIFY


# 
# avalon_chroma_process "avalon_chroma_process" v1.0
#  2022.02.04.17:16:44
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module avalon_chroma_process
# 
set_module_property DESCRIPTION ""
set_module_property NAME avalon_chroma_process
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP IP
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME avalon_chroma_process
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL altera_up_avalon_chroma_key
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file altera_up_avalon_chroma_key.v VERILOG PATH avalon_chroma_key/altera_up_avalon_chroma_key.v TOP_LEVEL_FILE
add_fileset_file ChromaProces.v VERILOG PATH avalon_chroma_key/ChromaProces.v

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL altera_up_avalon_chroma_key
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file altera_up_avalon_chroma_key.v VERILOG PATH avalon_chroma_key/altera_up_avalon_chroma_key.v
add_fileset_file ChromaProces.v VERILOG PATH avalon_chroma_key/ChromaProces.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_foreground_sink
# 
add_interface avalon_foreground_sink avalon_streaming end
set_interface_property avalon_foreground_sink associatedClock clock
set_interface_property avalon_foreground_sink associatedReset reset
set_interface_property avalon_foreground_sink dataBitsPerSymbol 10
set_interface_property avalon_foreground_sink errorDescriptor ""
set_interface_property avalon_foreground_sink firstSymbolInHighOrderBits true
set_interface_property avalon_foreground_sink maxChannel 0
set_interface_property avalon_foreground_sink readyLatency 0
set_interface_property avalon_foreground_sink ENABLED true
set_interface_property avalon_foreground_sink EXPORT_OF ""
set_interface_property avalon_foreground_sink PORT_NAME_MAP ""
set_interface_property avalon_foreground_sink CMSIS_SVD_VARIABLES ""
set_interface_property avalon_foreground_sink SVD_ADDRESS_GROUP ""

add_interface_port avalon_foreground_sink pixel_video data Input 30
add_interface_port avalon_foreground_sink pixel_video_empty empty Input 2
add_interface_port avalon_foreground_sink pixel_video_endofpacket endofpacket Input 1
add_interface_port avalon_foreground_sink pixel_video_ready ready Output 1
add_interface_port avalon_foreground_sink pixel_video_startofpacket startofpacket Input 1
add_interface_port avalon_foreground_sink pixel_video_valid valid Input 1


# 
# connection point avalon_background_sink
# 
add_interface avalon_background_sink avalon_streaming end
set_interface_property avalon_background_sink associatedClock clock
set_interface_property avalon_background_sink associatedReset reset
set_interface_property avalon_background_sink dataBitsPerSymbol 10
set_interface_property avalon_background_sink errorDescriptor ""
set_interface_property avalon_background_sink firstSymbolInHighOrderBits true
set_interface_property avalon_background_sink maxChannel 0
set_interface_property avalon_background_sink readyLatency 0
set_interface_property avalon_background_sink ENABLED true
set_interface_property avalon_background_sink EXPORT_OF ""
set_interface_property avalon_background_sink PORT_NAME_MAP ""
set_interface_property avalon_background_sink CMSIS_SVD_VARIABLES ""
set_interface_property avalon_background_sink SVD_ADDRESS_GROUP ""

add_interface_port avalon_background_sink pixel_fondo data Input 30
add_interface_port avalon_background_sink pixel_fondo_empty empty Input 2
add_interface_port avalon_background_sink pixel_fondo_endofpacket endofpacket Input 1
add_interface_port avalon_background_sink pixel_fondo_ready ready Output 1
add_interface_port avalon_background_sink pixel_fondo_startofpacket startofpacket Input 1
add_interface_port avalon_background_sink pixel_fondo_valid valid Input 1


# 
# connection point avalon_source
# 
add_interface avalon_source avalon_streaming start
set_interface_property avalon_source associatedClock clock
set_interface_property avalon_source associatedReset reset
set_interface_property avalon_source dataBitsPerSymbol 10
set_interface_property avalon_source errorDescriptor ""
set_interface_property avalon_source firstSymbolInHighOrderBits true
set_interface_property avalon_source maxChannel 0
set_interface_property avalon_source readyLatency 0
set_interface_property avalon_source ENABLED true
set_interface_property avalon_source EXPORT_OF ""
set_interface_property avalon_source PORT_NAME_MAP ""
set_interface_property avalon_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_source SVD_ADDRESS_GROUP ""

add_interface_port avalon_source output_data data Output 30
add_interface_port avalon_source output_empty empty Output 2
add_interface_port avalon_source output_ready ready Input 1
add_interface_port avalon_source output_startofpacket startofpacket Output 1
add_interface_port avalon_source output_valid valid Output 1
add_interface_port avalon_source output_endofpacket endofpacket Output 1

