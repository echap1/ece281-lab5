----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 02/20/2024 02:03:25 PM
-- Design Name:
-- Module Name: sevenSegDecoder
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0));
end sevenSegDecoder;

architecture sevenSegDecoder_arch of sevenSegDecoder is

signal D0, D1, D2, D3, Sa, Sb, Sc, Sd, Se, Sf, Sg: std_logic := '0';

begin

D0 <= i_D(0);
D1 <= i_D(1);
D2 <= i_D(2);
D3 <= i_D(3);

o_S(0) <= '1' when (
    (i_D = x"1") or
    (i_D = x"4") or
    (i_D = x"B") or
    (i_D = x"A") or
    (i_D = x"C") or
    (i_D = x"D") ) else '0';

o_S(1) <= '1' when (
    (i_D = x"5") or
    (i_D = x"6") or
    (i_D = x"B") or
    (i_D = x"A") or
    (i_D = x"C") or
    (i_D = x"E") or
    (i_D = x"F") ) else '0';

o_S(2) <= '1' when (
    (i_D = x"2") or
    (i_D = x"B") or
    (i_D = x"A") or
    (i_D = x"C") or
    (i_D = x"E") or
    (i_D = x"F") ) else '0';

o_S(3) <= '1' when (
    (i_D = x"1") or
    (i_D = x"B") or
    (i_D = x"4") or
    (i_D = x"7") or
    (i_D = x"9") or
    (i_D = x"A") or
    (i_D = x"F") ) else '0';

o_S(4) <= '1' when (
    (i_D = x"1") or
    (i_D = x"3") or
    (i_D = x"4") or
    (i_D = x"B") or
    (i_D = x"A") or
    (i_D = x"5") or
    (i_D = x"7") or
    (i_D = x"9") ) else '0';

o_S(5) <= '1' when (
    (i_D = x"1") or
    (i_D = x"2") or
    (i_D = x"3") or
    (i_D = x"7") or
    (i_D = x"A") or
    (i_D = x"B") or
    (i_D = x"C") or
    (i_D = x"D") ) else '0';

o_S(6) <= '1' when (
    (i_D = x"0") or
    (i_D = x"B") or
    (i_D = x"1") or
    (i_D = x"7") ) else '0';

--o_S(0) <= Sa;
--o_S(1) <= Sb;
--o_S(2) <= Sc;
--o_S(3) <= Sd;
--o_S(4) <= Se;
--o_S(5) <= Sf;
--o_S(6) <= Sg;

end sevenSegDecoder_arch;
