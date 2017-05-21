//Justin Lee (jpl88) and Ian Waldschmit (isw5)
//Converts the serial output of the adc to a parallel signal.
module adc_to_parallel(input clk, adc_out, cs, valid,
					   output reg [11:0] parallel_data);

	reg [11:0] values;
	reg [3:0] cycle;

	initial begin
		cycle <= 4'd0;
		values <= 12'd0;
	end

	always @(posedge clk) begin
		if(valid == 1) begin
			parallel_data <= values;
			cycle <= 4'd0;	
		end
		if(cs == 0) begin
			if(cycle > 3 & cycle < 16) begin
				values[15 - cycle] <= adc_out;
			end
			cycle <= cycle + 1;
		end
	end

endmodule
