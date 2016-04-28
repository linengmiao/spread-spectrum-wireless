---------- MIJN COUNTERTB

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use std.textio.ALL;
use ieee.std_logic_arith;

entity counterTB is
end counterTB;

architecture structural of counterTB is
component counter
port (
	clk: in std_logic;
	clkEnable:in std_logic;
	btnUp: in std_logic;
	btnDown: in std_logic;
	reset: in std_logic;
	countOut: out std_logic_vector(3 downto 0)
);
end component;

for uut : counter use entity work.counter(behav);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal reset: std_logic:='0';
signal up: std_logic;
signal down: std_logic;
signal countOut:std_logic_vector(3 downto 0);
signal clkEnableSig:std_logic:='1';

signal countSig: std_logic_vector(3 downto 0);

begin

	uut: counter PORT MAP(
      clk => clk,
      clkEnable=>clkEnableSig,
      reset => reset,
      btnUp => up,
      btnDown => down,
      countOut => countOut
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

tb : PROCESS is
	FILE tvo_file: text open write_mode is "C:\Users\Yalishand\Desktop\school\schakeljaar\digitale synthese\testbenchFiles\counter.txt";
	variable L: line;

   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
      up <= stimvect(1);
      down <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN

-- knop ingedrukt blijven houden, mag niet incrementen
for i in 0 to 3 loop
	tbvector("01");

end loop;

for i in 0 to 9 loop
	tbvector("10");
	tbvector("00");
	write(L, STRING'("up "));
	write(L, integer'image(i));
	write(L, ' ');
	write(L,conv_integer(countOut), left,0);
	writeline(tvo_file,L);
end loop;

for i in 0 to 7 loop
	tbvector("10");
end loop;


      end_of_sim <= true;
      wait;
   END PROCESS;

END;