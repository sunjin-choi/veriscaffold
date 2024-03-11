// See this example for improvement:
// https://github.com/antmicro/verilator/blob/master/examples/make_tracing_c/sim_main.cpp

#include "Vaccumulator.h"
#include <cstdint>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define WAVEFORM_FILE "WAVEFORM_FILE"
#define MAX_SIM_TIME 15

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
  Vaccumulator *const acc = new Vaccumulator{contextp};

  // Connect accumulator to trace
  acc->trace(tracep, 99);
  tracep->open(getenv(WAVEFORM_FILE));

  // Initialize
  acc->clk = 0;
  acc->rst_n = 1;
  acc->i_en = 0;
  acc->data_in = 0;

  // Simulate until $finish or MAX_SIM_TIME
  while (contextp->time() < MAX_SIM_TIME && !contextp->gotFinish()) {
    acc->clk = !acc->clk;

    if (contextp->time() == 1) {
      acc->rst_n = 0;
      acc->i_en = 1;
      acc->data_in = 0;
    } else if (contextp->time() >= 2 && contextp->time() <= 10) {
      acc->rst_n = 1;
      acc->i_en = 1;
      acc->data_in = 1;
    } else {
      acc->rst_n = 1;
      acc->i_en = 0;
      acc->data_in = 1;
    }

    // Evaluate model
    acc->eval();

    contextp->timeInc(1);
    tracep->dump(contextp->time());
    /*printf("sim time: %llu\n", contextp->time());*/
  }

  // Destroy model
  tracep->close();
  delete tracep;
  delete acc;

  // Return good completion status
  return 0;
}
