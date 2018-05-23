`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:21 12/08/2015 
// Design Name: 
// Module Name:    Numtodigit 
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
module Numtodigit(
	 input [15:0]n,
	 output reg[15:0]d
	 );
	 
	 reg [15:0]t1;
	 reg [15:0]t2;
	 
always@(*)
begin
	if(n>=9000)
		d[15:12]=9;
	else if(n>=8000)
		d[15:12]=8;
	else if(n>=7000)
		d[15:12]=7;
	else if(n>=6000)
		d[15:12]=6;
	else if(n>=5000)
		d[15:12]=5;
	else if(n>=4000)
		d[15:12]=4;
	else if(n>=3000)
		d[15:12]=3;
	else if(n>=2000)
		d[15:12]=2;
	else if(n>=1000)
		d[15:12]=1;
	else
		d[15:12]=0;
	t1=n-d[15:12]*1000;
	if(t1>=900)
		d[11:8]=9;
	else if(t1>=800)
		d[11:8]=8;
	else if(t1>=700)
		d[11:8]=7;
	else if(t1>=600)
		d[11:8]=6;
	else if(t1>=500)
		d[11:8]=5;
	else if(t1>=400)
		d[11:8]=4;
	else if(t1>=300)
		d[11:8]=3;
	else if(t1>=200)
		d[11:8]=2;
	else if(t1>=100)
		d[11:8]=1;
	else
		d[11:8]=0;
	t2=t1-d[11:8]*100;
	if(t2>=90)
		d[7:4]=9;
	else if(t2>=80)
		d[7:4]=8;
	else if(t2>=70)
		d[7:4]=7;
	else if(t2>=60)
		d[7:4]=6;
	else if(t2>=50)
		d[7:4]=5;
	else if(t2>=40)
		d[7:4]=4;
	else if(t2>=30)
		d[7:4]=3;
	else if(t2>=20)
		d[7:4]=2;
	else if(t2>=10)
		d[7:4]=1;
	else
		d[7:4]=0;
	d[3:0]=t2-d[7:4]*10;
end
 
endmodule
