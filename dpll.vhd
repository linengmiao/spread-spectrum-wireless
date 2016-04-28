library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity dpll is 
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;
	sdi_spread: in std_logic;

	semaphoreAOut: out std_logic;
	chip_sample: out std_logic_vector(2 downto 0)
);
end dpll;

architecture behavioral of dpll is

component transDetect is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	sdi_spread: in std_logic;
	extb: out std_logic
	
);
end component transDetect;

component transSeqDec is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	extb: in std_logic;

	semaphoreAOut: out std_logic;
	chip_sample: out std_logic_vector(2 downto 0)

);
end component transSeqDec;

signal extbSig: std_logic;

begin

transSeqDecSystem: transSeqDec
port map(
	clk=>clk,
	clkEnable=>clkEnable,

	reset=>reset,
	extb=>extbSig,
	chip_sample=>chip_sample,
	semaphoreAOut=>semaphoreAOut	

);

transDetectSystem: transDetect
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	sdi_spread=>sdi_spread,
	extb=>extbSig
	
);


end behavioral;