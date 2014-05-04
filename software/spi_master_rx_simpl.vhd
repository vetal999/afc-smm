LIBRARY ieee;
USE ieee.std_logic_1164.all;

--  Entity Declaration
ENTITY spi_master_rx_simpl IS
	PORT
	(
        CLK     : IN STD_LOGIC;
        Start   : IN STD_LOGIC;
        reset   : IN STD_LOGIC;

        SDI     : IN STD_LOGIC;
        SCK     : OUT STD_LOGIC;
        nCS     : OUT STD_LOGIC;

        DO      : OUT std_logic_vector(15 downto 0);
        Ready   : OUT STD_LOGIC

	);
	
END spi_master_rx_simpl;


ARCHITECTURE arch OF spi_master_rx_simpl IS

	signal data : std_logic_vector(15 downto 0);
	
	signal state : integer range 0 to 3 := 0;
BEGIN

process(CLK, Start, reset)
	
	variable bits : integer range 0 to 15 := 0;
begin

if (reset = '1') then
	nCS <= '1';
	DO <= (others => '0');
	Ready <= '0';
	state <= 0;

elsif (CLK'event and CLK = '1') then

	case (state) is
		when 0 =>
				if (Start = '1') then
					nCS <= '0';
					bits := 0;
					state <= 1;
					Ready <= '0';
					data <= (others => '0');	
				end if;
				
		when 1 =>
				if (bits = 15) then
					state <= 2;
					Ready <= '1';
					DO <= data;
				else
					bits := bits + 1;
					
					data(15 downto 1) <= data(14 downto 0);
					data(0) <= SDI;
				end if;
				
		when 2 =>
				nCS <= '1';
				state <= 0;
				
		when others => state <= 0;
	end case;

end if;

end process;

SCK <= CLK when state = 1 else '1';

END ARCHITECTURE;