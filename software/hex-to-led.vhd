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
		DigitSelect: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)	-- LED Digit 
	);
END HEX_TO_LED;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Architecture of Entity Declarations 
ARCHITECTURE Behavioral OF HEX_TO_LED IS
	SIGNAL LED:	STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL Cathod: STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL cathod_clk: STD_LOGIC;
BEGIN
	
		
	------------------------------------------------------------------------------
	-- Clock 
	------------------------------------------------------------------------------
	PROCESS( RESET, GCLKP1 )
		VARIABLE Count  : integer range 0 to 2047;
		
	BEGIN
		------------------------------------
		--Period: 1uS 
		IF( RESET = '1' ) THEN 
			Count := 0;
		ELSIF( GCLKP1'EVENT AND GCLKP1='1' ) THEN 
			IF( Count > 511 ) THEN 	
				Count := 0;
				cathod_clk <= '1';
			ELSE                  		
				Count := Count + 1;
				cathod_clk <= '0';
			END IF;
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
	PROCESS( RESET, GCLKP1 )   
	BEGIN
		IF( RESET = '1' ) THEN 
			Cathod <= "00";
		ELSIF( GCLKP1'EVENT AND GCLKP1='1' )THEN 
			if (cathod_clk = '1') then
				CASE Cathod IS
					when "11" =>DigitSelect<= "0001";
					when "10" =>DigitSelect<= "0010";
					when "01" =>DigitSelect<= "0100";
					when "00" =>DigitSelect<= "1000";
					when others=>DigitSelect<= "XXXX";
				END CASE;
				Cathod <= Cathod + 1; 			
			end if;
		END IF;		
	END PROCESS;
		
	PROCESS(Cathod, LED0, LED1, LED2, LED3)
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
