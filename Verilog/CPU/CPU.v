module Program_counter(
	input clk,									// clock
	input reset,								// reset
	input [31:0] addrin,						// in address
	output reg [31:0] addrout);
	
	always @ (posedge clk) begin
		addrout <= reset ? 31'b0 : addrin;
	end
endmodule

module MultiplexULA(A, B, S, Y);
	// Entradas
	input [31:0] A; // Dado vindo do banco de registradores
	input [31:0] B; // Dado vindo do extensor de bits
	
	input S; // Sinal de controle 
	
	output [31:0] Y; 
	
	assign Y = S ? A : B;
endmodule

module MuxPC(A, B, S, Y);
	// Entradas
	input [31:0] A; // Dado vindo do banco de registradores
	input [31:0] B; // Dado vindo do extensor de bits
	
	input S; // Sinal de controle 
	
	output [31:0] Y; 
	
	assign Y = S ? A : B;
endmodule

module MuxExte(A, B, S, Y);
	// Entradas
	input [31:0] A; // Dado vindo do banco de registradores
	input [31:0] B; // Dado vindo do extensor de bits
	
	input S; // Sinal de controle 
	
	output [31:0] Y; 
	
	assign Y = S ? A : B;
endmodule

module Mux_Desv(IM, Regis, ctrl, out);
	// Entradas
	input [31:0] IM; 
	input [31:0] Regis;
	input ctrl;
	
	// Saida
	output [31:0] out;
	
	assign out = ctrl ? IM : Regis;
endmodule

module Muxout(inst, A, B, C, Resul, isFalse);
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
	2'b00: select = A; 
	2'b01: select = B; 
	2'b10: select = C; 


	default: select = 32'd0;
	endcase
	endfunction

	assign isFalse = A == 32'd0 ? 1'b1 : 1'b0;
	assign Resul = select(A, B, C,inst);
	
endmodule

module ExtensorBit(entrada, dadoExtendido);
	input [21:0] entrada; 

	output reg [31:0] dadoExtendido; // Dado extendido de 32 bits	
	
	always @ (entrada) begin			
			if	(entrada[21] == 1'b1)
				dadoExtendido = entrada + 32'b11111100000000000000000000000000;
			else
				dadoExtendido = entrada + 32'b0;
	end
	
endmodule

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

module Somadordesv(pc,IM, pcAtual);
	
	input [31:0] pc;	// Endereco do contador de programa atual
	
	input [31:0] IM;  // Endereco do desvio
	
	output [31:0] pcAtual;	// Endereco do contador de programa do proximo ciclo
	
	assign pcAtual = pc + IM;
	
endmodule

module Somador_Padrao(pc, pcAtual);
	
	input [31:0] pc;								// Endereco do contador de programa atual
	
	output [31:0] pcAtual;						// Endereco do contador de programa do proximo ciclo
	
	assign pcAtual = pc + 32'd1;
	
endmodule

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

module Mem_instr
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[28**ADDR_WIDTH-1:0];

	initial
	begin
		$readmemb("instrucoes.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

endmodule

module Mem_dados
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=32)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, read_clock, write_clock,
	output reg [(DATA_WIDTH-1):0] q,
	output reg[(DATA_WIDTH-1):0] x
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[ADDR_WIDTH-1:0];
	
	always @ (posedge write_clock)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;
	end
	
	always @ (posedge read_clock)
	begin
		// Read 
		q <= ram[read_addr];
		x <= ram[10];
	end
	
endmodule

module datapath (ControleUla,SinalMux,SinalEscritaMem,clk,SinalEscritaReg,Sdadoext, Smuxula, Sdesv, SelPC,resetPC,saida,Instru);
	
	input [4:0]ControleUla;
	input [1:0]SinalMux;
	input SinalEscritaMem,clk,SinalEscritaReg;
	input Sdadoext, Smuxula, Sdesv, SelPC, resetPC;

	output [31:0] saida;
	output [31:0] Instru;
	
	wire [31:0] Dado1, Dado2,Dado2MUX,ResultULA, outMD,outmuxMD;
	wire FalseUla ,Falsemux;
	wire [31:0] outmuxExte, Exte16, Exte21, DadosIM;
	wire [31:0] AdressPC;
	wire [31:0] Desv, Nextinst;
	wire [31:0] Sumpc, pcSumdesv;
	
	ULA ula(ControleUla, Dado1, Dado2MUX, ResulULA, FalseUla);     
	Mem_dados md( ResulULA, Instru[26:22], Instru[26:22], SinalEscrita, clk, clk, outMD, saida);
	Registradores Regis(clk, SinalEscritaReg , Instru[21:17], Instru[16:12] , Instru[26:22], outmuxMD, Dado1, Dado2); 
	Mem_instr minst(AdressPC , clk , Instru); 
	Extensor_bitsB dezesseis(Instru[16:0], Exte16);
	ExtensorBit vinteum(Instru[21:0], Exte21);
	MuxExte exteout(Exte16, Exte21, Sdadoext, DadosIM);
	MultiplexULA muxULA(Dado2, DadosIM, Smuxula, Dado2MUX);
	Mux_Desv mudev(DadosIM, Dado1, Sdesv, Desv);
	Muxout muxot(SinalMux, DadosIM, ResulULA, outmuxMD, Resul, Falsemux);
	MuxPC mupc(Sumpc , pcSumdesv , SelPC, Nextinst);
	Program_counter Pc(clk, resetPC,Nextinst,AdressPC);
	Somador_Padrao SumP(AdressPC , Sumpc);
	Somadordesv Sumdesv(Sumpc , Desv, pcSumdesv);
	
endmodule

module CPU( clk, resetPC, saida,NotF,out);

	input clk, resetPC;
	output [31:0]saida;
	output NotF;
	output [4:0]out;
	
	wire [4:0]CULA;
	wire SEscritaMem, SEscritaReg,Sddext,Smula,SPC;
	wire[1:0]SinalM;
	wire [31:0] Inst;

datapath data(CULA,SinalM,SEscritaMem,clk,SEscritaReg,Sddext, Smula, Sdes, SPC,resetPC,saida,Inst);

Unidade_controle UC(Inst[31:27],CULA, SinalM,SEscritaMem,SEscritaReg,Sddext, Smula, Sdes, SPC,NotF);
 
//teste t(Inst[31:27], out); 
endmodule
/*
module teste(In, ou);

input [4:0] In;
output [4:0] ou;

assign ou = In;

endmodule
*/
module Unidade_controle(
								
	input [4:0]Instr,

	output reg [4:0]ControleUla,
	output reg[1:0]SinalMux,
	output reg regSinalEscritaMem,SinalEscritaReg,
	output reg Sdadoext, Smuxula, Sdesv, SelPC,
	output reg NotFound
);
	always@*
		
	case(Instr)
	
	5'b00000: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// ADD
	
	5'b00001: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		Sdesv = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// ADDI
	
	5'b00010:
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end// SUB
	
	5'b00011: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		Sdesv = 1'b1;
		SinalEscritaReg = 1'b1;
	end// SUBI
	
	5'b00100: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// MUL
	
	5'b00101:
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// DIV

	5'b00110: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// AND
	
	5'b00111: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		Sdesv = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// ANDI
	
	5'b01000: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// OR 
	
	5'b01001: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		Sdesv = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// ORI
	
	5'b01010:
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// NOT

	5'b01011: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// SLT

	5'b01100: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// SR
	
	5'b01101: 
	begin
		Smuxula = 1'b1;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		SinalEscritaReg = 1'b1;
	end		// SL

	5'b01110: ; // jump
	
	5'b01111:
	begin
		SelPC = 1'b0;
		Sdadoext = 1'b0;
		Sdesv = 1'b1;
	end	// jumpI
	
	5'b10000: 
	begin
		SelPC = 1'b0;
		Sdadoext = 1'b0;
		Sdesv = 1'b1;
	end	// JAL
	
	5'b10001: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		SinalEscritaReg = 1'b1;
	end	//BEQ
	
	5'b10010: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		SinalEscritaReg = 1'b1;
	end	//BNE	
	
	5'b10011: 
	begin	
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// LOAD
	
	5'b10100: 
	begin
		Smuxula = 1'b0;
		ControleUla = Instr;
		SinalMux = 2'b01;
		SelPC = 1'b1;
		Sdadoext = 1'b1;
		SinalEscritaReg = 1'b1;
	end	// LOADI
	
	5'b10101: 
	begin
		ControleUla = Instr;
		SinalMux = 2'b00;
		SelPC = 1'b1;
		regSinalEscritaMem = 1'b1;
	end	// STORE
	
	5'b10110: ; // MOV 
	
	5'b10111: ; // IN 
	
	5'b11000: ; // OUT
	
	5'b11001: ; // Nop
	
	5'b11010: ; // Hlt
	
	

	default: NotFound = 1'b1;
	endcase
	
endmodule

