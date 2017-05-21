//Justin Lee (jpl88) and Ian Waldschmidt (isw5)
//Module used to determine position, sync, valid, and blank signals
module video_sync_generator(input clk,
         output reg hsync, vsync);

	reg [9:0] hsync_counter;
	reg [8:0] vsync_counter;
	
	initial begin
		hsync_counter <= 10'd0;
		vsync_counter <= 9'd0;
	end
	
	//Responsible for creating hsync, vsync, and valid signals
	always @(posedge clk) begin
		//Hsync is low for 41 clock cycles, then high for 484 cycles (525 total cycles)
		if(hsync_counter < 10'd41) hsync <= 0;
		else if(hsync_counter == 10'd41) hsync <= 1;
		else if(hsync_counter < 10'd525) hsync <= 1;
		else if(hsync_counter == 10'd525) begin
			hsync <= 0;
			vsync_counter <= vsync_counter + 1'b1;
		end
		if(hsync_counter == 10'd525) hsync_counter <= 10'd0;
		else hsync_counter <= hsync_counter + 1'b1;
		//Vsync is low for 10 hsync cycles, then high for 276 cycles (286 total cycles)
		if(vsync_counter < 9'd10) vsync <= 0;
		else if(vsync_counter == 9'd10) vsync <= 1;
		else if(vsync_counter < 9'd286) vsync <= 1;
		else if(vsync_counter == 9'd286) begin
			vsync <= 0;
			vsync_counter <= 0;
		end
	end
endmodule
