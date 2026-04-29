`ifndef DMA_TEST_SV
`define DMA_TEST_SV

class dma_test extends uvm_test;

    `uvm_component_utils(dma_test)

    dma_env      env;
    dma_sequence seq;

    function new(string name = "dma_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = dma_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq = dma_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);

        #100;
        phase.drop_objection(this);
    endtask

endclass

`endif
