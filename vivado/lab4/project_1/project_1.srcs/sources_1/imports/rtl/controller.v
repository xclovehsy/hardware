`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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

module controller(
	input wire clk,rst,
	//decode stage
	// input wire[5:0] opD,functD,
	input wire [31:0] instrD,
	output wire pcsrcD,branchD,equalD,jumpD,
	output wire sig_extD,
	
	//execute stage
	input wire flushE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,	
	output wire[4:0] alucontrolE,

	//mem stage
	output wire memtoregM,
	output wire[3:0]memwriteM,
	output wire	regwriteM,
	//write back stage
	output wire memtoregW,regwriteW,

	//jump control
	output wire branchwriteE,
	output wire j_regD,
	output wire j_31D,
	output wire j_pls8
    );

	wire[5:0] opD = instrD[31:26];
	wire[5:0] functD = instrD[5:0];
	
	//decode stage
	wire[1:0] aluopD;
	wire memtoregD,alusrcD,
		regdstD,regwriteD;
	wire[3:0] memwriteD;
	wire[4:0] alucontrolD;

	//execute stage
	wire[3:0] memwriteE;

	// jump push sign
	wire branchwriteD;
	assign branchwriteD = (instrD[20:16] == `BGEZAL) | (instrD[20:16] == `BLTZAL) ;  // test
	wire [2:0] jumpcontrol;
	assign j_regD=(jumpcontrol==3'b010)|(jumpcontrol==3'b100);
	assign j_31D=(jumpcontrol==3'b011);
	assign j_pls8=(jumpcontrol==3'b011)|(jumpcontrol==3'b100);

	maindec md(
		instrD,
		memtoregD,memwriteD,
		branchD,alusrcD,
		regdstD,regwriteD,
		jumpD,
		sig_extD,
		jumpcontrol
		);
	aludec ad(instrD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	floprc #(30) regE(
		clk,
		rst,
		flushE,
		{branchwriteD,memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD},
		{branchwriteE,memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE}
		);
	flopr #(11) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE},
		{memtoregM,memwriteM,regwriteM}
		);
	flopr #(8) regW(
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
		);
endmodule
