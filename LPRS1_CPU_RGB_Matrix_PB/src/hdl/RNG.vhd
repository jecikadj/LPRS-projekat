library ieee;
use ieee.std_logic_1164.all;

entity RNG is
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic
	);
end entity;

architecture Behavioral of RNG is
	signal sRNG      : std_logic_vector(15 downto 0);
	signal sNEXT_RNG : std_logic_vector(15 downto 0);
begin
	process (iCLK, inRST)
	begin
		if (inRST = '0') then
			sRNG <= "1010110011100001";
		elsif rising_edge(iCLK) then
			if (iBUS_WE = '1') then
				sRNG <= sNEXT_RNG;
			end if;
		end if;
	end process;
	
	sNEXT_RNG <= (((sRNG(0) xor sRNG(2)) xor sRNG(3)) xor sRNG(5)) & sRNG(15 downto 1);		-- Linear Feedback Shift Register
	
	oBUS_RD <= "0000000000000100" when sRNG(0) = '1' else
				  "0000000000000000";
end architecture;