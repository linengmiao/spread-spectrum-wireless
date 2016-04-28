library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity accessLayerTB is
end accessLayerTB;

architecture structural of accessLayerTB is
component accessLayer
port (
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;

	sdo_posenc:in std_logic;
	sw:in std_logic_vector(1 downto 0);

	dbgPort: out std_logic;

	pn_start:out std_logic;
	baseband:out std_logic
);
end component;


for uut : accessLayer use entity work.accessLayer(Behavioral);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clkEnable: std_logic:='1';

signal clk: std_logic;
signal reset: std_logic:='0';

signal sdo_posencTB: std_logic;
signal pn_startTB:std_logic;
signal basebandTB: std_logic;

signal swTB:std_logic_vector(1 downto 0);

signal dbgPortSig: std_logic;

begin


uut:accessLayer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,

	sdo_posenc=>sdo_posencTB,
	sw=>swTB,

	pn_start=>pn_startTB,
	dbgPort=>dbgPortSig,

	baseband=>basebandTB
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
   procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0))is
     begin
      sdo_posencTB <= stimvect(2);
      swTB(1) <= stimvect(1);
      swTB(0) <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN
	--data sw sw
	for i in 0 to 20 loop
	  tbvector("000");
	  for j in 0 to 5  loop
		tbvector("100"); 
	  end loop;
	end loop; 
 
	for i in 0 to 20 loop
	  tbvector("001");
	  for j in 0 to 5  loop
		tbvector("101"); 
	  end loop;
	end loop; 

	for i in 0 to 20 loop
	  tbvector("010");
	  for j in 0 to 5  loop
		tbvector("110"); 
	  end loop;
	end loop; 

	for i in 0 to 20 loop
	  tbvector("011");
	  for j in 0 to 5  loop
		tbvector("111"); 
	  end loop;
	end loop; 



      end_of_sim <= true;
      wait;

   END PROCESS;
END;