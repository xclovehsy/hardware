`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:52:16
// Design Name: 
// Module Name: alu
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

module alu(
	input wire[31:0] a,b,
	input wire[4:0] sa,
	input wire[4:0] alucontrol,
	output reg[31:0] y,
	output reg[31:0]hi,lo
//	input wire clk,
//	output reg stall_all
	// output reg overflow,
	// output wire zero
    );
//	reg[31:0] fg;
//	initial fg=2;
//	always@(posedge clk)begin 
//		if(fg==(1<<31)-1)fg<=2;
////		else if(alucontrol==`MULT)fg<=0;
//		else fg<=fg+1;
//	end
//	always@(posedge clk)begin 
//		if(alucontrol==`MULT)begin 
//			stall_all<=1'b1;
//		end else if(alucontrol==`MULTU)begin
//			stall_all<=1'b1;
//		end
//		else begin 
//			stall_all<=1'b0;
//		end
//	end
//	signed_mult mult1(a,b,clk,fg,hi,lo);
    reg[31:0] tmpa,tmpb;
    reg[61:0] tmp1,tmp2;
	always @(*) begin
		case (alucontrol)
			// 逻辑运算
			`AND_CONTROL:begin y<=a&b;hi=0;lo=0; end
			`OR_CONTROL: begin y<=a|b;hi=0;lo=0; end
			`NOR_CONTROL:begin y<=~(a|b);hi=0;lo=0; end
			`XOR_CONTROL:begin y<=a^b;hi=0;lo=0; end

			// 算数运算
			`ADD_CONTROL:begin y<=a+b;hi=0;lo=0; end
			`ADDU_CONTROL:begin y<=a+b;hi=0;lo=0;end
			`SUB_CONTROL:begin y<=a-b;hi=0;lo=0;end
			`SUBU_CONTROL:begin y<=a-b;hi=0;lo=0;  end
			`SLT_CONTROL:begin y<= $signed(a) < $signed(b);hi=0;lo=0; end
			`SLTU_CONTROL:begin y<= a < b;hi=0;lo=0;  end

			//移位运算
			`SLL_CONTROL:begin y<=b<<sa;hi=0;lo=0;  end
			`SRL_CONTROL:begin y<=b>>sa;hi=0;lo=0;  end
			`SRA_CONTROL:begin y<=$signed(b) >>> sa;hi=0;lo=0;  end
			`SLLV_CONTROL:begin y<= b<<a[4:0];hi=0;lo=0;  end
			`SRLV_CONTROL:begin y<=b>>a[4:0];hi=0;lo=0;  end
			`SRAV_CONTROL:begin y<=$signed(b) >>> a[4:0];hi=0;lo=0;  end
			`LUI_CONTROL:begin y<={b[15:0], 16'b0};hi=0;lo=0;  end
			`DIV_CONTROL:begin
                if(a[31]==1)tmpa=(~a[30:0])+1;else tmpa=a;
                if(b[31]==1)tmpb=(~b[30:0])+1;else tmpb=b;
                tmp1={31'b0,tmpa[30:0]};
                tmp2={tmpb[30:0],31'b0};
                for(int i=0;i<31;i++)begin
                    tmp1<<=1;
                    if(tmp1[61:31]>=tmpb[30:0])
                        tmp1=tmp1-tmp2+1;
                    else ;
                end
                mod=tmp1[61:31];
                if(a[31]^b[31])begin 
                    div={1'b1,(~tmp1[30:0])+1};
					if(b[31])mod={tmp[61:31];
					else mod={1'b1,(~tmp1[61:31])+1};
                end else begin
                    div={1'b0,tmp1[30:0]};mod={1'b0,tmp1[61:31]};
                end
			end
			//乘法运算
			//div
			default : y <= 32'b0;
		endcase	
	end
	// assign zero = (y == 32'b0);

	// always @(*) begin
	// 	case (op[2:1])
	// 		2'b01:overflow <= a[31] & b[31] & ~s[31] |
	// 						~a[31] & ~b[31] & s[31];
	// 		2'b11:overflow <= ~a[31] & b[31] & s[31] |
	// 						a[31] & ~b[31] & ~s[31];
	// 		default : overflow <= 1'b0;
	// 	endcase	
	// end
endmodule
