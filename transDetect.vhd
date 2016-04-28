
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity transDetect is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	sdi_spread: in std_logic;
	extb: out std_logic
	
);
end transDetect;


architecture Behavioral of transDetect is
        TYPE STATE_TYPE IS (waitingRisingEdge,sendPulse, waitingFallingEdge);
   	SIGNAL state : STATE_TYPE;
   	SIGNAL nextState : STATE_TYPE;
	signal previousState: state_type;

--	shared variable hulpVar:integer:=0;
	signal hulpSig:std_logic_vector(1 downto 0):="00";

begin

	syn_edgeDet: process(clk)begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
--				state<=waitingfRisingEdge;	
			else
				state<=nextState;
			end if;
			
			
		end if;
	end if;
	end process;

	com_edgeDet: process(sdi_spread, state)begin

		case state is		
			when waitingRisingEdge=>
				if(sdi_spread='0')then
					extb <='0';
					nextState<=waitingRisingEdge;	
				elsif(sdi_spread='1')then
					previousState<=waitingRisingEdge;
					nextState<=sendPulse;
				end if;
			when waitingFallingEdge=>
				if(sdi_spread='1')then
					extb <='0';
					nextState<=waitingFallingEdge;				
				elsif(sdi_spread='0')then
					extb <='0';
					previousState<=waitingFallingEdge;
					nextState<=sendPulse;
				end if;
			when sendPulse =>
				if(previousState=waitingRisingEdge)then
					extb<='1';
					nextState<=waitingFallingEdge;
				elsif(previousState=waitingFallingEdge)then
					extb<='1';
					nextState<=waitingRisingEdge;					
				end if;
			when others =>
		end case;
	end process;
end Behavioral;