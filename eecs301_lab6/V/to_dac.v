//Justin Lee (jpl88) and Ian Waldschmidt(isw5)
//Takes data from the NCO and ADC and determines what to send to the DAC
module to_dac(input clk, valid, did_collide, input [3:0] p1_score, p2_score, input [11:0] nco_data, adc_data,
				  output reg dac_in, sync);
	
	reg [31:0] shift_value;		//Parallel version of what will be shifted into the DAC
	reg [5:0] cycle;				//Determines which bit of shift_value should be shifted in
	reg enable;						//Makes sure the input is valid before sending to the DAC
	//Constant values 
	parameter commandBits = 4'b0011;
	parameter adressBits = 4'b0000;
	parameter randomBits = 4'b1111;
	
	initial begin
		cycle <= 6'd0;
		sync <= 1'b1;
		dac_in <= 1'b0;
		shift_value[31:20] = {randomBits, commandBits, adressBits};
		shift_value[7:0] = {randomBits, randomBits};
	end
	
	always @(posedge clk) begin
		//Make sure input is valid
		if(valid) begin
			enable <= 1'b1;
			cycle <= 6'd0;
		end
		if(enable) begin
			//Just starting cycle; figure out what data to feed in
			if(cycle == 6'b000000) begin
				//Game over; play ADC song
				if(p1_score == 4'd11 | p2_score == 4'd11) shift_value[19:8] <= {~adc_data[11], adc_data[10:0]};
				//Collided; play NCO tone
				else if(did_collide) shift_value[19:8] <= {nco_data};
				//No sound; feed in empty data
				else shift_value[19:8] <= {12'b0};
			end
			//In the middle of sending data in; keep sending data in
			else if(cycle < 6'd33) begin
				sync <= 1'b0;
				dac_in <= shift_value[6'd32 - cycle];
			end
			//Done sending data in; reset everything
			else if(cycle == 6'd33) begin
				sync <= 1'b1;
				dac_in <= 1'b0;
				enable <= 1'b0;
			end
			cycle <= cycle + 1'b1;
		end
	end
endmodule
