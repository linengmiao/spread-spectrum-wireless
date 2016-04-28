library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity PN_generator is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	pn_ml1:out std_logic;
	pn_ml2:out std_logic;
	pn_gold:out std_logic;
	pn_start:out std_logic;

	reset: in std_logic
);
end PN_generator;

architecture Behavioral of PN_generator is

TYPE STATE_TYPE IS (shift,sendPulse);
SIGNAL state : STATE_TYPE;
signal stateNext: STATE_TYPE;

signal shiftReg1: std_logic_vector(4 downto 0):="00010";
signal shiftReg1Next: std_logic_vector(4 downto 0):="00010";
signal shiftReg2: std_logic_vector(4 downto 0):="00111";
signal shiftReg2Next: std_logic_vector(4 downto 0):="00111";

constant initValueSR1: std_logic_vector(4 downto 0):="00010";
constant initValueSR2: std_logic_vector(4 downto 0):="00010";

begin

	syn_pnGen: process(clk)begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
				shiftReg1<=initValueSR1;
				shiftReg2<=initValueSR2;
			else
				state<=stateNext;
				shiftReg1<=shiftReg1Next;
				shiftReg2<=shiftReg2Next;
			end if;	
		end if;	
	end if;	
	end process;

	comb_pnGen: process(shiftReg1,shiftReg2,state)begin
	case state is
		when shift=>
		--pn_ml1				
			shiftReg1Next(3)<=shiftReg1Next(4);
			shiftReg1Next(2)<=shiftReg1Next(3);
			shiftReg1Next(1)<=shiftReg1Next(2);
			shiftReg1Next(0)<=shiftReg1Next(1);
			shiftReg1Next(4)<= (shiftReg1Next(3) xor shiftReg1Next(0)); 

			pn_ml1<=shiftReg1(0);
		--pn_ml2
			shiftReg2Next(3)<=shiftReg2Next(4);
			shiftReg2Next(2)<=shiftReg2Next(3);
			shiftReg2Next(1)<=shiftReg2Next(2);
			shiftReg2Next(0)<=shiftReg2Next(1);
			shiftReg2Next(4)<= shiftReg2Next(4) xor(shiftReg2Next(3) xor(shiftReg2Next(1) xor shiftReg2Next(0)));
	
			pn_ml2<=shiftReg2(0);
		--pn_gold
			pn_gold<=shiftReg1Next(0) xor shiftReg2Next(0);	
	

		pn_start<='0';
	when sendPulse=>		
		pn_start<='1';	
	end case;

	if(shiftReg1 = initValueSR1)then
		stateNext<=sendPulse;			
	else
		stateNext<=shift;				
	end if;


	end process;
end Behavioral;