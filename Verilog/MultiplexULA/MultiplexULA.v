module MultiplexULA(A, B, S, Y);
	// Entradas
	input [31:0] A; // Dado vindo do banco de registradores
	input [31:0] B; // Dado vindo do extensor de bits
	
	input S; // Sinal de controle 
	
	output [31:0] Y; 
	
	assign Y = S ? A : B;
endmodule