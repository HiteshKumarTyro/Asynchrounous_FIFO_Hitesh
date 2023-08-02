module empty_logic
#(
    parameter a_width = 4
)
(   
    input                Clk, Resetn, rd_en,
    input  [a_width:0]   wr_syn_ptr,
    output [a_width:0]   rd_ptr, 
    output [a_width-1:0] rd_addr,
    output               empty_flag
);

    reg [a_width:0] bin_code, rptr;
    wire empty_flag_val;
    reg  empty_flag_reg;
    wire [a_width:0] gray_code_next, bin_code_next;

    always @(posedge Clk) begin
        if (Resetn == 1'b0) 
            {bin_code, rptr} <= 0;
        else
            {bin_code, rptr} <= {bin_code_next, gray_code_next};
    end

    assign rd_ptr = rptr;
    assign rd_addr = bin_code[a_width-1:0];
    assign bin_code_next = bin_code + (rd_en & ~ empty_flag_reg);
    assign gray_code_next = (bin_code_next >> 1) ^ bin_code_next;

    // ************ Empty_Condition *********** //
    assign empty_flag_val = (gray_code_next == wr_syn_ptr);

    always @(posedge Clk) begin
        if (Resetn == 1'b0)
            empty_flag_reg <= 1'b1;
        else
            empty_flag_reg <= empty_flag_val; 
    end

    assign empty_flag = empty_flag_reg;
endmodule