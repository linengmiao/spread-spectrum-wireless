library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sequenceController is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	pn_start:in std_logic;
	ld:out std_logic;
	sh:out std_logic
);
end sequenceController;

architecture behav of sequenceController is

type state_machine is (count, load, waitPNStart);  
signal state: state_machine:=waitPNStart;
signal nextState: state_machine:=waitPNStart;

signal counter:integer:=0;
signal counterNext:integer:=0;

signal test:std_logic:='0';

begin

--kijkt of er een nieuwe periode moet gedaan worden 
	syn_stateMachine: process(clk)begin
	if(clkEnable = '1')then
		if(rising_edge(clk))then
			if(reset='1')then
			--	ld<='1';
			--	sh<='0';
				state<=count;
			else
				state<=nextState;
				counter<=counterNext;
			end if;

		end if;
	end if;
	end process;
-------------------------------------------------------------------

	com_stateMachine: process(pn_start,state,counter)begin

	if(counter=11)then
		counterNext<=0;
		nextState<=load;
	else
		case state is
			when count=>
				counterNext<=counter + 1;
				sh<='1';
				ld<='0';
	
				nextState<=waitPNStart;
			when load=>
				sh<='0';
				ld<='1';
				
				nextState<=waitPNStart;
			when waitPNStart=>
				sh<='0';
				ld<='0';	
		
				if(pn_start='1')then
					nextState<=count;
				end if;
			when others=>
				sh<='0';
				ld<='0';
		end case;
	end if;
--	else
--		if(previousState=w)then
--			nextState<=count;
--		elsif(previousState=count)then
--			nextState<=waitPNStart;
--		end if;
--	end if;
	end process;
end;