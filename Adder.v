/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps

module Adder(
    input  [31:0] src1_i,
	input  [31:0] src2_i,
	output [31:0] sum_o
	);
    
assign sum_o = src1_i + src2_i;
/*
	always@(*)
		begin
		$display("adder!! src1= %31b  src2 = %31b, sum=%32b \n", src1_i,src2_i,sum_o);
		end
*/

endmodule