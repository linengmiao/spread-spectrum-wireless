library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity edgeDetecterTB is
end entity;

 architecture structural of edgeDetecterTB is
component edgeDetecter
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	input: in std_logic;
	output: out std_logic
);
end component;

for uut : edgeDetecter use entity work.edgeDetecter(Behavioral);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal resetTB: std_logic:='0';
signal clkEnable:std_logic:='1';
signal inputTB: std_logic:='0';
signal outputTB: std_logic:='0';

begin

	uut: edgeDetecter PORT MAP(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>resetTB,
	input=>inputTB,
	output=>outputTB

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
	   inputTB<= stimvect;
       wait for period/2;
   end tbvector;
   BEGIN


	for i in 0 to 6 loop
		tbvector('0');
	end loop;

	for i in 0 to 6 loop
		tbvector('1');
	end loop;

	for i in 0 to 6 loop
		tbvector('0');
	end loop;

	for i in 0 to 6 loop
		tbvector('0');
	end loop;

	for i in 0 to 6 loop
		tbvector('1');
	end loop;

	for i in 0 to 6 loop
		tbvector('0');
	end loop;

      end_of_sim <= true;

end process;
END;


