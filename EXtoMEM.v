`timescale 1ns/1ps
module EXtoMEM (clk, rst, WB_IN, MEM_IN, PCIn, WritedataIn, ALUResultIn, ZeroIn, WB_addressIn,
                          WB,    MEM,    PC,    Writedata,   ALUResult,   Zero,   WB_address);
    input clk, rst, ZeroIn;
    input [1:0] WB_IN;   // {Regwrite,Memtoreg}
    input [2:0] MEM_IN;  // {Branch,Memread,Memwrite}
    input [31:0] PCIn, ALUResultIn, WritedataIn;
    input [4:0] WB_addressIn;

    output reg Zero;
    output reg [1:0] WB;
    output reg [2:0] MEM;
    output reg [31:0] PC,ALUResult, Writedata;
    output reg [4:0] WB_address;

    always @ (posedge clk) begin
        if (~rst) begin
        {WB, MEM, PC, ALUResult, Zero, WB_address} <= 0;
        end
        else begin
        WB <= WB_IN;
        MEM <= MEM_IN;
        PC <= PCIn;
        Writedata <= WritedataIn;
        ALUResult <= ALUResultIn;
        Zero <= ZeroIn;
        WB_address <= WB_addressIn;
        end
    end
    /*
    always @(*)begin
        $display("PC_p3 = %31b",
            PC
        );
    end
    */
endmodule 