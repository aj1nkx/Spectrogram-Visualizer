`timescale 1ns/100ps

module test_sqrt();
	reg clock1;
	reg clear;
	reg start;
	reg [7:0] number;
	wire over;
	wire [3:0] answer;

	initial begin
		clock1=1'b0;
		clear=1'b0;
		start=1'b1;
		number=8'd64;
		$dumpfile("OutputSee.vcd");
		$dumpvars(0,test_sqrt);
		#200 $finish;

	end

	sqrt inst1(.clk(clock1),.clr(clear),.go(start),.sw(number),.done(over),.root(answer));

	always #10 clock1=!clock1;	
	
	
	endmodule
