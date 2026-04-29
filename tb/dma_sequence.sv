`ifndef DMA_SEQUENCE_SV
`define DMA_SEQUENCE_SV

class dma_sequence extends uvm_sequence #(dma_seq_item);

    `uvm_object_utils(dma_sequence)

    function new(string name = "dma_sequence");
        super.new(name);
    endfunction

    task body();
        dma_seq_item item;

        item = dma_seq_item::type_id::create("item");
        start_item(item);

        if (!item.randomize() with {
            length == 4;
            base_data == 32'hCAFEBABE;
        }) begin
            `uvm_error("SEQ", "Randomization failed")
        end

        finish_item(item);
    endtask

endclass

`endif
