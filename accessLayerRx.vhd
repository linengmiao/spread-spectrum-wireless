library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accessLayer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;

	rx:in std_logic;
	sw:in std_logic_vector(1 downto 0);

	databit:out std_logic;

	bit_sample:out std_logic
);
end accessLayer;

architecture Behavioral of accessLayer is
	

component dpll is
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;
	sdi_spread: in std_logic;

	semaphoreAOut: out std_logic;
	chip_sample: out std_logic_vector(2 downto 0)
);
end component dpll;


component matchedFilter is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	chip_sample: in std_logic;
	sdi_spread: in std_logic;
	sw: in std_logic_vector(1 downto 0);
	
	seq_det: out std_logic

);
end component matchedFilter;

component PNBitNCO is
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
end component PNBitNCO;

component correlator is
port(
	clk: in std_logic;
	clk_enable: in std_logic;
	reset: in std_logic;

	chip_sample2: in std_logic;
	bit_sample: in std_logic;
	databit: out std_logic
);
end component correlator;

signal semaphoreAOutConn: std_logic;
signal chipSampleMF: std_logic;
signal chipSampleCorr: std_logic;
signal bit_sampleSig:std_logic;

signal chip_sample1Sig: std_logic;

--MUX links beneden
signal muxin1: std_logic;
signal muxin2: std_logic;
signal seq_det:std_logic;

signal pn_ml1Sig: std_logic;
signal pn_ml2Sig: std_logic;
signal pn_goldSig: std_logic;

--XOR rechts beneden
signal pn_seq: std_logic;
signal despredXOR: std_logic;

--MUX midden rechts
signal sdi_despread:std_logic;

begin

dpllSyst:dpll
port map(

	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	sdi_spread=>rx,

	semaphoreAOut=>muxin1,
	chip_sample(0)=>chipSampleMF,
	chip_sample(1)=>chip_sample1Sig,
	chip_sample(2)=>chipSampleCorr
);
-----------------------------------------------------------------------------

matchedFilterSyst:matchedFilter
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	chip_sample=>chipSampleMF,
	sdi_spread=>rx,
	sw=>sw,
	seq_det=>muxin2

);
-----------------------------------------------------------------------------


PNBitNCOSyst:PNBitNCO
port map(
	clk=>clk,
	clk_enable=>clkEnable,
	seq_det=>seq_det,
	full_seq=>bit_sampleSig,

	chip_sample1=>chip_sample1Sig,
	
	pn_ml1=>pn_ml1Sig,
	pn_ml2=>pn_ml2Sig,
	pn_gold=>pn_goldSig
);

-----------------------------------------------------------------------------

correlatorSyst:correlator
port map(
	clk=>clk,
	clk_enable=>clkEnable,
	reset=>reset,

	chip_sample2=>chipSampleCorr,
	bit_sample=>bit_sampleSig,
	databit=>databit
);

--process(clk)is
--begin
--	if(clkEnable='1')then
--		if(rising_edge(clk))then
--			if(reset='1')then
--				
--			else
--		
--				state<=nextState;
--			end if;
--
--		end if;
--	end if;
--end process;
--
process(sw, rx) is
begin
	despredXOR<=pn_seq xor rx;
	case(sw)is
		when "00"=>
			seq_det<=muxin1;
			pn_seq<=pn_ml1Sig;
			sdi_despread<=despredXOR;
		when "01"=>
			seq_det<=muxin2;
			pn_seq<=pn_ml2Sig;
			sdi_despread<=rx;			
		when "10"=>
			pn_seq<=pn_goldSig;
--		when "11"=>
		when others=>
	end case;
--
end process;
end;