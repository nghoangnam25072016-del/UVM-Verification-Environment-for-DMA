`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "dma_if.sv"
`include "dma_seq_item.sv"
`include "dma_sequence.sv"
`include "dma_driver.sv"
`include "dma_monitor.sv"
`include "dma_scoreboard.sv"
`include "dma_agent.sv"
`include "dma_env.sv"
`include "dma_test.sv"

module dma_tb_top;

    logic clk;
    always #5 clk = ~clk;

    dma_if dma_vif(clk);

    dma_top dut (
        .clk(clk),
        .rst_n(dma_vif.rst_n),
        .start(dma_vif.start),
        .length(dma_vif.length),

        .busy(dma_vif.busy),
        .dma_done(dma_vif.dma_done),

        .araddr(dma_vif.araddr),
        .arvalid(dma_vif.arvalid),
        .arready(dma_vif.arready),

        .rdata(dma_vif.rdata),
        .rvalid(dma_vif.rvalid),
        .rready(dma_vif.rready),

        .awaddr(dma_vif.awaddr),
        .awvalid(dma_vif.awvalid),
        .awready(dma_vif.awready),

        .wdata(dma_vif.wdata),
        .wvalid(dma_vif.wvalid),
        .wready(dma_vif.wready),

        .bvalid(dma_vif.bvalid),
        .bready(dma_vif.bready)
    );

    initial begin
        clk = 0;
        uvm_config_db#(virtual dma_if)::set(null, "*", "vif", dma_vif);
        run_test("dma_test");
    end

    initial begin
        $dumpfile("dma_uvm.vcd");
        $dumpvars(0, dma_tb_top);
    end

endmodule
