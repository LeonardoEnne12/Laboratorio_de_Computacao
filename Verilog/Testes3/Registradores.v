module Registradores(clock, regWrite, R1, R2,RD, dadosEscrita, leituraR1, leituraR2);
	input [4:0] R1; 
	input [4:0] R2; 
	input [4:0] RD; 
	input [31:0] dadosEscrita; // Dado Escrito no Registrador

	output [31:0] leituraR1; // Conteudo de R1
	output [31:0] leituraR2; // Conteudo de R2

	input clock;
	input regWrite; // Sinal de Escrita

	reg [31:0] regs[31:0];
	
	always @ (posedge clock) begin
		regs[RD] <= regWrite ? dadosEscrita : regs[RD];
	end

	assign leituraR1 = regs[R1];
	assign leituraR2 = regs[R2];
endmodule