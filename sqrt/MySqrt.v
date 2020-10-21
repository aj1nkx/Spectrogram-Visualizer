//since we know the values of square roots lie
//between 0 and 64 we will just compare and find
//the answer

//the value of square root appears at the first
//PGT

module MySqrt(Number,SquareRoot1,clk);
	input [6:0] Number;//can change this later
	input clk;
	wire clk;
	output [3:0] SquareRoot1;

	wire [6:0] Number;
	wire [3:0] SquareRoot1;
	reg [3:0] SquareRoot;

	assign SquareRoot1=SquareRoot;

	always@(posedge clk)begin
		if(Number==1'b0)
			SquareRoot<=4'd0;
		else if(Number==7'd1 || Number ==7'd2)
			SquareRoot<=1;
		else if(Number>=7'd4 && Number <=7'd6)
			SquareRoot<=4'd2;
		else if(Number>=7'd6  && Number <=7'd12)
			SquareRoot<=4'd3;
		else if(Number>=7'd12  && Number <=7'd20)
			SquareRoot<=4'd4;
		else if(Number>=7'd20  && Number <=7'd30)
			SquareRoot<=4'd5;
		else if(Number>=7'd30  && Number <=7'd42)
			SquareRoot<=4'd6;
		else if(Number>=7'd42  && Number <=7'd56)
			SquareRoot<=4'd7;
		else if(Number>=7'd56)
			SquareRoot<=4'd8;
	end
endmodule

module TestMySqrt();
	reg [6:0] squared;
	reg clock;
	wire [3:0] store;//testing

	MySqrt i0(.Number(squared),.SquareRoot1(store),.clk(clock));
	initial begin
	squared=7'd6;
	clock=1'b0;
	$dumpfile("MySqrt.vcd");
	$dumpvars(0);
	#50$display("The value of square root is %3d\n",store);
	#100 $finish;
	end

	always 
	#10 clock=!clock;

endmodule

/*
0->0
0.5-> 0.25 ~ 0
1->1
1.5->2.25 ~2
2->4
2.5->6.25 ~6
3->9
3.5->12.25 ~ 12
4->16
4.5->20.25 ~ 20
5->25
5.5->30.25 ~ 30
6->36
6.5->42.25 ~ 42
7->49
7.5->56.25 ~ 56
8->64

*/
