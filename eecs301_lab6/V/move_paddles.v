//Justin Lee(jpl88) & Ian Waldschmidt(isw5)
//A module used to control the paddles
module move_paddles(input clk, p1_up, p1_down, encoderA, encoderB, pause,
					output reg [7:0] p1_pos, p2_pos);

	reg[17:0] counter;
	reg lastA;
	reg enable; 		//Used for proper clocking and motor control
	reg [1:0] motor;	//Determines which direction the motor was spun; bit 0 is 1 if position was changed, bit 1 is 1 if it moved down
	reg [7:0] last_pos;
	wire [7:0] PADDLE_HEIGHT;

	constant parameters(.PADDLE_HEIGHT(PADDLE_HEIGHT)); //Assign values to game constants

	initial begin
		p1_pos <= 8'd135;
		p2_pos <= 8'd135;
		counter <= 18'd0;
		lastA <= encoderA;
	end 

	always @(posedge clk) begin		//Slow clock down to a speed people can see and react to
		counter <= counter + 1'b1;
		if(counter == 18'h3ffff) counter <=0;
		if(counter == 18'd0) enable <= 1'b1;
		else enable <= 1'b0;
		if(encoderA != lastA) begin
			if(~encoderB & p2_pos != (270 - PADDLE_HEIGHT) & ~pause) motor <= 2'b11;
			else if(encoderB & p2_pos != (0 + PADDLE_HEIGHT) & ~pause) motor <= 2'b10;
		end
		if(p2_pos != last_pos) begin
			motor <= 2'b00;
		end
		lastA = encoderA;
		last_pos = p2_pos;
	end

	always @(posedge enable) begin
		//Move paddle 1
		if(p1_down & p1_pos != 270 - PADDLE_HEIGHT & ~pause) p1_pos <= p1_pos + 1;
		else if(p1_up & p1_pos != 0 + PADDLE_HEIGHT & ~pause) p1_pos <= p1_pos -1;
		//Move paddle 2
		if(motor[1]) begin
			if(motor[0] & p2_pos != 270 - PADDLE_HEIGHT & ~pause) p2_pos <= p2_pos + 1;
			else if(~motor[0] & p2_pos != 0 + PADDLE_HEIGHT & ~pause) p2_pos <= p2_pos -1;
		end
	end
endmodule
