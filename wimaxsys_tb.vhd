library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wimaxsys_tb is end wimaxsys_tb;
architecture wimax_tb_arch of wimaxsys_tb is
component wimaxsys is
port(
clk_100,clk_50, reset, data_in,ready: in std_logic;
validsys : out std_logic;
out_data1: out signed (15 downto 0);
out_data2 : out signed (15 downto 0);
prbs_enc, enc_int, int_modu,valid_enc, valid_int, valid_modu :out std_logic
);
end component;

signal clk_100 : std_logic:='1';
signal clk_50: std_logic:='1';
signal reset: std_logic;
signal validsys:std_logic;
signal ready: std_logic;
signal data_in:std_logic;
signal out_data1:signed(15 downto 0);
signal out_data2:signed(15 downto 0);
signal prbs_enc, enc_int , int_modu,valid_enc,valid_int,valid_modu :std_logic;

constant in_prbs: std_logic_vector (95 downto 0) := x"ACBCD2114DAE1577C6DBF4C9";
signal in_encoder:  std_logic_vector (95 downto 0) := x"558AC4A53A1724E163AC2BF9";
signal in_interleaver: std_logic_vector (0 to 191) := x"2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA";
signal in_modulator: std_logic_vector (191 downto 0) := x"4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E";
signal enc_int1:std_logic_vector (191 downto 0);
signal enc_int2:std_logic_vector (191 downto 0);
signal int_modu1:std_logic_vector (191 downto 0);
signal int_modu2:std_logic_vector (191 downto 0);


begin

uut: wimaxsys port map(
clk_100=>clk_100,clk_50=>clk_50,reset=>reset,ready=>ready,validsys=>validsys,data_in=>data_in,out_data1=>out_data1,out_data2=>out_data2,
prbs_enc=>prbs_enc,enc_int=>enc_int,int_modu=>int_modu,valid_enc=>valid_enc,valid_int=>valid_int,valid_modu=>valid_modu);

clk_100 <= not clk_100 after 25 ns;
clk_50 <= not clk_50 after 50 ns;

process
begin

reset <= '1'; 
ready <='1';
wait for 100 ns;
reset <='0';
ready <= '1';
for i in 95 downto 0 loop
data_in<= in_prbs(i);
wait for 100 ns;
end loop;
data_in <= in_prbs(95);
wait for 100 ns;
for i in 95 downto 0 loop
data_in<= in_prbs(i);
wait for 100 ns;
end loop;
wait for 100 ns;
for i in 95 downto 0 loop
data_in<= in_prbs(i);
wait for 100 ns;
end loop;
for i in 95 downto 0 loop
data_in<= in_prbs(i);
wait for 100 ns;
end loop;
ready <='0';
wait;
end process;
process
begin
wait until rising_edge (valid_int); 
wait for 100 ns;
for i in 191 downto 0 loop
enc_int1(i)<=enc_int;
wait for 50 ns ;
end loop;
assert(enc_int1=in_interleaver)
report "test Failed!"
severity note;	
wait;
end process;

process
begin
wait until rising_edge (valid_modu); 
wait for 100 ns;
for i in 191 downto 0 loop
int_modu1(i)<=int_modu;
enc_int2(i)<=enc_int;
wait for 50 ns ;
end loop;
for i in 191 downto 0 loop
int_modu2(i) <= int_modu;
wait for 50 ns;
end loop;
assert(int_modu1=in_modulator)
report "test Failed!"
severity note;	
wait;
end process;


end wimax_tb_arch;