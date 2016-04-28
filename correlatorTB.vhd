---------- MIJN COUNTERTB

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity correlatorTB is
end correlatorTB;

architecture structural of correlatorTB is
component correlator
port (
	clk: in std_logic;
	clk_enable: in std_logic;
	reset: in std_logic;

	chip_sample2: in std_logic;
	bit_sample: in std_logic;
	databit: out std_logic
);
end component;

for uut : correlator use entity work.correlator(Behavioral);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal clk_enable:std_logic:='1';
signal reset: std_logic:='0';

signal chip_sample2TB: std_logic;
signal bit_sampleTB:std_logic;
signal databitTB:std_logic;

begin

	uut: correlator PORT MAP(
		clk=>clk,
		clk_enable=>clk_enable,
		reset=>reset,
	
		chip_sample2=>chip_sample2TB,
		bit_sample=>bit_sampleTB,
		databit=>databitTB
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
---------------------------------------------------------------------------------

tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
	chip_sample2TB<=stimvect(0);
	bit_sampleTB<=stimvect(1);
       wait for period;
   end tbvector;
   BEGIN

		tbvector("00");
		tbvector("00");
		tbvector("00");
	for i in 0 to 3 loop
		tbvector("10");
		for j in 0 to 31 loop
			tbvector("01");
		end loop;
	end loop;
      end_of_sim <= true;
      wait;
   END PROCESS;

END;
