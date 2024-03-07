# veriscaffold
scaffolding systemverilog-based projects

## TODO
- [ ] folder structure
- [ ] verible linting actions
- [ ] verible formatting pre-commit hooks
- [ ] verilator-based naming convention checks
- [ ] reset testing template ([ref](http://www.sunburst-design.com/papers/HunterSNUGSV_UVM_Resets_paper.pdf))
- [ ] simple systemverilog design + testing examples in icarus verilog
- [ ] simple systemverilog desing + testing examples in verilator
- [ ] simple systemverilog design + testing examples in cocotb
- [ ] functional unit testing framework
- [ ] synthesizability check using proprietary tool e.g., Cadence, Synopsys
- [ ] auto-instantiation

## Features Awaiting
- Verilator UVM support is coming along...

## Note
- `rules_verilator` doesn't work in macOS ([Link](https://github.com/bazelbuild/bazel/issues/18183))
- verilator-gtest integration ([Link](https://github.com/mortenjc/systemverilog))
- check this link for cmake sophistication ([Link](https://github.com/antmicro/renode-verilator-integration/blob/master/cmake/configure-and-verilate.cmake))
