LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY memUnit is
PORT (clk, rst : in STD_LOGIC;
      consig : in STD_LOGIC_VECTOR (2 downto 0);           -- 0th bit store or load, 1th bit push or pop, 2th bit to indicate do nothing
      address : in STD_LOGIC_VECTOR (15 downto 0);     -- 20 bit address (ends at FF00), also for SP (ends at FFFF) 
      carry : in std_logic;
      SP : inout STD_LOGIC_VECTOR (19 downto 0);
      datain : in STD_LOGIC_VECTOR (15 downto 0);          -- data taken from exec stage
                         -- Write enable and Read enable, read enable is useless till now
      dataout : out STD_LOGIC_VECTOR (15 downto 0));       -- dataout to the buffer or to forwarding unit

END ENTITY;


architecture a_memUnit of memUnit is
component Ram is
PORT (clk, we, rst :  IN STD_LOGIC ;
      address : IN std_logic_vector(19 downto 0);
      datain : in std_logic_vector (15 downto 0);
      dataout : out std_logic_vector (15 downto 0));
end COMPONENT;


signal offset : std_logic_vector (19 downto 0);
signal enable : std_logic;                                -- 1 means store or push, 0 means load or pop
signal SP_temp : std_logic_vector (19 downto 0);
signal OUTPU : std_logic_vector(15 downto 0);
--signal buffsig : std_logic;


begin

SP_temp <= SP;


with consig(2 downto 1) select
offset <= SP when "01",
"000" & carry & address when "00",
(OTHERS => '0') when OTHERS;





--SPoutsig <= consig(1);                                 --meaning sending signal to buffer to make him return another handshake signal


enable <= consig(0) and not(consig(2));                                     --0 means load or pop, 1 means store of push (write enable = 1)


mem: RAM PORT MAP (clk, enable, rst, offset, datain, OUTPU);
dataout <= OUTPU;

process(clk)
begin
if(rst = '1') then
	SP <= std_logic_vector(to_unsigned(((2**20) - 1) , SP'length));
	
elsif(clk'event and clk = '1') then
	if(consig = "011") then
		SP <= std_logic_vector(unsigned(SP_temp) - 1);
	elsif(consig = "010") then
		SP <= std_logic_vector(unsigned(SP_temp) + 1);
	end if;
end if;
end process;



end a_memUnit;
