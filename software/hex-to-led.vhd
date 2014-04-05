---------------------------------------------------------------------------------------------------
--*
--* File                : hex-to-led.vhd
--* Hardware Environment:
--* Build Environment   : Quartus II Version 13.1
--* Version             : 
--* By                  : Rezchenko Dmitriy
--*
--*
---------------------------------------------------------------------------------------------------

-- VHDL library Declarations 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Entity Declarations 
ENTITY HEX_TO_LED IS
	PORT 
	(
		-- Reset & Clock Signal 
		RESET: 		IN STD_LOGIC; 
		GCLKP1:		IN STD_LOGIC;	-- 50 MHz 
		
		LED0:			IN STD_LOGIC_VECTOR(3 downto 0);
		LED1:			IN STD_LOGIC_VECTOR(3 downto 0);
		LED2:			IN STD_LOGIC_VECTOR(3 downto 0);
		LED3:			IN STD_LOGIC_VECTOR(3 downto 0);
	
		-- LED8 PIN 
		LEDOut:		 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- LED Segment 
		DigitSelect: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);	-- LED Digit 
		
		-- clock
		Period_1S: 		OUT STD_LOGIC;
		Period_1uS: 	OUT STD_LOGIC;
		Period_1mS: 	OUT STD_LOGIC
	);
END HEX_TO_LED;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Architecture of Entity Declarations 
ARCHITECTURE Behavioral OF HEX_TO_LED IS
	SIGNAL LED:	STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL Cathod: STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL Period1uS, Period1mS, Period1S, cathod_clk: STD_LOGIC;
BEGIN
	
Period_1S <= Period1S;
Period_1uS <= Period1uS;
Period_1mS <= Period1mS;
		
	------------------------------------------------------------------------------
	-- Clock 
	------------------------------------------------------------------------------
	PROCESS( RESET, GCLKP1, Period1uS, Period1mS )
		VARIABLE Count  : STD_LOGIC_VECTOR(5 DOWNTO 0);
		VARIABLE Count1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
		VARIABLE Count2 : STD_LOGIC_VECTOR(9 DOWNTO 0);
		VARIABLE Count3 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	BEGIN
		------------------------------------
		--Period: 1uS 
		IF( RESET = '0' ) THEN 
			Count := "000000";
		ELSIF( GCLKP1'EVENT AND GCLKP1='1' ) THEN 
			IF( Count>"110000" ) THEN 	Count := "000000";	--  110000:48  50/50M = 1us
			ELSE                  		Count := Count + 1;
			END IF;
			Period1uS <= Count(5);
		END IF;
		------------------------------------
		--Period: 1mS 
		IF( Period1uS'EVENT AND Period1uS='1' ) THEN 
			IF( Count1>"1111100110" ) THEN 	Count1 := "0000000000";  -- 1111100110:998  1000*1us = 1ms
			ELSE                  			Count1 := Count1 + 1;
			END IF;
			Period1mS <= Count1(9);

		END IF;
		------------------------------------
		--Period: 1S (1111100110: 998)
		IF( Period1mS'EVENT AND Period1mS='1' ) THEN 
			IF( Count2>"1111100110" ) THEN 	Count2 := "0000000000";
			ELSE                  			Count2 := Count2 + 1;
			END IF;
			
			Period1S  <= Count2(9); 
		END IF; 
		
		IF( Period1mS'EVENT AND Period1mS='1' ) THEN 
			Count3 := Count3 + 1;
			cathod_clk  <= Count3(2); 
		END IF;
	END PROCESS;
	
	-------------------------------------------------
	-- Encoder 
	-------------------------------------------------
	-- HEX-to-seven-segment decoder 
	-- segment encoding 
	--      0 
	--     ---  
	--  5 |   | 1
	--     --- <------6
	--  4 |   | 2
	--     ---  
	--      3
	PROCESS( LED )   
	BEGIN
		CASE LED IS
			when "0000"=>LEDOut<= "11000000";    --'0'
			when "0001"=>LEDOut<= "11111001";    --'1'
			when "0010"=>LEDOut<= "10100100";    --'2'
			when "0011"=>LEDOut<= "10110000";    --'3'
			when "0100"=>LEDOut<= "10011001";    --'4'
			when "0101"=>LEDOut<= "10010010";    --'5'
			when "0110"=>LEDOut<= "10000010";    --'6'
			when "0111"=>LEDOut<= "11111000";    --'7'
			when "1000"=>LEDOut<= "10000000";    --'8'
			when "1001"=>LEDOut<= "10010000";    --'9'
			when "1010"=>LEDOut<= "10001000";    --'A'
			when "1011"=>LEDOut<= "10000011";    --'b'
			when "1100"=>LEDOut<= "11000110";    --'C'
			when "1101"=>LEDOut<= "10100001";    --'d'
			when "1110"=>LEDOut<= "10000110";    --'E'
			when "1111"=>LEDOut<= "10001110";    --'F'
			when others=>LEDOut<= "XXXXXXXX";    --' '
		END CASE;
	END PROCESS;
	
	-------------------------------------------------
	
	-- Dynamic indacator  
	PROCESS( RESET, cathod_clk )   
	BEGIN
		IF( RESET = '0' ) THEN 
			Cathod <= "00";
		ELSIF( cathod_clk'EVENT AND cathod_clk = '1' )THEN 
			CASE Cathod IS
				when "11" =>DigitSelect<= "0001";
				when "10" =>DigitSelect<= "0010";
				when "01" =>DigitSelect<= "0100";
				when "00" =>DigitSelect<= "1000";
				when others=>DigitSelect<= "XXXX";
			END CASE;
			Cathod <= Cathod + 1; 			
		END IF;		
	END PROCESS;
		
	PROCESS(Cathod)
	BEGIN
		CASE Cathod is
			when "01" => LED <= LED3;
			when "10" => LED <= LED2;
			when "11" => LED <= LED1;
			when "00" => LED <= LED0;
			when others => LED <= "1111";
		end case;
	end process;

END Behavioral;
