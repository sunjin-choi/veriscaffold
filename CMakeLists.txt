cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0074 NEW)

project(veriscaffold)

# clangd autocompletion
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

#set(CMAKE_CXX_STANDARD 17)
#set(CMAKE_CXX_STANDARD_REQUIRED ON)
#
#set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wpedantic -Werror")
#add_definitions(-DCMAKE_EXPORT_COMPILE_COMMANDS=1)

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

add_executable(hello_world ./test/hello_world/tb_hello.cpp)
add_executable(example ./test/counter/tb_counter_inst.cpp)

verilate(hello_world
	INCLUDE_DIRS "./test/hello_world/Makefile"
	SOURCES ./src/hello_world/hello.sv
)

verilate(example
	INCLUDE_DIRS "./test/counter/Makefile"
	SOURCES ./src/counter/counter.sv
)

