`timescale 1ns/1ns
//clocks check, which clock where
//initial???????????? remove during actual fpga implementation????
//remove all the testing lines like feedback
//bugs yis are changing but after 15~16 cycles,still output is 0
//bigstore is also changing after15 cycle
//actually the Bigstore lengths should be 31
//i think we will have to use megafunction for implementing square root
//just take 4 bit number from the adc so that the square will be smaller

module TestBench();

	//these regs are for changing the values and manipulating
	// and finally assigning to wires
	reg [7:0] Input;
	reg clock;
	
	//note that f of fft is small here
	wire TestfftClock;
	wire TestAdcClock;
	wire [2:0] TestLedSelect;
	wire feedback;//testing

	//these are for actual instantiation
	wire [7:0] TestAdc8BitInput;
	wire [3:0] TestLedOutput0;
	wire [3:0] TestLedOutput1;
	wire [3:0] TestLedOutput2;
	wire [3:0] TestLedOutput3;
	wire [3:0] TestLedOutput4;
	wire [3:0] TestLedOutput5;
	wire [3:0] TestLedOutput6;
	wire [3:0] TestLedOutput7;

	assign TestfftClock=TestAdcClock;
	assign TestAdcClock=clock;
	assign TestAdc8BitInput=Input;
	assign feedback=Input[7]^Input[0];

	InOutManage call0(.Adc8BitInput(TestAdc8BitInput),.LedOutput0(TestLedOutput0),.LedOutput1(TestLedOutput1),.LedOutput2(TestLedOutput2),.LedOutput3(TestLedOutput3),.LedOutput4(TestLedOutput4),.LedOutput5(TestLedOutput5),.LedOutput6(TestLedOutput6),.LedOutput7(TestLedOutput7),.LedSelect(TestLedSelect),.AdcClock(TestAdcClock),.fftClock(TestfftClock));

	always@(posedge clock)begin
		//Input=Input+8'd1;
		//testing
		Input[7]<=Input[6];
		Input[6]<=Input[5];
		Input[5]<=Input[4];
		Input[4]<=Input[3];
		Input[3]<=Input[2];
		Input[2]<=Input[1];
		Input[1]<=Input[0];
		Input[0]<=feedback;
	end

	always #1 clock=!clock;

	//testing
	initial begin
	clock=1'b0;
	Input=8'd1;
	#10 $dumpfile("fft.vcd");
	#10 $dumpvars(3,TestBench);
	#200 $finish;
	end

endmodule

module InOutManage(Adc8BitInput,LedOutput0,LedOutput1,LedOutput2,LedOutput3,LedOutput4,LedOutput5,LedOutput6,LedOutput7,LedSelect,AdcClock,fftClock);
//fftClock is fast clock for fft
	input [7:0] Adc8BitInput;//this input comes from the adc
	input AdcClock;
	input fftClock;
	output [2:0] LedSelect;//for selecting column of led matrix
	//Shoule these be reduced to one output which is multiplexed???????????????
	output [3:0] LedOutput0;
	output [3:0] LedOutput1;
	output [3:0] LedOutput2;
	output [3:0] LedOutput3;
	output [3:0] LedOutput4;
	output [3:0] LedOutput5;
	output [3:0] LedOutput6;
	output [3:0] LedOutput7;
	
	wire [7:0] Adc8BitInput;
	wire AdcClock;
	wire fftClock;

	reg [2:0] Ledselect;

	//these will get multiplexed and shown as LedOutput one by one
	wire [3:0] LedOutput0;
	wire [3:0] LedOutput1;
	wire [3:0] LedOutput2;
	wire [3:0] LedOutput3;
	wire [3:0] LedOutput4;
	wire [3:0] LedOutput5;
	wire [3:0] LedOutput6;
	wire [3:0] LedOutput7;

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
	reg [3:0] count;//for seeing uptil what stage are the inputs filled

	//the output which is feeding to fft8 should be reg
	//coz we will change it only after we receive all 8 inputs
	//till then the fft should show the previous input

	fft8 main(.Ar0({4'b0000,fftInput0}),.Ar1({4'b0000,fftInput1}),.Ar2({4'b0000,fftInput2}),.Ar3({4'b0000,fftInput3}),.Ar4({4'b0000,fftInput4}),.Ar5({4'b0000,fftInput5}),.Ar6({4'b0000,fftInput6}),.Ar7({4'b0000,fftInput7}),.FinalAns0(LedOutput0),.FinalAns1(LedOutput1),.FinalAns2(LedOutput2),.FinalAns3(LedOutput3),.FinalAns4(LedOutput4),.FinalAns5(LedOutput5),.FinalAns6(LedOutput6),.FinalAns7(LedOutput7),.clk(fftClock));

	assign fftInput0=RegisterInput0;//so there is some output present at the led
	assign fftInput1=RegisterInput1;//matrix at all times
	assign fftInput2=RegisterInput2;
	assign fftInput3=RegisterInput3;
	assign fftInput4=RegisterInput4;
	assign fftInput5=RegisterInput5;
	assign fftInput6=RegisterInput6;
	assign fftInput7=RegisterInput7;

	//which clock to write here
	always@(posedge AdcClock)begin
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
			//giving some time for processing, discarding ADC outputs
			4'b1001:;
			4'b1010:;
			4'b1011:;
			4'b1100:;
			4'b1101:;
			4'b1110:;
			4'b1111:;

		endcase
	end

	initial begin
		count=4'b0000;
	end

endmodule

module fft8(Ar0,Ar1,Ar2,Ar3,Ar4,Ar5,Ar6,Ar7,FinalAns0,FinalAns1,FinalAns2,FinalAns3,FinalAns4,FinalAns5,FinalAns6,FinalAns7,clk
);//this clk will typically be quite high since the 	

	parameter EIGHT=12'd8;//changed:added signed coz division was going wrong
	parameter FOUR=12'd4;
	//no effect of adding signed
	//removing + and seeing:no use

	/*inputs will be real*/
	input  wire signed [11:0]  Ar0;
	input  wire signed [11:0]  Ar1;
	input  wire signed [11:0]  Ar2;
	input  wire signed [11:0]  Ar3;
	input  wire signed [11:0]  Ar4;
	input  wire signed [11:0]  Ar5;
	input  wire signed [11:0]  Ar6;
	input  wire signed [11:0]  Ar7;
	input clk;

	output [3:0] FinalAns0;
	output [3:0] FinalAns1;
	output [3:0] FinalAns2;
	output [3:0] FinalAns3;
	output [3:0] FinalAns4;
	output [3:0] FinalAns5;
	output [3:0] FinalAns6;
	output [3:0] FinalAns7;

	wire [3:0] FinalAns0;
	wire [3:0] FinalAns1;
	wire [3:0] FinalAns2;
	wire [3:0] FinalAns3;
	wire [3:0] FinalAns4;
	wire [3:0] FinalAns5;
	wire [3:0] FinalAns6;
	wire [3:0] FinalAns7;

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

	//can determine the size required later on
	wire [29:0] BigSqStore0;//hope this is more than sufficient
	wire [29:0] BigSqStore1;
	wire [29:0] BigSqStore2;
	wire [29:0] BigSqStore3;
	wire [29:0] BigSqStore4;
	wire [29:0] BigSqStore5;	
	wire [29:0] BigSqStore6;	
	wire [29:0] BigSqStore7;

	//square root accepts 7 bit numbers
	wire [6:0] AnswerSq0;
	wire [6:0] AnswerSq1;
	wire [6:0] AnswerSq2;
	wire [6:0] AnswerSq3;
	wire [6:0] AnswerSq4;
	wire [6:0] AnswerSq5;
	wire [6:0] AnswerSq6;
	wire [6:0] AnswerSq7;

	//these are used for storing the squares
	//which are then passed onto the square root finder
	wire [23:0] Square0;
	wire [23:0] Square1;
	wire [23:0] Square2;
	wire [23:0] Square3;
	wire [23:0] Square4;
	wire [23:0] Square5;
	wire [23:0] Square6;
	wire [23:0] Square7;


	wire [11:0] modulusNumber;//testing

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

	/*i will divide the numbers by 10 after fft8 is done*/	
	/*coz i have to take modulus by squaring and then i will*/
	/*take the square roots , so for all these operations*/
	/*making the number smaller is necessary or the number will overflow*/

	//saving the squares in the big size numbers so that problem
	//of division by negative is not there
	assign BigSqStore0=(Yr0*Yr0)+(Yi0*Yi0);
	assign BigSqStore1=(Yr1*Yr1)+(Yi1*Yi1);
	assign BigSqStore2=(Yr2*Yr2)+(Yi2*Yi2);
	assign BigSqStore3=(Yr3*Yr3)+(Yi3*Yi3);
	assign BigSqStore4=(Yr4*Yr4)+(Yi4*Yi4);
	assign BigSqStore5=(Yr5*Yr5)+(Yi5*Yi5);
	assign BigSqStore6=(Yr6*Yr6)+(Yi6*Yi6);
	assign BigSqStore7=(Yr7*Yr7)+(Yi7*Yi7);

	/*
	assign AnswerSq1=BigSqStore1;
	assign AnswerSq2=BigSqStore2;
	assign AnswerSq3=BigSqStore3;
	assign AnswerSq4=BigSqStore4;
	assign AnswerSq5=BigSqStore5;
	assign AnswerSq6=BigSqStore6;
	assign AnswerSq7=BigSqStore7;
	*/
	

	//first we should take the square root of bigstore and then pass it 
	//for scaling

	
	//is it 29:23 or 28:28? is the first bit reserved for 2's complement?
	assign AnswerSq0=BigSqStore0[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);//AnswerSq :- Square of the answer
	//after all these divisions it becomes a 7 bit number
	assign AnswerSq1=BigSqStore1[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);
	assign AnswerSq2=BigSqStore2[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);
	assign AnswerSq3=BigSqStore3[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);
	assign AnswerSq4=BigSqStore4[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);
	assign AnswerSq5=BigSqStore5[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);
	assign AnswerSq6=BigSqStore6[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);
	assign AnswerSq7=BigSqStore7[29:23];///(EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*EIGHT*FOUR);

	MySqrt root0(.Number(AnswerSq0),.SquareRoot1(FinalAns0),.clk(clk));//sqrtclk ????????????
	MySqrt root1(.Number(AnswerSq1),.SquareRoot1(FinalAns1),.clk(clk));//Bit width of AnswerSq1??????????
	MySqrt root2(.Number(AnswerSq2),.SquareRoot1(FinalAns2),.clk(clk));
	MySqrt root3(.Number(AnswerSq3),.SquareRoot1(FinalAns3),.clk(clk));
	MySqrt root4(.Number(AnswerSq4),.SquareRoot1(FinalAns4),.clk(clk));
	MySqrt root5(.Number(AnswerSq5),.SquareRoot1(FinalAns5),.clk(clk));
	MySqrt root6(.Number(AnswerSq6),.SquareRoot1(FinalAns6),.clk(clk));
	MySqrt root7(.Number(AnswerSq7),.SquareRoot1(FinalAns7),.clk(clk));

	
	//testing
	initial begin
	#30 $display("Value of Square of Yr6 is %d\n",(Yr6/EIGHT)*(Yr6/EIGHT));
	#10 $display("Value of Square of Yi6 is %d\n",(Yi6/EIGHT)*(Yi6/EIGHT));
	#10 $display("Value of square of 1st output is ");
	#10 $display("real part of 4th answer is %d\n",Yr3);
	#10 $display("imaginary part of 4th answer is %d\n",Yi3);
	#10 $display("Value of square of 4th ans is %d\n",BigSqStore3);
	#10 $display("final 4th answer is %d\n",BigSqStore3/(EIGHT*EIGHT));
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
