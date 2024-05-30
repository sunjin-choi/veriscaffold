
FILE(GLOB_RECURSE ACC_SRC_FILES "${VERILOG_SRC_DIR}/accumulator/*.sv")

# Testbench build configuration
add_executable(tb_accumulator "${VERILOG_SIM_DIR}/accumulator/tb_accumulator.cpp")
verilate(tb_accumulator
	TRACE
	PREFIX Vaccumulator
	INCLUDE_DIRS "${VERILOG_LIB_DIR}/common"
	SOURCES "${ACC_SRC_FILES}"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE accumulator
)

# Testbench build configuration
add_executable(tb_accumulator_multi "${VERILOG_SIM_DIR}/accumulator/tb_accumulator_multi.cpp")
verilate(tb_accumulator_multi
	TRACE
	PREFIX Vaccumulator_multi
	INCLUDE_DIRS "${VERILOG_LIB_DIR}/common"
	SOURCES "${ACC_SRC_FILES}"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE accumulator_multi
)

#add_custom_command(TARGET tb_accumulator POST_BUILD
#    COMMAND ./tb_accumulator
#    COMMENT "Running test_echo"
#)
#add_custom_target(wave
#    COMMAND ${GTKWAVE_APP} "${CMAKE_CURRENT_BINARY_DIR}/${WAVEFORM_FILE}"
#    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${WAVEFORM_FILE}"
#    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#    COMMENT "Running gtkwave"
#)
