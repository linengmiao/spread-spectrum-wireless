library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity zenderTB is
end zenderTB;

architecture structural of zenderTB is
component zender
port (
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	up: in std_logic;
	down: in std_logic;
	muxSw: in std_logic_vector(1 downto 0);
	tx: out std_logic
);

end component;


for uut : zender use entity work.zender(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clkEnable: std_logic:='1';

signal clk: std_logic;
signal reset: std_logic:='0';
signal upTB:std_logic;
signal downTB:std_logic;
signal muxSwTB: std_logic_vector(1 downto 0);
signal tx:std_logic;

begin

uut:zender
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	up=>upTB,
	down=>downTB,
	muxSw=>muxSwTB,
	tx=>tx
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
-------------------------------------------------------------------------------------------------
tb : PROCESS
   procedure tbvector(constant swStim : in std_logic_vector(3 downto 0))is
--		      constant stimvect : in std_logic_vector(4 downto 0)
     begin
	muxSwTB(0)<= swStim(0);
	muxSwTB(1)<= swStim(1);
	upTB<=swStim(2);
	downTB<=swStim(3);
	
       wait for period;
   end tbvector;
   BEGIN
	  for j in 0 to 25  loop
		  tbvector("0100"); 
		  tbvector("0000"); 
	  end loop;



      end_of_sim <= true;
      wait;

   END PROCESS;
END;


