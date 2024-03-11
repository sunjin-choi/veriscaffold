
run:
	@echo
	@echo "-- Verilator CMake hello world example"

	@echo
	@echo "-- VERILATE ----------------"
	mkdir -p build && cd build && cmake ..

	@echo
	@echo "-- BUILD -------------------"
	cmake --build build -j4
	#if [ -f compile_commands.json ]; then rm compile_commands.json; fi
	#ln -s sim/compile_commands.json .

	@echo
	@echo "-- RUN ---------------------"
	build/tests/hello_world/hello_world
	#build/sim/counter/tb_counter

	@echo
	@echo "-- DONE --------------------"
	@echo

clean mostlyclean distclean maintainer-clean:
	@rm -rf build logs
