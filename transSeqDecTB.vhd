
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.ALL;

entity transSeqDecTB is
end transSeqDecTB;

architecture structural of transSeqDecTB is
component transSeqDec 
port(
	clk: in std_logic;
	clkEnable:in std_logic;
	reset:in std_logic;
	extb: in std_logic
	
);
end component;


for uut : transSeqDec use entity work.transSeqDec(Behavioral);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;
signal clkEnable: std_logic:='1';

signal clk: std_logic;
signal reset: std_logic:='0';

signal extbTB: std_logic;

begin

uut:transSeqDec
port map(
	clk=>clk,
	clkEnable=>clkEnable,
	reset=>reset,
	extb=>extbTB
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
-------------------------------------------------------------------------------------------------
tb : PROCESS
   procedure tbvector(constant stimulus : in std_logic)is
	file outfile: TEXT OPEN WRITE_MODE is "C:\Users\Yalishand\Desktop\school\schakeljaar\digitale synthese\dpllTB.txt";
	file text_var : text;
	variable line_var : line;
     begin
	extbTB<=stimulus;
       wait for period;
   end tbvector;
   BEGIN

		for i in 0 to 10  loop

			--for j in 0 to 15 loop
				 tbvector('1'); 
			--end loop;

			for j in 0 to 15 loop
				 tbvector('0'); 
			--	    file_open(text_var,outfile, write_mode);
			--	    write(line_var,integer'image(num));         -- write num into line_var
			--	    writeline(text_var, line_var);   -- write line_var into the file
			--	    file_close(text_var);
			end loop;
		
			--for j in 0 to 15 loop
				 tbvector('1'); 
			--end loop;
		end loop;


      end_of_sim <= true;
      wait;

   END PROCESS;
END;

