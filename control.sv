module control
(
	input clk,
	input reset,
	
	// Button input
	input i_enter,
	
	// Datapath
	output logic o_inc_actual,
	input i_over,
	input i_under,
	input i_equal,
	
	// LED Control: Setting this to 1 will copy the current
	// values of over/under/equal to the 3 LEDs. Setting this to 0
	// will cause the LEDs to hold their current values.
	output logic o_update_leds
);

// Declare two objects, 'state' and 'nextstate'
// that are of enum type.
enum int unsigned
{
	// TODO: declare states here
	s_initialize,
	s_initialize_wait,
	s_compare,
	s_equal,
	s_nonequal,
	s_nonequal_wait
} state, nextstate;

// Clocked always block for making state registers
always_ff @ (posedge clk or posedge reset) begin
	if (reset) state <= s_initialize;// TODO: choose initial reset state
	else state <= nextstate;
end

// always_comb replaces always @* and gives compile-time errors instead of warnings
// if you accidentally infer a latch
always_comb begin
	// Set default values for signals here, to avoid having to explicitly
	// set a value for every possible control path through this always block
	nextstate = state;
	o_inc_actual = 1'b0;
	o_update_leds = 1'b0;
	
	case (state)
		// TODO: complete this
		s_initialize: begin
			o_inc_actual = 1;
			o_update_leds = 0;
			if (i_enter) nextstate = s_initialize_wait;
			else nextstate = s_initialize;
		end
		
		s_initialize_wait: begin
			o_inc_actual = 0;
			o_update_leds = 0;
			if (i_enter) nextstate = s_initialize_wait;
			else nextstate = s_compare;
		end
		
		s_compare: begin
			o_inc_actual = 0;
			o_update_leds = 1;
			if (i_equal) nextstate = s_equal;
			else nextstate = s_nonequal;
		end
		
		s_nonequal: begin
			o_inc_actual = 0;
			o_update_leds = 0;
			if (i_enter) nextstate = s_nonequal_wait;
			else nextstate = s_nonequal;
		end
		
		s_nonequal_wait: begin
			o_inc_actual = 0;
			o_update_leds = 0;
			if (i_enter) nextstate = s_nonequal_wait;
			else nextstate = s_compare;
		end
		
		s_equal: begin
			o_inc_actual = 0;
			o_update_leds = 0;
		end
		default nextstate = s_initialize;
	endcase
end

endmodule
