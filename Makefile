
run:
	@echo
	@echo "-- Verilator CMake hello world example"

	@echo
	@echo "-- VERILATE ----------------"
	mkdir -p build && cd build && cmake ..

	@echo
	@echo "-- BUILD -------------------"
	cmake --build build -j4

	@echo
	@echo "-- RUN ---------------------"
	build/hello_world

	@echo
	@echo "-- DONE --------------------"
	@echo

clean mostlyclean distclean maintainer-clean:
	@rm -rf build logs
