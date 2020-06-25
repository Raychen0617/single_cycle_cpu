`timescale 1ns/1ps
module MEMtoWB (clk, rst, WB_IN, ALUResultIn, memReadIn, WB_addressIn,
                          WB,    ALUResult,   memRead,   WB_address);
    input clk, rst;
    input [1:0] WB_IN;
    input [31:0] ALUResultIn, memReadIn;
    input [4:0] WB_addressIn;

    output reg [1:0] WB;
    output reg [31:0] ALUResult, memRead;
    output reg [4:0] WB_address;

    always @ (posedge clk) begin
        if (~rst) begin
        {WB, ALUResult, memRead, WB_address} <= 0;
        end
        else begin
        WB <= WB_IN;
        WB_address <= WB_addressIn;
        ALUResult <= ALUResultIn;
        memRead <= memReadIn;
        end
    end
endmodule