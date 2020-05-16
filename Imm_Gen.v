/***************************************************
Student Name: 
Student ID: 0716230
***************************************************/

`timescale 1ns/1ps


module Imm_Gen(
	input  [31:0] instr_i,
	output [31:0] Imm_Gen_o
	);

wire [6:0] opcode;
assign opcode = instr_i[6:0];
wire [2:0] funct3;
assign funct3 = instr_i[14:12];
wire [11:0] imm;
wire [11:0] imm2;

assign imm =		(opcode==7'b1100011)?{instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8]}:(
                     (opcode==7'b0100011)?{instr_i[31:25],instr_i[11:7]}:((
					 (opcode==7'b1100111 && funct3==3'b000) ||	//JALR
                     (opcode==7'b0010011 && funct3==3'b000) ||	//ADDI
					 (opcode==7'b0010011 && funct3==3'b010) ||	//SLTI
					 (opcode==7'b0010011 && funct3==3'b100) ||	//XORI
					 (opcode==7'b0010011 && funct3==3'b110) ||	//ORI
					 (opcode==7'b0010011 && funct3==3'b001) ||	//SLI
					 (opcode==7'b0010011 && funct3==3'b101) ||	//SRI
					 (opcode==7'b0010011 && funct3==3'b111))?{instr_i[31:20]}:(//ANDI
					 (opcode==7'b0110011)?32'b0:(
					 (opcode==7'b1101111)?{instr_i[31],instr_i[19:12],instr_i[20], instr_i[30:21]}:
					 {instr_i[31:20]}))));

assign imm2 = instr_i[31:20];

assign Imm_Gen_o[11:0] = imm[11:0];
assign Imm_Gen_o[31:12] = {20{imm[11]}};

/*
always @ (*) begin
  $display("instr=%32b, opcode = %7b, imm = %12b ",
        instr_i, opcode, imm, Imm_Gen_o
   );
   
end
*/
endmodule