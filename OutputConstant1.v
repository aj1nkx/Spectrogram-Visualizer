//did proper frequencies of adc and displaying
//removed initial blocks, dindnt affect anything
`timescale 100s/1ns

//check b4 implementing whether sizes of all modules match with each other
module test_InOutManage();
	parameter INSIZE=3'd7;//after changing this also change Number in initial and 
	parameter OUTSIZE=2'd2;//always

	reg [INSIZE:0] Number;
	wire [INSIZE:0] NumberPass;
	reg clk;

	assign NumberPass={Number[2:0],Number[3]^Number[2]};

	wire [INSIZE:0] Catch0;
	wire [INSIZE:0] Catch1;
	wire [OUTSIZE:0] Catch2;
	wire [OUTSIZE:0] Catch3;
	wire [OUTSIZE:0] Catch4;
	wire [OUTSIZE:0] Catch5;
	wire [OUTSIZE:0] Catch6;
	wire [OUTSIZE:0] Catch7;

	wire clkTake;

	initial begin
		clk=1'b0;
		Number=8'd1;
		$dumpfile("OutputConstant1.vcd");
		$dumpvars(0);
		#10000 $finish;
	end

	always@(posedge clk)begin
		Number=Number+4'd11;
	end

	always #1 clk=!clk;

	TrueInOutManage1 test(.Adc8BitInput(NumberPass),.MainClock(clk),.MatrixOut0(Catch0),.MatrixOut1(Catch1),.clkPass(clkTake));
endmodule


//to remove initial from the blocks??? and also display and dumpvars?????

module TrueInOutManage1(Adc8BitInput,MatrixOut0,MatrixOut1,MainClock,clkPass);
//fftClock is fast clock for fft
	input [7:0] Adc8BitInput;//this input comes from the adc
	input MainClock;

	output clkPass;
	output [7:0] MatrixOut0;
	output [7:0] MatrixOut1;
	//output [2:0] LedSelect;//for selecting column of led matrix
		
	wire [7:0] Adc8BitInput;
	
	wire clkPass;
	wire HarshPass;
	
	reg [29:0] Number;
	
	assign clkPass=Number[5];//this is for adc simulation
	assign HarshPass=Number[12];//this is for led multiplexing
	
	always@(posedge MainClock)begin
		Number=Number+1'b1;
	end

	//these will get multiplexed and shown as LedOutput one by one
	wire [2:0] LedOutput0;
	wire [2:0] LedOutput1;
	wire [2:0] LedOutput2;
	wire [2:0] LedOutput3;
	wire [2:0] LedOutput4;
	wire [2:0] LedOutput5;
	wire [2:0] LedOutput6;
	wire [2:0] LedOutput7;

	//these are used for storing the inputs which we will assign to
	//the inputs of fft module
	reg [7:0] RegisterInput0;
	reg [7:0] RegisterInput1;
	reg [7:0] RegisterInput2;
	reg [7:0] RegisterInput3;
	reg [7:0] RegisterInput4;
	reg [7:0] RegisterInput5;
	reg [7:0] RegisterInput6;
	reg [7:0] RegisterInput7;

	wire [7:0] fftInput0;//these are actually outputs of our
	wire [7:0] fftInput1;//module but they serve as inputs of 
	wire [7:0] fftInput2;//fft8
	wire [7:0] fftInput3;
	wire [7:0] fftInput4;
	wire [7:0] fftInput5;
	wire [7:0] fftInput6;
	wire [7:0] fftInput7;

	//these variables are first in taking the inputs
	reg [7:0] TempInput0;
	reg [7:0] TempInput1;
	reg [7:0] TempInput2;
	reg [7:0] TempInput3;
	reg [7:0] TempInput4;
	reg [7:0] TempInput5;
	reg [7:0] TempInput6;
	reg [7:0] TempInput7;


	//how to initialise it for systhesis ???????
	reg [4:0] count;//for seeing uptil what stage are the inputs filled

	//the output which is feeding to fft8 should be reg
	//coz we will change it only after we receive all 8 inputs
	//till then the fft should show the previous input

	fft8 main(.Ar0({4'b0000,fftInput0}),.Ar1({4'b0000,fftInput1}),.Ar2({4'b0000,fftInput2}),.Ar3({4'b0000,fftInput3}),.Ar4({4'b0000,fftInput4}),.Ar5({4'b0000,fftInput5}),.Ar6({4'b0000,fftInput6}),.Ar7({4'b0000,fftInput7}),.FinalAns0(LedOutput0),.FinalAns1(LedOutput1),.FinalAns2(LedOutput2),.FinalAns3(LedOutput3),.FinalAns4(LedOutput4),.FinalAns5(LedOutput5),.FinalAns6(LedOutput6),.FinalAns7(LedOutput7),.clk(MainClock));

	//fft does not use clk so have to remove it later
	matrix leds(.TakeLedout1(MatrixOut0),.clk(HarshPass),.TakeLedout2(MatrixOut1),.inpt1(LedOutput0),.inpt2(LedOutput1),.inpt3(LedOutput2),.inpt4(LedOutput3),.inpt5(LedOutput4),.inpt6(LedOutput5),.inpt7(LedOutput6),.inpt8(LedOutput7));
	//module matrix(TakeLedout1, clk, TakeLedout2, inpt1, inpt2, inpt3, inpt4, inpt5, inpt6, inpt7, inpt8);


	assign fftInput0=RegisterInput0;//so there is some output present at the led
	assign fftInput1=RegisterInput1;//matrix at all times
	assign fftInput2=RegisterInput2;
	assign fftInput3=RegisterInput3;
	assign fftInput4=RegisterInput4;
	assign fftInput5=RegisterInput5;
	assign fftInput6=RegisterInput6;
	assign fftInput7=RegisterInput7;

	initial begin//remove this sfter testing
		Number=30'd0;
		count=4'b0;
		TempInput0=8'b0;
		TempInput1=8'b0;
		TempInput2=8'b0;
		TempInput3=8'b0;
		TempInput4=8'b0;
		TempInput5=8'b0;
		TempInput6=8'b0;
		TempInput7=8'b0;
		RegisterInput0=8'b0;
		RegisterInput1=8'b0;
		RegisterInput2=8'b0;
		RegisterInput3=8'b0;
		RegisterInput4=8'b0;
		RegisterInput5=8'b0;
		RegisterInput6=8'b0;
		RegisterInput7=8'b0;
	end

	always@(posedge clkPass)begin
		count<=count+4'b001;
		case(count)
			//we are taking inputs at ADC clock frequency only
			//but we are discarding some of the ADC outputs
			4'b0000:TempInput0<=Adc8BitInput;
			4'b0001:TempInput1<=Adc8BitInput;
			4'b0010:TempInput2<=Adc8BitInput;
			4'b0011:TempInput3<=Adc8BitInput;
			4'b0100:TempInput4<=Adc8BitInput;
			4'b0101:TempInput5<=Adc8BitInput;
			4'b0110:TempInput6<=Adc8BitInput;
			4'b0111:TempInput7<=Adc8BitInput;
			//as is visible from this the led matrix outputs
			//are displayed at 1/16th the ADC sampling freq
			//so if ADC sample freq is 50kHz display freq is
			//3kHz,and these registers drive input wires continuously
			//temp inputs take inputs one by one and in a flash
			//give those outputs for processing
			4'b1000:begin
				RegisterInput0<=TempInput0;
				RegisterInput1<=TempInput1;
				RegisterInput2<=TempInput2;
				RegisterInput3<=TempInput3;
				RegisterInput4<=TempInput4;
				RegisterInput5<=TempInput5;
				RegisterInput6<=TempInput6;
				RegisterInput7<=TempInput7;
			end
			default:;
			//giving some time for processing, discarding ADC outputs

		endcase
	end
endmodule

module fft8(Ar0,Ar1,Ar2,Ar3,Ar4,Ar5,Ar6,Ar7,FinalAns0,FinalAns1,FinalAns2,FinalAns3,FinalAns4,FinalAns5,FinalAns6,FinalAns7,clk
);//this clk will typically be quite high since the

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
	input clk;

	output [2:0] FinalAns0;
	output [2:0] FinalAns1;
	output [2:0] FinalAns2;
	output [2:0] FinalAns3;
	output [2:0] FinalAns4;
	output [2:0] FinalAns5;
	output [2:0] FinalAns6;
	output [2:0] FinalAns7;

	wire [2:0] FinalAns0;
	wire [2:0] FinalAns1;
	wire [2:0] FinalAns2;
	wire [2:0] FinalAns3;
	wire [2:0] FinalAns4;
	wire [2:0] FinalAns5;
	wire [2:0] FinalAns6;
	wire [2:0] FinalAns7;

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

	wire clk;

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
	//outputs of 8 point fft after appropriate addition and subtraction
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

	//Ym is Y mod i.e absolute value of Yr
	Modulus r0(.SigNumber(Yr0),.UnsigNumber(Ymr0));
	Modulus i0(.SigNumber(Yi0),.UnsigNumber(Ymi0));
	Modulus r1(.SigNumber(Yr1),.UnsigNumber(Ymr1));
	Modulus i1(.SigNumber(Yi1),.UnsigNumber(Ymi1));
	Modulus r2(.SigNumber(Yr2),.UnsigNumber(Ymr2));
	Modulus i2(.SigNumber(Yi2),.UnsigNumber(Ymi2));
	Modulus r3(.SigNumber(Yr3),.UnsigNumber(Ymr3));
	Modulus i3(.SigNumber(Yi3),.UnsigNumber(Ymi3));
	Modulus r4(.SigNumber(Yr4),.UnsigNumber(Ymr4));
	Modulus i4(.SigNumber(Yi4),.UnsigNumber(Ymi4));
	Modulus r5(.SigNumber(Yr5),.UnsigNumber(Ymr5));
	Modulus i5(.SigNumber(Yi5),.UnsigNumber(Ymi5));
	Modulus r6(.SigNumber(Yr6),.UnsigNumber(Ymr6));
	Modulus i6(.SigNumber(Yi6),.UnsigNumber(Ymi6));
	Modulus r7(.SigNumber(Yr7),.UnsigNumber(Ymr7));
	Modulus i7(.SigNumber(Yi7),.UnsigNumber(Ymi7));
	
	//Penul means Penultimate
	BinomialSqrt num0(.InputReal(Ymr0),.InputImaginary(Ymi0),.InteractAnswer(PenulAns0));	
	BinomialSqrt num1(.InputReal(Ymr1),.InputImaginary(Ymi1),.InteractAnswer(PenulAns1));	
	BinomialSqrt num2(.InputReal(Ymr2),.InputImaginary(Ymi2),.InteractAnswer(PenulAns2));	
	BinomialSqrt num3(.InputReal(Ymr3),.InputImaginary(Ymi3),.InteractAnswer(PenulAns3));	
	BinomialSqrt num4(.InputReal(Ymr4),.InputImaginary(Ymi4),.InteractAnswer(PenulAns4));	
	BinomialSqrt num5(.InputReal(Ymr5),.InputImaginary(Ymi5),.InteractAnswer(PenulAns5));	
	BinomialSqrt num6(.InputReal(Ymr6),.InputImaginary(Ymi6),.InteractAnswer(PenulAns6));	
	BinomialSqrt num7(.InputReal(Ymr7),.InputImaginary(Ymi7),.InteractAnswer(PenulAns7));	


	assign Scaled0=PenulAns0/(EIGHT*EIGHT);//first EIGHT is for the EIGHT we multiplied
	assign Scaled1=PenulAns1/(EIGHT*EIGHT);//and second Eight is for the three times
	assign Scaled2=PenulAns2/(EIGHT*EIGHT);//our worst case is becoming double
	assign Scaled3=PenulAns3/(EIGHT*EIGHT);
	assign Scaled4=PenulAns4/(EIGHT*EIGHT);
	assign Scaled5=PenulAns5/(EIGHT*EIGHT);
	assign Scaled6=PenulAns6/(EIGHT*EIGHT);
	assign Scaled7=PenulAns7/(EIGHT*EIGHT);

	//penul needs to be divided by ???????????????????????
	//penul means penultimate
	assign FinalAns0=PenulAns0[2:0];
	assign FinalAns1=PenulAns1[2:0];
	assign FinalAns2=PenulAns2[2:0];
	assign FinalAns3=PenulAns3[2:0];
	assign FinalAns4=PenulAns4[2:0];
	assign FinalAns5=PenulAns5[2:0];
	assign FinalAns6=PenulAns6[2:0];
	assign FinalAns7=PenulAns7[2:0];

	//testing
	initial begin
	#30 $display("Value of Square of Yr6 is %d\n",(Yr6/EIGHT)*(Yr6/EIGHT));
	#10 $display("Value of Square of Yi6 is %d\n",(Yi6/EIGHT)*(Yi6/EIGHT));
	#10 $display("Value of square of 1st output is ");
	#10 $display("real part of 4th answer is %d\n",Yr3);
	#10 $display("imaginary part of 4th answer is %d\n",Yi3);
	end

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
	
	//this variable interacts with other modules since its a wire
	wire [N:0] InteractAnswer;

	assign InteractAnswer=OutputAnswer;

	initial begin
		OutputAnswer=12'd0;//Changes when N changes
		SquareStore=24'd0;//changes when M changes
	end

	//conditional expressions
	always@(InputReal or InputImaginary)begin
		if(InputReal>InputImaginary)begin
			SquareStore=InputImaginary*InputImaginary;
			OutputAnswer=InputReal+(SquareStore/(InputReal*TWO));
		end
		else begin
			SquareStore=InputReal*InputReal;
			OutputAnswer=(InputImaginary+(SquareStore/(InputImaginary*TWO)));
		end
	end
	
endmodule

module Modulus(SigNumber,UnsigNumber);
	parameter SIZE=4'd11;
	parameter MINUSONE=-2'b1;
	
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
		if(SigNumber>0)
			Temp=SigNumber;
		else
			Temp=SigNumber*MINUSONE;
	end
endmodule

module matrix(TakeLedout1, clk, TakeLedout2, inpt1, inpt2, inpt3, inpt4, inpt5, inpt6, inpt7, inpt8);
	input [2:0] inpt1;//input from the ADC which is of 4-bit
	input [2:0] inpt2;//input from the ADC which is of 4-bit
	input [2:0] inpt3;//input from the ADC which is of 4-bit
	input [2:0] inpt4;//input from the ADC which is of 4-bit
	input [2:0] inpt5;//input from the ADC which is of 4-bit
	input [2:0] inpt6;//input from the ADC which is of 4-bit
	input [2:0] inpt7;//input from the ADC which is of 4-bit
	input [2:0] inpt8;//input from the ADC which is of 4-bit
	input clk;//clock of high frequency for selecting columns in led 
	output wire [7:0] TakeLedout1;
	output wire [7:0] TakeLedout2;

	reg [7:0] ledout1;
	reg [7:0] ledout2;
	reg [2:0] Q;//Counter for select
	reg [7:0] outh;
	reg [7:0] outl;

	assign TakeLedout1=ledout1;
	assign TakeLedout2=ledout2;

	initial begin
	 ledout1=8'd0;
	 ledout2=8'd0;
	outh=8'd0;
	outl=8'd0;
	Q=3'd0;
	end

	always@(posedge clk)begin
		Q <= Q+1'b1;

		  ledout2[7]<=~outl[0];							//addressing each bit on the led
		  ledout2[6]<=outh[4];							//addressing each bit on the led
		  ledout2[5]<=outh[2];							//addressing each bit on the led
		  ledout2[4]<=~outl[3];							//addressing each bit on the led
		  ledout2[3]<=outh[7];							//addressing each bit on the led
		  ledout2[2]<=~outl[1];							//addressing each bit on the led
		  ledout2[1]<=outh[1];							//addressing each bit on the led
		  ledout2[0]<=outh[0];							//addressing each bit on the led
		  ledout1[7]<=~outl[4];							//addressing each bit on the led
		  ledout1[6]<=~outl[6];							//addressing each bit on the led
		  ledout1[5]<=outh[6];							//addressing each bit on the led
		  ledout1[4]<=outh[5];							//addressing each bit on the led
		  ledout1[3]<=~outl[7];							//addressing each bit on the led
		  ledout1[2]<=outh[3];							//addressing each bit on the led
		  ledout1[1]<=~outl[5];							//addressing each bit on the led
		  ledout1[0]<=~outl[2];							//addressing each bit on the led

		if(Q==3'b000) begin
		outl <= 8'b10000000;
		case(inpt1)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b001) begin
			outl <= 8'b01000000;
		case(inpt2)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b010) begin
			outl <= 8'b00100000;
		case(inpt3)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b011) begin
			outl <= 8'b00010000;
		case(inpt4)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b100) begin
			outl <= 8'b00001000;
		case(inpt5)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b101) begin
			outl <= 8'b00000100;
		case(inpt6)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b110) begin
			outl <= 8'b00000010;
		case(inpt7)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
			else if(Q==3'b111) begin
			outl <= 8'b00000001;
		case(inpt8)
			3'b000: outh <= 8'b00000001;
			3'b001: outh <= 8'b00000011;
			3'b010: outh <= 8'b00000111;
			3'b011: outh <= 8'b00001111;
			3'b100: outh <= 8'b00011111;
			3'b101: outh <= 8'b00111111;
			3'b110: outh <= 8'b01111111;
			3'b111: outh <= 8'b11111111;
			endcase	
			end
		end
endmodule

/*
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
*/


//can i delete it??????????????????????????????
/*
module LatchInput(NumberIn0,NumberOut0,LatchClock);

	input [7:0] NumberIn0;
	input LatchClock;
	wire LatchClock;
	output [7:0] NumberOut0;
	wire [7:0] NumberIn0;
	wire [7:0] NumberOut0;
	reg [7:0] NumberTemp0;
	
	assign NumberOut0=NumberTemp0;

	always@(posedge LatchClock)begin
		NumberTemp0=NumberIn0;
	end

endmodule
*/
