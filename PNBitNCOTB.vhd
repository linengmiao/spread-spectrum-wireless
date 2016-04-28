library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PNBitNCOTB is
end entity;

architecture structural of PNBitNCOTB is
component PNBitNCO 
port(
	clk: in std_logic;
	clk_enable: in std_logic;
	seq_det: in std_logic;
	full_seq: out std_logic;
	
	chip_sample1: in std_logic;

	pn_ml1:out std_logic;
	pn_ml2:out std_logic;
	pn_gold: out std_logic
);
end component;


for uut: PNBitNCO use entity work.PNBitNCO(Behavioral);

constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:std_logic;
signal clkEnable:std_logic:='1';
signal reset: std_logic;

signal seq_detSig: std_logic;
signal chip_sampleSig: std_logic;
signal full_seqSig: std_logic;
signal pn_ml1Sig:std_logic;
signal pn_ml2Sig:std_logic; 
signal pn_goldSig:std_logic;

signal chip_sample1Sig: std_logic;

begin

	uut:PNBitNCO
	port map(
	clk=>clk,
	clk_enable=>clkEnable,
	seq_det=>seq_detSig,
	full_seq=>full_seqSig,

	chip_sample1=>chip_sample1Sig,
	
	pn_ml1=>pn_ml1Sig,
	pn_ml2=>pn_ml2Sig,
	pn_gold=>pn_goldSig
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
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
	seq_detSig<=stimvect(0);
	chip_sample1Sig<=stimvect(1);
       wait for period/2;
   end tbvector;
   BEGIN

	tbvector("10");
	end process;
end;

