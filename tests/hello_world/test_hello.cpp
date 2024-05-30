
#include "Vhello_world.h"
#include <verilated.h>

int main() {

  printf("Hello, World from C++\n");

  // Construct the Verilated model, from Vhello.h generated from Verilating
  // "hello.sv"
  Vhello_world *const hello = new Vhello_world;

  // Evaluate the model
  hello->eval();

  // Final cleanup
  hello->final();
  delete hello;

  // Return good completion status
  return 0;
}
