library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interleaver_buff_tb is
end interleaver_buff_tb;
architecture  tb_arch of interleaver_buff_tb is
component interleaver_buff
port( 
data_in: in std_logic;
clk_100,clk_50,reset,ready : in std_logic;
data_out,valids : out std_logic
);
end component;
signal clk_100,clk_50 : std_logic := '1';
signal data_in,data_out,reset,ready,valids : std_logic;
signal hexout : std_logic_vector( 0 to 191 ):= (others=>'0') ;
signal hexin : std_logic_vector( 0 to 191) := x"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA" ;
signal ind_count : integer range 0 to 199;
begin 
dut : interleaver_buff 
port map(
clk_100 => clk_100,
clk_50 => clk_50,
reset => reset,
ready => ready,
data_in => data_in,
valids => valids,
data_out => data_out );
clk_100 <= not clk_100 after 25 ns;
clk_50 <= not clk_50 after 50 ns;
stimulus : process 
begin
reset <= '1';
ready<='0';
wait for 50 ns;
reset<='0';
ready<='1';
for i in 0 to 191 loop
wait for 50 ns;
Data_in <= hexin(i);
end loop ;
wait;

end process stimulus ;
end tb_arch;