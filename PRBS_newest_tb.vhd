library ieee;
use ieee.std_logic_1164.all;


entity PRBS_newest_tb is
end PRBS_newest_tb;

architecture PRBS_tb_arch of PRBS_newest_tb is 
component PRBS_newest is 
port ( 
clk_50,clk_100, reset, data_in,ready: in std_logic;
data_out, valid: out std_logic
);
end component;

signal clk_50,clk_100: std_logic := '1';
signal reset,ready,valid: std_logic;
signal data_in: std_logic;
signal data_out: std_logic;
signal test_data_in : std_logic_vector(95 downto 0);
signal test_data_out : std_logic_vector(95 downto 0);
begin
dut : PRBS_newest port map (clk_50 => clk_50,clk_100=>clk_100, reset => reset, data_in => data_in ,
data_out => data_out, ready=>ready, valid=>valid);


test_data_in <= x"ACBCD2114DAE1577C6DBF4C9";
test_data_out<= x"558AC4A53A1724E163AC2BF9";

process
begin
wait for 50 ns; 
clk_50 <= not clk_50;
end process;
clk_100 <= not clk_100 after 25 ns;
process
begin 
reset <= '1'; 
ready <='1';
wait for 100 ns;
reset <= '0';
ready<='1'; 
for i in 95 downto 0 loop
data_in <= test_data_in(i); 
wait for 100 ns; 
end loop;
wait for 100 ns;
for i in 95 downto 0 loop
data_in <= test_data_in(i); 
wait for 100 ns; 
end loop;
wait;
end process;
end PRBS_tb_arch;
