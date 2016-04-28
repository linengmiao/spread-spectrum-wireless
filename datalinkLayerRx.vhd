library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datalinkLayerRx is
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;

	preambleOut: out std_logic_vector(6 downto 0);
	latchOut: out std_logic_vector(3 downto 0);

	databit: in std_logic;
	bit_sample: in std_logic
);
end datalinkLayerRx;

architecture behavioral of datalinkLayerRx is

signal shiftRegister: std_logic_vector(10 downto 0):="00000000000";
signal shiftRegisterNext: std_logic_vector(10 downto 0):="00000000000";

begin

synProc: process(clk)is
begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
		
			else	
				shiftRegister<=shiftRegisterNext;
			end if;
		end if;
	end if;
end process;

	preambleOut <= shiftRegister(6 downto 0);
	latchOut <= shiftRegister(10 downto 7);

combProc: process(databit, bit_sample)is
begin

	if(bit_sample='1')then		
		shiftRegisterNext(9 downto 0)<=shiftRegister(10 downto 1);
		shiftRegisterNext(10)<=databit;
	end if;

end process;
end;