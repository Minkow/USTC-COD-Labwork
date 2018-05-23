`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:40 12/08/2015 
// Design Name: 
// Module Name:    Digitron 
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
module Digitron(
	 input clk,
    input [3:0]data1,
    input [3:0]data2,
    input [3:0]data3,
    input [3:0]data4,
    output reg [6:0]seg,
	 output reg [3:0]an
    );

reg clk3;
reg [15:0]cnt=0;
reg [3:0]data;

always@(posedge clk)
begin
if(cnt==16'b1000_0000_0000_0000) 
	 begin
		 clk3<=~clk3;
		 cnt<=16'b0;
	 end
	 else
		 cnt<=cnt+16'b1;
end

always@(posedge clk3)
begin
	case(an[3:0])
		4'b0111:	
		begin
			data=data2;
			an=4'b1011;
		end
		4'b1011:
		begin
			data=data3;
			an=4'b1101;
		end
		4'b1101:
		begin
			data=data4;
			an=4'b1110;
		end
		4'b1110:
		begin
			data=data1;
			an=4'b0111;
		end
		default:
			an=4'b0111;
	endcase
end

always@(data)
begin
	case(data)
		4'h1:seg=7'b1111001;
		4'h2:seg=7'b0100100;
		4'h3:seg=7'b0110000;
		4'h4:seg=7'b0011001;
		4'h5:seg=7'b0010010;
		4'h6:seg=7'b0000010;
		4'h7:seg=7'b1111000;
		4'h8:seg=7'b0000000;
		4'h9:seg=7'b0011000;
		4'ha:seg=7'b0001000;
		4'hb:seg=7'b0000011;
		4'hc:seg=7'b1000110;
		4'hd:seg=7'b0100001;
		4'he:seg=7'b0000110;
		4'hf:seg=7'b0001110;
		default:seg=7'b1000000;
	endcase
end

endmodule
