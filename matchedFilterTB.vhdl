library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity matchedFilterTB is
end entity;

architecture structural of matchedFilterTB is
component matchedFilter 
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	chip_sample: in std_logic;
	sdi_spread: in std_logic;
	sw: in std_logic_vector(1 downto 0);
	
	seq_det: out std_logic
);
end component;


for uut: matchedFilter use entity work.matchedFilter(Behavioral);


constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:std_logic;
signal clkEnable:std_logic:='1';
signal reset: std_logic;
signal chip_sampleSig: std_logic;
signal sdi_spreadSig: std_logic;
signal swSig: std_logic_vector(1 downto 0);
signal seq_det: std_logic;


begin

	uut:matchedFilter
	port map(
		clk=>clk,
		clkEnable=>clkEnable,
		reset=>reset,
		chip_sample=>chip_sampleSig,
		sdi_spread=>sdi_spreadSig,
		sw=>swSig,

		seq_det=>seq_det
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
   procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0))is
     begin
		swSig(0)<=stimvect(0);
		swSig(1)<=stimvect(1);
		chip_sampleSig<=stimvect(2);
		sdi_spreadSig<=stimvect(3);
      
	

       wait for period/2;
   end tbvector;
   BEGIN

	tbvector("0000");
	tbvector("0000");
	tbvector("0000");
	tbvector("0000");
	tbvector("1100");	
	tbvector("0000");
	tbvector("0000");
	tbvector("0000");
	end process;
end;
