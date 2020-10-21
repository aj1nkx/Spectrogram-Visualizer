//this function computes the absolute 
//value of a signed verilog variable
module Modulus(SigNumber,UnsigNumber);
	parameter SIZE=3'd7;
	parameter MINUSONE=-1'b1;
	
	input [SIZE:0] SigNumber;
	output [SIZE:0] UnsigNumber;

	wire SigNumber;
	wire UnsigNumber;

	reg Temp;

	assign UnsigNumber=Temp;

	always@(*)begin
		if(SigNumber>0)
			Temp=SigNumber;
		else
			Temp=SigNumber*MINUSONE;
	end

endmodule
