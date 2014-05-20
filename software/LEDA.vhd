--???21EDA??
--?????:A-C8V4
--www.21eda.com
--??LED???LED??????0??????1???
--????????21EDA????????

LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;                   
ENTITY LEDA is                                        
     PORT(
          clk:in STD_LOGIC;  --System Clk                            
          led1:out STD_LOGIC_VECTOR(3 DOWNTO 0)
				);
END LEDA ;       
		
ARCHITECTURE light OF LEDA IS            
SIGNAL clk1 :std_logic;                                       
BEGIN   

	PROCESS( clk )
		VARIABLE Count  : integer range 0 to 65535;
	BEGIN
		IF( clk'EVENT AND clk='1' ) THEN 
			IF( Count > 50000 ) THEN 	
				Count := 0;
				clk1 <= '1';
			ELSE                  		
				Count := Count + 1;
				clk1 <= '0';
			END IF;
		END IF;
	END PROCESS;
	
---------------------------------------------------------
P2:PROCESS(clk)                                              
variable count1:INTEGER RANGE 0 TO 7;                       
BEGIN                                                                                                             
IF clk'event AND clk='1'THEN 
	if (clk1 = '1') then                               
		if count1<=4 then                                          
			if count1=4 then                                        
				count1:=0;                                                
			end if;                                                          
			CASE count1 IS                                            
			WHEN 0=>led1<="0111";                        
			WHEN 1=>led1<="1011";                        
			WHEN 2=>led1<="1101";                       
			WHEN 3=>led1<="1110";           
			WHEN OTHERS=>led1<="1111";              
			END CASE;                                                     
			count1:=count1+1;                                   
		 end if;          
	end if;	 
end if;                                                                        
end process;                              
END light;