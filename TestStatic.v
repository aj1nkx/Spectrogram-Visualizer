`timescale 1ns/1ns

module TestStatic();
	wire [11:0] Inpt0;
	wire [11:0] Inpt1;
	wire [11:0] Inpt2;
	wire [11:0] Inpt3;
	wire [11:0] Inpt4;
	wire [11:0] Inpt5;
	wire [11:0] Inpt6;
	wire [11:0] Inpt7;
	
	wire [7:0] Oupt0;
	wire [7:0] Oupt1;
	wire [7:0] Oupt2;
	wire [7:0] Oupt3;
	wire [7:0] Oupt4;
	wire [7:0] Oupt5;
	wire [7:0] Oupt6;
	wire [7:0] Oupt7;
	
	assign Inpt0=11'd12;
	assign Inpt1=11'd15;
	assign Inpt2=11'd24;
	assign Inpt3=11'd5;
	assign Inpt4=11'd13;
	assign Inpt5=11'd22;
	assign Inpt6=11'd21;
	assign Inpt7=11'd9;
	
	initial begin
		$dumpfile("TestStatic.vcd");
		$dumpvars(0);
		#50 $finish;
	end

	fft8 test(.Ar0(Inpt0),.Ar1(Inpt1),.Ar2(Inpt2),.Ar3(Inpt3),.Ar4(Inpt4),.Ar5(Inpt5),.Ar6(Inpt6),.Ar7(Inpt7),.FinalAns0(Oupt0),.FinalAns1(Oupt1),.FinalAns2(Oupt2),.FinalAns3(Oupt3),.FinalAns4(Oupt4),.FinalAns5(Oupt5),.FinalAns6(Oupt6),.FinalAns7(Oupt7));
endmodule

module fft8(Ar0,Ar1,Ar2,Ar3,Ar4,Ar5,Ar6,Ar7,FinalAns0,FinalAns1,FinalAns2,FinalAns3,FinalAns4,FinalAns5,FinalAns6,FinalAns7);//this clk will typically be quite high since the 	

	parameter EIGHT=12'd8;//changed:added signed coz division was going wrong
	parameter FOUR=12'd4;
	//no effect of adding signed
	//removing + and seeing:no use

	/*inputs will be real*/
	input wire signed [11:0]  Ar0;
	input wire signed [11:0]  Ar1;
	input wire signed [11:0]  Ar2;
	input wire signed [11:0]  Ar3;
	input wire signed [11:0]  Ar4;
	input wire signed [11:0]  Ar5;
	input wire signed [11:0]  Ar6;
	input wire signed [11:0]  Ar7;

	output [7:0] FinalAns0;
	output [7:0] FinalAns1;
	output [7:0] FinalAns2;
	output [7:0] FinalAns3;
	output [7:0] FinalAns4;
	output [7:0] FinalAns5;
	output [7:0] FinalAns6;
	output [7:0] FinalAns7;

	wire [7:0] FinalAns0;
	wire [7:0] FinalAns1;
	wire [7:0] FinalAns2;
	wire [7:0] FinalAns3;
	wire [7:0] FinalAns4;
	wire [7:0] FinalAns5;
	wire [7:0] FinalAns6;
	wire [7:0] FinalAns7;

	//sizes of these???????????????
	wire [11:0] PenulAns0;
	wire [11:0] PenulAns1;
	wire [11:0] PenulAns2;
	wire [11:0] PenulAns3;
	wire [11:0] PenulAns4;
	wire [11:0] PenulAns5;
	wire [11:0] PenulAns6;
	wire [11:0] PenulAns7;

	wire [11:0] Scaled0;
	wire [11:0] Scaled1;
	wire [11:0] Scaled2;
	wire [11:0] Scaled3;
	wire [11:0] Scaled4;
	wire [11:0] Scaled5;
	wire [11:0] Scaled6;
	wire [11:0] Scaled7;


	wire signed [11:0]  Yr0;
	wire signed [11:0]  Yr1;
	wire signed [11:0]  Yr2;
	wire signed [11:0]  Yr3;
	wire signed [11:0]  Yr4;
	wire signed [11:0]  Yr5;
	wire signed [11:0]  Yr6;
	wire signed [11:0]  Yr7;
	wire signed [11:0]  Yi0;
	wire signed [11:0]  Yi1;
	wire signed [11:0]  Yi2;
	wire signed [11:0]  Yi3;
	wire signed [11:0]  Yi4;
	wire signed [11:0]  Yi5;
	wire signed [11:0]  Yi6;
	wire signed [11:0]  Yi7;

	//for storing the absolute values
	//of real and imaginary parts of 
	//asnwer	
	wire [11:0] Ymr0;
	wire [11:0] Ymr1;
	wire [11:0] Ymr2;
	wire [11:0] Ymr3;
	wire [11:0] Ymr4;
	wire [11:0] Ymr5;
	wire [11:0] Ymr6;
	wire [11:0] Ymr7;
	wire [11:0] Ymi0;
	wire [11:0] Ymi1;
	wire [11:0] Ymi2;
	wire [11:0] Ymi3;
	wire [11:0] Ymi4;
	wire [11:0] Ymi5;
	wire [11:0] Ymi6;
	wire [11:0] Ymi7;

	/*These are 4 of the 8th roots of unity*/
	reg signed [11:0] Wr0=12'd8;//W0 is 1+0i multiplied by 8
	reg signed [11:0] Wi0=12'd0;
	reg signed [11:0] Wr1=12'd6;//W1 is 0.7+0.7i multiplied by 8
	reg signed [11:0] Wi1=12'd6;
	reg signed [11:0] Wr2=12'd0;//W2 is 0+1i multiplied by 10
	reg signed [11:0] Wi2=12'd8;
	reg signed [11:0] Wr3= -12'd6;//W3 is -0.7+0.7i multiplied by 10
	reg signed [11:0] Wi3=12'd6;

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
	fft4 fft4one(
	.Cin0(Ar0),.Cin1(Ar2),.Cin2(Ar4),.Cin3(Ar6),
	/*these are the 4 (imaginary and real parts)outputs from the first 4point fft*/
	.COur0(Sr0),.COur1(Sr1),.COur2(Sr2),.COur3(Sr3),// it is COu for C Ouutput
	.COui0(Si0),.COui1(Si1),.COui2(Si2),.COui3(Si3)
	);
	fft4 fft4two(
	.Cin0(Ar1),.Cin1(Ar3),.Cin2(Ar5),.Cin3(Ar7),
	/*these are the 4 (imaginary and real parts)outputs from the second 4point fft*/
	.COur0(Qr0),.COur1(Qr1),.COur2(Qr2),.COur3(Qr3),
	.COui0(Qi0),.COui1(Qi1),.COui2(Qi2),.COui3(Qi3)
	);

	//Multiplying complex numbers and output from fft4
	//to produce outputs for fft8 after addition 
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
	
	/*execution time can be minimised by storing values of Sr0,...Si3*/
	//outputs of 8 point fft after appropriate addiition and subtraction
	//M's are already multiplied by 8 since W's are multiplied by 8
	assign Yr0=(Sr0*EIGHT)+Mr0;
	assign Yi0=(Si0*EIGHT)+Mi0;
	assign Yr1=(Sr1*EIGHT)+Mr1;
	assign Yi1=(Si1*EIGHT)+Mi1;
	assign Yr2=(Sr2*EIGHT)+Mr2;
	assign Yi2=(Si2*EIGHT)+Mi2;
	assign Yr3=(Sr3*EIGHT)+Mr3;
	assign Yi3=(Si3*EIGHT)+Mi3;

	assign Yr4=(Sr0*EIGHT)-Mr0;
	assign Yi4=(Si0*EIGHT)-Mi0;
	assign Yr5=(Sr1*EIGHT)-Mr1;
	assign Yi5=(Si1*EIGHT)-Mi1;
	assign Yr6=(Sr2*EIGHT)-Mr2;
	assign Yi6=(Si2*EIGHT)-Mi2;
	assign Yr7=(Sr3*EIGHT)-Mr3;
	assign Yi7=(Si3*EIGHT)-Mi3;
	
	//this takes the absolute value of the number
	//therefore if number is -2 it becomes
	//for example if Yr0 is negative
	//Ymr0 becomes positive
	//this is a part of our functional code
	//we commented it in the evening when we took just real part
	
	//Ym is Y mod i.e absolute value of Yr
	Modulus rea0(.SigNumber(Yr0),.UnsigNumber(Ymr0));
	Modulus ima0(.SigNumber(Yi0),.UnsigNumber(Ymi0));
	Modulus rea1(.SigNumber(Yr1),.UnsigNumber(Ymr1));
	Modulus ima1(.SigNumber(Yi1),.UnsigNumber(Ymi1));
	Modulus rea2(.SigNumber(Yr2),.UnsigNumber(Ymr2));
	Modulus ima2(.SigNumber(Yi2),.UnsigNumber(Ymi2));
	Modulus rea3(.SigNumber(Yr3),.UnsigNumber(Ymr3));
	Modulus ima3(.SigNumber(Yi3),.UnsigNumber(Ymi3));
	Modulus rea4(.SigNumber(Yr4),.UnsigNumber(Ymr4));
	Modulus ima4(.SigNumber(Yi4),.UnsigNumber(Ymi4));
	Modulus rea5(.SigNumber(Yr5),.UnsigNumber(Ymr5));
	Modulus ima5(.SigNumber(Yi5),.UnsigNumber(Ymi5));
	Modulus rea6(.SigNumber(Yr6),.UnsigNumber(Ymr6));
	Modulus ima6(.SigNumber(Yi6),.UnsigNumber(Ymi6));
	Modulus rea7(.SigNumber(Yr7),.UnsigNumber(Ymr7));
	Modulus ima7(.SigNumber(Yi7),.UnsigNumber(Ymi7));
	
	//this is for taking the sqrt with binomial method
	//Penul means Penultimate
	BinomialSqrt num0(.InputReal(Ymr0),.InputImaginary(Ymi0),.InteractAnswer(PenulAns0));	
	BinomialSqrt num1(.InputReal(Ymr1),.InputImaginary(Ymi1),.InteractAnswer(PenulAns1));	
	BinomialSqrt num2(.InputReal(Ymr2),.InputImaginary(Ymi2),.InteractAnswer(PenulAns2));	
	BinomialSqrt num3(.InputReal(Ymr3),.InputImaginary(Ymi3),.InteractAnswer(PenulAns3));	
	BinomialSqrt num4(.InputReal(Ymr4),.InputImaginary(Ymi4),.InteractAnswer(PenulAns4));	
	BinomialSqrt num5(.InputReal(Ymr5),.InputImaginary(Ymi5),.InteractAnswer(PenulAns5));	
	BinomialSqrt num6(.InputReal(Ymr6),.InputImaginary(Ymi6),.InteractAnswer(PenulAns6));	
	BinomialSqrt num7(.InputReal(Ymr7),.InputImaginary(Ymi7),.InteractAnswer(PenulAns7));	

	//since inputs were mutiplied by 8 we are now dividing them by 8
	// also the outputs may become larger after processing hence i am dividing them further 
	//by 8
	
	
	assign FinalAns0=PenulAns0/(EIGHT);//first EIGHT is for the EIGHT we multiplied
	assign FinalAns1=PenulAns1/(EIGHT);//and second Eight is for the three times
	assign FinalAns2=PenulAns2/(EIGHT);//our worst case is becoming double
	assign FinalAns3=PenulAns3/(EIGHT);
	assign FinalAns4=PenulAns4/(EIGHT);
	assign FinalAns5=PenulAns5/(EIGHT);
	assign FinalAns6=PenulAns6/(EIGHT);
	assign FinalAns7=PenulAns7/(EIGHT);
	
	/*
	//penul needs to be divided by ???????????????????????
	//penul means penultimate
	assign FinalAns0=Yr0[2:0];
	assign FinalAns1=Yr1[2:0];
	assign FinalAns2=Yr2[2:0];
	assign FinalAns3=Yr3[2:0];
	assign FinalAns4=Yr4[2:0];
	assign FinalAns5=Yr5[2:0];
	assign FinalAns6=Yr6[2:0];
	assign FinalAns7=Yr7[2:0];
	*/

	/*//testing
	initial begin
	#30 $display("Value of Square of Yr6 is %d\n",(Yr6/EIGHT)*(Yr6/EIGHT));
	#10 $display("Value of Square of Yi6 is %d\n",(Yi6/EIGHT)*(Yi6/EIGHT));
	#10 $display("Value of square of 1st output is ");
	#10 $display("real part of 4th answer is %d\n",Yr3);
	#10 $display("imaginary part of 4th answer is %d\n",Yi3);
	end*/

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

	//Final output of 4 pt fft
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


//multiplies 2 complex numbers
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

//this is a perfectly working module
// tested in its original source code file
module BinomialSqrt(InputReal,InputImaginary,InteractAnswer);
	parameter N=4'd11;
	parameter M=(N*TWO)+3'd1;
	parameter TWO=2'd2;
	
	input [N:0] InputReal;
	input [N:0] InputImaginary;
	output [N:0] InteractAnswer;

	wire [N:0] InputReal;
	wire [N:0] InputImaginary;
	reg [N:0] OutputAnswer;
	reg [M:0] SquareStore;
	reg [M:0] Store4Div;
	
	//this variable interacts with other modules since its a wire
	wire [N:0] InteractAnswer;

	assign InteractAnswer=OutputAnswer;

	/*initial begin
		OutputAnswer=12'd0;//Changes when N changes
		SquareStore=24'd0;//changes when M changes
	end*/

	//conditional expressions
	always@(*)begin
		if(InputReal==0)
			OutputAnswer=InputImaginary;
		else if(InputImaginary==0)
			OutputAnswer=InputReal;
		else if(InputReal>InputImaginary)begin
			SquareStore=InputImaginary*InputImaginary;
			Store4Div=InputReal*TWO;
			OutputAnswer=InputReal+(SquareStore/Store4Div);
		end
		else begin
			SquareStore=InputReal*InputReal;
			Store4Div=InputImaginary*TWO;
			OutputAnswer=InputImaginary+(SquareStore/Store4Div);
		end
	end
	
endmodule

module Modulus(SigNumber,UnsigNumber);
	parameter SIZE=4'd11;
	parameter MINUSONE=-1'b1;

	input signed [SIZE:0] SigNumber;
	output [SIZE:0] UnsigNumber;

	wire signed [SIZE:0] SigNumber;
	wire [SIZE:0] UnsigNumber;

	reg [SIZE:0] Temp;

	assign UnsigNumber=Temp;

	initial begin
	Temp=12'b0;//this will also change when SIZE changes
	end

		always@(SigNumber)begin
	if(SigNumber>=0)
		Temp=SigNumber;
	else
		Temp=SigNumber*MINUSONE;
	end

endmodule
