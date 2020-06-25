/***************************************************
Student Name: 
Student ID: 
***************************************************/
/***************************************************
Student Name: 
Student ID: 
***************************************************/

`timescale 1ns/1ps
module Pipeline_CPU(
	input clk_i,
	input rst_i
	);
wire [31:0] pc_i, pc_o;
wire [31:0] PC_p1, PC_p2, PC_p3, PC_p4;
wire [31:0] instr, instr_p1;
wire RegWrite, MemRead, MemWrite;
wire [31:0] RSdata_o, RSdata_o_p1, RSdata_o_p2, RTdata_o, RTdata_o_p1, RTdata_o_p2, RTdata_o_p3, Alurs1, Alurs2;
wire [31:0] ALUresult, ALUresult_p3, ALUresult_p4;
wire [31:0] DM_o, DM_o_p4;
wire ALUSrc, Branch, zero, zero_p3, Pcsrc;
wire [1:0] ALUOp;
wire [3:0] ALU_CONTROL;
wire [31:0] pcplusfour, ingen, ingen_p2, instrleft, instradd, muxdata, memtoreg, muxpc,writedata;
wire [1:0] Jump;
wire [3:0] ALUinstr;
wire [4:0] WB_address_p2, WB_address_p3, WB_address_p4, Rs1_p2, Rs2_p2; 
wire bge;
wire blt;
wire [2:0] EXE_p2, MEM_p2, MEM_p3;
wire [1:0] WB_p2, WB_p3, WB_p4;
wire [1:0] forwardA, forwardB;
wire muxRsWb, muxRtWb;


//assign Pcsrc = Branch & ((instr[14]==1 && instr[12]==1)?(~ALUresult[0]):((instr[14]==1)?ALUresult[0]:((instr[12]==1)?~zero:zero)));

//*******************************   first pipeline  *************************************************************************************//

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
	    .pc_i(pc_i),   
	    .pc_o(pc_o) 
	    );

Instr_Memory IM(
        .addr_i(pc_o),  
	    .instr_o(instr_p1)    
	    );	


Adder Adder1(
        .src1_i(pc_o),     
	    .src2_i(4),     
	    .sum_o(pcplusfour)    
	    );	

IFtoID IF2ID(
        .clk_i(clk_i),      
	    .rst_i(rst_i),
		.PCIn(pc_o),
		.instructionIn(instr_p1),
		.instruction (instr),
		.PC(PC_p1)
		);

MUX_2to1 Mux_PCSrc(
		.data0_i(pcplusfour),       
		.data1_i(PC_p3),
		.select_i(Pcsrc),
		.data_o(pc_i)
		);
	
MUX_2to1 Mux_MemtoReg(
		.data0_i(ALUresult_p4),       
		.data1_i(DM_o_p4),
		.select_i(WB_p4[0]),
		.data_o(writedata)	// connect to mux3to1
		);	

//*******************************   second pipeline  *************************************************************************************//

Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .RSaddr_i(instr[19:15]) ,  
        .RTaddr_i(instr[24:20]) ,  
        .RDaddr_i(WB_address_p4) ,  
        .RDdata_i(writedata)  , // MUX_3to1
        .RegWrite_i (WB_p4[1]), // Regwrite
        .RSdata_o(RSdata_o) ,  
        .RTdata_o(RTdata_o)   
        );		
		
Imm_Gen ImmGen(
		.instr_i(instr),
		.Imm_Gen_o(ingen)
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

assign muxRsWb = ( instr[19:15] == WB_address_p4) ? 1:0;
assign muxRtWb = ( instr[24:20] == WB_address_p4) ? 1:0;

MUX_2to1 RsWb(
		.data0_i(RSdata_o),       
		.data1_i(writedata),
		.select_i(muxRsWb),
		.data_o(RSdata_o_p1)	
		);	

MUX_2to1 RtWb(
		.data0_i(RTdata_o),       
		.data1_i(writedata),
		.select_i(muxRtWb),
		.data_o(RTdata_o_p1)	// connect to mux3to1
		);	

IDtoEXE ID2EXE(
        .clk(clk_i),      
	    .rst(rst_i),    
		.PCIn(PC_p1),
		.Read_data1In(RSdata_o_p1),
		.Read_data2In(RTdata_o_p1),
		.ImmGenIn(ingen),
		.ALUIn({instr[30],instr[14:12]}),
		.WB_addressIn(instr[11:7]), 
		.Rs1addressIn(instr[19:15]),
		.Rs2addressIn(instr[24:20]),
		.EXE_IN({ALUOp,ALUSrc}),
		.MEM_IN({Branch,MemRead,MemWrite}), 
		.WB_IN({RegWrite,MemtoReg}),
		.PC(PC_p2),
	    .Read_data1(RSdata_o_p2),
		.Read_data2(RTdata_o_p2),
		.ImmGen(ingen_p2),
		.ALU(ALUinstr),
		.WB_address(WB_address_p2),
		.EXE(EXE_p2),
		.MEM(MEM_p2),
		.WB(WB_p2),
		.Rs1address(Rs1_p2),
		.Rs2address(Rs2_p2)
		);

//*******************************   third pipeline  *************************************************************************************//

ALU_Ctrl ALU_Ctrl(
		.instr(ALUinstr),
		.ALUOp(EXE_p2[2:1]),  // ALUop
		.ALU_Ctrl_o(ALU_CONTROL)
		);

MUX_2to1 Mux_ALUSrc(
		.data0_i(RTdata_o_p2),       
		.data1_i(ingen_p2),
		.select_i(EXE_p2[0]),
		.data_o(muxdata)
		);

Shift_Left_1 SL1(
		.data_i(ingen_p2),
		.data_o(instrleft)
		);

Adder Adder2(
        .src1_i(PC_p2),     
	    .src2_i(instrleft),     
	    .sum_o(instradd)   
	    );

alu alu(
		.rst_n(rst_i),
		.src1(Alurs1),
		.src2(Alurs2),
		.ALU_control(ALU_CONTROL),
		.zero(zero),
		.result(ALUresult),
		.bge(bge),
		.blt(blt),
		.cout(),
		.overflow()
		);

ForwardingUnit forwardingUnit(
		.ExMemRegwrite(WB_p3[1]),
		.MemWbRegwrite(WB_p4[1]), 
		.IDExRs1(Rs1_p2), 
		.IDExRs2(Rs2_p2), 
		.ExMemRegRd(WB_address_p3), 
		.MemWbRegRd(WB_address_p4),
		.ForwardA(forwardA),
		.ForwardB(forwardB)
		);

EXtoMEM EX2MEM(
		.clk(clk_i),
		.rst(rst_i),
		.WB_IN(WB_p2),
		.MEM_IN(MEM_p2),
		.PCIn(instradd),
		.WritedataIn(Alurs2),
		.ALUResultIn(ALUresult),
		.ZeroIn(zero),
		.WB_addressIn(WB_address_p2),
		.WB(WB_p3),
		.MEM(MEM_p3),
		.PC(PC_p3),
		.Writedata(RTdata_o_p3),
		.ALUResult(ALUresult_p3),
		.Zero(zero_p3),
		.WB_address(WB_address_p3)
		);

MUX_3to1 Mux_Rs1(
		.data0_i(RSdata_o_p2),       
		.data1_i(writedata),
		.data2_i(ALUresult_p3),
		.select_i(forwardA),
		.data_o(Alurs1)
		);	

MUX_3to1 Mux_Rs2(
		.data0_i(muxdata),       
		.data1_i(writedata),
		.data2_i(ALUresult_p3),
		.select_i(forwardB),
		.data_o(Alurs2)
		);

//*******************************   fourth pipeline  *************************************************************************************//

Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(ALUresult_p3),
		.data_i(RTdata_o_p3),
		.MemRead_i(MEM_p3[1]),	//Memread
		.MemWrite_i(MEM_p3[0]), //Memwrite
		.data_o(DM_o)
		);


assign Pcsrc = zero_p3 & MEM_p3[2];

MEMtoWB MEM2WB(
		.clk(clk_i),
		.rst(rst_i),
		.WB_IN(WB_p3),
		.ALUResultIn(ALUresult_p3),
		.memReadIn(DM_o),
		.WB_addressIn(WB_address_p3),
		.WB(WB_p4),
		.ALUResult(ALUresult_p4),
		.memRead(DM_o_p4),
		.WB_address(WB_address_p4)
		);

/*
MUX_3to1 Mux_Write(
		.data0_i(memtoreg),       
		.data1_i(pcplusfour),//pc+4
		.data2_i(0),
		.select_i(Jump),
		.data_o(writedata)
		);	
MUX_3to1 Mux_Jump(
		.data0_i(muxpc),       
		.data1_i(instrleft),
		.data2_i(RSdata_o),
		.select_i(Jump),
		.data_o(pc_i)
		);
*/

endmodule
		  


