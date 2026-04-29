`ifndef DMA_DRIVER_SV
`define DMA_DRIVER_SV

class dma_driver extends uvm_driver #(dma_seq_item);

    `uvm_component_utils(dma_driver)

    virtual dma_if vif;

    function new(string name = "dma_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual dma_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("DRV", "Failed to get virtual interface")
        end
    endfunction

    task run_phase(uvm_phase phase);
        dma_seq_item item;

        reset_dut();

        forever begin
            seq_item_port.get_next_item(item);
            drive_transfer(item);
            seq_item_port.item_done();
        end
    endtask

    task reset_dut();
        vif.rst_n   <= 0;
        vif.start   <= 0;
        vif.length  <= 0;

        vif.arready <= 0;
        vif.rvalid  <= 0;
        vif.rdata   <= 0;

        vif.awready <= 0;
        vif.wready  <= 0;
        vif.bvalid  <= 0;

        repeat (5) @(posedge vif.clk);
        vif.rst_n <= 1;
        repeat (2) @(posedge vif.clk);
    endtask

    task automatic random_delay();
        repeat ($urandom_range(1, 5)) @(posedge vif.clk);
    endtask

    task drive_transfer(dma_seq_item item);

        vif.length <= item.length;

        @(posedge vif.clk);
        vif.start <= 1;
        @(posedge vif.clk);
        vif.start <= 0;

        for (int i = 0; i < item.length; i++) begin
            wait (vif.arvalid == 1);
            random_delay();
            vif.arready <= 1;
            @(posedge vif.clk);
            vif.arready <= 0;

            wait (vif.rready == 1);
            random_delay();
            vif.rdata  <= item.base_data + i;
            vif.rvalid <= 1;
            @(posedge vif.clk);
            vif.rvalid <= 0;

            wait (vif.awvalid == 1 && vif.wvalid == 1);
            random_delay();
            vif.awready <= 1;
            vif.wready  <= 1;
            @(posedge vif.clk);
            vif.awready <= 0;
            vif.wready  <= 0;

            wait (vif.bready == 1);
            random_delay();
            vif.bvalid <= 1;
            @(posedge vif.clk);
            vif.bvalid <= 0;
        end

        wait (vif.dma_done == 1);
        `uvm_info("DRV", "DMA transfer completed", UVM_MEDIUM)
    endtask

endclass

`endif
