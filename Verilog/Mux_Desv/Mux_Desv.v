module Mux_Desv(IM, Regis, ctrl, out);
	// Entradas
	input [31:0] IM; 
	input [31:0] Regis;
	input ctrl;
	
	// Saida
	output [31:0] out;
	
	assign out = ctrl ? IM : Regis;
endmodule