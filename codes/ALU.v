`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:06:28 03/22/2016 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
   input signed [31:0] alu_a,
   input signed [31:0] alu_b,
   input [2:0] alu_op,
   output reg [31:0] alu_out
   );
	
	parameter	A_NOP	= 0;	//������ 	
	parameter	A_ADD	= 1;	//���ż�
	parameter	A_SUB	= 2;	//���ż�
	parameter	A_AND = 3;	//��
	parameter	A_OR  = 4;	//��
	parameter	A_XOR = 5;	//���
	parameter	A_NOR = 6;	//���
	parameter	A_SLT = 7; 	//С��������
	
	always@(*)
	begin
		case(alu_op)
			A_NOP:alu_out = 31'b0;
			A_ADD:alu_out = alu_a + alu_b;
			A_SUB:alu_out = alu_a - alu_b;
			A_AND:alu_out = alu_a & alu_b;
			A_OR:	alu_out = alu_a | alu_b;
			A_XOR:alu_out = alu_a ^ alu_b;
			A_NOR:alu_out = ~(alu_a | alu_b);
			A_SLT:alu_out = alu_a < alu_b ? 1 : 0;
		endcase
	end

endmodule
