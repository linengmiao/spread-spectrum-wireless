library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sequenceControllerTB is
end entity;

 architecture structural of sequenceControllerTB is
component sequenceController
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	pn_start:in std_logic;
	ld:out std_logic;
	sh:out std_logic
);
end component;

for uut : sequenceController use entity work.sequenceController(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clkSig: std_logic;
signal clkEnableTB:std_logic:='1';
signal resetTB:std_logic:='0';
signal ldTB:std_logic:='0';
signal shTB:std_logic:='1';
signal pn_startTB:std_logic;


begin

	uut: sequenceController PORT MAP(
	clk=>clkSig,
	clkEnable=>clkEnableTB,
	reset=>resetTB,
	pn_start=>pn_startTB,
	ld=>ldTB,
	sh=>shTB
	);	

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

---------------------------------------------------------------------------------

tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic)is
     begin
	pn_startTB<=stimvect;
       wait for period;
   end tbvector;
   BEGIN

	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('0');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('0');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('1');
	 tbvector('0');
	 tbvector('0');

      end_of_sim <= true;
	wait;
   END PROCESS;

end;