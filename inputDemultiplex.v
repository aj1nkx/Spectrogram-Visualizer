/*This will multiplex and give the inputs to the cpld*/
/*inputs will come from ADC*/
/*only after all 8 inputs are present should we give them for fft */
/*processing*/

/*clk will be sampling frequency */
module input(clk,data);
	input wire clk;
	input wire data;
	reg tempInput1[11:0];
	reg tempInput2[11:0];
	reg tempInput3[11:0];
	reg tempInput4[11:0];
	reg tempInput5[11:0];
	reg tempInput6[11:0];
	reg tempInput7[11:0];
	reg tempInput8[11:0];
	reg fftInput1[11:0];
	reg fftInput2[11:0];
	reg fftInput3[11:0];
	reg fftInput4[11:0];
	reg fftInput5[11:0];
	reg fftInput6[11:0];
	reg fftInput7[11:0];
	reg fftInput8[11:0];

	reg InputSelector [3:0];
	always@(posedge clk)begin
		InputSelector<=InputSelector+1;
		case(InputSelector):
			4'b0000:tempInput1<=data;
			4'b0001:tempInput2<=data;
			4'b0010:tempInput3<=data;
			4'b0011:tempInput4<=data;
			4'b0100:tempInput5<=data
			4'b0101:tempInput6<=data;
			4'b0110:tempInput7<=data;
			4'b0111:tempInput8<=data;
			4'b1000:begin
				fftInput1<=tempInput1;	
				fftInput2<=tempInput2;	
				fftInput3<=tempInput3;	
				fftInput4<=tempInput4;	
				fftInput5<=tempInput5;	
				fftInput6<=tempInput6;	
				fftInput7<=tempInput7;	
				fftInput8<=tempInput8;	

			end
			/*i have kept some time for processing*/
			/*the code does nothing in this time period*/
			/*giving time for the cpld to run fft implementation*/

			4'b1001:;
			4'b1010:;
			4'b1011:;
			4'b1100:;
			4'b1101:;
			4'b1110:;
			4'b1111:;

		endcase
	end
endmodule
