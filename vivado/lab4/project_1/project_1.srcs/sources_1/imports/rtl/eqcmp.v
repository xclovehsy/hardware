`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/23 22:57:01
// Design Name: 
// Module Name: eqcmp
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


module eqcmp(
	input wire [31:0] instrD,
	input wire [31:0] a,b,
	output reg y
    );

	wire [5:0] op = instrD[31:26];

	always @(*) begin
		case (op) 
			// 跳转指令
			`BEQ: y <= (a == b) ? 1 : 0;
			`BNE: y <= (a != b) ? 1 : 0;
			`BGTZ: y <= (a > 0) ? 1 : 0;
			`BLEZ: y <= (a <= 0) ? 1 : 0;
			// `BLTZ: y <= (a < 0) ? 1 : 0;
			`REGIMM_INST: begin
				case (instrD[20:16])
					`BGEZ: y <= (a >= 0) ? 1 : 0;
					`BLTZ: y <= (a < 0) ? 1 : 0;
					`BGEZAL: y <= (a >= 0) ? 1: 0;
					`BLTZAL: y <= (a < 0) ? 1:0;
					// `
					//  `BLTZAL: begin
					// 	controls <= 7'b1001000;
					// 	memwrite2<=4'b0000; jumpcontrol <= 3'b000;
					// end
				endcase
			end
			default: y <= 0;

		endcase

	end
	// assign y = (a == b) ? 1 : 0;
endmodule
