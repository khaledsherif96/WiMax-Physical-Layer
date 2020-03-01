LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------------------------------------------
ENTITY encoder_fsm_buff_tb IS
END ENTITY;
-------------------------------------------------------------------------
ARCHITECTURE TestBench  OF encoder_fsm_buff_tb IS
COMPONENT encoder_fsm_buff IS
  PORT(	Data_in, clk_50, clk_100, rst,ready: in std_logic;
			Data_out, valid: out std_logic
	);
END COMPONENT;

SIGNAL Data_in,clk_50,rst,clk_100,ready,Data_out,valid:STD_LOGIC;
SIGNAL hexin : std_logic_vector(0 to 95) := x"558AC4A53A1724E163AC2BF9" ;
BEGIN
uut: encoder_fsm_buff 
PORT MAP(
		Data_in => Data_in,
		ready => ready,
		clk_50=> clk_50,
		rst=> rst,
		Data_out => Data_out,
		valid => valid,
		clk_100=>clk_100);

PROCESS
BEGIN
                     clk_50 <= '1';
WAIT FOR 50 ns;      clk_50 <= '0';
WAIT FOR 50 ns;
END PROCESS;
PROCESS
BEGIN
                     clk_100 <= '1';
WAIT FOR 25 ns;      clk_100 <= '0';
WAIT FOR 25 ns;
END PROCESS;

PROCESS
BEGIN
    rst <= '1';  
	Data_in <= hexin(0);
	WAIT FOR 100 ns;           
		rst <= '0';        
		ready <='1';       
	WAIT FOR 100 ns;           
	for i in 1 to 95 loop      
	Data_in <= hexin(i);     
	WAIT FOR 100 ns;           
	END LOOP;                  
	Data_in <= hexin(0);       
	wait for 100 ns;           
	for i in 1 to 95 loop      
		Data_in <= hexin(i);		
	WAIT FOR 100 ns;           
	END LOOP;                    											 
	for i in 0 to 95 loop          
	Data_in <= hexin(i);   
	WAIT FOR 100 ns;            
	END LOOP;                  
	for i in 0 to 95 loop      
	Data_in <= hexin(i);       
	WAIT FOR 100 ns;           
	END LOOP;                  
	for i in 0 to 95 loop               
	Data_in <= hexin(i);
	WAIT FOR 100 ns;                 
	END LOOP; 
	for i in 0 to 95 loop               
	Data_in <= hexin(i);
	WAIT FOR 100 ns;                 
	END LOOP; 			
	for i in 0 to 95 loop               
	Data_in <= hexin(i);
	WAIT FOR 100 ns;                 
	END LOOP; 			
	for i in 0 to 95 loop               
	Data_in <= hexin(i);
	WAIT FOR 100 ns;                 
	END LOOP; 
WAIT;
END PROCESS;

END ARCHITECTURE;	 