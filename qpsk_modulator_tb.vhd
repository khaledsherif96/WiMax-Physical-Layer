library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity qpsk_modulator_tb is
end qpsk_modulator_tb;
architecture tb of qpsk_modulator_tb is
component qpsk_modulator 
port(
Data_in,clk_100,clk_50: in std_logic;
output1,output2: out signed( 15 downto 0 );
ready,reset: in std_logic;
valid: out std_logic
); 
end component;
signal clk_50,clk_100 : std_logic := '1';
signal Data_in,ready,valid,reset : std_logic;
signal output1,output2:  signed( 15 downto 0 );
signal hexin : std_logic_vector( 0 to 191 ) := x"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E" ;
begin
dut : qpsk_modulator
 port map ( 
clk_100 => clk_100,
clk_50 => clk_50,
reset => reset,
Data_in=>Data_in ,
output1 =>output1 ,
output2 =>output2 ,
ready => ready,
valid => valid ) ;
clk_50 <= not clk_50 after 50 ns;
clk_100 <= not clk_100 after 25 ns;
stimulus : process 
begin
reset <= '1';
ready <= '0';
wait for 50 ns;
reset<='0';
ready <= '1';
for i in 0 to 191 loop
Data_in <= hexin(i);
wait for 50 ns;
end loop ;
wait;
end process stimulus ;
end tb;