library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;

entity datalatch is
port(
	clk: in std_logic;
	clk_enable: in std_logic;
	reset: in std_logic;

	preambleIn: in std_logic_vector(6 downto 0);
	latchIn: in std_logic_vector(3 downto 0);

	sevSeg: out std_logic_vector(3 downto 0)

);
end datalatch;

architecture Behavioral of datalatch is

constant preamble: std_logic_vector(6 downto 0):="0111110";
signal localLatch: std_logic_vector(3 downto 0);

begin
	sync_DL:process(clk)is
	begin
		if(clk_enable='1')then
			if(rising_edge(clk))then
				if(reset='1')then
					sevSeg<="0000";
				else
					sevSeg<=localLatch;
				end if;
			end if;
		end if;
	end process sync_DL;
	
	comb_DL: process(latchIn, preambleIn)is
	begin
		if(preambleIn=preamble)then
			localLatch<=latchIn;
		end if;

	end process comb_DL;
end;