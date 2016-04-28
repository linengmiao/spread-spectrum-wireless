library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;
use ieee.numeric_std.all;

entity matchedFilter is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	chip_sample: in std_logic;
	sdi_spread: in std_logic;
	sw: in std_logic_vector(1 downto 0);
	
	seq_det: out std_logic

);
end matchedFilter;


architecture Behavioral of matchedFilter is

constant zero:std_logic_vector(31 downto 0):="00000000000000000000000000000000";
constant ml1_ptrn: std_logic_vector(31 downto 0):="00101100111110001101110101000010";
constant ml2_ptrn: std_logic_vector(31 downto 0):="01110100111010011101001110100111";
constant gold_ptm: std_logic_vector(31 downto 0):= ml1_ptrn xor ml2_ptrn;


TYPE STATE_TYPE IS (shift, sendPulse, sendZeroOut, waitingChipSample);
signal state : STATE_TYPE;
signal nextState: STATE_TYPE;


signal shiftRegister: std_logic_vector(31 downto 0):=zero;
signal shiftRegisterNext: std_logic_vector(31 downto 0):=zero;

begin

	syn_matchedFilter: process(clk)is
	begin
		if(clkEnable='1')then
			if(rising_edge(clk))then
				shiftRegister<=shiftRegisterNext;
				state<=nextState;
			end if;
		end if;
	end process;

	comb_matchedFilter: process(chip_sample, shiftRegister,sw,state)is
	begin
		if(chip_sample='1')then
			shiftRegisterNext<=sdi_spread & shiftregister(31 downto 1);
				case(sw)is
					when "00"=>
						if(shiftregister = zero)then
							nextState<=sendPulse;
						end if;
						if(shiftregister = not(zero))then
							nextState<=sendPulse;
						end if;
					when"01"=>
						if(shiftregister = ml1_ptrn)then
							nextState<=sendPulse;
						end if;
						if(shiftregister = not(ml1_ptrn))then
							nextState<=sendPulse;
						end if;
					when "10"=>
						if(shiftregister = ml2_ptrn)then
							nextState<=sendPulse;
						end if;
						if(shiftregister = not(ml2_ptrn))then
							nextState<=sendPulse;
						end if;
					when "11"=>
						if(shiftregister = gold_ptm)then
							nextState<=sendPulse;
						end if;
						if(shiftregister = not(gold_ptm))then
							nextState<=sendPulse;
						end if;
					when others => 
						nextState<=sendZeroOut;
				end case;	
		end if;
		if(state=sendPulse)then  --indien er niet geshift moet worden
			seq_det<='1';	
			nextState<=waitingChipSample;
		else
			seq_det<='0';
		end if;

	end process;
end;