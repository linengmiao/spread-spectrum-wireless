library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity debouncerTB is
end entity;

 architecture structural of debouncerTB is
component debouncer
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset: in std_logic;
	inputBtn: in std_logic;
	outputBtn: out std_logic

);
end component;

for uut : debouncer use entity work.debouncer(behav);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal reset: std_logic:='0';
signal inputTB: std_logic:='0';
signal outputTB: std_logic:='0';

signal clkEnableSig:std_logic:='1';

begin

	uut: debouncer PORT MAP(
	      clk => clk,
	      clkEnable=>clkEnableSig,
	      reset=>reset,
	      inputBtn=>inputTB,
	      outputBtn=>outputTB

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
	--wait for period; --anders stijgt de btn van mijn flank bij een stijgende klokflank, mag niet
      inputTB <= stimvect;
   
       wait for period/2;
   end tbvector;
   BEGIN

--	for i in 0 to 3 loop
--		for j in 0 to 5 loop
--			tbvector('0');
--		end loop;
--
--		for j in 0 to 2 loop
--			tbvector('1');
--		end loop;
--
--		for j in 0 to 5 loop
--			tbvector('0');
--		end loop;
--	end loop;


		for j in 0 to 15 loop
			tbvector('0');
		end loop;

		for j in 0 to 15 loop
			tbvector('1');
		end loop;

		for j in 0 to 15 loop
			tbvector('0');
		end loop;

		for j in 0 to 15 loop
			tbvector('1');
		end loop;


      end_of_sim <= true;
      wait;
   END PROCESS;

END;



