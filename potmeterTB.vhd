
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.ALL;

entity potmeterTB is
end entity;

architecture structural of potmeterTB is
component potmeter 
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	syncha: in std_logic;
	synchb: in std_logic;
	counter: out std_logic_vector(3 downto 0)
);
end component;


for uut : potmeter use entity work.potmeter(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clk_enable: std_logic:='1';
signal clk: std_logic;
signal reset: std_logic:='0';

signal synchATB: std_logic;
signal synchBTB: std_logic;
signal edgeUpTB: std_logic;
signal edgeDownTB:std_logic;

signal counterSig: std_logic_vector(3 downto 0);

begin

uut:potmeter
port map(
	clk=>clk,
	clkEnable=>clk_enable,
	reset=>reset,
	syncha=>synchATB,
	synchb=>synchBTB,
	counter=> counterSig
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
   procedure tbvector(constant stimulus : in std_logic_vector(1 downto 0))is
    begin
	synchATB<=stimulus(0);
	synchBTB<=stimulus(1);
       wait for period;
   end tbvector;
   BEGIN

	tbvector("00");
	tbvector("00");
	tbvector("00");
	tbvector("10");
	tbvector("11");
	tbvector("11");
	tbvector("01");
	tbvector("00");
	tbvector("10");
	tbvector("11");
	tbvector("11");
	tbvector("01");
	tbvector("00");
	tbvector("10");
	tbvector("11");
	tbvector("11");
	tbvector("01");
	tbvector("00");
	tbvector("10");
	tbvector("11");
	tbvector("11");
	tbvector("11");
	tbvector("11");

      end_of_sim <= true;
      wait;

   END PROCESS;
END;

