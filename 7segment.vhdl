library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity segment is
port(
	clk: in std_logic;
	reset:in std_logic;
	-- is het common anode of common cathode?
	anode: out std_logic;
	input: in std_logic_vector(3 downto 0);
	segmentDisp: out std_logic_vector(7 downto 0)
);
end segment;

architecture behav of segment is

	alias GFEDCBA: std_logic_vector (6 downto 0) is segmentDisp;  

begin
--	syn_seg: process(clk)begin
--		if(rising_edge(clk))then
--			if(reset='1')then
--				anode<='0';
--				segmentDisp<="00000000";			
--			end if;
--		end if;
--	end process;
--
--	comb_seg:process(input)begin
--		 case (input) is
--		      when "0000" => GFEDCBA <= "1000000";      -- actief laag   
--		      when "0001" => GFEDCBA <= "1111001";
--                      when "0010" => GFEDCBA <= "0100100";
--                      when "0011" => GFEDCBA <= "0110000"; 
--                      when "0100" => GFEDCBA <= "0011001";
--                      when "0101" => GFEDCBA <= "0010010";
--                      when "0110" => GFEDCBA <= "0000010"; 
--                      when "0111" => GFEDCBA <= "1111000";   
--                      when "1000" => GFEDCBA <= "0000000";               
--	              when others => GFEDCBA <= "0010000";             
--                 end case; 
--                  anode <= '0';   --actief laag
--	end process;
	
end behav;
