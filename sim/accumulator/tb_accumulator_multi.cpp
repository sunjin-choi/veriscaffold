// See this example for improvement:
// https://github.com/antmicro/verilator/blob/master/examples/make_tracing_c/sim_main.cpp

#include "Vaccumulator_multi.h"
#include <cstdint>
#include <cstdlib>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define WAVEFORM_FILE "WAVEFORM_FILE"
#define MAX_SIM_TIME 20

/*vluint64_t sim_time = 0;*/

typedef struct {
  CData rst_n;
  CData i_en;
} accumulator_state_t;

typedef struct {
  CData i_rdy;
  CData i_val;
} accumulator_bfm_state_t;

accumulator_state_t accInitialState = {0, 0};
accumulator_state_t accResetState = {0, 1};
accumulator_state_t accDisableState = {1, 0};
accumulator_state_t accEnableState = {1, 1};

accumulator_bfm_state_t accBfmInitialState = {0, 0};
accumulator_bfm_state_t accBfmInputState = {1, 0};
accumulator_bfm_state_t accBfmOutputState = {0, 1};
accumulator_bfm_state_t accBfmInOutState = {1, 1};

void accStateUpdate(Vaccumulator_multi *acc, const accumulator_state_t *state) {
  acc->rst_n = state->rst_n;
  acc->i_en = state->i_en;
}

void accBfmStateUpdate(Vaccumulator_multi *acc,
                       const accumulator_bfm_state_t *state) {
  acc->i_rdy = state->i_rdy;
  acc->i_val = state->i_val;
}

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
  Vaccumulator_multi *const acc = new Vaccumulator_multi{contextp};

  // Connect accumulator to trace
  acc->trace(tracep, 99);
  tracep->open(getenv(WAVEFORM_FILE));

  // Initialize
  acc->clk = 0;
  accStateUpdate(acc, &accInitialState);
  accBfmStateUpdate(acc, &accBfmInitialState);

  // Simulate until $finish or MAX_SIM_TIME
  while (contextp->time() < MAX_SIM_TIME && !contextp->gotFinish()) {
    acc->clk = !acc->clk;

    if (contextp->time() == 1) {
      accStateUpdate(acc, &accResetState);
      accBfmStateUpdate(acc, &accBfmInputState);
      acc->data_in = 0;
    } else if (contextp->time() >= 2 && contextp->time() <= 10) {
      accStateUpdate(acc, &accEnableState);
      accBfmStateUpdate(acc, &accBfmInOutState);
      acc->data_in = 1;
      acc->i_sel = 0;
    } else if (contextp->time() > 10 && contextp->time() <= 15) {
      accStateUpdate(acc, &accEnableState);
      accBfmStateUpdate(acc, &accBfmInOutState);
      acc->data_in = 1;
      acc->i_sel = 1;
    } else {
      accStateUpdate(acc, &accDisableState);
      accBfmStateUpdate(acc, &accBfmInOutState);
      acc->data_in = 0;
      acc->i_sel = 0;
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
