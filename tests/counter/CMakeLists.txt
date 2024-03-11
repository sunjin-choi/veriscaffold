
# Testbench build configuration
add_executable(test_counter_inst "${VERILOG_TEST_DIR}/counter/test_counter_inst.cpp")
verilate(test_counter_inst
	#TRACE
	INCLUDE_DIRS "${VERILOG_LIB_DIR}"
	SOURCES "${VERILOG_SRC_DIR}/counter/counter.sv"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE counter
)


add_executable(
	gtest_counter
	"${VERILOG_TEST_DIR}/counter/gtest_counter.cpp"
)

# verilate internally uses PUBLIC signature in target_link_libraries
# Another target_link_libraries should also use PUBLIC
target_link_libraries(
	gtest_counter	
	PUBLIC
	GTest::gtest_main
)

verilate(gtest_counter
	#TRACE
	#INCLUDE_DIRS "./test/counter/Makefile"
	SOURCES "${VERILOG_SRC_DIR}/counter/counter.sv"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE counter
)

include(GoogleTest)
gtest_discover_tests(gtest_counter)
