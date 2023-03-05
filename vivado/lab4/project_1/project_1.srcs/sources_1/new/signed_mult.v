`timescale 1ns / 1ps
module signed_mult(
    input wire[31:0] a,b,
    input clk,
    input wire[31:0] fg,//fg=0 means the first period, fg=1 means the second   en=1 means multi
    output reg[31:0] hi,lo//remember fg=~fg every clk in datapath
    );
    reg [31:0] tmpa,tmpb;
    reg [15:0] a_lo,a_hi,b_lo,b_hi;
    reg [31:0] tmp1,tmp2,tmp3,tmp4;
    reg [63:0] res;
    reg sign;
    initial begin hi=0;lo=0; end
    always @(*)begin
        if(fg!=2&&fg!=1)begin
            a_lo=15'b0;a_hi=15'b0;a_lo=15'b0;b_hi=15'b0;
        end
        else begin
            if(fg==1)begin
                if(a[31]==1)tmpa=(~a[30:0])+1;else tmpa=a;
                if(b[31]==1)tmpb=(~b[30:0])+1;else tmpb=b;
                a_lo=tmpa[15:0];a_hi={1'b0,tmpa[30:16]};
                b_lo=tmpb[15:0];b_hi={1'b0,tmpb[30:16]};
                tmp1=a_lo*b_lo;tmp2=a_hi*b_lo;
                tmp3=a_lo*b_hi;tmp4=a_hi*b_hi;
                sign=a[31]^b[31];hi=0;lo=0;
            end
            else if(fg==2) begin
                res=tmp1+(tmp2<<16)+(tmp3<<16)+(tmp4<<30);
                if(sign)res={1'b1,~res[62:0]+1};
                if(a[31]^b[31])lo={1'b1,res[30:0]};
                else lo={1'b0,res[30:0]};
                hi=res[62:31];
            end
        end
    end
endmodule

