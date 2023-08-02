module wr2rd_synchronizer
#(
    parameter a_width = 4
)
(
    input                Clk, Resetn,
    input  [a_width:0] wr_ptr,
    output [a_width:0] wr_syn_ptr
);

    reg [a_width:0] wr_ptr_reg_1, wr_ptr_reg_2;

    always @(posedge Clk) begin
        if (Resetn == 1'b0)
            {wr_ptr_reg_2, wr_ptr_reg_1} <= 0;
        else
            {wr_ptr_reg_2, wr_ptr_reg_1} <= {wr_ptr_reg_1, wr_ptr};
    end

    assign wr_syn_ptr = wr_ptr_reg_2;
endmodule