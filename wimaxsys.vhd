library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity wimaxsys is
port(
clk_100,clk_50, reset, data_in,ready: in std_logic;
validsys : out std_logic;
out_data1: out signed (15 downto 0);
out_data2 : out signed (15 downto 0);
prbs_enc, enc_int, int_modu,valid_enc,valid_out_enc, valid_int,valid_out_int, valid_modu :out std_logic
);
end wimaxsys;

architecture wimax_arch of wimaxsys is
component PRBS_newest 
port( 
clk_50,clk_100: in std_logic;
reset: in std_logic;
data_in: in std_logic;
data_out: out std_logic;
valid: out std_logic;
ready:in std_logic
);
end component;
component encoder_fsm_buff
port(

Data_in, clk_50, clk_100, rst,ready: in std_logic;
			valid,valid_out: out std_logic;
			Data_out : out std_logic
);

end component;
component interleaver_buff
port( 

data_in: in std_logic;
clk_50,clk_100,reset,ready : in std_logic;
data_out,valids,valids_out : out std_logic
);

end component;

component qpsk_modulator 
port(

Data_in,clk_100,clk_50: in std_logic;
output1,output2: out signed( 15 downto 0 );
ready,reset: in std_logic;
valid: out std_logic
);

end component;

signal prbs_enc_s, enc_int_s , int_modu_s ,valid_enc_s,valid_out_enc_s,valid_int_s,valid_out_int_s,valid_modu_s :std_logic;

	
	begin
	u1: PRBS_newest port map (clk_50=>clk_50,clk_100=>clk_100 , reset=>reset, ready=>ready , data_in=>data_in , data_out=>prbs_enc_s , valid=>valid_enc_s); 
	u2: encoder_fsm_buff port map(clk_50=>clk_50,clk_100=>clk_100 , rst=>reset , data_in=>prbs_enc_s, Data_out=>enc_int_s , ready=>valid_enc_s , valid=>valid_int_s,valid_out=>valid_out_enc_s);
	u3: interleaver_buff port map(clk_100=>clk_100,clk_50=>clk_50 , reset=>reset , data_in=>enc_int_s , data_out=>int_modu_s , ready=>valid_int_s , valids=>valid_modu_s,valids_out => valid_out_int_s);
	u4:qpsk_modulator port map (clk_100=>clk_100,clk_50=>clk_50,ready => ready, reset=>reset,Data_in=>int_modu_s,output1=>out_data1,output2=>out_data2,valid=>validsys);
	
	prbs_enc <= prbs_enc_s;
	enc_int <= enc_int_s;
	int_modu<= int_modu_s;
	valid_enc<=valid_enc_s;
	valid_int<= valid_int_s;
	valid_modu<= valid_modu_s;	
	valid_out_enc <= valid_out_enc_s;
	valid_out_int <= valid_out_int_s;
	
	end wimax_arch;

