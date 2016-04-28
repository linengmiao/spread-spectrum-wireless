library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;
--use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity transSeqDec is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	extb: in std_logic;
	
	semaphoreAOut: out std_logic;
	chipSample: out std_logic_vector(2 downto 0)

);
end transSeqDec;


architecture Behavioral of transSeqDec is

--procedures and function
--procedure setSegments (signal counter: integer);
--function calculatePreload(signal segAE: std_logic_vector(4 downto 0)) return integer;

-------------------------------------------------------------------------------------------------------------------------------

TYPE STATE_TYPE IS (NCODecr,NCODecr2, countBoth,countIncr, setSemA, setSemEChip);

--general
signal state: STATE_TYPE:=NCODecr;
signal nextState: STATE_TYPE;

--right
signal preloadValue: integer:=15;
constant preloadValueCte: integer:=15;
signal NCOCounter: integer range 0 to 19:=15;
signal NCOCounterNext: integer range 0 to 19:=15;
signal chipSampleDelay: integer:=0;

--left
signal counter: integer:=0;
signal segAE: std_logic_vector(4 downto 0);

--semaphore
signal semE: bit:='0';
signal semA: bit:='0';


begin
	syn_transSegDet : process(clk)begin
			if(clkEnable='1')then
				if(rising_edge(clk))then
					if(reset='1')then
						NCOCounter<=0;					
					else 
						NCOCounter<=NCOCounterNext;
						state<=nextState;
					end if;
				end if;
			end if;	
	end process;

	com_transSegDet:process(state, extb,NCOCounter)is

--------------------------------------------------------------------------------------------------------------------------
-- This procedure outputs the counter's value on the seg lines
--
	procedure setSegments (signal counter: integer) is
	begin
		segAE<=std_logic_vector(to_unsigned(counter,5));
	end procedure setSegments;

	function calculatePreload(signal segAE: std_logic_vector(4 downto 0))return integer is
	begin
		if((segAE>="00000")and(segAE<="00100"))then return 3;
			elsif ((segAE>="00101")and(segAE<="00110"))then return 1;
			elsif ((segAE>="00111")and(segAE<="01000"))then return 0;
			elsif ((segAE>="01001")and(segAE<="01010"))then return -1;
			else return -3;
		end if;

	end calculatePreload;
----------------------------------------------------------------------------------------------------------------

begin	
		
		--indien extbpuls => sowieso countBoth state 
		if(extb='1')then
			semA<='1';
			nextState<=countBoth;
			counter<=0;
		else
			case state is
				when countBoth=>
					setSegments(counter);
					counter<=counter+1;
					--set segA untill segE lines every time via subroutine
				when others=>
					counter<=0;
			end case;
		end if;

		--ncoCOunter blijft altijd lopen in de achtergrond	
		if(NCOCounterNext>0)then
			NCOCounterNext<=NCOcounter-1;
		end if;

		if(counter=15)then
			counter<=0;
			semA<='1';
			if(semE='1')then
				--set preload Value
				--preloadValue<=15;
				NCOCounterNext<=preloadValueCte + calculatePreload(segAE);
				--preloadValue<=preloadValueCte + calculatePreload(segAE);
				semA<='0';
				semE<='0';
			end if;
		end if;	
		
		if(NCOCounterNext=0)then
			--NCOCounterNext<=preloadValue;	
			semE<='1';
			if(semA='1')then
				--set preload Value
				--preloadValue<=15;
				NCOCounterNext<=preloadValueCte + calculatePreload(segAE);
				--preloadValue<=preloadValueCte + calculatePreload(segAE);
				semA<='0';
				semE<='0';
			end if;
			chipSample(0)<='1';
			chipSample(1)<='0';
			chipSample(2)<='0';
			chipSampleDelay<=1;
		end if;
		if(chipSampleDelay=1)then
			chipSample(0)<='0';
			chipSample(1)<='1';
			chipSample(2)<='0';
			chipSampleDelay<=2;
		elsif(chipSampleDelay=2)then
			chipSample(0)<='0';
			chipSample(1)<='0';
			chipSample(2)<='1';
			chipSampleDelay<=3;
		elsif(chipSampleDelay=3)then
			chipSample(0)<='0';
			chipSample(1)<='0';
			chipSample(2)<='0';
		end if;
		
	end process;
end;



