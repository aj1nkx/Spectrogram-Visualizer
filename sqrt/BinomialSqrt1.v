//program working fine

/*`timescale 1ns/1ns

module TestBinomialSqrt();
	parameter N=3'd7;

	reg [N:0] Increment1;
	reg [N:0] Increment2;
	reg clock;

	wire [N:0] Real;
	wire [N:0] Imaginary;
	wire [N:0] CatchAnswer;

	initial begin
		clock=1'b0;
		Increment1=8'b0;
		Increment2=8'b0;
		$dumpfile("BinomialSqrt.vcd");
		$dumpvars(0);
		#200 $finish;
	end

	always@(posedge clock)begin
		Increment1<=Increment1+8'd6;
		Increment2<=Increment2+8'd11;
	end

	always #5 clock=!clock;

	assign Real=Increment1;
	assign Imaginary=Increment2;

	BinomialSqrt call0(.InputReal(Real),.InputImaginary(Imaginary),.InteractAnswer(CatchAnswer));

endmodule*/

//trying out implementation without the clock
module BinomialSqrt(InputReal,InputImaginary,InteractAnswer);
	parameter N=3'd7;
	parameter M=(N*TWO)+3'd1;
	parameter TWO=2'd2;
	
	input [N:0] InputReal;
	input [N:0] InputImaginary;
	output [N:0] InteractAnswer;

	wire [N:0] InputReal;
	wire [N:0] InputImaginary;
	reg [N:0] OutputAnswer;
	reg [M:0] SquareStore;
	
	//this variable interacts with other modules since its a wire
	wire [N:0] InteractAnswer;

	assign InteractAnswer=OutputAnswer;

	//conditional expressions
	always@(InputReal or InputImaginary)begin
		if(InputReal>InputImaginary)begin
			SquareStore=InputImaginary*InputImaginary;
			OutputAnswer=InputReal+(SquareStore/(InputReal*TWO));
		end
		else begin
			SquareStore=InputReal*InputReal;
			OutputAnswer=InputImaginary+(SquareStore/(InputImaginary*TWO));
		end
	end
	
endmodule
