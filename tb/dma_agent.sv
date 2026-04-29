`ifndef DMA_AGENT_SV
`define DMA_AGENT_SV

class dma_agent extends uvm_agent;

    `uvm_component_utils(dma_agent)

    dma_driver    driver;
    dma_monitor   monitor;
    uvm_sequencer #(dma_seq_item) sequencer;

    function new(string name = "dma_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        driver    = dma_driver::type_id::create("driver", this);
        monitor   = dma_monitor::type_id::create("monitor", this);
        sequencer = uvm_sequencer #(dma_seq_item)::type_id::create("sequencer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass

`endif
