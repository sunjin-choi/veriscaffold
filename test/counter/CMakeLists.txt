
# Testbench build configuration
add_executable(test_counter_inst "${VERILOG_TEST_DIR}/counter/test_counter_inst.cpp")
verilate(test_counter_inst
	#TRACE
	#INCLUDE_DIRS "./test/counter/Makefile"
	SOURCES "${VERILOG_SRC_DIR}/counter/counter.sv"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE counter
)

add_executable(tb_counter "${VERILOG_TEST_DIR}/counter/tb_counter.cpp")
verilate(tb_counter
	TRACE
	#INCLUDE_DIRS "./test/counter/Makefile"
	SOURCES "${VERILOG_SRC_DIR}/counter/counter.sv"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE counter
)
add_custom_command(TARGET tb_counter POST_BUILD
	COMMAND ./tb_counter 
	COMMENT "Running test_echo"
)
add_custom_target(wave
	COMMAND ${GTKWAVE_APP} "${CMAKE_CURRENT_BINARY_DIR}/${WAVEFORM_FILE}"
	DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${WAVEFORM_FILE}"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Running gtkwave"
)
