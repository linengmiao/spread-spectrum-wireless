library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity transDetectTB is
end entity;

 architecture structural of transDetectTB is
component transDetect
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	sdi_spread: in std_logic;
	extb: out std_logic
);
end component;

for uut : transDetect use entity work.transDetect(Behavioral);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal resetTB: std_logic:='0';
signal clkEnable:std_logic:='1';
signal sdi_spreadTB: std_logic:='0';
signal extbTB: std_logic:='0';

begin

	uut: transDetect PORT MAP(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>resetTB,
	sdi_spread=>sdi_spreadTB,
	extb=>extbTB

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
	   sdi_spreadTB<= stimvect;
       wait for period/2;
   end tbvector;
   BEGIN

for i in 0 to 4 loop
	for j in 0 to 10 loop
		tbvector('0'); 
	end loop;
	
	for j in 0 to 10 loop
		 tbvector('1'); 
	end loop;

end loop;

	end_of_sim <= true;

end process;
END;


