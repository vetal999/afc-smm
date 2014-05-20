LIBRARY ieee;
USE ieee.std_logic_1164.all;

--  Entity Declaration
ENTITY pid_controller IS
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
	
END pid_controller;


ARCHITECTURE arch OF pid_controller IS

	signal data : std_logic_vector(15 downto 0);
	
	signal state : integer range 0 to 3 := 0;
BEGIN



end architecture;
