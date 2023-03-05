`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/20 22:18:54
// Design Name: 
// Module Name: unsigned_multi
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


module unsigned_mult(
    input wire[31:0] a,b,
    input clk,
    input wire[31:0] fg,//fg=0 means the first period, fg=1 means the second   en=1 means multi
    output reg[31:0] hi,lo//remember fg=~fg every clk in datapath
    );
    //fg??????????????en????????????????1
    reg [15:0] a_lo,a_hi,b_lo,b_hi;
    reg [31:0] tmp1,tmp2,tmp3,tmp4;
    reg [63:0] res;
    initial begin hi=0;lo=0; end
    always @(*)begin
        if(fg!=2&&fg!=1)begin
            a_lo=15'b0;a_hi=15'b0;a_lo=15'b0;b_hi=15'b0;
        end
        else begin
            if(fg==1)begin
                a_lo=a[15:0];a_hi=a[31:16];
                b_lo=b[15:0];b_hi=b[31:16];
                tmp1=a_lo*b_lo;tmp2=a_hi*b_lo;
                tmp3=a_lo*b_hi;tmp4=a_hi*b_hi;
                hi=0;lo=0;
            end
            else if(fg==2) begin
                res=tmp1+(tmp2<<16)+(tmp3<<16)+(tmp4<<32);
                lo=res[31:0];hi=res[63:32];
            end
        end
    end
endmodule

