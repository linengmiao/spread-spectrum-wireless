library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataregisterTB is
end entity;

 architecture structural of dataregisterTB is
component dataregister
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	ld:in std_logic;
	sh:in std_logic;
	data:in std_logic_vector(3 downto 0);
	sdo_posenc:out std_logic
);
end component;

for uut : dataregister use entity work.dataregister(behav);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clkSig: std_logic;
signal clkEnableTB:std_logic:='1';
signal resetTB:std_logic:='0';
signal ldInTB: std_logic:='1';
signal shInTB: std_logic:='0';
signal dataInTB: std_logic_vector(3 downto 0);
signal sdo_posencTB: std_logic;


begin

	uut: dataregister PORT MAP(
		clk=>clkSig,
		clkEnable=>clkEnableTB,
		reset=>resetTB,
		ld=>ldInTb,
		sh=>shInTB,
		data=>dataInTB,
		sdo_posenc=>sdo_posencTB
	);	

-------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------

tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic_vector(5 downto 0))is
     begin
	dataInTB<=stimvect(3 downto 0);
	ldInTB<=stimvect(4);
	shInTB<=stimvect(5);
       wait for period;
   end tbvector;
   BEGIN
	-- shift, load, data
	 tbvector("010000");
	 tbvector("011000");
	for i in 0 to 20 loop
		tbvector("100000");
		tbvector("000000");
	end loop;

      end_of_sim <= true;
	wait;
   END PROCESS;

end;