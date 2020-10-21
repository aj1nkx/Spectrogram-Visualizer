`timescale 1ns/1ns

module TestMatrix();
	reg clock;
	reg [2:0] SendIn0;
	reg [2:0] SendIn1;
	reg [2:0] SendIn2;
	reg [2:0] SendIn3;
	reg [2:0] SendIn4;
	reg [2:0] SendIn5;
	reg [2:0] SendIn6;
	reg [2:0] SendIn7;

	wire [2:0] wSendIn0;
	wire [2:0] wSendIn1;
	wire [2:0] wSendIn2;
	wire [2:0] wSendIn3;
	wire [2:0] wSendIn4;
	wire [2:0] wSendIn5;
	wire [2:0] wSendIn6;
	wire [2:0] wSendIn7;


	wire wclock;
	wire [7:0] out0;
	wire [7:0] out1;

	assign wclock=clock;
	assign wSendIn0=SendIn0;
	assign wSendIn1=SendIn1;
	assign wSendIn2=SendIn2;
	assign wSendIn3=SendIn3;
	assign wSendIn4=SendIn4;
	assign wSendIn5=SendIn5;
	assign wSendIn6=SendIn6;
	assign wSendIn7=SendIn7;

	initial begin
		clock=1'b0;
		SendIn0=3'd0;
		SendIn1=3'd0;
		SendIn2=3'd0;
		SendIn3=3'd0;
		SendIn4=3'd0;
		SendIn5=3'd0;
		SendIn6=3'd0;
		SendIn7=3'd0;
		$dumpfile("MatrixTest.vcd");
		$dumpvars(0);
	 	#1000 $finish;
	end

	always@(posedge clock)begin
		SendIn0<=SendIn0+1'b1;
		SendIn1<=SendIn1+1'b1;
		SendIn2<=SendIn2+1'b1;
		SendIn3<=SendIn3+1'b1;
		SendIn4<=SendIn4+1'b1;
		SendIn5<=SendIn5+1'b1;
		SendIn6<=SendIn6+1'b1;
		SendIn7<=SendIn7+1'b1;
	end

	always #5 clock=!clock;

	matrix test0(.inpt1(wSendIn0),.inpt2(wSendIn1),.inpt3(wSendIn2),.inpt4(wSendIn3),.inpt5(wSendIn4),.inpt6(wSendIn5),.inpt7(wSendIn6),.inpt8(wSendIn7),.clk(wclock),.TakeLedout1(out0),.TakeLedout2(out1));

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
		Q <= Q+1;

		ledout2[7]<=~outl[7];	//addressing each bit on the led
		ledout2[6]<=~outl[6];	//addressing each bit on the led
		ledout2[5]<=outh[1];	//addressing each bit on the led
		ledout2[4]<=~outl[0];	//addressing each bit on the led
		ledout2[3]<=outh[3];	//addressing each bit on the led
		ledout2[2]<=~outl[5];	//addressing each bit on the led
		ledout2[1]<=~outl[3];	//addressing each bit on the led
		ledout2[0]<=outh[0];	//addressing each bit on the led
		ledout1[7]<=outh[2];	//addressing each bit on the led
		ledout1[6]<=outh[5];	//addressing each bit on the led
		ledout1[5]<=~outl[4];	//addressing each bit on the led
		ledout1[4]<=outh[7];	//addressing each bit on the led
		ledout1[3]<=~outl[2];	//addressing each bit on the led
		ledout1[2]<=~outl[1];	//addressing each bit on the led
		ledout1[1]<=outh[6];	//addressing each bit on the led
		ledout1[0]<=outh[4];	//addressing each bit on the led

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
