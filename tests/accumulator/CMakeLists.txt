

add_executable(
	gtest_accumulator
	"${VERILOG_TEST_DIR}/accumulator/gtest_accumulator.cpp"
)


FILE(GLOB_RECURSE ACC_SRC_FILES "${VERILOG_SRC_DIR}/accumulator/*.sv")

# verilate internally uses PUBLIC signature in target_link_libraries
# Another target_link_libraries should also use PUBLIC
target_link_libraries(
	gtest_accumulator	
	PUBLIC
	GTest::gtest_main
)

verilate(gtest_accumulator
	#TRACE
	PREFIX Vaccumulator
	INCLUDE_DIRS "${VERILOG_LIB_DIR}/common"
	SOURCES "${ACC_SRC_FILES}"
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE accumulator
)

include(GoogleTest)
gtest_discover_tests(gtest_accumulator)
