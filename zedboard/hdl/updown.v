`timescale 1ns/1ps

module up_down_counter(
	input clock,
	input reset,
	input up,
	input down,
	output reg [7:0] count
);

	reg [7:0] addend;

	always @(*) begin
		if (up & ~down) begin
			addend = 8'h01;
		end else if (~up & down) begin
			addend = 8'hFF;
		end else begin
			addend = 8'h00;
		end
	end

	always @(posedge clock) begin
		if (reset) begin
			count <= 8'h0;
		end else begin
			count <= count + addend;
		end
	end

endmodule
