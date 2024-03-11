
#include "Vcounter.h"
#include <verilated.h>

int main(int argc, char **argv) {

  // Construct a VerilatedContext to hold simulation time, etc
  VerilatedContext *const contextp = new VerilatedContext;

  // Pass arguments so Verilated code can see them, e.g. $value$plusargs
  // This needs to be called before you create any model
  contextp->commandArgs(argc, argv);

  // Construct the Verilated model, from Vcounter.h generated from Verilating
  Vcounter *const counter = new Vcounter{contextp};

  /*  // Simulate until $finish
   *  while (!contextp->gotFinish()) {
   *    // Evaluate model
   *    counter->eval();
   *  }
   *
   *  // Final model cleanup
   *  counter->final();*/

  // Destroy model
  delete counter;

  // Return good completion status
  return 0;
}
