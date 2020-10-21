//2d array is not allowed in verilog as far as i know 
//2 point fft gives real outputs
//4 point fft gives complex outputs
//8 point fft gives complex as well as fractional outputs
//take car of always , initial and all....

//division of output by 10 is reaining 
//square root implementation is remaining
//also seeing the imaginary parts of output is remaining
//seeing overflow for square in finding square root

//commented only temporarily
module test_fft8(/*Ter0,Ter1,Ter2,Ter3,Ter4,Ter5,Ter6,Ter7,
Tei0,Tei1,Tei2,Tei3,Tei4,Tei5,Tei6,Tei7*/
);

	reg signed [11:0]  Te1;
	reg signed [11:0]  Te2;
	reg signed [11:0]  Te3;
	reg signed [11:0]  Te4;
	reg signed [11:0]  Te5;
	reg signed [11:0]  Te6;
	reg signed [11:0]  Te7;
	reg signed [11:0]  Te8;

	/*output*/  wire signed [11:0]  Ter0;
	/*output*/  wire signed [11:0]  Ter1;
	/*output*/  wire signed [11:0]  Ter2;
	/*output*/  wire signed [11:0]  Ter3;
	/*output*/  wire signed [11:0]  Ter4;
	/*output*/  wire signed [11:0]  Ter5;
	/*output*/  wire signed [11:0]  Ter6;
	/*output*/  wire signed [11:0]  Ter7;
	/*output*/  wire signed [11:0]  Tei0;
	/*output*/  wire signed [11:0]  Tei1;
	/*output*/  wire signed [11:0]  Tei2;
	/*output*/  wire signed [11:0]  Tei3;
	/*output*/  wire signed [11:0]  Tei4;
	/*output*/  wire signed [11:0]  Tei5;
	/*output*/  wire signed [11:0]  Tei6;
	/*output*/  wire signed [11:0]  Tei7;


	fft8 m0(
	.Ar0(Te1),.Ar1(Te2),.Ar2(Te3),.Ar3(Te4),.Ar4(Te5),.Ar5(Te6),.Ar6(Te7),.Ar7(Te8),
	.Yr0(Ter0),.Yr1(Ter1),.Yr2(Ter2),.Yr3(Ter3),.Yr4(Ter4),.Yr5(Ter5),.Yr6(Ter6),.Yr7(Ter7),
	.Yi0(Tei0),.Yi1(Tei1),.Yi2(Tei2),.Yi3(Tei3),.Yi4(Tei4),.Yi5(Tei5),.Yi6(Tei6),.Yi7(Tei7)
	);
	/*testing*/
	initial begin
	Te1=12'd10;
	Te2=12'd5;
	Te3=-12'd10;
	Te4=12'd12;	
	Te5=-12'd15;	
	Te6=12'd14;
	Te7=12'd0;
	Te8=-12'd9;

	#5$display("The values of input are %3d , %3d , %3d , %3d , %3d , %3d , %3d , %3d and the values of the ouputs are %3d+%3di , %3d+%3di , %3d+%3di , %3d+%3di , %3d+%3di , %3d+%3di , %3d+%3di , %3d+%3di ",Te1,Te2,Te3,Te4,Te5,Te6,Te7,Te8,Ter0,Tei0,Ter1,Tei1,Ter2,Tei2,Ter3,Tei3,Ter4,Tei4,Ter5,Tei5,Ter6,Tei6,Ter7,Tei7);
	end
	/*testing*/

endmodule

module fft8(
Ar0,Ar1,Ar2,Ar3,Ar4,Ar5,Ar6,Ar7,//real parts , inputs will always be real
Yr0,Yr1,Yr2,Yr3,Yr4,Yr5,Yr6,Yr7,//real parts
Yi0,Yi1,Yi2,Yi3,Yi4,Yi5,Yi6,Yi7
);	
	parameter TEN=+12'd10;

	/*inputs will be real*/
	input  wire signed [11:0]  Ar0;
	input  wire signed [11:0]  Ar1;
	input  wire signed [11:0]  Ar2;
	input  wire signed [11:0]  Ar3;
	input  wire signed [11:0]  Ar4;
	input  wire signed [11:0]  Ar5;
	input  wire signed [11:0]  Ar6;
	input  wire signed [11:0]  Ar7;
		
	output  wire signed [11:0]  Yr0;
	output  wire signed [11:0]  Yr1;
	output  wire signed [11:0]  Yr2;
	output  wire signed [11:0]  Yr3;
	output  wire signed [11:0]  Yr4;
	output  wire signed [11:0]  Yr5;
	output  wire signed [11:0]  Yr6;
	output  wire signed [11:0]  Yr7;
	output  wire signed [11:0]  Yi0;
	output  wire signed [11:0]  Yi1;
	output  wire signed [11:0]  Yi2;
	output  wire signed [11:0]  Yi3;
	output  wire signed [11:0]  Yi4;
	output  wire signed [11:0]  Yi5;
	output  wire signed [11:0]  Yi6;
	output  wire signed [11:0]  Yi7;
	
	/*These are 4 of the 8th roots of unity*/
	reg signed [11:0] Wr0=12'd10;//W0 is 1+0i multiplied by 10
	reg signed [11:0] Wi0=12'd0;
	reg signed [11:0] Wr1=12'd7;//W1 is 0.7+0.7i multiplied by 10
	reg signed [11:0] Wi1=12'd7;
	reg signed [11:0] Wr2=12'd0;//W2 is 0+1i multiplied by 10
	reg signed [11:0] Wi2=12'd10;
	reg signed [11:0] Wr3= -12'd7;//W3 is -0.7+0.7i multiplied by 10
	reg signed [11:0] Wi3=12'd7;

	//variables in which return values of 4point fft will be stored 
	//this is for 1st 4 point fft output
	wire signed [11:0] Sr0;//S for store
	wire signed [11:0] Si0;
	wire signed [11:0] Sr1;//
	wire signed [11:0] Si1;
	wire signed [11:0] Sr2;//
	wire signed [11:0] Si2;
	wire signed [11:0] Sr3;//
	wire signed [11:0] Si3;

	wire signed [11:0] Qr0;//Q for store
	wire signed [11:0] Qi0;
	wire signed [11:0] Qr1;//
	wire signed [11:0] Qi1;
	wire signed [11:0] Qr2;//
	wire signed [11:0] Qi2;
	wire signed [11:0] Qr3;//
	wire signed [11:0] Qi3;

	//for storing the value of multiplication of w and ouput of second 4point fft
	wire signed [11:0] Mr0;//Q for store
	wire signed [11:0] Mi0;
	wire signed [11:0] Mr1;//
	wire signed [11:0] Mi1;
	wire signed [11:0] Mr2;//
	wire signed [11:0] Mi2;
	wire signed [11:0] Mr3;//
	wire signed [11:0] Mi3;

	//COu is C output , CIn is C Input
	//r stands for real and i for imaginary
	fft4 u0(
	.Cin0(Ar0),.Cin1(Ar2),.Cin2(Ar4),.Cin3(Ar6),
	/*these are the 4 (imaginary and real parts)outputs from the first 4point fft*/
	.COur0(Sr0),.COur1(Sr1),.COur2(Sr2),.COur3(Sr3),// it is COu for C Ouutput
	.COui0(Si0),.COui1(Si1),.COui2(Si2),.COui3(Si3)
	);
	fft4 u1(
	.Cin0(Ar1),.Cin1(Ar3),.Cin2(Ar5),.Cin3(Ar7),
	/*these are the 4 (imaginary and real parts)outputs from the second 4point fft*/
	.COur0(Qr0),.COur1(Qr1),.COur2(Qr2),.COur3(Qr3),
	.COui0(Qi0),.COui1(Qi1),.COui2(Qi2),.COui3(Qi3)
	);
	
	/*testing*/
	/*always@(*) begin
	$display("1st 4 point fft with input %d,%d,%d,%d gives output %d+%di,%d+%di,%d+%di,%d+%di\n",Ar0,Ar2,Ar4,Ar6,Sr0,Si0,Sr1,Si1,Sr2,Si2,Sr3,Si3);
	
	$display("2nd 4 point fft with input %d,%d,%d,%d gives output %d+%di,%d+%di,%d+%di,%d+%di\n",Ar1,Ar3,Ar5,Ar7,Qr0,Qi0,Qr1,Qi1,Qr2,Qi2,Qr3,Qi3);
	end*/
	/*testing*/

	//??????????????????Multiplying by 10???????????????????? before the complex multiplication?
	/*i dont think there is a necessity to multiply ouput of 2nd
	4point fft by 10 since we are already multiplying 10 to Ws
	and those get multiplied with the outputs */
	Mul2Comp w0(
	.Ar(Wr0),.Ai(Wi0),
	.Br(Qr0),.Bi(Qi0),
	.Yr(Mr0),.Yi(Mi0)
	);

	Mul2Comp w1(
	.Ar(Wr1),.Ai(Wi1),
	.Br(Qr1),.Bi(Qi1),
	.Yr(Mr1),.Yi(Mi1)
	);

	Mul2Comp w2(
	.Ar(Wr2),.Ai(Wi2),
	.Br(Qr2),.Bi(Qi2),
	.Yr(Mr2),.Yi(Mi2)
	);

	Mul2Comp w3(
	.Ar(Wr3),.Ai(Wi3),
	.Br(Qr3),.Bi(Qi3),
	.Yr(Mr3),.Yi(Mi3)
	);
	
	/*testing*/
	/*always@(*) begin
	$display("Multiplying complex roots in 8 point fft\n");
	$display("Multiplication of %d+%di and %d+%di gives %d+%di\n",Wr0,Wi0,Qr0,Qi0,Mr0,Mi0);
	$display("Multiplication of %d+%di and %d+%di gives %d+%di\n",Wr1,Wi1,Qr1,Qi1,Mr1,Mi1);
	$display("Multiplication of %d+%di and %d+%di gives %d+%di\n",Wr2,Wi2,Qr2,Qi2,Mr2,Mi2);
	$display("Multiplication of %d+%di and %d+%di gives %d+%di\n",Wr3,Wi3,Qr3,Qi3,Mr3,Mi3);
	end*/
	/*testing*/

	/*execution time can be minimised by storing values of Sr0,...Si3*/
	assign Yr0=(Sr0*TEN)+Mr0;
	assign Yi0=(Si0*TEN)+Mi0;
	assign Yr1=(Sr1*TEN)+Mr1;
	assign Yi1=(Si1*TEN)+Mi1;
	assign Yr2=(Sr2*TEN)+Mr2;
	assign Yi2=(Si2*TEN)+Mi2;
	assign Yr3=(Sr3*TEN)+Mr3;
	assign Yi3=(Si3*TEN)+Mi3;

	assign Yr4=(Sr0*TEN)-Mr0;
	assign Yi4=(Si0*TEN)-Mi0;
	assign Yr5=(Sr1*TEN)-Mr1;
	assign Yi5=(Si1*TEN)-Mi1;
	assign Yr6=(Sr2*TEN)-Mr2;
	assign Yi6=(Si2*TEN)-Mi2;
	assign Yr7=(Sr3*TEN)-Mr3;
	assign Yi7=(Si3*TEN)-Mi3;

	/*testing*/
	/*always@(*) begin
	$display("The final stage calculations and outputs are as follows:\n");
	$display("%d+%di and %d+%di gives %d+%di\n",Sr0,Si0,Mr0,Mi0,Yr0,Yi0);
	$display("%d+%di and %d+%di gives %d+%di\n",Sr1,Si1,Mr1,Mi1,Yr1,Yi1);
	$display("%d+%di and %d+%di gives %d+%di\n",Sr2,Si2,Mr2,Mi2,Yr2,Yi2);
	$display("%d+%di 
	$display("%d+%di and %d+%di gives %d+%di\n",Sr0,Si0,Mr0,Mi0,Yr4,Yi4);
	$display("%d+%di and %d+%di gives %d+%di\n",Sr1,Si1,Mr0,Mi0,Yr5,Yi5);
	$display("%d+%di and %d+%di gives %d+%di\n",Sr2,Si2,Mr0,Mi0,Yr6,Yi6);
	$display("%d+%di and %d+%di gives %d+%di\n",Sr3,Si3,Mr0,Mi0,Yr6,Yi6);
	end*/
	/*testing*/



	/*i will divide the numbers by 10 after fft8 is done*/	
	/*coz i have to take modulus by squaring and then i will*/
	/*take the square roots , so for all these operations*/
	/*making the number smaller is necessary or the number will overflow*/
	
endmodule

/*.Cin0(Ar1),.Cin1(Ar3),.Cin2(Ar5),.Cin3(Ar7),
	these are the 4 (imaginary and real parts)outputs from the second 4point fft
	.COur0(Qr0),.COur1(Qr1),.COur2(Qr2),.COur3(Qr3),
	.COui0(Qi0),.COui1(Qi1),.COui2(Qi2),.COui3(Qi3)*/
/*to see what variables are needed for fft4*/

module fft4(
Cin0,Cin1,Cin2,Cin3,
COur0,COur1,COur2,COur3,
COui0,COui1,COui2,COui3
);
	input signed [11:0] Cin0;
	input signed [11:0] Cin1;
	input signed [11:0] Cin2;
	input signed [11:0] Cin3;
	
	wire [11:0] Cin0;
	wire [11:0] Cin1;
	wire [11:0] Cin2;
	wire [11:0] Cin3;


	output signed [11:0] COur0;
	output signed [11:0] COur1;
	output signed [11:0] COur2;
	output signed [11:0] COur3;
	output signed [11:0] COui0;
	output signed [11:0] COui1;
	output signed [11:0] COui2;
	output signed [11:0] COui3;

	wire [11:0] COur0;
	wire [11:0] COur1;
	wire [11:0] COur2;
	wire [11:0] COur3;
	wire [11:0] COui0;
	wire [11:0] COui1;
	wire [11:0] COui2;
	wire [11:0] COui3;


	/*to catch the output of the values thrown out
	by 2 point fft*/
	wire signed [11:0] Cat0;//Cat is for 'catch'ing the values
	wire signed [11:0] Cat1;
	wire signed [11:0] Cat2;
	wire signed [11:0] Cat3;

	fft2 u0(.Fin0(Cin0),.Fin1(Cin2),.Fout0(Cat0),.Fout1(Cat1));
	fft2 u1(.Fin0(Cin1),.Fin1(Cin3),.Fout0(Cat2),.Fout1(Cat3));

	/*testing*/
	/*always@(*) begin
	$display("The 1st  2 point fft having input as %d,%d gives ouput as %d , %d\n",Cin0,Cin2,Cat0,Cat1);

	$display("The 2nd  2 point fft having input as %d,%d gives ouput as %d , %d\n", Cin1,Cin3,Cat2,Cat3);

	end*/
	/*testing*/

	/*combining*/
	assign COur0=Cat0+Cat2;
	assign COui0=0;
	assign COur1=Cat1;
	assign COui1=Cat3;
	assign COur2=Cat0-Cat2;
	assign COui2=0;
	assign COur3=Cat1;
	assign COui3= -Cat3;

endmodule

module fft2(
Fin0,Fin1,Fout0,Fout1
);
	input signed [11:0] Fin0;
	input signed [11:0] Fin1;
	output signed [11:0] Fout0;
	output signed [11:0] Fout1;

	wire [11:0] Fin0;
	wire [11:0] Fin1;
	wire [11:0] Fout0;
	wire [11:0] Fout1;


	assign Fout0=Fin0+Fin1;
	assign Fout1=Fin0-Fin1;

endmodule

module Mul2Comp(Ar,Ai,Br,Bi,Yr,Yi);
	input wire [11:0] Ar;
	input wire [11:0] Ai;
	input wire [11:0] Br;
	input wire [11:0] Bi;
	output [11:0] Yr;
	output [11:0] Yi;
	
	wire [11:0] Yr;
	wire [11:0] Yi;

	assign Yr=(Ar*Br)-(Ai*Bi);
	assign Yi=(Ar*Bi)+(Ai*Br);

endmodule

