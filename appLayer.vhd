library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity appLayer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	btnUp: in std_logic;
	btnDown: in std_logic;
	data: out std_logic_vector(3 downto 0)
);
end appLayer;

architecture Behavioral of appLayer is
------------------------------------------------------
-- Contains different components previously made:
-- counter, debouncer and segment driver
------------------------------------------------------

component counter is
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	btnUp: in std_logic;
	btnDown: in std_logic;
	reset: in std_logic;
	countOut: out std_logic_vector(3 downto 0)
);
end component counter;

component debouncer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset: in std_logic;
	inputBtn: in std_logic;
	outputBtn: out std_logic

);
end component debouncer;

component segment is 
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	-- is het common anode of common cathode?
	anode: out std_logic;
	input: in std_logic_vector(3 downto 0);
	segmentDisp: out std_logic_vector(7 downto 0)
);
end component segment;

--general signals
--signal clkSig:std_logic;
--signal resetSig:std_logic;


--debouncer DownBtn
signal inputBtnDownSig:std_logic;
signal debouncedDownSignal:std_logic;  --output


--debouncer UpBtn
signal inputBtnUpSig:std_logic;
signal debouncedUpSignal:std_logic;  --output


--updownCounter
--signal btnUpSig: std_logic; word vervangen door het debounced signal
--signal btnDownSig: std_logic; word vervangen door het debounced signal
signal	countOutSig: std_logic_vector(3 downto 0);

--segment driver
signal	anodeSig: std_logic;
signal	inputSig: std_logic_vector(3 downto 0);
signal	segmentDispSig: std_logic_vector(7 downto 0);


begin
----------------------------------------------------------------------------
-- verbind de verschillende componenten
----------------------------------------------------------------------------
debounceUpBtnSystem:debouncer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	inputBtn=>btnUp, --poort v deze topcomponent
	outputBtn=>debouncedUpSignal
);	


debounceDownBtnSystem:debouncer
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	inputBtn=>btnDown,  --poort v deze topcomponent
	outputBtn=>debouncedDownSignal
);	

---------------------------------------------------------------------------------------

counterSystem:counter
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	btnUp=>debouncedUpSignal,
	btnDown=>debouncedDownSignal,
	reset=>reset,
	countOut=>countOutSig
);
---------------------------------------------------------------------------------------
segmentDriver:segment
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	anode=>anodeSig,
	input=>inputSig,
	segmentDisp=>segmentDispSig
);

data<=countOutSig;

end Behavioral;