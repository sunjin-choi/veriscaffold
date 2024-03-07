cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0074 NEW)

project(veriscaffold)

# clangd autocompletion
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Too many warnings
#set(CMAKE_CXX_FLAGS "-Wall -Wextra")

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

list(APPEND VERI_ARGS -Wall -Wno-fatal -sv --cc)


add_executable(hello_world ./test/hello_world/test_hello.cpp)
verilate(hello_world
	#INCLUDE_DIRS "./test/hello_world/Makefile"
	SOURCES ./src/hello_world/hello.sv
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE hello
)

add_executable(test_counter_inst ./test/counter/test_counter_inst.cpp)
verilate(test_counter_inst
	#TRACE
	#INCLUDE_DIRS "./test/counter/Makefile"
	SOURCES ./src/counter/counter.sv
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE counter
)

add_executable(tb_counter ./test/counter/tb_counter.cpp)
verilate(tb_counter
	TRACE
	#INCLUDE_DIRS "./test/counter/Makefile"
	SOURCES ./src/counter/counter.sv
	VERILATOR_ARGS ${VERI_ARGS}
	TOP_MODULE counter
)

# TODO: GLOB_RECURSE to add the library later
