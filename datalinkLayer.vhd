library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datalinkLayer is
port(
	clk: in std_logic;
	clkEnable: in std_logic;
	reset: in std_logic;

	pn_start: in std_logic;
	data: in std_logic_vector(3 downto 0);
	sdo_posenc: out std_logic

);
end datalinkLayer;

architecture behavioral of datalinkLayer is

component sequenceController is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	pn_start:in std_logic;
	ld:out std_logic;
	sh:out std_logic
);
end component;


component dataregister is
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

signal ldSig: std_logic;
signal shSig: std_logic;
begin

sequenceControllerSystem:sequenceController
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	pn_start=> pn_start,
	ld=>ldSig,
	sh=>shSig
);	

dataregisterSystem: dataregister
port map(
	clk=> clk,
	clkEnable=> clkEnable,
	reset=>reset,
	ld=>ldSig,
	sh=>shSig,
	data=>data,
	sdo_posenc=>sdo_posenc

);



end behavioral;
