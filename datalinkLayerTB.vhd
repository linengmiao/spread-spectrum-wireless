library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datalinkLayerTB is
end datalinkLayerTB;

architecture structural of datalinkLayerTB is
component datalinkLayer
port (
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;

	pn_start: in std_logic;
	data: in std_logic_vector(3 downto 0);
	sdo_posenc: out std_logic
);
end component;

for uut : datalinkLayer use entity work.datalinkLayer(behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk: std_logic;
signal reset: std_logic:='0';
signal clkEnableSig: std_logic:='1';

signal pn_startTB: std_logic;
signal sdo_posencTB: std_logic;
signal dataTB: std_logic_vector(3 downto 0);

begin

	uut: datalinkLayer PORT MAP(
	      clk => clk,
	      clkEnable=>clkEnableSig,
	      reset => reset,
	
		pn_start=>pn_startTB,
		data=>dataTB,
		sdo_posenc=> sdo_posencTB
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
   procedure tbvector(constant stimvect : in std_logic_vector(4 downto 0))is
     begin
	if(stimvect(3 downto 0) /= "0000")then
		dataTB<=stimvect(3 downto 0);
	end if;
	
		pn_startTB<=stimvect(4);
       wait for period;
   end tbvector;
   BEGIN

  tbvector("10101"); --laad data

--shift data
	for i in 0 to 25 loop
	  tbvector("10000");  
	  tbvector("00000");  
	end loop; 



      end_of_sim <= true;
      wait;
   END PROCESS;
end;