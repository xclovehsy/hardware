`timescale 1ns / 1ps
module unsigned_div#(parameter WID=32)(
    input wire[WID-1:0] a,b,
    output reg[WID-1:0] div,mod
    );
    reg[63:0] tmp1,tmp2;
    always @(a or b)begin
        tmp1={32'b0,a};
        tmp2={b,32'b0};
        for(int i=0;i<32;i++)begin
            tmp1<<=1;
            if(tmp1[63:32]>=b)
                tmp1=tmp1-tmp2+1;
            else ;
        end
        mod=tmp1[63:32];
        div=tmp1[31:0];
    end
endmodule
