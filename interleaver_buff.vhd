library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interleaver_buff is 
port( 

data_in: in std_logic;
clk_50,clk_100,reset,ready : in std_logic;
data_out,valids,valids_out : out std_logic
);

end interleaver_buff;

architecture rtl of interleaver_buff is 
signal reg,reg2 : std_logic_vector( 191 downto 0 );
signal mk1,mk2: unsigned( 8 downto 0 );
signal k1,k2,counter,counter2 : unsigned( 7 downto 0 );
signal valid: std_logic := '0';
signal valid2: std_logic := '0';
signal donefillingbufferA : std_logic;
signal donefillingbufferB : std_logic;
constant sixteen: unsigned( 4 downto 0 ) := "10000";
constant twelve: unsigned( 3 downto 0 ) := "1100";
SIGNAL BUFFER0,BUFFER1:STD_LOGIC_VECTOR (191 DOWNTO 0);
SIGNAL dec_counter: integer range 0 to 385;

begin

process(clk_100,reset)
begin
if(reset ='1') then
	reg <= ( others => '0' );
	reg2 <= ( others => '0' );
	k1 <= ( others => '0' );
	k2 <= ( others => '0' );
	counter <= "00000000";
	counter2 <= "00000000";
	BUFFER0<=(OTHERS=>'0'); 
	BUFFER1<=(OTHERS=>'0');
	valids<='0';
	valids_out <='0';
elsif rising_edge(clk_100) then
	if (ready ='1') then
		IF (dec_counter<192 ) THEN
			dec_counter<= dec_counter +1; --incrementing counter
			BUFFER0<=Data_in & BUFFER0(191 DOWNTO 1); --filling Buffer A with Data_in
			k1 <= k1 +1;
			mk1 <=  ( twelve*(k1 mod sixteen ) )+ (k1/sixteen);
			reg(to_integer(mk1)) <= Data_in;
			BUFFER1<='0' & BUFFER1(191 DOWNTO 1); -- filling Buffer B with zeros 
		ELSIF (dec_counter = 192) THEN
			dec_counter <= dec_counter +1; -- incrementing counter
			donefillingbufferA <='1'; --indicator that Buffer A is full
			donefillingbufferB <='0';
			valid <= '1';
			BUFFER1<=Data_in & BUFFER1(191 DOWNTO 1); 
			k2 <= k2 +1;
			mk2 <=  ( twelve*(k2 mod sixteen ) )+ (k2/sixteen);
			reg2(to_integer(mk2)) <= Data_in;
		ELSIF (dec_counter > 192 and dec_counter <384) THEN 
			BUFFER1<=Data_in & BUFFER1(191 DOWNTO 1); --filling Buffer B
			BUFFER0<='0' & BUFFER0(191 DOWNTO 1); -- Shifting BUFFER A
			dec_counter <= dec_counter +1; -- incrementing the counter
			k2 <= k2 +1;
			mk2 <=  ( twelve*(k2 mod sixteen ) )+ (k2/sixteen);
			reg2(to_integer(mk2)) <= Data_in;
		ELSIF (dec_counter =384) THEN
			dec_counter <= 1; --restarting the counter
			donefillingbufferA <='0';
			donefillingbufferB <='1';			-- indicating that buffer B is now full.
			valid2<='1';
		END IF;
			if (donefillingbufferA ='1') then
				valid <='1';
				valids <='1';
			end if;
			if (donefillingbufferB ='1') then
				valid2 <='1';
			end if;
			if (valid ='1') then
				data_out<= reg(to_integer(counter));
				valids_out <= '1';
				counter<=counter+1;
				if (counter ="10111111") then
					counter <= "00000000" ;	
				end if;
			--	valid2 <='0';
			end if;
				if( k1 = "11000000" ) then 
					k1 <= "00000000";
				end if;
				if( k2 = "11000000" ) then 
					k2 <= "00000000";
				end if;
				
			if (valid2 ='1') then
				--valid <='0';
				data_out<= reg2(to_integer(counter2));
				counter2<=counter2+1;
				if (counter2 ="10111111") then
				counter2 <= "00000000"; 
				end if;
			end if;
			elsif ( ready <='0') then 
			valids <='0';

	end if;

end if;
end process;
end rtl;