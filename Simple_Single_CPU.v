/***************************************************
Student Name: 
Student ID: 
***************************************************/
/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps
module Simple_Single_CPU(
	input clk_i,
	input rst_i
	);
wire [31:0] pc_i;
wire [31:0] pc_o;
wire [31:0] instr;
wire RegWrite;
wire [31:0] RSdata_o;
wire [31:0] RTdata_o;
wire [31:0] ALUresult;
wire MemRead,MemWrite;
wire [31:0] DM_o;
wire ALUSrc;
wire Branch;
wire [1:0] ALUOp;
wire [3:0] ALU_CONTROL;
wire zero;
wire [31:0] pcplusfour;
wire [31:0] ingen;
wire [31:0] instrleft;
wire [31:0] instradd;
wire [31:0] muxdata;
wire Pcsrc;
wire [31:0] memtoreg;
wire [31:0] muxpc;
wire [31:0] writedata;
wire [1:0] Jump;
wire bge;
wire blt;

//assign Pcsrc = Branch & ((instr[12]==1)?~zero:zero);

assign Pcsrc = Branch & ((instr[14]==1 && instr[12]==1)?bge:((instr[14]==1)?blt:((instr[12]==1)?~zero:zero)));


ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_i(pc_i),   
	    .pc_o(pc_o) 
	    );

Instr_Memory IM(
        .addr_i(pc_o),  
	    .instr_o(instr)    
	    );		

Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[19:15]) ,  
        .RTaddr_i(instr[24:20]) ,  
        .RDaddr_i(instr[11:7]) ,  
        .RDdata_i(writedata)  , // MUX_3to1
        .RegWrite_i (RegWrite),
        .RSdata_o(RSdata_o) ,  
        .RTdata_o(RTdata_o)   
        );		

Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(ALUresult),
		.data_i(RTdata_o),
		.MemRead_i(MemRead),
		.MemWrite_i(MemWrite),
		.data_o(DM_o)
		);

MUX_2to1 Mux_MemtoReg(
		.data0_i(ALUresult),       
		.data1_i(DM_o),
		.select_i(MemtoReg),
		.data_o(memtoreg)	// connect to mux3to1
		);	

MUX_3to1 Mux_Write(
		.data0_i(memtoreg),       
		.data1_i(pcplusfour),//pc+4
		.data2_i(0),
		.select_i(Jump),
		.data_o(writedata)
		);
		
Decoder Decoder(
		.MemtoReg(MemtoReg),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Jump(Jump),//Jump
		.instr_i(instr), 
		.ALUSrc(ALUSrc),
	    .RegWrite(RegWrite),
	    .Branch(Branch),
		.ALUOp(ALUOp)  
	    );
		
Adder Adder1(
        .src1_i(pc_o),     
	    .src2_i(4),     
	    .sum_o(pcplusfour)    
	    );
		
Imm_Gen ImmGen(
		.instr_i(instr),
		.Imm_Gen_o(ingen)
		);

Shift_Left_1 SL1(
		.data_i(ingen),
		.data_o(instrleft)
		);

Adder Adder2(
        .src1_i(pc_o),     
	    .src2_i(instrleft),     
	    .sum_o(instradd)   
	    );

MUX_2to1 Mux_PCSrc(
		.data0_i(pcplusfour),       
		.data1_i(instradd),
		.select_i(Pcsrc),
		.data_o(muxpc)// connect  to 3to1 mux
		);

MUX_3to1 Mux_Jump(
		.data0_i(muxpc),       
		.data1_i(instrleft),
		.data2_i(RSdata_o),
		.select_i(Jump),
		.data_o(pc_i)
		);
	

			
ALU_Ctrl ALU_Ctrl(
		.instr({instr[30],instr[14:12]}),
		.ALUOp(ALUOp),
		.ALU_Ctrl_o(ALU_CONTROL)
		);

MUX_2to1 Mux_ALUSrc(
		.data0_i(RTdata_o),       
		.data1_i(ingen),
		.select_i(ALUSrc),
		.data_o(muxdata)
		);

alu alu(
		.rst_n(rst_i),
		.src1(RSdata_o),
		.src2(muxdata),
		.ALU_control(ALU_CONTROL),
		.zero(zero),
		.result(ALUresult),
		.bge(bge),
		.blt(blt),
		.cout(),
		.overflow()
		);
endmodule
		  


