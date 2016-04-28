library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ontvanger is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	baseband: in std_logic;
	sw: in std_logic_vector(1 downto 0);
	sevenSeg: out std_logic_vector(3 downto 0)
	
);
end ontvanger;


architecture behavioral of datalinkLayer is

component accessLayerRx is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;

	rx:in std_logic;
	sw:in std_logic_vector(1 downto 0);

	databit:out std_logic;

	bit_sample:out std_logic
);
end component;

component datalinkLayerRx is
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;

	preambleOut: out std_logic_vector(6 downto 0);
	latchOut: out std_logic_vector(3 downto 0);

	databit: in std_logic;
	bit_sample: in std_logic
);
end component;

component datalatch is
port(
	clk: in std_logic;
	clk_enable: in std_logic;
	reset: in std_logic;

	preambleIn: in std_logic_vector(6 downto 0);
	latchIn: in std_logic_vector(3 downto 0);

	sevSeg: out std_logic_vector(3 downto 0)

);
end component;

--accessLayer
signal rxSig: std_logic;
signal swSig: std_logic_vector(1 downto 0);
signal databitSig: std_logic;
signal bit_sampleSig: std_logic;

--datalink layer
signal preambleSig: std_logic_vector(6 downto 0);
signal latchSig: std_logic_vector(3 downto 0);

--applicationLayer
signal sevenSegSig: std_logic_vector(3 downto 0);

begin

accessLayerRxSyst:accessLayerRx
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	rx=>rxSig,
	sw=>swSig,

	databit=>databitSig,

	bit_sample=>bit_sampleSig
);


datalinkLayerSyst:datalinkLayerRx
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,

	preambleOut=>preambleSig,
	latchOut=>latchSig,

	databit=>databitSig,
	bit_sample=>bit_sampleSig
);


datalatchSyst:datalatch
port map(
	clk=>clk,
	clk_enable=>clkEnable,
	reset=>reset,

	preambleIn=>preambleSig,
	latchIn=>latchSig,

	sevSeg=>sevenSegSig
);

--sevenSeg<=sevenSegSig;
--swSig<=sw;
--rxSig<=baseband;
--
end;

