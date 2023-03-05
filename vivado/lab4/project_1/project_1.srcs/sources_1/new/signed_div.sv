`timescale 1ns / 1ps
module signed_div#(parameter WID=32)(
    input wire[WID-1:0] a,b,
    output reg[WID-1:0] div,mod
    );
<<<<<<< HEAD
    reg[61:0] tmp1,tmp2;
    always @(a or b)begin
        tmp1={31'b0,a[30:0]};
        tmp2={b[30:0],31'b0};
        for(int i=0;i<31;i++)begin
            tmp1<<=1;
            if(tmp1[61:31]>=b[30:0])
=======
    reg[WID-1:0] tmpa,tmpb;
    reg[61:0] tmp1,tmp2;
    always @(a or b)begin
        if(a[31]==1)tmpa=(~a[30:0])+1;else tmpa=a;
        if(b[31]==1)tmpb=(~b[30:0])+1;else tmpb=b;
        tmp1={31'b0,tmpa[30:0]};
        tmp2={tmpb[30:0],31'b0};
        for(int i=0;i<31;i++)begin
            tmp1<<=1;
            if(tmp1[61:31]>=tmpb[30:0])
>>>>>>> da2b0dd963a0f4c07c08133c48869fa3bb87fc84
                tmp1=tmp1-tmp2+1;
            else ;
        end
        mod=tmp1[61:31];
        if(a[31]^b[31])begin 
<<<<<<< HEAD
            div={1'b1,tmp1[30:0]};mod={1'b1,tmp1[61:31]};
=======
            div={1'b1,(~tmp1[30:0])+1};mod={1'b1,(~tmp1[61:31])+1};
>>>>>>> da2b0dd963a0f4c07c08133c48869fa3bb87fc84
        end else begin
            div={1'b0,tmp1[30:0]};mod={1'b0,tmp1[61:31]};
        end
    end
endmodule
