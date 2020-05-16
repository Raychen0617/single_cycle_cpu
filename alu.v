/***************************************************
Student Name:陳子睿 
Student ID:0716230
***************************************************/
`timescale 1ns/1ps

module alu(
	input                   rst_n,         // negative reless            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be less (output)
	output reg   [32-1:0]   cout,          // 1 bit carry out           (output)
	output reg              overflow,       // 1 bit overflow            (output)
	output reg 				bge,
	output reg 				blt
	);
always@(*)
begin 
	case(ALU_control)
	4'b0000: result = src1 & src2;
	4'b0001: result = src1 | src2;
	4'b0010: result = src1 + src2;
	4'b0110: result = src1 - src2;
	4'b0111: result = src1 ^ src2;  //xor
	4'b1111: result = src1<<src2;	//shift left
	4'b1010: result = src1>>src2;	//shift right
	4'b1110: result = (src1<src2)? 32'b1: 32'b0;	//slt
	default: result = src1 + src2;
	endcase

	zero = (src1==src2)?1:0;
	bge = (src1>=src2)?1:0;
	blt = (src1<src2)?1:0;
end
endmodule
