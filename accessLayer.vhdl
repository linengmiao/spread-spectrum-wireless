library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accessLayer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;

	sdo_posenc:in std_logic;
	sw:in std_logic_vector(1 downto 0);

	dbgPort:out std_logic;

	pn_start:out std_logic;
	baseband:out std_logic
);
end accessLayer;

architecture Behavioral of accessLayer is

component PN_generator is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	pn_ml1:out std_logic;
	pn_ml2:out std_logic;
	pn_gold:out std_logic;
	pn_start:out std_logic;

	reset: in std_logic
);
end component PN_generator;

signal pn_ml1Sig: std_logic;
signal pn_ml2Sig: std_logic:='0';
signal pn_goldSig: std_logic;
signal xorOut1Sig: std_logic;
signal xorOut2Sig: std_logic;
signal xorOut3Sig: std_logic;
signal sdo_spread: std_logic;
signal pn_startSig:std_logic:='0';

signal hulpSig: std_logic_vector(1 downto 0):="00";

begin

PN_genSyst:PN_generator
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	pn_ml1=>pn_ml1Sig,
	pn_ml2=>pn_ml2Sig,
	pn_gold=>pn_goldSig,
	pn_start=>pn_startSig,
	reset=>reset
);
-----------------------------------------------------------------------------
	process(clk)begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
			end if;
			
			xorOut1Sig <= sdo_posenc xor(pn_ml1Sig);
			xorOut2Sig <= sdo_posenc xor(pn_goldSig);
			xorOut3Sig <= sdo_posenc xor(pn_ml2Sig);
	
			baseband<=sdo_spread;
		
		case(sw)is
			when "00"=>
				sdo_spread<=sdo_posenc;
			when "01"=>
				sdo_spread<=xorOut1Sig;
						
			when "10"=>sdo_spread<=xorOut2Sig;
			when "11"=>sdo_spread<=xorOut3Sig;
			
			--om maar iets te kennen. Is dit OK?
			when others=>sdo_spread<=xorOut1Sig;
		end case;

		end if;
	end if;
	end process;

--------------------------------------------------
-- Bij elke nieuwe input bit wordt het onderstaande process uitgevoerd
-- Er komt pas een nieuwe bit na 32 shiften vh ...register
-- is dus OK
--------------------------------------------------
pn_start<=pn_startSig;

--	process(sw,sdo_posenc)begin 
--		case(sw)is
--			when "00"=>hulpSig<="00";
--			when "01"=>hulpSig<="01";
--			when "10"=>hulpSig<="10";
--			when "11"=>hulpSig<="11";
--			
--			--om maar iets te kennen. Is dit OK?
--			when others=>hulpSig<="00";
--		end case;
--
--	end process;
end Behavioral;