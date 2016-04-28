library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity edgeDetecter is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	input: in std_logic;
	output: out std_logic
	
);
end edgeDetecter;


architecture Behavioral of edgeDetecter is
        TYPE STATE_TYPE IS (waitingRisingEdge,sendPulse, waitingFallingEdge);
   	SIGNAL state : STATE_TYPE;
   	SIGNAL nextState : STATE_TYPE;

	signal previousInput: std_logic;

begin

	syn_edgeDet: process(clk)begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
				state<=waitingRisingEdge;	
			else
				state<=nextState;
			end if;
		end if;
	end if;
	end process;

		previousInput<=input;

	com_edgeDet: process(input, state)begin
		if(input='1')then 
			if(previousInput='0')then --er is een overgang
				nextState<=sendPulse;	
			end if;
		elsif(input='0')then-- ook als er een falling edge is
			nextState<=waitingRisingEdge;
		end if;
		case state is
			when sendPulse=>
				output<='1';
				nextState<=waitingRisingEdge;
			when waitingRisingEdge=>
				output<='0';
			when others=>
		end case;
	
	end process;
end Behavioral;