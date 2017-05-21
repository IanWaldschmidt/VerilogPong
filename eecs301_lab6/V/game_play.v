//Justin Lee (jpl88) and Ian Waldschmidt(isw5)
//Game logic that dictates ball movement and scoring
module game_play(input clk, 
					  input [7:0] p1_pos, p2_pos,
					  input pause, continue,
					  output reg [3:0] p1_score, p2_score,
					  output reg [8:0] ball_x, ball_y,
					  output reg did_collide);
	
	//Assign values to game constants
	constant parameters(BALL_RADIUS, PADDLE_WIDTH, PADDLE_HEIGHT, PADDING);
	wire [7:0] BALL_RADIUS, PADDLE_WIDTH, PADDLE_HEIGHT, PADDING;
	//Determines direction of ball movement
	reg [2:0] direction;		// bit 0 is left, bit 1 is up, bit 2 is horizontal movement only
	reg [21:0] counter;		//Used to slow the clock to a speed people can react to
	reg reset;					//Allows user to start game when ready
	reg hit;						//Used to determine did_collide value

	initial begin
		//Set score to 0-0
		p1_score <= 4'd0;
		p2_score <= 4'd0;
		//Put ball in middle of the screen
		ball_x <= 9'd240;
		ball_y <= 9'd135;
		//Make the ball move horizontally left
		direction <= 3'b101;
		//Allow the user to start the game when desired
		reset <= 1'b1;
		//Initialize collision detection and counter
		did_collide <= 1'b0;
		counter <= 0;
	end

	always @(posedge clk) begin		//Slow clock down for people to react
		counter = counter + 1'b1;
		if(counter == 22'h3fffff) counter = 0;
	end

	always @(posedge clk) begin
		if(reset) begin
			if(continue & p1_score < 4'd11 & p2_score < 4'd11) reset <= 0;
		end
		else begin
			//Check to see if the ball collided with the left paddle
			if(PADDING < ball_x + BALL_RADIUS & ball_x < PADDING + PADDLE_WIDTH + BALL_RADIUS & p1_pos < ball_y + PADDLE_HEIGHT + BALL_RADIUS & ball_y < p1_pos + PADDLE_HEIGHT + BALL_RADIUS) begin
				//Change direction
				direction[0] <= 1'b0;
				if(ball_y < p1_pos) direction[1] <= 1'b1;
				else direction[1] <= 1'b0;
				direction[2] <= 1'b0;
				hit <= 1'b1;
			end
			//Check to see if the ball collided with the right paddle
			else if(9'd480 - PADDING - PADDLE_WIDTH < ball_x + BALL_RADIUS & ball_x < 9'd480 - PADDING + BALL_RADIUS & p2_pos < ball_y + PADDLE_HEIGHT + BALL_RADIUS & ball_y < p2_pos + PADDLE_HEIGHT + BALL_RADIUS) begin
				//Change direction
				direction[0] <= 1'b1;
				if(ball_y < p2_pos) direction[1] <= 1'b1;
				else direction[1] <= 1'b0;
				direction[2] <= 1'b0;
				hit <= 1'b1;
			end
			//Check to see if the ball collided with the ceiling or floor
			if(ball_y == BALL_RADIUS) begin
				direction[1] <= 0;
				hit <= 1'b1;
			end
			else if(ball_y == 10'd272 - BALL_RADIUS) begin
				direction[1] <= 1;
				hit <= 1'b1;
			end
			//Disable hit once detected
			if(did_collide) hit <= 1'b0;
			//Check to see if someone scored
			if(ball_x < PADDING) begin
				p2_score <= p2_score + 1'b1;
				reset <= 1'b1;
				direction <= 3'b101;
			end
			else if(ball_x > 480 - PADDING) begin
				p1_score <= p1_score + 1'b1;
				reset <= 1'b1;
				direction <= 3'b100;
			end
		end
	end
	
	always @(posedge counter[17]) begin
		//See if someone scored
		if(reset) begin
			ball_x <= 9'd240;
			ball_y <= 9'd136;
		end
		else begin
			//Move the ball vertically
			if(~direction[2] & ~direction[1] & ~pause) ball_y <= ball_y + 1'b1;
			else if(~direction[2] & direction[1] & ~pause) ball_y <= ball_y - 1'b1;
			//Move the ball horizontally
			if(~direction[0] & ~pause) ball_x <= ball_x + 1'b1;
			else if(~pause) ball_x <= ball_x - 1'b1;
		end
	end
	//Update the did_collide variable
	always @(posedge counter[21]) did_collide <= hit;
endmodule
