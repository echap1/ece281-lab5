--+----------------------------------------------------------------------------
--|
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--|
--| United States Air Force Academy     __  _______ ___    _________
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--|
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : clock_divider.vhd
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 03/2017
--| DESCRIPTION   : This file implements a generic clock divider that uses a counter and comparator.
--|					This provides more flexibility than simpler designs that use a bit from a
--|					clk bus (they only provide divisors of powers of 2).
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : None
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity register_unit is
	port ( 	write_enable  : in std_logic;
			input         : in std_logic_vector(7 downto 0);
			output        : out std_logic_vector(7 downto 0)
	);
end register_unit;

architecture Behavioral of register_unit is

begin

    process(write_enable, input)
    begin
        if write_enable = '1' then
            output <= input;
        end if;
    end process;
	
end Behavioral;
