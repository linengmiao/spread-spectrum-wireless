library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity appLayerTB is
end appLayerTB;

architecture structural of appLayerTB is
component appLayer
port (
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	btnUp: in std_logic;
	btnDown: in std_logic;
	data: out std_logic_vector(3 downto 0)
);
end component;


for uut : appLayer use entity work.appLayer(Behavioral);

 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clkEnable: std_logic:='1';

signal clk: std_logic;
signal reset: std_logic:='0';

signal btnUpSig:std_logic;
signal btnDownSig:std_logic;
signal dataSig:std_logic_vector (3 downto 0);


begin


uut:appLayer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	btnUp=>btnUpSig,
	btnDown=>btnDownSig,
	data=>dataSig
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
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
      btnUpSig <= stimvect(1);
      btnDownSig <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN

  tbvector("00");  

  tbvector("10");
  tbvector("10");  
  tbvector("10");
  tbvector("10");  

  tbvector("00");  
  tbvector("00");  
  tbvector("00");  
  tbvector("00");  

  tbvector("10");
  tbvector("10");  
  tbvector("10");
  tbvector("10");  

  tbvector("00");  
  tbvector("00");  
  tbvector("00");  
  tbvector("00");  


  tbvector("10");
  tbvector("10");
  tbvector("10");
  tbvector("10");  

  tbvector("00");  
--
----counted up till 3
--

  tbvector("00");  

  tbvector("01");
  tbvector("01");  
  tbvector("01");
  tbvector("01");  

  tbvector("00");  
  tbvector("00");  
  tbvector("00");  
  tbvector("00");  


  tbvector("01");
  tbvector("01");  
  tbvector("01");
  tbvector("01");  

  tbvector("00");  
  tbvector("00");  
  tbvector("00");  
  tbvector("00");  


  tbvector("01");
  tbvector("01");  
  tbvector("01");
  tbvector("01");  

  tbvector("00");  
  tbvector("00");  
  tbvector("00");  
  tbvector("00");  

      end_of_sim <= true;
      wait;

   END PROCESS;
END;
