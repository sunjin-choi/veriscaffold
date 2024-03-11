
#include "Vcounter.h"
#include <gtest/gtest.h>
#include <verilated.h>

class CounterTest : public ::testing::Test {
protected:
  Vcounter *cntr;

  void SetUp() override {
    cntr = new Vcounter;
    cntr->eval();
  }

  void TearDown() override {
    cntr->final();
    delete cntr;
  }

  void reset() {
    cntr->rst_n = 0;
    cntr->eval();
    cntr->rst_n = 1;
    cntr->eval();
  }

  void tick(int N) {
    for (int i = 0; i < N; i++) {
      cntr->clk = 0;
      cntr->eval();
      cntr->clk = 1;
      cntr->eval();
    }
  }
};

TEST_F(CounterTest, Initial) { ASSERT_EQ(cntr->count, 0); }

TEST_F(CounterTest, Count) {
  reset();
  tick(1);
  ASSERT_EQ(cntr->count, 1);
  tick(1);
  ASSERT_EQ(cntr->count, 2);
  tick(1);
  ASSERT_EQ(cntr->count, 3);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  return res;
}
