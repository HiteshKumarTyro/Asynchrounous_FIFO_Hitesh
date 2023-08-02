module FIFO_RAM
#(
    parameter a_width = 4,
    parameter d_width = 16
)
(
    input                Clk, wr_en, rd_en,
    input  [a_width-1:0] rd_addr, wr_addr,
    input  [d_width-1:0] wr_data,
    output [d_width-1:0] rd_data
);

    reg [d_width-1:0] MEM [0:2**a_width-1];

    always @(posedge Clk) begin
        if (wr_en == 1'b1)
            MEM[wr_addr] <= wr_data;
    end 

    assign rd_data = (rd_en) ? (MEM[rd_addr]) : ({d_width{1'b0}});
endmodule