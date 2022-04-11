module Multiplex1(A, B, S, Y);
	// Entradas
	input [31:0] A; // IM 16
	input [31:0] B; // IM 21
	
	input S; // Sinal de controle 
	
	output [31:0] Y; 
	
	assign Y = S ? A : B;
endmodule
