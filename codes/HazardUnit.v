`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:40:06 05/29/2016 
// Design Name: 
// Module Name:    HazardUnit 
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
////////
//////////////////////////////////////////////////////////////////////////
module HazardUnit(
	input JumpD,
	input BranchD,
	input MemtoRegE,
	input RegWriteE,
	input MemtoRegM,
	input RegWriteM,
	input RegWriteW,
	input JumpR,
	input [4:0]RsD,
	input [4:0]RtD,
	input [4:0]RsE,
	input [4:0]RtE,
	input [4:0]WriteRegE,
	input [4:0]WriteRegM,
	input [4:0]WriteRegW,
	
	output StallF,
	output StallD,
	output ForwardAD,
	output ForwardBD,
	output FlushE,
	output reg [1:0]ForwardAE,
	output reg [1:0]ForwardBE
    );

	wire Lwstall;
	wire BranchStall;
	
	assign #1 Lwstall=((RsD==RtE)|(RtD==RtE))&MemtoRegE;
	assign #1 BranchStall=(BranchD|JumpR)&(RegWriteE&(WriteRegE==RsD|WriteRegE==RtD)|MemtoRegM&(WriteRegM==RsD|WriteRegM==RtD));
	
	assign ForwardAD=(RsD!=0&RsD==WriteRegM&RegWriteM);
	assign ForwardBD=(RtD!=0&RtD==WriteRegM&RegWriteM);
	
	assign StallF=Lwstall|BranchStall;
	assign StallD=Lwstall|BranchStall;
	assign FlushE=Lwstall|BranchStall;
	
always@(*)
begin
	ForwardAE=0;
	ForwardBE=0;
	if((RsE!=0)&&(RsE==WriteRegM)&&RegWriteM)
		ForwardAE=2;
	else if((RsE!=0)&&(RsE==WriteRegW)&&RegWriteW)
		ForwardAE=1;

	if((RtE!=0)&&(RtE==WriteRegM)&&RegWriteM)
		ForwardBE=2;
	else if((RtE!=0)&&(RtE==WriteRegW)&&RegWriteW)
		ForwardBE=1;
end
	
endmodule
