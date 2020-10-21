module BinomialSqrt(InputReal,InputImaginary,OutputAnswer,SqrtClock);
	parameter N=3'd7;
	parameter M=(N*TWO)+3'd1;
	parameter TWO=2'd2;
	input [N:0] InputReal;
	input [N:0] InputImaginary;
	input SqrtClock;
	output [N:0] OutputAnswer;

	reg [M:0] SquareStore;

	wire [N:0] InputReal;
	wire [N:0] InputImaginary;
	reg [N:0] OutputAnswer;
	
	always@(posedge SqrtClock)begin
		case(InputReal>InputImaginary)
			1'b0:begin
				SquareStore=InputImaginary*InputImaginary;
				OutputAnswer=InputReal+(SquareStore/(InputReal*TWO));
			end
			1'b1:begin
				SquareStore=InputReal*InputReal;
				OutputAnswer=InputImaginary+(SquareStore/(InputImaginary*TWO));
			end
		endcase
	end

endmodule
