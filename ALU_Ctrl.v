/***************************************************
Student Name: 
Student ID:0716230
***************************************************/

`timescale 1ns/1ps

module ALU_Ctrl(
	input	[4-1:0]	instr,
	input	[2-1:0]	ALUOp,
	output [4-1:0] ALU_Ctrl_o
	);
	wire [5:0] aluctrl;
   reg  [4:0] ALU_Ctrl;
	assign aluctrl = {ALUOp,instr};
   assign ALU_Ctrl_o=ALU_Ctrl; 

always@(aluctrl)
casex(aluctrl)
   6'b100010: ALU_Ctrl=4'b1110;   //slt
   6'b110010: ALU_Ctrl=4'b1110;   //slt imm
   6'b100100: ALU_Ctrl=4'b0111;   //xor
   6'b110100: ALU_Ctrl=4'b0111;	  //xor imm
   6'b100001: ALU_Ctrl=4'b1111;   //shift left 
   6'b110001: ALU_Ctrl=4'b1111;   //shift left imm
   6'b101101: ALU_Ctrl=4'b1010;   //shift right
   6'b110101: ALU_Ctrl=4'b1010;   //shift right imm
   6'b00xxxx: ALU_Ctrl=4'b0010;   //load
   6'b01xxxx: ALU_Ctrl=4'b0110;   //beq and bne  6'b01xxxx 
   6'b11x100: ALU_Ctrl=4'b0110;	  //blt
   6'b11x101: ALU_Ctrl=4'b0110;	  //bge
   6'b100000: ALU_Ctrl=4'b0010;   //add
   6'b11x000: ALU_Ctrl=4'b0010;   //add imm  11x000
   6'b101000: ALU_Ctrl=4'b0110;   //sub 
   6'b100111: ALU_Ctrl=4'b0000;   //and
   6'b11x111: ALU_Ctrl=4'b0000;   //and imm 6'b11x111
   6'b100110: ALU_Ctrl=4'b0001;   //or
   6'b11x110: ALU_Ctrl=4'b0001;   //or imm 11x110
   default  ALU_Ctrl=4'b0010;
endcase
/*
always @ (*) begin
  $display("instr = %4b, ALUOp = %2b, ALUctrl = %4b\n",
         instr, ALUOp, ALU_Ctrl
   );
end
*/

endmodule

