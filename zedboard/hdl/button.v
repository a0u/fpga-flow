`timescale 1ns/1ps

module edge_detector(
	input clock,
	input reset,
	input in,
	output out);

	reg [1:0] debounce;
	reg detect;
	wire enable;

	assign enable = &debounce;
	assign out = enable & ~detect;

	always @(posedge clock) begin
		if (reset | ~in) begin
			debounce <= 2'h0;
		end else if (in & ~enable) begin
			debounce <= debounce + 2'h1;
		end

		if (reset) begin
			detect <= 1'b0;
		end else begin
			detect <= enable;
		end
	end

endmodule
