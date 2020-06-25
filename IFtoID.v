`timescale 1ns/1ps

module IFtoID (clk_i, rst_i, PCIn, instructionIn, PC, instruction);
  input clk_i, rst_i;
  input [31:0] PCIn, instructionIn;
  output reg [31:0] PC, instruction;

  always @ (posedge clk_i) begin
    if (~rst_i) begin
        PC <= 0;
        instruction <= 0;
    end
    else begin
        instruction <= instructionIn;
        PC <= PCIn;
    end
  end
endmodule 