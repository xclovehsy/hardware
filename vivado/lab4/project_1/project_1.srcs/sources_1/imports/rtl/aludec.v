`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:27:24
// Design Name: 
// Module Name: aludec
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
`include "defines2.vh"

module aludec(
	input wire[31:0] instrD,
	output reg[4:0] alucontrol
    );
    
    wire [5:0] funct = instrD[5:0];
	wire [5:0] op = instrD[31:26];
	wire [4:0] rs = instrD[25:21];
	wire [4:0] as = instrD[10:6];

	always @(*) begin
		case(op)
			// R type
			`R_TYPE: 
                case (funct)
                    `SLL: alucontrol <= `SLL_CONTROL;
                    `SRL: alucontrol <= `SRL_CONTROL;
                    `SRA: alucontrol <= `SRA_CONTROL;
                    // sllv, srlv, srav
                    `SLLV: alucontrol <= `SLLV_CONTROL;
                    `SRLV: alucontrol <= `SRLV_CONTROL;
                    `SRAV: alucontrol <= `SRAV_CONTROL;

                    // and or xor nor
                    `AND: alucontrol <= `AND_CONTROL;
                    `OR: alucontrol <= `OR_CONTROL;
                    `XOR: alucontrol <= `XOR_CONTROL;
                    `NOR: alucontrol <= `NOR_CONTROL;

                    // r-type算数运算
                    `ADD: alucontrol <= `ADD_CONTROL;
                    `ADDU: alucontrol <= `ADDU_CONTROL;
                    `SUB: alucontrol <= `SUB_CONTROL;
                    `SUBU: alucontrol <= `SUBU_CONTROL;
                    `SLT: alucontrol <= `SLT_CONTROL;
                    `SLTU: alucontrol <= `SLTU_CONTROL;
                    
                    // slt 
                    `SLT: alucontrol <= `SLT_CONTROL;
                    `MULT: alucontrol<= `MULT_CONTROL;
                    `MULTU: alucontrol<= `MULTU_CONTROL;
                    `DIV: alucontrol<= `DIV_CONTROL;
                    `DIVU: alucontrol<= `DIVU_CONTROL;
                    `MTHI:alucontrol<=`MTHI_CONTROL;
                    `MTLO:alucontrol<=`MTLO_CONTROL;
                    `MFHI: alucontrol<= `MFHI_CONTROL;
                    `MFLO: alucontrol<= `MFLO_CONTROL;

                    //jump
                    `JALR: alucontrol <= `ADD_CONTROL;

                    default: alucontrol <= 5'b00000;
                endcase
			// I type
			// 逻辑运算
			`ANDI: alucontrol <= `AND_CONTROL;
			`XORI: alucontrol <= `XOR_CONTROL;
			`ORI: alucontrol <= `OR_CONTROL;
			`LUI: alucontrol <= `LUI_CONTROL;
			// 算数运算
			`ADDI: alucontrol <= `ADD_CONTROL;
			`ADDIU: alucontrol <= `ADD_CONTROL;
			`SLTI: alucontrol <= `SLT_CONTROL;
			`SLTIU: alucontrol <= `SLTU_CONTROL;
            `LB,`LBU,`LH,`LHU,`LW,`SB,`SH,`SW:alucontrol<=`ADD_CONTROL;

            // jump
            `JAL: alucontrol <= `ADD_CONTROL;
            `REGIMM_INST: alucontrol <= `ADD_CONTROL;
            
			default: alucontrol <= 5'b00000;

		endcase 
	end
endmodule
