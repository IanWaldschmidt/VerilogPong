//Justin Lee (jpl88) and Ian Waldschmidt (isw5)
//Paints the paddles, ball, and score to the screen
module paint(input clk, hsync, vsync,
				 input [7:0] p1_pos, p2_pos,
				 input [8:0] ball_x, ball_y,
				 output reg [7:0] red, green, blue
				 );
	
	constant parameters(BALL_RADIUS, PADDLE_WIDTH, PADDLE_HEIGHT, PADDING); //Assign values to game constants
	wire [7:0] BALL_RADIUS, PADDLE_WIDTH, PADDLE_HEIGHT, PADDING;
	
	reg [8:0] x,y,real_x;	//Saves the current pixel being updated (real_x includes the 2 don't cares, x does not)
	
	initial begin
		real_x <= 9'b0;
		y <= 9'b0;
		red <= 8'haa;
		green <= 8'haa;
		blue <= 8'haa;
	end
	
	always @(posedge clk) begin
		if(~vsync) begin			//In between full-screen refreshes, so reset position
			real_x <= 9'b0;
			y <= 9'b0;
		end
		else begin
			if(~hsync) begin		//Just updated a row, so move to the start of the next row
				if(real_x > 9'b0) begin
					y <= y + 1'b1;
					real_x <= 9'b0;
				end
			end
			else begin
				if(real_x > 9'd2) begin
					x = real_x - 9'd2; //Ignore the 2 don't care hsync signals because we don't need them to update anything
					//Paint current pixel
					if(PADDING < x & x < PADDING + PADDLE_WIDTH & p1_pos < y + PADDLE_HEIGHT & y < p1_pos + PADDLE_HEIGHT) begin						//Pixel is in left paddle
						red <= 8'hff;
						green <= 8'h00;
						blue <= 8'h00;
					end
					else if(9'd480 - PADDING - PADDLE_WIDTH < x & x < 9'd480 - PADDING & p2_pos < y + PADDLE_HEIGHT & y < p2_pos + PADDLE_HEIGHT) begin //Pixel is in right paddle
						red <= 8'h00;
						green <= 8'hff;
						blue <= 8'h00;
					end
					else if(ball_x < x + BALL_RADIUS & x < ball_x + BALL_RADIUS & ball_y < y + BALL_RADIUS & y < ball_y + BALL_RADIUS) begin		//Pixel is in ball
						red <= 8'h00;
						green <= 8'h00;
						blue <= 8'hff;
					end
					else begin
						red <= 8'h00;
						green <= 8'h00;
						blue <= 8'h00;
					end
				end
				real_x <= real_x + 1'b1;
			end
		end
	end
endmodule
