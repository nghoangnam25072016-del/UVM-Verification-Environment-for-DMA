interface dma_if(input logic clk);

    logic rst_n;
    logic start;
    logic [7:0] length;
    logic busy;
    logic dma_done;

    logic [31:0] araddr;
    logic        arvalid;
    logic        arready;

    logic [31:0] rdata;
    logic        rvalid;
    logic        rready;

    logic [31:0] awaddr;
    logic        awvalid;
    logic        awready;

    logic [31:0] wdata;
    logic        wvalid;
    logic        wready;

    logic        bvalid;
    logic        bready;

endinterface
