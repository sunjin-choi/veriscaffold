
run:
	@echo
	@echo "-- Verilator CMake hello world example"

	@echo
	@echo "-- VERILATE ----------------"
	mkdir -p sim && cd sim && cmake ..

	@echo
	@echo "-- BUILD -------------------"
	cmake --build sim -j4
	if [ -f compile_commands.json ]; then rm compile_commands.json; fi
	ln -s sim/compile_commands.json .

	@echo
	@echo "-- RUN ---------------------"
	sim/test/hello_world/hello_world

	@echo
	@echo "-- DONE --------------------"
	@echo

clean mostlyclean distclean maintainer-clean:
	@rm -rf sim logs
