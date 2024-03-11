// See this example for improvement:
// https://github.com/antmicro/verilator/blob/master/examples/make_tracing_c/sim_main.cpp

#include "Vcounter.h"
#include <cstdint>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define WAVEFORM_FILE "WAVEFORM_FILE"
#define MAX_SIM_TIME 10

/*vluint64_t sim_time = 0;*/

int main(int argc, char **argv) {

  // Construct a VerilatedContext to hold simulation time, etc
  VerilatedContext *const contextp = new VerilatedContext;

  // Generate a trace
  Verilated::traceEverOn(true);
  VerilatedVcdC *tracep = new VerilatedVcdC;

  // Default does not work out -- manually set time unit and resolution
  tracep->set_time_unit("ns");
  tracep->set_time_resolution("ps");

  // Pass arguments so Verilated code can see them, e.g. $value$plusargs
  // This needs to be called before you create any model
  contextp->commandArgs(argc, argv);

  // Construct the Verilated model, from Vcounter.h generated from Verilating
  Vcounter *const counter = new Vcounter{contextp};

  // Connect counter to trace
  counter->trace(tracep, 99);
  tracep->open(getenv(WAVEFORM_FILE));

  /*printf("timeprecision: %d\n", contextp->timeprecision());*/

  // Initialize
  counter->clk = 0;
  counter->rst_n = 0;
  counter->en = 0;

  // Simulate until $finish or MAX_SIM_TIME
  while (contextp->time() < MAX_SIM_TIME) {
    counter->clk = !counter->clk;

    if (contextp->time() == 1) {
      counter->rst_n = 1;
      counter->en = 1;
    }

    // Evaluate model
    counter->eval();

    contextp->timeInc(1);
    tracep->dump(contextp->time());
    /*printf("sim time: %llu\n", contextp->time());*/
  }

  // Destroy model
  tracep->close();
  delete tracep;
  delete counter;

  // Return good completion status
  return 0;
}
