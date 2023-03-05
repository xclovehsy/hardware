`timescale 1ns / 1ps
`include "defines2.vh"
module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	output wire equalD,
	input wire sig_extD,
	// output wire[5:0] opD,functD,
	output wire [31:0]instrD,
	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire[4:0] alucontrolE,
	output wire flushE,
	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM1,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,

	// jump new
	input wire branchwriteE,
	input wire j_regD,
	input wire j_31D,
	input wire j_pls8D
    );
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD;
	//decode stage
	wire [31:0] pcplus4D;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rtD,rdD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage
	wire [31:0] instrE;
	wire [1:0] forwardaE,forwardbE;
	wire [4:0] rsE,rtE,rdE;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E,srca3E,srcb4E;
	wire [31:0] aluoutE;
	//mem stage
	wire [4:0] writeregM;
	//writeback stage
	wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,resultW;

	//hi lo寄存器以及相关乘法除法操�???
	wire[31:0] hi_E,lo_E;wire stall_all;


	//XC new
	wire [31:0]pc_tst;
	//F stage
	
	//D stage 
	wire [31:0]pcD;
	//E stage
	wire [31:0]pcbranchE;
	wire [31:0]pcE;
	wire j_31E;
	wire j_pls8E;
	//M stage
	wire [31:0]pcbranchM;
	wire branchwriteM;
	//W stage
	wire [31:0]pcbranchW;
	wire branchwriteW;
	


	//hazard detection
	hazard h(
		//fetch stage
		stallF,
		//decode stage
		rsD,rtD,
		branchD,
		forwardaD,forwardbD,
		stallD,
		//execute stage
		rsE,rtE,
		writeregE,
		regwriteE,
		memtoregE,
		forwardaE,forwardbE,
		flushE,
		//mem stage
		writeregM,
		regwriteM,
		memtoregM,
		//write back stage
		writeregW,
		regwriteW
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcmux(pcnextbrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD,pcnextFD);
	//xc new
	mux2 #(32) pcmux2(pcnextFD,srca2D,j_regD,pc_tst);

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	pc #(32) pcreg(clk,rst,(~stallF)&(~stall_all),pc_tst,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);
	//decode stage
	flopenr #(32) r1D(clk,rst,~stallD&~stall_all,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD&~stall_all,flushD,instrF,instrD);
	flopenr #(32) r3D(clk,rst,~stallD&~stall_all,pcF,pcD);
	signext se(sig_extD, instrD[15:0],signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(instrD, srca2D,srcb2D,equalD);

	assign opD = instrD[31:26];
	assign functD = instrD[5:0];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];

	//execute stage
	floprc #(32) r1E(clk,rst,flushE|stall_all,srcaD,srcaE);
	floprc #(32) r2E(clk,rst,flushE|stall_all,srcbD,srcbE);
	floprc #(32) r3E(clk,rst,flushE|stall_all,signimmD,signimmE);
	floprc #(5) r4E(clk,rst,flushE|stall_all,rsD,rsE);
	floprc #(5) r5E(clk,rst,flushE|stall_all,rtD,rtE);
	floprc #(5) r6E(clk,rst,flushE|stall_all,rdD,rdE);
	floprc #(32) r7E(clk,rst,flushE|stall_all,instrD,instrE);  // push instr into stage E

	//XC new
	floprc #(32)r8E(clk,rst,flushE|stall_all,pcD,pcE);
	floprc #(1)r10E(clk,rst,flushE|stall_all,j_31D,j_31E);
	floprc #(1)r11E(clk,rst,flushE|stall_all,j_pls8D,j_pls8E);
    floprc #(32)r12E(clk,rst,flushE|stall_all,pcbranchD,pcbranchE);

	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
	//xc new
	mux2 #(32) srcamux(srca2E,pcE,j_pls8E|branchwriteE,srca3E);
	mux2 #(32) srcbmux2(srcb3E,32'b1000,j_pls8E|branchwriteE,srcb4E);



	//for mfhi and mflo
	wire[1:0] mf_op_E,mf_op_M,mf_op_W;
	/******mult option*****/
	wire[31:0] hi3,lo3;
	alu alu(srca3E,srcb4E,instrE[10:6],alucontrolE,aluoutE,hi3,lo3,mf_op_E);
	//signed multiply option
	wire fg1;reg[31:0] fg2;
	wire[31:0] hi1,lo1;
	initial fg2=0;
	assign fg1=(instrE[5:0]==`MULT)&(instrE[15:6]==0)&(instrE[31:26]==0);
	always@(posedge clk)fg2[1]=fg1;
	signed_mult mult1(srca2E,srcb3E,clk,{fg2[31:1],fg1},hi1,lo1);
	//unsigned multiply option
	wire fg3;reg[31:0] fg4;
	wire[31:0] hi2,lo2;
	initial fg4=0;
	assign fg3=(instrE[5:0]==`MULTU)&(instrE[15:6]==0)&(instrE[31:26]==0);
	always@(posedge clk)fg4[1]=fg3;
	unsigned_mult mult2(srca2E,srcb3E,clk,{fg4[31:1],fg3},hi2,lo2);
	//if need to stall
	assign stall_all=(fg1|fg3);
	assign hi_E=hi1|hi2|hi3; assign lo_E=lo1|lo2|lo3;
//	always@(posedge clk)begin
//	   if(hi1|hi2|hi3!=0)hi<=hi1|hi2|hi3;else hi<=hi;
//	end
	/******mult option*****/
	
	
	
	//乘法
	mux2 #(5) wrmux(rtE,rdE,regdstE,writeregE);
	//XC new
	wire [4:0]writereg2E;
	mux2 #(5) wrmux2(writeregE,5'b11111,branchwriteE|j_31E,writereg2E);
	//mem stage
	wire[31:0] hi_M,lo_M,hi_W,lo_W,alutmpM,alutmpM2;
	reg[31:0] readdataM;
	wire[5:0] op_M;//lw lh lhu
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
//	flopr #(32) r2M(clk,rst,aluoutE,aluoutM);
    flopr #(32) r2M(clk,rst,aluoutE,alutmpM);
	flopr #(5) r3M(clk,rst,writereg2E,writeregM);
	flopr #(2) r4M(clk,rst,mf_op_E,mf_op_M);
	flopr #(6) r5M(clk,rst,instrE[31:26],op_M);
	mux2 #(32) mmux1(alutmpM,lo_M,mf_op_M[0],alutmpM2);
	mux2 #(32) mmux2(alutmpM2,hi_M,mf_op_M[1],aluoutM);

	//XC new
	wire pcbranchM;
	flopr #(32) r6M(clk,rst,pcbranchE,pcbranchM);
	
	hilo_reg hilo_reg1(clk,rst,1'b1,hi_E,lo_E,hi_M,lo_M);
	always@(op_M,readdataM1,aluoutM)begin
	   case(op_M)
	       `LB:begin 
	           readdataM={32{1'b1}}; 
	           if(aluoutM[1:0]==3)begin readdataM[7:0]=readdataM1[31:24]; end
	           else if(aluoutM[1:0]==2)begin readdataM[7:0]=readdataM1[23:16]; end
	           else if(aluoutM[1:0]==1)begin readdataM[7:0]=readdataM1[15:8]; end
	           else begin readdataM[7:0]=readdataM1[7:0]; end
	       end
	       `LBU:begin 
	           readdataM={32'b0}; 
	           if(aluoutM%4==3)begin readdataM[7:0]=readdataM1[31:24]; end
	           else if(aluoutM[1:0]==2)begin readdataM[7:0]=readdataM1[23:16]; end
	           else if(aluoutM[1:0]==1)begin readdataM[7:0]=readdataM1[15:8]; end
	           else begin readdataM[7:0]=readdataM1[7:0]; end
	       end
	       `LH:begin 
	           readdataM={32{1'b1}}; 
	           if(aluoutM[1:0]==2)begin readdataM[15:0]=readdataM1[31:16]; end
	           else begin readdataM[15:0]=readdataM1[15:0]; end
	       end
	       `LHU:begin 
	           readdataM={32'b0}; 
	           if(aluoutM[1:0]==2)begin readdataM[15:0]=readdataM1[31:16]; end
	           else begin readdataM[15:0]=readdataM1[15:0]; end
	       end
	       default:begin readdataM=readdataM1;end
	   endcase
	end
	//writeback stage
	hilo_reg hilo_reg2(clk,rst,1'b1,hi_M,lo_M,hi_W,lo_W);
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);
	flopr #(2) r4W(clk,rst,mf_op_M,mf_op_W);

	// XC new 
	wire pcbranchW;
	flopr #(32)r5W(clk,rst,pcbranchM,pcbranchW);

	wire[31:0] res1,res2;
//	mux2 #(32) resmux1(aluoutW,readdataW,memtoregW,resultW);
	mux2 #(32) resmux1(aluoutW,readdataW,memtoregW,res1);
	mux2 #(32) resmux2(res1,lo_W,mf_op_W[0],res2);
	mux2 #(32) resmux3(res2,hi_W,mf_op_W[1],resultW);
endmodule
