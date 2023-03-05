`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:29:33
// Design Name: 
// Module Name: signext
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module signext(
	input wire sign_ext,
	input wire[15:0] a,
	output reg[31:0] y
    );

	// assign y = {{16{a[15]}},a};

	always @(*) begin
		if(sign_ext == 1'b0)  y = { {16{1'b0}} ,a[15:0]};  // 立即数，imm为0扩展至32
		else y = {{16{a[15]}},a};
	end
endmodule
