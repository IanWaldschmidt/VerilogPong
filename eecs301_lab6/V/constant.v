//Justin Lee (jpl88) and Ian Waldschmidt (isw5)
//Module that defines game parameters in one place for easy manipulation
module constant(output reg [7:0] BALL_RADIUS, PADDLE_WIDTH,
					 PADDLE_HEIGHT, PADDING);
		 
	initial begin
		BALL_RADIUS <= 8'd5;		//Ball radius
		PADDLE_WIDTH <= 8'd10;	//Paddle width
		PADDLE_HEIGHT <= 8'd50;	//Distance from center of paddle to top or bottom of paddle
		PADDING <= 8'd16;			//Padding between edge of screen and game elements.
	end
endmodule
