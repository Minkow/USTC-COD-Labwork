`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:24:47 05/29/2016 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top(
	input clk,
	input rst_n,
	input sw,
	output [3:0]an,
	output [6:0]seg
    );

	wire RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,BranchD,EqualD;
	wire [2:0]ALUControlD;
	wire [1:0]PCSrcD;
	reg RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE;
	reg [2:0]ALUControlE;
	reg RegWriteM,MemtoRegM,MemWriteM;
	reg RegWriteW,MemtoRegW;
	wire [5:0]Op;
	wire [5:0]Funct;
	//CPUÄ£¿é
	wire StallF,StallD,ForwardAD,ForwardBD,FlushE;
	wire [1:0]ForwardAE;
	wire [1:0]ForwardBE;
	//HazardÄ£¿é
	wire [31:0]PC;
	
	wire [31:0]PCPlus4F;
	reg [31:0]PCPlus4D;
	wire [31:0]PCBranchD;
	//PCÄ£¿é
	wire [31:0]RDI;

	reg [31:0]InstrD;
	//¼¤ÀøÄ£¿é
	wire [4:0]A1;
	wire [4:0]A2;
	wire [4:0]A3;
	wire [31:0]WD3;
	wire [31:0]RD1;
	reg [31:0]RD1E;
	wire [31:0]RD2;
	reg [31:0]RD2E;
	//REGÄ£¿é
	wire [31:0]SignImmD;
	reg [31:0]SignImmE;
	
	wire [4:0]RsD;
	wire [4:0]RtD;
	wire [4:0]RdD;
	
	reg [4:0]RsE;
	reg [4:0]RtE;
	reg [4:0]RdE;
	
	wire [2:0]ALUOp;
	
	wire [31:0]SrcAE;
	wire [31:0]SrcBE;
	wire [31:0]WriteDataE;
	//ALUÄ£¿é
	wire [4:0]WriteRegE;
	reg [4:0]WriteRegM;
	reg [4:0]WriteRegW;
	
	reg [31:0]ALUOutM;
	wire [31:0]ALUResult;
	reg [31:0]WriteDataM;
	
	wire [31:0]RDM;
	
	reg [31:0]ReadDataW;
	reg [31:0]ALUOutW;
	
	wire [31:0]ResultW;
	
	reg [31:0]PCF;
	
	wire CLR;
	wire JumpD;
	wire JumpR;
	wire [31:0]PCJump;
	wire [31:0]PCJumpR;
	
	wire [31:0]CL;
	wire [31:0]CR;
	
	InstructionMemory IM(PCF[7:2],RDI);
	REG_FILE RF(~clk,rst_n,A1,A2,A3,WD3,RegWriteW,RD1,RD2);
	ALU alu(SrcAE,SrcBE,ALUControlE,ALUResult);
	DataMemory DM(ALUOutM[6:2],WriteDataM,clk,MemWriteM,RDM);
	SignExtend SE(InstrD[15:0],SignImmD);
	ControlUnit CU(Op,Funct,RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,BranchD,JumpD,JumpR,ALUOp);
	ALUDecoder AD(ALUOp,Funct,ALUControlD);
	HazardUnit HU(JumpD,BranchD,MemtoRegE,RegWriteE,MemtoRegM,RegWriteM,RegWriteW,JumpR,RsD,RtD,RsE,RtE,WriteRegE,WriteRegM,WriteRegW,StallF,StallD,ForwardAD,ForwardBD,FlushE,ForwardAE,ForwardBE);
	Digitron DI(clk,RDM[15:12],RDM[11:8],RDM[7:4],RDM[3:0],seg,an);
	
	assign A1=InstrD[25:21];
	assign A2=InstrD[20:16];
	assign A3=WriteRegW[4:0];
	assign WD3=ResultW;
	assign Op=InstrD[31:26];
	assign Funct=InstrD[5:0];
	assign RsD=InstrD[25:21];
	assign RtD=InstrD[20:16];
	assign RdD=InstrD[15:11];
	
	assign CL=(ForwardAD?ALUOutM:RD1);
	assign CR=(ForwardBD?ALUOutM:RD2);//´úÌæÔ­ÓÐµÄEqualD×÷ÅÐ¶Ï
		
	Judge JU(CL,CR,Op,RtD,EqualD);
	//assign EqualD=((ForwardAD?ALUOutM:RD1)==(ForwardBD?ALUOutM:RD2))?1:0;//EqualIDÑ¡ÔñÆ÷ÅÐ¶Ï
	//assign EqualD=(ForwardAD?ALUOutM:RD1)>0?1:0;//EqualID
	
	assign PCSrcD[0]=EqualD&&BranchD;//PCSrcD
	assign PCSrcD[1]=JumpD;
	assign PCPlus4F=PCF+4;
	assign PCBranchD=(SignImmD<<2)+PCPlus4D;//Î»ÍØÕ¹
	assign SrcAE=ForwardAE==0?RD1E:ForwardAE==1?ResultW:ALUOutM;
	assign WriteDataE=ForwardBE==0?RD2E:ForwardBE==1?ResultW:ALUOutM;
	assign WriteRegE=RegDstE?RdE:RtE;
	assign SrcBE=ALUSrcE?SignImmE:WriteDataE;
	assign CLR=PCSrcD[0]||PCSrcD[1]||JumpR;
	assign PCJump[27:0]=InstrD[25:0]<<2;
	assign PCJump[31:28]=PCPlus4D[31:28];
	assign PCJumpR=JumpR?CL:PCJump;
	assign ResultW=MemtoRegW?ReadDataW:ALUOutW;
	assign PC=PCSrcD==0?PCPlus4F:PCSrcD==1?PCBranchD:PCJumpR;
	
	always@(posedge clk or negedge rst_n)//Ëø´æÆ÷3,4
	begin
		if(~rst_n)
		begin
			PCF<=0;
		
			RegWriteM<=0;
			MemtoRegM<=0;
			MemWriteM<=0;
			WriteDataM<=0;
			WriteRegM<=0;
			
			RegWriteW<=0;
			MemtoRegW<=0;
			ReadDataW<=0;
			ALUOutW<=0;
			WriteRegW<=0;
		end
		
		else
		begin
			if(~StallF) PCF<=PC;
		
			RegWriteM<=RegWriteE;
			MemtoRegM<=MemtoRegE;
			MemWriteM<=MemWriteE;
			WriteDataM<=WriteDataE;
			WriteRegM<=WriteRegE;
			
			RegWriteW<=RegWriteM;
			MemtoRegW<=MemtoRegM;
			ReadDataW<=RDM;
			ALUOutW<=ALUOutM;
			WriteRegW<=WriteRegM;
		end
	end

	always@(posedge clk or negedge rst_n)//Ëø´æÆ÷1
	begin
		if(~rst_n)
		begin
			InstrD<=0;
			PCPlus4D<=0;
		end
		else
		if(~StallD)
		begin
			if(CLR)
			begin
				InstrD<=0;
				PCPlus4D<=0;
			end
			else
			begin
				InstrD<=RDI;
				PCPlus4D<=PCPlus4F;
			end
		end
	end

	always@(posedge clk or negedge rst_n)//Ëø´æÆ÷2
	begin
		if(~rst_n)
		begin
			RegWriteE<=0;
			MemtoRegE<=0;
			MemWriteE<=0;
			ALUControlE<=0;
			ALUSrcE<=0;
			RegDstE<=0;
			RD1E<=0;
			RD2E<=0;
			RsE<=0;
			RtE<=0;
			RdE<=0;
			SignImmE<=0;
		end
		else
		if(FlushE)
		begin
			RegWriteE<=0;
			MemtoRegE<=0;
			MemWriteE<=0;
			ALUControlE<=0;
			ALUSrcE<=0;
			RegDstE<=0;
			RD1E<=0;
			RD2E<=0;
			RsE<=0;
			RtE<=0;
			RdE<=0;
			SignImmE<=0;
		end
		else
		begin
			RegWriteE<=RegWriteD;
			MemtoRegE<=MemtoRegD;
			MemWriteE<=MemWriteD;
			ALUControlE<=ALUControlD;
			ALUSrcE<=ALUSrcD;
			RegDstE<=RegDstD;
			RD1E<=RD1;
			RD2E<=RD2;
			RsE<=RsD;
			RtE<=RtD;
			RdE<=RdD;
			SignImmE<=SignImmD;
		end
	end
	
	always@(posedge clk or negedge rst_n)//Ëø´æÆ÷3,4
	begin
		if(~rst_n)
		ALUOutM<=0;
		else if(sw)
		ALUOutM<=76;
		else ALUOutM<=ALUResult;
	end
	
endmodule
