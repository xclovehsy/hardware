-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
<<<<<<< HEAD
-- Date        : Mon Dec 19 18:00:52 2022
-- Host        : DESKTOP-CF3K8O5 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/ComputerCode/hardware_project/CO-lab-material-CQU/vivado/lab4/rtl/xilinx_ip/inst_ram/inst_ram_stub.vhdl
=======
-- Date        : Sat Dec 24 15:53:19 2022
-- Host        : DESKTOP-CF3K8O5 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/xc/Desktop/hard/hardware/vivado/lab4/project_1/project_1.srcs/inst_ram/ip/inst_ram/inst_ram_stub.vhdl
>>>>>>> da2b0dd963a0f4c07c08133c48869fa3bb87fc84
-- Design      : inst_ram
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inst_ram is
  Port ( 
    clka : in STD_LOGIC;
    rsta : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 3 downto 0 );
    addra : in STD_LOGIC_VECTOR ( 31 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 31 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rsta_busy : out STD_LOGIC
  );

end inst_ram;

architecture stub of inst_ram is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,rsta,ena,wea[3:0],addra[31:0],dina[31:0],douta[31:0],rsta_busy";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
