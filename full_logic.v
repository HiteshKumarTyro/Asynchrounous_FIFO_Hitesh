module full_logic
#(
    parameter a_width = 4
)
(   
    input                Clk, Resetn, wr_en,
    input  [a_width:0]   rd_syn_ptr,
    output [a_width:0]   wr_ptr, 
    output [a_width-1:0] wr_addr,
    output               full_flag
);

    reg [a_width:0] bin_code, rptr;
    wire full_flag_val;
    reg  full_flag_reg;
    wire [a_width:0] gray_code_next, bin_code_next;

    always @(posedge Clk) begin
        if (Resetn == 1'b0) 
            {bin_code, rptr} <= 0;
        else
            {bin_code, rptr} <= {bin_code_next, gray_code_next};
    end

    assign wr_ptr = rptr;
    assign wr_addr = bin_code[a_width-1:0];
    assign bin_code_next = bin_code + (wr_en & ~ full_flag_reg);
    assign gray_code_next = (bin_code_next >> 1) ^ bin_code_next;

    // ************ full_Condition *********** //
    assign full_flag_val = (gray_code_next == {~rd_syn_ptr[a_width:a_width-1], rd_syn_ptr[a_width-2:0]});

    always @(posedge Clk) begin
        if (Resetn == 1'b0)
            full_flag_reg <= 1'b0;
        else
            full_flag_reg <= full_flag_val; 
    end

    assign full_flag = full_flag_reg;
endmodule