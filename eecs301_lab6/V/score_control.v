//Justin Lee (jpl88) and Ian Waldschmit (isw5)
//Module that controls the score of each player.
module score_control(input clk, input [3:0] p1_score, p2_score,
							output reg [13:0] p1_hex, p2_hex);

	always @(posedge clk) begin	
		if(p1_score == 4'd0)  p1_hex <= 14'b01111110111111;
		if(p1_score == 4'd1)  p1_hex <= 14'b01111110000110;
		if(p1_score == 4'd2)  p1_hex <= 14'b01111111011011;
		if(p1_score == 4'd3)  p1_hex <= 14'b01111111001111;
		if(p1_score == 4'd4)  p1_hex <= 14'b01111111100110;
		if(p1_score == 4'd5)  p1_hex <= 14'b01111111101101;
		if(p1_score == 4'd6)  p1_hex <= 14'b01111111111101;
		if(p1_score == 4'd7)  p1_hex <= 14'b01111110000111;
		if(p1_score == 4'd8)  p1_hex <= 14'b01111111111111;
		if(p1_score == 4'd9)  p1_hex <= 14'b01111111101111;
		if(p1_score == 4'd10) p1_hex <= 14'b00001100111111;
		if(p1_score == 4'd11) p1_hex <= 14'b00001100000110;
		
		if(p2_score == 4'd0)  p2_hex <= 14'b01111110111111;
		if(p2_score == 4'd1)  p2_hex <= 14'b01111110000110;
		if(p2_score == 4'd2)  p2_hex <= 14'b01111111011011;
		if(p2_score == 4'd3)  p2_hex <= 14'b01111111001111;
		if(p2_score == 4'd4)  p2_hex <= 14'b01111111100110;
		if(p2_score == 4'd5)  p2_hex <= 14'b01111111101101;
		if(p2_score == 4'd6)  p2_hex <= 14'b01111111111101;
		if(p2_score == 4'd7)  p2_hex <= 14'b01111110000111;
		if(p2_score == 4'd8)  p2_hex <= 14'b01111111111111;
		if(p2_score == 4'd9)  p2_hex <= 14'b01111111101111;
		if(p2_score == 4'd10) p2_hex <= 14'b00001100111111;
		if(p2_score == 4'd11) p2_hex <= 14'b00001100000110;
	end
endmodule
