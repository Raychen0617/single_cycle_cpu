`timescale 1ns/1ps
module IDtoEXE (clk, rst, PCIn, Read_data1In, Read_data2In, ImmGenIn, ALUIn, WB_addressIn, Rs1addressIn, Rs2addressIn, EXE_IN, MEM_IN, WB_IN, PC, Read_data1, Read_data2, ImmGen, ALU, WB_address, EXE, MEM, WB, Rs1address, Rs2address);


    input clk, rst;
    input [1:0] WB_IN;   // {Regwrite,Memtoreg}
    input [2:0] EXE_IN;  // {ALUop[1:0],ALUsrc}
    input [2:0] MEM_IN;  // {Branch,Memread,Memwrite}
    input [31:0] PCIn, Read_data1In, Read_data2In, ImmGenIn;
    input [3:0] ALUIn;
    input [4:0] WB_addressIn;
    input [4:0] Rs1addressIn, Rs2addressIn;

    output reg [1:0] WB;
    output reg [2:0] EXE, MEM;
    output reg [31:0] PC,Read_data1, Read_data2, ImmGen;
    output reg [3:0] ALU;
    output reg [4:0] WB_address;
    output reg [4:0] Rs1address, Rs2address;

    always @ (posedge clk) begin
        if (~rst) begin
        {PC,Read_data1, Read_data2, ImmGen, ALU, WB_address, EXE, MEM, WB, Rs1address, Rs2address} <= 0;
        end
        else begin
            MEM <= MEM_IN;
            WB <= WB_IN;
            EXE <= EXE_IN;
            PC <= PCIn;
            Read_data1 <= Read_data1In;
            Read_data2 <= Read_data2In;
            ImmGen <= ImmGenIn;
            ALU <= ALUIn;
            WB_address <= WB_addressIn;
            Rs1address <= Rs1addressIn;
            Rs2address <= Rs2addressIn;
        end
    end

/*    always @ (*) begin
        $display("Regwrite = %1b,  MEM_OUT = %3b  EXE_OUT = %3b",
            WB[1], MEM , EXE
        );
    end
*/
endmodule 