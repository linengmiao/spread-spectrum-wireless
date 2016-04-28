library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity potmeter is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	syncha: in std_logic;
	synchb: in std_logic;
	counter: out std_logic_vector(3 downto 0)
	
);
end potmeter;


architecture Behavioral of potmeter is
        TYPE STATE_TYPE IS (waitingRisingEdge,sendPulse, waitingFallingEdge);

   	SIGNAL state : STATE_TYPE:=waitingRisingEdge;
   	SIGNAL nextState : STATE_TYPE:=waitingRisingEdge;
	signal previousState: state_type;

	signal edge_do: std_logic;
	signal edge_up: std_logic;
	signal zIn: std_logic;
	signal en: std_logic;

	signal counterNext: std_logic_vector(3 downto 0):="0100";


begin

	syn_potmeter: process(clk)begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
--				state<=waitingfRisingEdge;	
			else
				state<=nextState;
				counter<=counterNext;
			end if;
			
			
		end if;
	end if;
	end process;

	com_potmeter: process(syncha, synchb, state)begin

		case state is		
			when waitingRisingEdge=>
				if(synchb='0')then
					edge_up <='0';
					edge_do<='0';
					nextState<=waitingRisingEdge;	
				elsif(synchb='1')then
					edge_up <='0';
					edge_do<='0';
					previousState<=waitingRisingEdge;
					nextState<=sendPulse;
				end if;
			when waitingFallingEdge=>
				if(synchb='1')then
					edge_do<='0';
					edge_up<='0';
					nextState<=waitingFallingEdge;				
				elsif(synchb='0')then
					edge_up<='0';
					edge_do<='0';
					previousState<=waitingFallingEdge;
					nextState<=sendPulse;
				end if;
			when sendPulse =>
				if(previousState=waitingRisingEdge)then
					edge_up<='1';
					zIn<=(syncha and synchb);
					edge_do<='0';
					nextState<=waitingFallingEdge;

				elsif(previousState=waitingFallingEdge)then
					edge_up<='0';
					edge_do<='1';
					nextState<=waitingRisingEdge;					
				end if;
			when others =>
		end case;
		case zIn is
			when '0'=>
				en<=edge_do;	
			when '1'=>
				en<=edge_up;	
			when others=>
		end case;
	if(zIn='1')then
		if(en='1')then
			if(counterNext="1001")then
				counterNext<="0000";
			else
				counterNext<=counterNext+"0001";
			end if;
		end if;
	else
		if(en='1')then
			if(counterNext="0000")then
				counterNext<="1001";
			else	
				counterNext<=counterNext-"0001";
			end if;

		end if;
	end if;

	end process;

end Behavioral;
