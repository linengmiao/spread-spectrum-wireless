library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity dpllTB is
end entity;

 architecture structural of dpllTB is
component dpll
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;
	sdi_spread: in std_logic;

	semaphoreAOut: out std_logic;
	chip_sample: out std_logic_vector(2 downto 0)
);
end component;

for uut : dpll use entity work.dpll(Behavioral);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal resetTB: std_logic:='0';
signal clkEnable:std_logic:='1';

signal sdi_spreadTB: std_logic;
signal chipSampleTB: std_logic_vector(2 downto 0);
signal semaphoreAOutTB:std_logic;


begin


	uut: dpll PORT MAP(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>resetTB,

	sdi_spread=>sdi_spreadTB,
	semaphoreAOut=>semaphoreAOutTB,
	chip_sample=>chipSampleTB
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
   procedure tbvector(constant stimulus : in std_logic)is
     begin
	sdi_spreadTB<=stimulus;
	
       wait for period;
   end tbvector;
   BEGIN
 

	for j in 0 to 4 loop
 tbvector('0');
 tbvector('0');

		for i in 0 to 16 loop
			 tbvector('0'); 
		end loop;
		for i in 0 to 16 loop
			 tbvector('1'); 
		end loop;

	

	end loop;


      end_of_sim <= true;
      wait;

   END PROCESS;
END;
