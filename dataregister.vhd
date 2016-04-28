library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity dataregister is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	ld:in std_logic;
	sh:in std_logic;
	data:in std_logic_vector(3 downto 0);
	sdo_posenc:out std_logic
);
end dataregister;

architecture behav of dataregister is

TYPE STATE_TYPE IS (shift, load, waitPulse);
signal state : STATE_TYPE;
signal stateNext: STATE_TYPE;

signal dataregister:std_logic_vector(10 downto 0);
signal dataregisterNext:std_logic_vector(10 downto 0);

constant preamble: std_logic_vector(6 downto 0):="0111110";

begin
	syn_stateMachine: process(clk,reset)is
	begin
		if(clkEnable = '1')then
			if(rising_edge(clk))then
				if(reset='1')then
					dataregister(10 downto 7)<= "0000";
					dataregister(6 downto 0)<= preamble;				
				else
					dataregister<=dataregisterNext;
					state<=stateNext;
				end if;
			end if;			
		end if;
	end process;

	comb_process:process(ld, sh)is
	begin
		case state is
			when shift=>
				dataregisterNext(9)<=dataregisterNext(10);
				dataregisterNext(8)<=dataregisterNext(9);
				dataregisterNext(7)<=dataregisterNext(8);
				dataregisterNext(6)<=dataregisterNext(7);
				dataregisterNext(5)<=dataregisterNext(6);
				dataregisterNext(4)<=dataregisterNext(5);
				dataregisterNext(3)<=dataregisterNext(4);
				dataregisterNext(2)<=dataregisterNext(3);
				dataregisterNext(1)<=dataregisterNext(2);
				dataregisterNext(0)<=dataregisterNext(1);
				sdo_posenc<=dataregisterNext(0);
			when load=>
				dataregisterNext(10 downto 7)<= data;
				dataregisterNext(6 downto 0)<= preamble;				
			when others=>
		end case;
		if((sh='1')and(ld='0'))then
			stateNext<=shift;
		elsif((sh='0')and(ld='1'))then
			stateNext<=load;
		else
			stateNext<=waitPulse;
		end if;

	end process;
end;