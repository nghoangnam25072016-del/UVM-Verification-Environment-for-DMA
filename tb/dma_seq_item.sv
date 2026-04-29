`ifndef DMA_SEQ_ITEM_SV
`define DMA_SEQ_ITEM_SV

class dma_seq_item extends uvm_sequence_item;

    rand bit [7:0]  length;
    rand bit [31:0] base_data;

    constraint length_c {
        length inside {[1:8]};
    }

    `uvm_object_utils_begin(dma_seq_item)
        `uvm_field_int(length,   UVM_ALL_ON)
        `uvm_field_int(base_data, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "dma_seq_item");
        super.new(name);
    endfunction

endclass

`endif
