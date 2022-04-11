module Extensor_bitsB(entrada, dadoExtendido);
	input [16:0] entrada; 

	output reg [31:0] dadoExtendido; // Dado extendido de 32 bits	
	
	always @ (entrada) begin			
			if	(entrada[16] == 1'b1)
				dadoExtendido = entrada + 32'b11111100000000000000000000000000;
			else
				dadoExtendido = entrada + 32'b0;
	end
	
endmodule