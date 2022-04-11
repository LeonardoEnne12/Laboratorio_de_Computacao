module MuxPC(inst, A, B, C, Resul, isFalse);
	// Entradas
	input [1:0] inst; 
	input [31:0] A; 
	input [31:0] B;
	input [31:0] C;	

	// Saidas
	output [31:0] Resul; // Resultado da operacao
	output isFalse;

	// Logica sequencial
	function [31:0] select;
	input[31:0] A, B,C;
	input[1:0] inst;
	case(inst)
	
	// Deslocamentos
	5'b00: select = A; 
	5'b01: select = B; 
	5'b10: select = C; 


	default: select = 32'd0;
	endcase
	endfunction

	assign isFalse = A == 32'd0 ? 1'b1 : 1'b0;
	assign Resul = select(A, B, C,inst);
	
endmodule