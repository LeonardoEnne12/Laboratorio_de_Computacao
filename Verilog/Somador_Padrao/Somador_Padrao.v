module Somador_Padrao(pc, pcAtual);
	
	input [31:0] pc;								// Endereco do contador de programa atual
	
	output [31:0] pcAtual;						// Endereco do contador de programa do proximo ciclo
	
	assign pcAtual = pc + 32'd1;
	
endmodule