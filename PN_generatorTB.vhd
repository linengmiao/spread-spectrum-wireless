library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PN_generatorTB is
end entity;

architecture structural of PN_generatorTB is
component PN_generator 
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	pn_ml1:out std_logic;
	pn_ml2:out std_logic;
	pn_gold:out std_logic;
	pn_start:out std_logic;

	reset: in std_logic
);
end component;

for uut: PN_generator use entity work.PN_generator(Behavioral);


constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:std_logic;
signal clkEnable:std_logic:='1';
signal pn_ml1: std_logic;
signal pn_ml2: std_logic;
signal pn_gold: std_logic;
signal pn_start: std_logic;
signal reset:std_logic:='0';

begin

	uut:PN_generator
	port map(
		clk=>clk,
		clkEnable=>clkEnable,
		pn_ml1=>pn_ml1,
		pn_ml2=>pn_ml2,
		pn_gold=>pn_gold,
		pn_start=>pn_start,
		reset=>reset
	);

--------------------------------------------------------------------------------------
	clock : process
   begin 
       clk <= '0';
       wait for period/2;
     loop
       clk <= '0';
       wait for period/2;
       clk <= '1';
       wait for period/2;
       exit when end_of_sim;
     end loop;
     wait;
   end process clock;

--------------------------------------------------------------------------------------

tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic)is
     begin
      
   
       wait for period/2;
   end tbvector;
   BEGIN

for i in 0 to 74 loop

	tbvector('0');
end loop;


      end_of_sim <= true;

end process;
end;
