module ULA(inst, A, B, Resul, isFalse);
	// Entradas
	input [4:0] inst; // Operacao que sera realizada
	input [31:0] A; // Primeiro registrador
	input [31:0] B; // Segundo registrador
	parameter C=1;                         // Deslocamento    


	// Saidas
	output [31:0] Resul; // Resultado da operacao
	output isFalse;

	// Logica sequencial
	function [31:0] select;
	input[31:0] A, B;
	input[4:0] inst;
	case(inst)
	// Aritmeticas
	5'b00000: select = A + B; // ADD
	5'b00001: select = A + B; // ADDI
	5'b00010: select = A - B; // SUB
	5'b00011: select = A - B; // SUBI
	5'b00100: select = A * B; // MUL
	5'b00101: select = A / B; // DIV

	// Logicas
	5'b00110: select = A & B; // AND
	5'b00111: select = A & B; // ANDI
	5'b01000: select = A | B; // OR 
	5'b01001: select = A | B; // ORI
	5'b01010: select = ~A; // NOT

	// Deslocamentos
	5'b01100: select = A >> C; // SR
	5'b01101: select = A << C; // SL

	// Atribuicao
	5'b10110: select = A; // MOV 
	5'b10011: select = A; // LOAD
	5'b10100: select = A; // LOADI
	5'b10101: select = A; // STORE
	
	// Comparacao
	5'b10001: select = A == B ? 32'd1 : 32'd0;  //BEQ
	5'b10010: select = A != B ? 32'd1 : 32'd0;  //BNE
	5'b01011: select = A < B  ? 32'd1 : 32'd0;  // SLT

	default: select = 32'd0;
	endcase
	endfunction

	assign isFalse = A == 32'd0 ? 1'b1 : 1'b0;
	assign Resul = select(A, B, inst);
endmodule
