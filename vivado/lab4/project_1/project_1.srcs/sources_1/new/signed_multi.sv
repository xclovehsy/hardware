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


module signed_multi(
    input wire[31:0] a,b,
    input clk,en,fg,//fg=0 means the first period, fg=1 means the second   en=1 means multi
    output reg[31:0] hi,lo//remember fg=~fg every clk in datapath
    );
    //fg每个周期都要取反，en在是乘法指令的时候置为1
    reg [15:0] a_lo,a_hi,b_lo,b_hi;
    reg [31:0] tmp1,tmp2,tmp3,tmp4;
    reg [63:0] res;
    always_ff @(posedge clk)begin
        if(!en)begin
            a_lo=15'b0;a_hi=15'b0;a_lo=15'b0;b_hi=15'b0;
        end
        else begin
            if(fg==0)begin
                a_lo=a[15:0];a_hi={1'b0,a[30:16]};
                b_lo=b[15:0];b_hi={1'b0,b[30:16]};
                tmp1=a_lo*b_lo;tmp2=a_hi*b_lo;
                tmp3=a_lo*b_hi;tmp4=a_hi*b_hi;
            end
            else begin
                res=tmp1+(tmp2<<16)+(tmp3<<16)+(tmp4<<30);
                if(a[31]^b[31])lo={1'b1,res[30:0]};
                else lo={1'b0,res[30:0]};
                hi=res[62:31];
            end
        end
    end
endmodule

