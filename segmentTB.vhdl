library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity segmentTB is
end entity;

 architecture structural of segmentTB is
component segment
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	-- is het common anode of common cathode?
	anode: out std_logic;
	input: in std_logic_vector(3 downto 0);
	segmentDisp: out std_logic_vector(7 downto 0)
);
end component;

for uut : segment use entity work.segment(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clkSig: std_logic;
signal resetSig: std_logic:='0';
signal anodeSig: std_logic;
signal inputSig: std_logic_vector (3 downto 0);
signal segmentDispSig: std_logic_vector (7 downto 0);

signal clkEnableSig:std_logic:='1';

begin

	uut: segment PORT MAP(
	      clk => clkSig,
	      clkEnable=>clkEnableSig,
	      reset=>resetSig,
	      anode=>anodeSig,
	      input=>inputSig,
	      segmentDisp=>segmentDispSig
	);	
--------------------------------------------------------------------------------------
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
   procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
     begin
	inputSig<=stimvect;
       wait for period;
   end tbvector;
   BEGIN
--
       tbvector("0100");
       tbvector("1100");
      end_of_sim <= true;
	wait;
   END PROCESS;

END;
