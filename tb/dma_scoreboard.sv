`ifndef DMA_SCOREBOARD_SV
`define DMA_SCOREBOARD_SV

class dma_scoreboard extends uvm_component;

    `uvm_component_utils(dma_scoreboard)

    uvm_analysis_imp #(dma_seq_item, dma_scoreboard) analysis_export;

    bit [31:0] expected_data[$];
    int pass_count;
    int fail_count;

    function new(string name = "dma_scoreboard", uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        expected_data.push_back(32'hCAFEBABE);
        expected_data.push_back(32'hCAFEBABF);
        expected_data.push_back(32'hCAFEBAC0);
        expected_data.push_back(32'hCAFEBAC1);

        pass_count = 0;
        fail_count = 0;
    endfunction

    function void write(dma_seq_item item);
        bit [31:0] expected;

        if (expected_data.size() == 0) begin
            `uvm_error("SCB", $sformatf("Unexpected data received: %h", item.base_data))
            fail_count++;
            return;
        end

        expected = expected_data.pop_front();

        if (item.base_data == expected) begin
            pass_count++;
            `uvm_info("SCB", $sformatf("PASS: expected=%h actual=%h", expected, item.base_data), UVM_LOW)
        end
        else begin
            fail_count++;
            `uvm_error("SCB", $sformatf("FAIL: expected=%h actual=%h", expected, item.base_data))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SCB", $sformatf("Scoreboard result: PASS=%0d FAIL=%0d", pass_count, fail_count), UVM_NONE)

        if (fail_count == 0 && pass_count == 4)
            `uvm_info("SCB", "DMA UVM TEST PASSED", UVM_NONE)
        else
            `uvm_error("SCB", "DMA UVM TEST FAILED")
    endfunction

endclass

`endif
