library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datalinkLayerRxTB is
end entity;

architecture structural of datalinkLayerRxTB is

component datalinkLayerRx
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;

	preambleOut: out std_logic_vector(6 downto 0);
	latchOut: out std_logic_vector(3 downto 0);

	databit: in std_logic;
	bit_sample: in std_logic
);
end component;


for uut : datalinkLayerRx use entity work.datalinkLayerRx(behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clkSig: std_logic;
signal clkEnableTB:std_logic:='1';
signal resetTB:std_logic:='0';
signal databitTB: std_logic;
signal bit_sampleTB: std_logic;

signal preambleOutTB: std_logic_vector(6 downto 0);
signal latchOutTB: std_logic_vector(3 downto 0);

begin

	uut: datalinkLayerRx PORT MAP(
		clk=>clkSig,
		clkEnable=>clkEnableTB,
		reset=>resetTB,
	
		preambleOut=>preambleOutTB,
		latchOut=>latchOutTB,
	
		databit=>databitTB,
		bit_sample=>bit_sampleTB
	);	

-------------------------------------------------------------------------------

clock : process
   begin 
       clkSig <= '0';
       wait for period/2;
     loop
       clkSig <= '0';
       wait for period/2;
       clkSig <= '1';
       wait for period/2;
        if(end_of_sim = true)then
		exit;
	end if;
     end loop;
     wait;
   end process clock;

---------------------------------------------------------------------------------------------------------

tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin	
		bit_sampleTB<=stimvect(0);
		databitTB<=stimvect(1);
       wait for period;
   end tbvector;
   BEGIN

	 tbvector("01");
	 tbvector("01");
	 tbvector("01");
	 tbvector("11");
	 tbvector("01");
	 tbvector("11");
	 tbvector("01");
   END PROCESS;

end;