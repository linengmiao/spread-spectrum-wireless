library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;


entity PNBitNCO is
port(
	clk: in std_logic;
	clk_enable: in std_logic;
	seq_det: in std_logic;
	full_seq: out std_logic;

	chip_sample1: in std_logic;
	
	pn_ml1:out std_logic;
	pn_ml2:out std_logic;
	pn_gold: out std_logic
);
end PNBitNCO;


architecture Behavioral of PNBitNCO is

constant initValueUpSR: std_logic_vector(4 downto 0):="00001";

signal upperShiftRegister: std_logic_vector(4 downto 0):="00001";
signal upperShiftRegisterNext: std_logic_vector(4 downto 0):="00001";
signal lowerShiftRegister: std_logic_vector(4 downto 0):="00111";
signal lowerShiftRegisterNext: std_logic_vector(4 downto 0):="00111";


TYPE STATE_TYPE IS (shift, sendPulse);
signal state : STATE_TYPE;
signal nextState: STATE_TYPE;

----------------------------------------------------------------------------------------------------
-- seq detect is een soort van reset elke keer als die 1 is zal de pn generator reset worden
-- chip_sample1 zorgt ervoor dat uw pngenerator 16x trager loopt
-- als chip sample ='1' shift als seq det => reser shiftregister
----------------------------------------------------------------------------------------------------
begin
	--is altijd waar
	
	pn_ml1 <= upperShiftRegister(0);
	pn_ml2 <= lowerShiftRegister(0); 
	pn_gold <= upperShiftRegister(0) xor lowerShiftRegister(0);

	syn_edgeDet: process(clk)is
	begin
		if(clk_enable='1')then
			if(rising_edge(clk))then
				lowerShiftRegister<=lowerShiftRegisterNext;
				upperShiftRegister<=upperShiftRegisterNext;
				state<=nextState;
			end if;					
		end if;
	end process;

	comb_edgeDet: process(seq_det,state,lowerShiftRegister, upperShiftRegister)is
	begin
		if(chip_sample1='1')then
			case state is
				when shift=>
					upperShiftRegister(4)<=upperShiftRegister(1)xor upperShiftRegister(3);
					upperShiftRegister(3)<=upperShiftRegister(4);
					upperShiftRegister(2)<=upperShiftRegister(3);
					upperShiftRegister(1)<=upperShiftRegister(2);
					upperShiftRegister(0)<=upperShiftRegister(1);
	
					lowerShiftRegister(4)<=lowerShiftRegister(0)xor lowerShiftRegister(1)xor lowerShiftRegister(3)xor lowerShiftRegister(4);
					lowerShiftRegister(3)<=lowerShiftRegister(4);
					lowerShiftRegister(2)<=lowerShiftRegister(3);
					lowerShiftRegister(1)<=lowerShiftRegister(2);
					lowerShiftRegister(0)<=lowerShiftRegister(1);
					pn_ml2<=lowerShiftRegister(0);

					full_seq<='0';
				when sendPulse=>
					full_seq<='1';
					nextState<=shift;
				end case;
		elsif(seq_det='1')then
			upperShiftRegister<=initValueUpSR;
		end if;
		if(upperShiftRegister=initValueUpSR)then	
			nextState<=sendPulse;
		else
			nextState<=shift;
		end if;

end process;

end;


