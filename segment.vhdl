library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity segment is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	-- is het common anode of common cathode?
	anode: out std_logic;
	input: in std_logic_vector(3 downto 0);
	segmentDisp: out std_logic_vector(7 downto 0)
);
end segment;

architecture behav of segment is
	alias HGFEDCBA: std_logic_vector (7 downto 0) is segmentDisp;  

	signal segmentSignal: std_logic_vector(7 downto 0);

begin

	syn_seg: process(clk,reset)begin
	if(clkEnable = '1')then
		if(rising_edge(clk))then
			if(reset='1')then
				anode<='0';
				segmentDisp<="00000000";			
			end if;
			HGFEDCBA<=segmentSignal;
		end if;
	end if;
	end process;

	comb_seg:process(input)begin
		 case (input) is
		      when "0000" => segmentSignal <= "11000000";      -- actief laag   
		      when "0001" => segmentSignal <= "11111001";
                      when "0010" => segmentSignal <= "10100100";
                      when "0011" => segmentSignal <= "10110000"; 
                      when "0100" => segmentSignal <= "10011001";
                      when "0101" => segmentSignal <= "10010010";
                      when "0110" => segmentSignal <= "10000010"; 
                      when "0111" => segmentSignal <= "11111000";   
                      when "1000" => segmentSignal <= "10000000";               
	              when others => segmentSignal <= "10010000";             
                 end case; 
                  anode <= '0';   --actief laag
	end process;
	
end behav;