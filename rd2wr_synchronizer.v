module rd2wr_synchronizer
#(
    parameter a_width = 4
)
(
    input               Clk, Resetn,
    input  [a_width:0] rd_ptr,
    output [a_width:0] rd_syn_ptr
);

    reg [a_width-1:0] rd_ptr_reg_1, rd_ptr_reg_2;

    always @(posedge Clk) begin
        if (Resetn == 1'b0)
            {rd_ptr_reg_2, rd_ptr_reg_1} <= 0;
        else
            {rd_ptr_reg_2, rd_ptr_reg_1} <= {rd_ptr_reg_1, rd_ptr};
    end

    assign rd_syn_ptr = rd_ptr_reg_2;
endmodule