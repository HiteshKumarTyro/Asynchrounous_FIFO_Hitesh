module Async_FIFO
#(
    parameter a_width = 6,
    parameter d_width = 16
)
(
    input                rd_Clk, rd_resetn, rd_en,
    input                wr_Clk, wr_resetn, wr_en,
    input [d_width-1:0]  wr_data,
    output [d_width-1:0] rd_data,
    output               fifo_full, fifo_empty
);

    wire               mem_wr_en;
    wire [a_width-1:0] rd_addr, wr_addr;
    wire [a_width:0]   rd_ptr, rd_syn_ptr, wr_ptr, wr_syn_ptr;

    assign mem_wr_en = wr_en & (~ fifo_full);
    FIFO_RAM #(a_width, d_width) fiforam (.Clk(wr_Clk), .wr_en(mem_wr_en), .rd_en(rd_en),
                                          .rd_addr(rd_addr), .wr_addr(wr_addr), 
                                          .wr_data(wr_data), .rd_data(rd_data));

    rd2wr_synchronizer #(a_width) r2wsync (.Clk(wr_Clk), .Resetn(wr_resetn), .rd_ptr(rd_ptr), .rd_syn_ptr(rd_syn_ptr));

    wr2rd_synchronizer #(a_width) w2rsync (.Clk(rd_Clk), .Resetn(rd_resetn), .wr_ptr(wr_ptr), .wr_syn_ptr(wr_syn_ptr));

    empty_logic #(a_width) emptyLogic (.Clk(rd_Clk), .Resetn(rd_resetn), .rd_en(rd_en), 
                                       .wr_syn_ptr(wr_syn_ptr), .rd_ptr(rd_ptr), .rd_addr(rd_addr),
                                       .empty_flag(fifo_empty));

    full_logic #(a_width) fullLogic (.Clk(wr_Clk), .Resetn(wr_resetn), .wr_en(wr_en),
                                     .rd_syn_ptr(rd_syn_ptr), .wr_ptr(wr_ptr), .wr_addr(wr_addr),
                                     .full_flag(fifo_full));

endmodule