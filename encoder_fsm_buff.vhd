LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-------------------------------------------------------------------------------------------------------------------------------
ENTITY encoder_fsm_buff IS
    PORT(	Data_in, clk_50, clk_100, rst,ready: in std_logic;
			Data_out, valid,valid_out : out std_logic

	);
END ENTITY;
-------------------------------------------------------------------------------------------------------------------------------
ARCHITECTURE RTL  OF encoder_fsm_buff IS
TYPE encoder_state IS
( filling_buffer , processing_input , processing_output, idle);
SIGNAL BUFFER0,BUFFER1:STD_LOGIC_VECTOR (95 DOWNTO 0);
SIGNAL 			outx,outy : std_logic;
SIGNAL			donefillingbufferA: std_logic;
SIGNAL			donefillingbufferB : std_logic;
SIGNAL			x_out, y_out:  std_logic;
SIGNAL SHIFT_REG:STD_LOGIC_VECTOR (5 downto 0);
SIGNAL dec_counter: integer range 0 to 193;
SIGNAL out_reg: std_logic_vector (0 to 191);
SIGNAL out_final_reg : std_logic_vector ( 0 to 191);
signal counter_for_out_reg: unsigned (7 downto 0);
signal counter_for_out_reg_2: unsigned( 7 downto 0);
signal counter3bits : unsigned ( 2 downto 0);
signal counter3bits_2 : unsigned ( 2 downto 0);
signal counter2bits: unsigned (1 downto 0);
signal counter2bits_2: unsigned (1 downto 0);
signal valids : std_logic;

BEGIN
process (clk_50,rst)
begin
IF (rst ='1') THEN 
	BUFFER0<=(OTHERS=>'0'); 
	BUFFER1<=(OTHERS=>'0'); 
	SHIFT_REG<=(OTHERS=>'0');
	donefillingbufferA<='0';
	donefillingbufferB<='0';
	dec_counter <= 0;
ELSIF (clk_50 ='1' and clk_50'event) THEN
	If (ready ='1') then
	IF (dec_counter<96 ) THEN
		dec_counter<= dec_counter +1; --incrementing counter
        BUFFER0(dec_counter)<=Data_in;-- & BUFFER0(95 DOWNTO 1); --filling Buffer A with Data_in
	    SHIFT_REG<= BUFFER1(0)& SHIFT_REG(5 DOWNTO 1); -- last bit in Buffer B that is actually the INPUT.
	    BUFFER1<='0' & BUFFER1(95 DOWNTO 1); -- filling Buffer B with zeros 
	ELSIF (dec_counter = 96) THEN
		SHIFT_REG<=BUFFER0(95 downto 90); -- Applying the method of tail-biting
		dec_counter <= dec_counter +1; -- incrementing counter
		donefillingbufferA <='1'; --indicator that Buffer A is full
		donefillingbufferB <='0';
    ELSIF (dec_counter > 95 and dec_counter <193) THEN 
		SHIFT_REG<= BUFFER0(0)& SHIFT_REG(5 DOWNTO 1);  -- Last bit in Buffer A which is actually the INPUT.
		BUFFER1<=Data_in & BUFFER1(95 DOWNTO 1); --filling Buffer B
		BUFFER0<='0' & BUFFER0(95 DOWNTO 1); -- Shifting BUFFER A
		dec_counter <= dec_counter +1; -- incrementing the counter
	ELSIF (dec_counter =193) THEN
		SHIFT_REG<=BUFFER1(95 downto 90);  -- Applying the method of tail-biting
		dec_counter <= 0; --restarting the counter
		donefillingbufferA <='0';
		donefillingbufferB <='1'; -- indicating that buffer B is now full.
		
	END IF;
	elsif (ready ='0') then
	end if;
END IF;
END PROCESS;
-----------------------------------------------------------------------------------------------------------------------------------------
PROCESS (clk_100,rst)
begin
	IF (rst ='1') then
	 counter_for_out_reg <= (OTHERS=>'0');
	 counter_for_out_reg_2 <=(OTHERS=>'0');
	 outx<= '0';
	 outy <= '0';
	 valid <='0';
	 valid_out <='0';
	valids <='0';
	 out_reg <= (OTHERS=>'0');
	 Data_out <= '0';
	 counter3bits <= "000";
	 counter2bits <="00";
	 counter2bits_2 <= "00";
	 counter3bits_2 <= "000";
     elsIF (clk_100 ='1' and clk_100'event) THEN
		if ( ready ='1') then
		if( dec_counter = 97 ) then 
			--valid <='1';	
			valids <='1';
		end if;
		IF (donefillingbufferA ='1') THEN
		counter3bits_2 <="000";
				 valid <='1';

		X_out<=BUFFER0(0) XOR SHIFT_REG(5) XOR SHIFT_REG(4) XOR SHIFT_REG(3) XOR SHIFT_REG(0);
		y_out<=BUFFER0(0) XOR SHIFT_REG(4) XOR SHIFT_REG(3) XOR SHIFT_REG(1) XOR SHIFT_REG(0);
		counter_for_out_reg <= counter_for_out_reg +1;
		counter3bits <= counter3bits +1; 
		counter2bits <= counter2bits +1;
		if (counter3bits = "001" or counter3bits = "011") then
			out_reg(to_integer(counter_for_out_reg-1)) <= x_out;
			out_reg(to_integer(counter_for_out_reg)) <= y_out;
			outx <= x_out;
			outy <= y_out;
		else 
			outx<= '0';
			outy<='0';
		end if;
		if (counter2bits = "01" ) then
		 Data_out <= x_out;
		 valid_out <='1';
		elsif (counter2bits = "00") then
		 Data_out <= y_out;
		end if;
		if (counter2bits ="01") then 
		 counter2bits <= "00";
		 end if;
		if (counter3bits ="011" ) then
			counter3bits <="000";
		end if;
		if( counter_for_out_reg = "10111111" ) then 
			counter_for_out_reg <="00000000";
		end if;
		if ( valids ='1') then
		out_final_reg <= out_reg;
		end if;
		ELSiF (donefillingbufferB ='1') THEN 
			counter3bits <="000";
			X_out<=BUFFER1(0) XOR SHIFT_REG(5) XOR SHIFT_REG(4) XOR SHIFT_REG(3) XOR SHIFT_REG(0);
			y_out<=BUFFER1(0) XOR SHIFT_REG(4) XOR SHIFT_REG(3) XOR SHIFT_REG(1) XOR SHIFT_REG(0);
			counter_for_out_reg_2 <= counter_for_out_reg_2 +1;
			counter3bits_2 <= counter3bits_2 +1; 
			counter2bits_2 <= counter2bits_2+1;
			if (counter3bits_2 = "001" or counter3bits_2 = "011") then
				out_reg(to_integer(counter_for_out_reg_2-1)) <= x_out;
				out_reg(to_integer(counter_for_out_reg_2)) <= y_out;
			    outx <= x_out;
				outy <= y_out;
			else 
				outx<= '0';
				outy<='0';
			end if;
					if (counter2bits_2 = "01" ) then
					Data_out <= x_out;
					elsif (counter2bits_2 = "00") then
					Data_out <= y_out;
					end if;
		if (counter2bits_2 ="01") then 
			counter2bits_2 <= "00";
		end if;
		if (counter3bits_2 ="011" ) then
			counter3bits_2 <="000";
		end if;
		if( counter_for_out_reg_2 = "10111111" ) then 
			counter_for_out_reg_2 <="00000000";
		end if;
		if (valids ='1') then
			out_final_reg <= out_reg;
		end if;
			
	END IF;
			elsif (ready ='0') then 
				valid <='0';
				valids <='0';
			end if;
	End IF;
	END PROCESS;
END RTL;

