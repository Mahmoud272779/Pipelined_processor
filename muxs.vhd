library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_muxs is
port(   reg,mem,ex,im : in std_logic_vector(15 downto 0); --input operands
        slc : in std_logic_vector(1 downto 0); --select of muxs
        R : out std_logic_vector(15 downto 0)  --output of muxs
	);
end alu_muxs;

architecture muxarch of alu_muxs is

signal RES,rg,mm,e,imd : std_logic_vector(15 downto 0) := (others => '0');
begin

rg<=reg;
mm<=mem;
e<=ex;
imd<=im;
R <=RES;

RES <=  rg WHEN slc= "00"
else  e WHEN slc="10"
else  mm WHEN slc="01"
else  imd WHEN slc="11";
end muxarch;
