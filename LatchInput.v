//wait for prescribed amount of time and then change the output
//according to the current input

//LatchClock has to be set in the instantiation

//module working well
module LatchInput(NumberIn0,NumberOut0,LatchClock);

	input [11:0] NumberIn0;
	input LatchClock;
	wire LatchClock;
	output [11:0] NumberOut0;
	wire [11:0] NumberIn0;
	wire [11:0] NumberOut0;
	reg [11:0] NumberTemp0;
	
	assign NumberOut0=NumberTemp0;

	always@(posedge LatchClock)begin
		NumberTemp0=NumberIn0;
	end

endmodule

`timescale 1ns/1ns

module TestLatchInput();
	
	reg clock;
	reg [2:0] SelClockFreq;
	wire [11:0] CatchOut;//catch the output
	reg [11:0] Number;
	wire [11:0] GiveInput;

	assign GiveInput=Number;

	initial begin
		clock=1'b0;
		SelClockFreq=3'b000;
		Number=11'd0;
		#10 $dumpfile("testlatch.vcd");
		#30 $dumpvars(1,TestLatchInput);
		#200 $finish;
	end
	
	LatchInput testmodule(.NumberIn0(GiveInput),.NumberOut0(CatchOut),.LatchClock(SelClockFreq[1]));

	always@(posedge clock)begin
		SelClockFreq=SelClockFreq+3'd1;
		Number=Number+1'b1;
	end

	always #10 clock=!clock;

endmodule
