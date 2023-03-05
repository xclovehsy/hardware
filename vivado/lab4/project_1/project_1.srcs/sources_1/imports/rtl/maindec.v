`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
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


module maindec(
	input wire[31:0] instrD,

	output wire memtoreg,
	output wire[3:0]memwrite,
	output wire branch,alusrc,
	output wire regdst,regwrite,
	output wire jump,
	output wire sig_extD,
	output reg [2:0] jumpcontrol,
	output reg [3:0] branchid
    );

	wire [5:0] op = instrD[31:26];

	assign sig_extD = (op[5:2] == 4'b0011) ? 1'b0 : 1'b1;  // test
	// assign sig_extD = 1'b1;
    wire memwrite1;
	reg[6:0] controls;
	assign {regwrite,regdst,alusrc,branch,memwrite1,memtoreg,jump} = controls;
	reg[3:0] memwrite2;
	assign memwrite=memwrite2;
	always @(*) begin
		case (op)
			`R_TYPE:begin 

				// controls <= 7'b1100000;//R-TYRE
				// memwrite2<=4'b0000;
				// jumpcontrol <= 3'b000;
				case(instrD[5:0]) 
				
					`JR: begin
						controls <= 7'b0000001;
						memwrite2 <= 4'b0000;
						jumpcontrol <= 3'b010;
					end
					`JALR: begin
						controls <= 7'b1100001;
						memwrite2 <= 4'b0000;
						jumpcontrol <= 3'b100;
					end
					default: begin
						controls <= 7'b1100000;//R-TYRE
			    		memwrite2<=4'b0000;
						jumpcontrol <= 3'b000;
					end
				endcase 
			    
			end
			`LB,`LBU,`LH,`LHU,`LW:begin 
			    controls<=7'b1010010;
			    memwrite2<=4'b0000;
				jumpcontrol <= 3'b000;
			end
			`SB:begin
			    controls <= 7'b0010100;
			    memwrite2<=4'b0001;
				jumpcontrol <= 3'b000;
			end
			`SH:begin 
			    controls <= 7'b0010100;
			    memwrite2<=4'b0011;
				jumpcontrol <= 3'b000;
			end
			`SW:begin 
			     controls <= 7'b0010100;
			     memwrite2<=4'b1111;
				 jumpcontrol <= 3'b000;
			end
			//6'b100011:controls <= 7'b1010010;//LW
			//6'b101011:controls <= 7'b0010100;//SW
			// 6'b000100:begin 
			//      controls <= 7'b0001000;//BEQ
			//      memwrite2<=4'b0000;
			// end
			// 6'b001000:controls <= 7'b1010000;//ADDI

			//jump指令
			`J:begin 
			     controls <= 7'b0000001;//J
			     memwrite2<=4'b0000;
				 jumpcontrol <= 3'b001;
            end
			`JAL: begin
				controls <= 7'b1000001;
				// controls <= 7'b0000001;//J
				memwrite2 <= 4'b0000;
				jumpcontrol <= 3'b011;
			end
			// I type
			// 逻辑运算
			`ANDI:begin controls <= 7'b1010000;memwrite2<=4'b0000; jumpcontrol <= 3'b000;end	
			`XORI:begin controls <= 7'b1010000;memwrite2<=4'b0000; jumpcontrol <= 3'b000;end
			`LUI:begin controls <= 7'b1010000;memwrite2<=4'b0000; jumpcontrol <= 3'b000;end
			`ORI:begin controls <= 7'b1010000;memwrite2<=4'b0000; jumpcontrol <= 3'b000;end
			// 算数运算
			`ADDI:begin controls <= 7'b1010000;memwrite2<=4'b0000;jumpcontrol <= 3'b000;end
			`ADDIU:begin controls <= 7'b1010000;memwrite2<=4'b0000;jumpcontrol <= 3'b000;end
			`SLTI:begin controls <= 7'b1010000;memwrite2<=4'b0000;jumpcontrol <= 3'b000;end
			`SLTIU:begin controls <= 7'b1010000;memwrite2<=4'b0000;jumpcontrol <= 3'b000;end

			// branch指令
			`BEQ, `BNE, `BGTZ, `BLEZ: begin
				controls <= 7'b0001000;
			    memwrite2<=4'b0000;
				jumpcontrol <= 3'b000;
			end
			`REGIMM_INST: begin
				case (instrD[20:16])
					`BGEZ, `BLTZ: begin
						controls <= 7'b0001000;
						memwrite2<=4'b0000; jumpcontrol <= 3'b000;
					end
					`BGEZAL, `BLTZAL: begin
						controls <= 7'b1001000;
						memwrite2<=4'b0000; jumpcontrol <= 3'b000;
					end
				endcase
			end


			default:begin  controls <= 7'b0000000;memwrite2<=4'b0000; jumpcontrol <= 3'b000;end//illegal op
		endcase

	end
endmodule
