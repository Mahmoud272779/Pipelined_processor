
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ramFetch IS
PORT (clk,res,counterPC : IN std_logic;
 re,we: IN std_logic;
address : IN std_logic_vector(31 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
takeImmad : IN std_logic;
dataout,immad : OUT std_logic_vector(15 DOWNTO 0) ;
p: OUT std_logic_vector(31 DOWNTO 0) );

END ENTITY ramFetch;

ARCHITECTURE sync_ram OF ramFetch IS 
 TYPE ram_type IS ARRAY(0 TO 2**20) of std_logic_vector(15 DOWNTO 0);
 SIGNAL ram : ram_type ;
BEGIN
PROCESS(clk,re,we,address) IS 
BEGIN
if (res='1')then
p<=(others=>'0');
else
if(address /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" and address /= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" and counterPC='0')then
 IF (clk'event and clk = '1') THEN 
 IF we = '1' and re='0' THEN 
ram(to_integer(unsigned((address)))) <= datain; 
 END IF;
if re='1' and we='0' then

	dataout <= ram(to_integer(unsigned((address))));
 	p<=std_logic_vector(unsigned((address))+1);
	if (ram(to_integer(unsigned((address))))(4 downto 0)="10001")then
		immad<= ram(to_integer(unsigned((address)))+1) ;
                p<=std_logic_vector(unsigned((address))+2);
        else
                immad<=(OTHERS=>'0');
	end if;






 END IF;
 END IF;
end if;
end if;
END PROCESS;
 



END sync_ram;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std_unsigned.all;
entity FETCH is
port(
CLK ,RES,counterPC,takeImmad: in std_logic;
P : out std_logic_vector(31 downto 0);
f1 ,immad: out std_logic_vector(15 downto 0)
);
END ENTITY FETCH;
ARCHITECTURE s1 OF FETCH IS
COMPONENT ramFetch IS 
PORT (clk,res ,counterPC: IN std_logic;
 re,we: IN std_logic;
address : IN std_logic_vector(31 DOWNTO 0);
datain : IN std_logic_vector(15 DOWNTO 0);
takeImmad : IN std_logic;
dataout,immad : OUT std_logic_vector(15 DOWNTO 0);
p: OUT std_logic_vector(31 DOWNTO 0) );
END COMPONENT;
SIGNAL in1:  std_logic_vector(15 downto 0);
Signal PC : std_logic_vector(31 downto 0);

begin
stageMem1: ramFetch  PORT MAP (CLK,RES,counterPC,'1','0',PC,in1,takeImmad,f1,immad,PC);
p<=PC;
END s1;







