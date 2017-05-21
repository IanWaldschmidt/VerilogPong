//Justin Lee (jpl88) and Ian Waldschmit (isw5)
//A module that sends signals into the adc
module adc_in(input clk,
				  output reg adc_in, cs, valid);
	
	reg[15:0] shiftValue;
	reg[7:0] cycle;

	initial cycle <= 8'b0;

	always @(posedge clk) begin
		if(cycle == 8'b0) shiftValue <= 16'b1000001100000000;
		else if(cycle < 8'b00010001)begin
			cs <= 1'b0;
			valid <= 1'b0;
			adc_in <= shiftValue[16-cycle];
		end
		else if(cycle == 8'b00010001) begin
			cs <= 1'b1;
			valid <= 1'b1;
			adc_in <= 1'b0;
		end
		else if(cycle < 8'b11001000) begin
			cs <= 1'b1;
			valid <= 1'b0;
			adc_in <= 1'b0;
		end
		cycle <= cycle + 1'b1;
		if(cycle == 8'd199) cycle <= 8'b0;
	end
endmodule
