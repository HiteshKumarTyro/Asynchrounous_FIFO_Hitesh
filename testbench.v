`timescale 1ns/1ns

module testbench;

	parameter a_width = 6;
    parameter d_width = 16;
	
	reg 			   rd_Clk, rd_resetn, rd_en;
	reg 			   wr_Clk, wr_resetn, wr_en;
	reg  [d_width-1:0] wr_data;
	wire [d_width-1:0] rd_data;
	wire 			   fifo_full, fifo_empty;
	
	integer i;
	
	Async_FIFO #(a_width, d_width) DUT (.rd_Clk(rd_Clk), .rd_resetn(rd_resetn), .rd_en(rd_en),
										.wr_Clk(wr_Clk), .wr_resetn(wr_resetn), .wr_en(wr_en),
										.wr_data(wr_data), .rd_data(rd_data), 
										.fifo_full(fifo_full), .fifo_empty(fifo_empty));
	
	always
	begin
		rd_Clk = ~rd_Clk; 
		#50;
	end
	
	always
	begin
		wr_Clk = ~wr_Clk;
		#10;
	end
	
	initial
	begin
		rd_Clk = 0;
		wr_Clk = 0;
		rd_resetn = 0;
		wr_resetn = 0;
		wr_en = 0;
		rd_en = 0;
		#120;
		
		rd_resetn = 1;
		wr_resetn = 1;
		#25;
		
		wr_data = 420;
		wr_en = 1;
		rd_en = 1;
		#20;
		for (i=1; i<50; i=i+1)
		begin
			wr_data = i;
			#20;
		end
		wr_en = 0;
		
		#5000;
		
		wr_data = 619;
		wr_en = 1;
		#20;
		for (i=1; i<50; i=i+1)
		begin
			wr_data = 2*i + 3*i*i + 5;
			#20;
		end
		wr_en = 0;
		
		#5000;
		$stop;
	end
endmodule