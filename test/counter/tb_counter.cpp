
#include "Vcounter.h"
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define WAVEFORM_FILE WAVEFORM_FILE
#define MAX_SIM_TIME 10
vluint64_t sim_time = 0;

int main(int argc, char **argv) {

  // Construct a VerilatedContext to hold simulation time, etc
  VerilatedContext *const contextp = new VerilatedContext;

  // Generate a trace
  Verilated::traceEverOn(true);
  VerilatedVcdC *tracep = new VerilatedVcdC;

  // Pass arguments so Verilated code can see them, e.g. $value$plusargs
  // This needs to be called before you create any model
  contextp->commandArgs(argc, argv);

  // Construct the Verilated model, from Vcounter.h generated from Verilating
  Vcounter *const counter = new Vcounter{contextp};

  // Connect counter to trace
  counter->trace(tracep, 99);
  /*tracep->open("waveform.vcd");*/
  tracep->open(getenv("WAVEFORM_FILE"));

  /*  // Simulate until $finish
   *  while (!contextp->gotFinish()) {
   *    // Evaluate model
   *    counter->eval();
   *  }
   *
   *  // Final model cleanup
   *  counter->final();*/

  while (sim_time < MAX_SIM_TIME) {
    if (sim_time == 0) {
      // Initial clock
      counter->clk = 0;
    } else if (sim_time == 1) {
      // Reset
      counter->rst_n = 0;
      counter->clk = 1;
    } else {
      counter->clk ^= 1;
    }

    counter->eval();
    tracep->dump(sim_time);
    sim_time += 1;
  }

  // Destroy model
  tracep->close();
  delete tracep;
  delete counter;

  // Return good completion status
  return 0;
}
