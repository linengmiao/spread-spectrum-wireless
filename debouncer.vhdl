library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity debouncer is
port(
	clk:in std_logic;
	clkEnable:in std_logic;
	reset: in std_logic;
	inputBtn: in std_logic;
	outputBtn: out std_logic

);

end debouncer;

architecture behav of debouncer is

type state_machine is (shift, load);  
signal state: state_machine:=shift;
signal stateNext: state_machine:=shift;

signal test: std_logic;

signal shiftRegister: std_logic_vector(3 downto 0):="0001";
signal shiftRegisterNext: std_logic_vector(3 downto 0):="0001";
signal exorRes: std_logic:='0';
signal shiftLoad: std_logic:='1';




begin
	syn_debouncer: process(clk) -- in syn enkel clk
	begin
	if(clkEnable='1')then
		if(rising_edge(clk))then
			if(reset='1')then
				shiftRegister<="0000";
			else
				state<=stateNext;
				outputBtn<=shiftRegister(0);
				shiftRegister<=shiftRegisterNext;
			end if;						
		end if;
	end if;
	end process;

	com_debouncer: process(shiftRegister, inputBtn, shiftLoad)
	begin
		case shiftLoad is
			when '1' => --shift
				test<='1';
			
				shiftRegisterNext(3)<=inputBtn;
				shiftRegisterNext(2)<=shiftRegister(3);
				shiftRegisterNext(1)<=shiftRegister(2);
				shiftRegisterNext(0)<=shiftRegister(1);		
			
			when '0' =>
				test<='0';
				--uitgaande bit wordt geplaatst in alle registers(stabiele output)
				shiftRegisterNext(3)<= shiftRegister(0);
				shiftRegisterNext(2)<= shiftRegister(0);
				shiftRegisterNext(1)<= shiftRegister(0);
			when others =>
		end case;

	end process;

	shiftLoad<=(inputBtn)xor(shiftRegister(0));		


end behav;