module Program_counter(
	input clk,									// clock
	input reset,								// reset
	input inta,									// interrupt acknowledge
	input [31:0] addrin,						// in address
	output reg [31:0] addrout,				// out address
	output reg [31:0] addrBckp);
	
	always @ (negedge clk) begin
		addrBckp <= inta ? addrBckp : addrin;
	end
	
	always @ (posedge clk) begin
		addrout <= reset | inta ? 31'b0 : addrin;
	end
endmodule