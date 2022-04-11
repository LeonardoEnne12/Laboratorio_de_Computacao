module Somadordesv(pc,IM, pcAtual);
	
	input [31:0] pc;	// Endereco do contador de programa atual
	
	input [31:0] IM;  // Endereco do desvio
	
	output [31:0] pcAtual;	// Endereco do contador de programa do proximo ciclo
	
	assign pcAtual = pc + IM;
	
endmodule