library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity zender is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	up: in std_logic;
	down: in std_logic;
	muxSw: in std_logic_vector(1 downto 0);
	tx: out std_logic
);
end zender;


architecture Behavioral of zender is

component appLayer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	btnUp: in std_logic;
	btnDown: in std_logic;
	data: out std_logic_vector(3 downto 0)
);
end component appLayer;


component datalinkLayer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	pn_start: in std_logic;
	data: in std_logic_vector(3 downto 0);
	sdo_posenc: out std_logic
);
end component datalinkLayer;

component accessLayer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;

	sdo_posenc:in std_logic;
	sw:in std_logic_vector(1 downto 0);

	pn_start:out std_logic;
	baseband:out std_logic
);
end component accessLayer;

signal dataSig: std_logic_vector(3 downto 0);
signal pn_startSig:std_logic;
signal sdo_posencSig:std_logic;

begin

appLayerSyst:appLayer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	btnUp=>up,
	btnDown=>down,
	data=>dataSig
);

datalinkLayerSyst:datalinkLayer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	pn_start=>pn_startSig,
	data=>dataSig,
	sdo_posenc=>sdo_posencSig
);

accessLayerSyst:accessLayer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,

	sdo_posenc=>sdo_posencSig,
	sw=>muxSw,

	pn_start=>pn_startSig,
	baseband=>tx
);


end Behavioral;