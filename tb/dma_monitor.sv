`ifndef DMA_MONITOR_SV
`define DMA_MONITOR_SV

class dma_monitor extends uvm_component;

    `uvm_component_utils(dma_monitor)

    virtual dma_if vif;
    uvm_analysis_port #(dma_seq_item) ap;

    function new(string name = "dma_monitor", uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual dma_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Failed to get virtual interface")
    endfunction

    task run_phase(uvm_phase phase);
        dma_seq_item item;

        forever begin
            @(posedge vif.clk);

            if (vif.wvalid && vif.wready) begin
                item = dma_seq_item::type_id::create("item");
                item.base_data = vif.wdata;
                item.length    = 1;
                ap.write(item);

                `uvm_info("MON", $sformatf("Observed write data: %h", vif.wdata), UVM_MEDIUM)
            end
        end
    endtask

endclass

`endif
