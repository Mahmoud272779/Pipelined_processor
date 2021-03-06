library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simple_alu is
port(   --Clk : in std_logic; --clock signal
        A,B : in std_logic_vector(15 DOWNTO 0);--input operands
        Op : in std_logic_vector(2 downto 0); --Operation to be performed
        R : out std_logic_vector(15 downto 0);  --output of ALU
        zf,nf,cf: out std_logic --flags
	);
end simple_alu;

architecture Behavioral of simple_alu is

--temporary signal declaration.
signal Reg1,Reg2,Reg3 : signed(15 downto 0) := (others => 'Z');

begin

Reg1 <= signed((A));
Reg2 <= signed((B));
R <= std_logic_vector(Reg3);

nf<= Reg3(15);
	
process(Reg1,Reg2,OP,Reg3)
variable temp : std_logic_vector(16 downto 0);

begin

    --if(rising_edge(Clk)) then --Do the calculation at the positive edge of clock cycle.
        case Op is
            when "000" => --addition
	    temp := std_logic_vector(("0" & unsigned(Reg1)) + unsigned(Reg2));
            Reg3 <= Reg1 + Reg2;
            cf <= temp(16);          
            
            when "001" => --subtraction
            temp := std_logic_vector(("0" & unsigned(Reg1)) - unsigned(Reg2));
            Reg3 <= Reg1 - Reg2;
            cf <= temp(16);
            
	    when "010" => --and
            Reg3 <=  Reg1 and Reg2;  
		cf<='0';

            when "011" => --move
            Reg3 <= Reg1 ;
		cf<='0';

            when "100" => --inc
            temp := std_logic_vector(("0" & unsigned(Reg1)) + 1);
            Reg3 <= Reg1 + 1;
            cf <= temp(16);

	    when "101" => --not 
            Reg3 <= not Reg1;
            

	    when "110" => --setCarry 
            cf<='1';          

            when others =>
                Reg3 <= (others => 'Z');
        end case;

	if (Reg3="0000000000000000")then 
            zf <='1'; 
    	else
    	    zf <='0';
    	end if;	           
   
end process;   

end Behavioral;
