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