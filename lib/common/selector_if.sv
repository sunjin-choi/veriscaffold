// General parameterizable mux/demux
// Reference: https://github.com/taichi-ishitani/tbcm/blob/master/tbcm_selector.sv

interface selector_if #(
    parameter type DATA_TYPE,
    parameter int  ENTRIES
);

  localparam int SelectWidth = $clog2(ENTRIES);
  localparam type SELECT_TYPE = logic [SelectWidth-1:0];
  localparam type DATA_BUNDLE_TYPE = DATA_TYPE[ENTRIES-1:0];

  function automatic DATA_TYPE mux(DATA_BUNDLE_TYPE i_data, SELECT_TYPE i_sel);
    // simulator (verilator)-specific implementation strategy
    // Since selecting element with i_sel doens't work in Verilator

    DATA_BUNDLE_TYPE data_expand;
    for (int i = 0; i < ENTRIES; i++) begin
      assign data_expand[i] = (int'(i_sel) == i) ? i_data[i] : 0;
    end
    /*return data_expand.or;*/
    return |data_expand;
  endfunction

  function automatic DATA_BUNDLE_TYPE demux(DATA_TYPE i_data, logic [SelectWidth-1:0] i_sel);
    // simulator (verilator)-specific implementation strategy
    // Since selecting element with i_sel doens't work in Verilator

    DATA_BUNDLE_TYPE data_expand;
    for (int i = 0; i < ENTRIES; i++) begin
      assign data_expand[i] = (int'(i_sel) == i) ? i_data : 0;
    end
    return data_expand;
  endfunction

endinterface
