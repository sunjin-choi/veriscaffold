
#include "Vaccumulator.h"
#include <gtest/gtest.h>
#include <verilated.h>

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  return res;
}
