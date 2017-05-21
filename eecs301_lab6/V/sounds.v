//Justin Lee (jpl88) and Ian Waldschmidt (isw5)
//Reads sound input at ADC and determines what should be output to DAC
module sounds(input clk_50, audio_clk, adc_out, did_collide, input [3:0] p1_score, p2_score,
				  output adc_in, cs, output dac_in, sync);
				  
	//Internal variables
	parameter FREQUENCY = 32'd34360;
	wire valid;
	wire [11:0] song_data, nco_out;
	
	adc_in signals(					//Generates ADC input signals
		.clk(audio_clk),
		.adc_in(adc_in),
		.cs(cs),
		.valid(valid)
	);
	
	adc_to_parallel converter(		//Converts ADC output from serial signal to parallel form
		.clk(audio_clk),
		.adc_out(adc_out),
		.cs(cs),
		.valid(valid),
		.parallel_data(song_data)
	);
	
	nco tone(							//NCO instance to generate tone when collisions occur
		.clk(clk_50),
		.reset_n(1'b1),
		.clken(1'b1),
		.phi_inc_i(FREQUENCY),
		.fsin_o(nco_out)
	);
	
	to_dac out(							//Determines what should be heard at the DAC and sends the necessary information
		.clk(audio_clk),
		.valid(valid),
		.did_collide(did_collide),
		.p1_score(p1_score),
		.p2_score(p2_score),
		.nco_data(nco_out),
		.adc_data(song_data),
		.dac_in(dac_in),
		.sync(sync)
	);
endmodule
