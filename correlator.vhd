library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;

entity correlator is
port(
	clk: in std_logic;
	clk_enable: in std_logic;
	reset: in std_logic;

	chip_sample2: in std_logic;
	bit_sample: in std_logic;
	databit: out std_logic
);
end correlator;

architecture Behavioral of correlator is

TYPE STATE_TYPE IS (init,count, setQHigh,setQLow);
signal state : STATE_TYPE:=init;
signal nextState: STATE_TYPE;


signal counter: integer range 0 to 65:= 32;
signal counterNext: integer range 0 to 65:= 32;
signal test: std_logic:='0';

begin
	sync_corr:process(clk)is
	begin
		if(clk_enable='1')then
			if(rising_edge(clk))then
				counter<=counterNext;
				state<=nextState;
			end if;
		end if;
	end process;

	comb_corr:process(bit_sample, counter, chip_sample2,state)is
	begin
--	if(chip_sample2='1')then
--		test<='1';
--	end if;
		case state is
			when count=>
				if (chip_sample2='1')then
					counterNext<= counter+1;
					
				else
					counterNext<= counter-1;					
				end if;
			
			when setQHigh=>
				databit<='1';
				nextState<=count;
				counterNext<=32;
			when setQLow=>
				databit<='0';
				nextState<=count;
				counterNext<=32;
			when others=>
		end case;

		if(bit_sample='1')then --new datastream
			if(state=init)then --first iteration
				nextState<=count;
			else
				if(counter>32)then
					nextState<=setQHigh;
				else
					nextState<=setQLow;			
				end if;
				counterNext<=32; --reinitialize counter
			end if;
		end if;
	end process;
end;

