
# Testbench build configuration
add_executable(hello_world "${VERILOG_TEST_DIR}/hello_world/test_hello.cpp")
verilate(hello_world
	#INCLUDE_DIRS "./test/hello_world/Makefile"
	#SOURCES ./src/hello_world/hello.sv
	SOURCES "${VERILOG_SRC_DIR}/hello_world/hello.sv"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE hello
)


