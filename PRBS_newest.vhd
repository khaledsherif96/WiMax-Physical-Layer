library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PRBS_newest is
port( 
clk_50,clk_100: in std_logic;
reset: in std_logic;
data_in: in std_logic;
data_out: out std_logic;
valid: out std_logic;
ready:in std_logic
);
end PRBS_newest;

architecture PRBS_arch of PRBS_newest is

signal ran_feed_bit: std_logic_vector (1 to 15);
signal q: std_logic;
signal counter : integer range 0 to 400;
begin

q <= ran_feed_bit(15) xor ran_feed_bit(14);

process (clk_50, reset)
begin
	if (reset = '1') then
		valid <= '0'; 
		ran_feed_bit <= "011011100010101";
		counter <= 0;
	elsif RISING_EDGE (clk_50) then
	if (ready='1') then
		data_out <= data_in xor q; 
		valid<='1';
		ran_feed_bit <= q & ran_feed_bit(1 to 14);
		counter <= counter +1;
		if (counter = 95) then
			ran_feed_bit <= "011011100010101";
			counter <= 0;
		end if;
	elsif (ready ='0') then
		valid <= '0';
	end if;
	end if;
end process;

end PRBS_arch;