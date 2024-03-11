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

# TODO: add if/else for the environment variables
set(VERILOG_SRC_DIR $ENV{VERILOG_SRC_DIR} CACHE PATH "Path to the verilog source directory")
set(VERILOG_LIB_DIR $ENV{VERILOG_LIB_DIR} CACHE PATH "Path to the verilog library directory")
set(VERILOG_TEST_DIR $ENV{VERILOG_TEST_DIR} CACHE PATH "Path to the verilog test directory")
set(VERILOG_SIM_DIR $ENV{VERILOG_SIM_DIR} CACHE PATH "Path to the verilog sim directory")

message(STATUS "Verilog source directory: ${VERILOG_SRC_DIR}")
message(STATUS "Verilog library directory: ${VERILOG_LIB_DIR}")
message(STATUS "Verilog test directory: ${VERILOG_TEST_DIR}")
message(STATUS "Verilog sim directory: ${VERILOG_SIM_DIR}")

list(APPEND VERI_ARGS -Wall -Wno-fatal -sv --cc)
#list(APPEND VERI_ARGS -Wall -Wno-fatal -Wno-TIMESCALEMOD -sv --cc --timescale 1ns/1ps)

set(GTKWAVE_APP $ENV{GTKWAVE_APP} CACHE PATH "Path to gtkwave executable")
set(WAVEFORM_FILE $ENV{WAVEFORM_FILE} CACHE PATH "Path to the waveform file")

message(STATUS "Waveform file: ${WAVEFORM_FILE}")

add_subdirectory(tests)
add_subdirectory(sim)

# TODO: GLOB_RECURSE to add the library later

# Custom target to run gtkwave
add_custom_target(wave
	COMMAND ${GTKWAVE_APP} "${CMAKE_CURRENT_BINARY_DIR}/${WAVEFORM_FILE}"
	DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${WAVEFORM_FILE}"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Running gtkwave"
)

## TODO: refactor this into config.cmake?
#add_custom_target(wave
#    COMMAND gtkwave ${WAVEFORM}
#    #DEPENDS ${WAVEFORM}
#    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
#)
#add_custom_command(
#    TARGET wave
#    POST_BUILD
#    COMMAND ${GTKWAVE_APP} ${WAVEFORM}
#)

#add_executable(hello_world ./test/hello_world/test_hello.cpp)
#verilate(hello_world
#    #INCLUDE_DIRS "./test/hello_world/Makefile"
#    SOURCES ./src/hello_world/hello.sv
#    VERILATOR_ARGS ${VERI_ARGS}
#    TOP_MODULE hello
#)
#
#add_executable(test_counter_inst ./test/counter/test_counter_inst.cpp)
#verilate(test_counter_inst
#    #TRACE
#    #INCLUDE_DIRS "./test/counter/Makefile"
#    SOURCES ./src/counter/counter.sv
#    VERILATOR_ARGS ${VERI_ARGS}
#    TOP_MODULE counter
#)
#
#add_executable(tb_counter ./test/counter/tb_counter.cpp)
#verilate(tb_counter
#    TRACE
#    #INCLUDE_DIRS "./test/counter/Makefile"
#    SOURCES ./src/counter/counter.sv
#    VERILATOR_ARGS ${VERI_ARGS}
#    TOP_MODULE counter
#)



# Google Test integration
# Include Google Test using FetchContent
include(FetchContent)
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)

# Fetch and configure Google Test
FetchContent_MakeAvailable(googletest)

# Optionally enable testing
enable_testing()


