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

entity controller is
	port ( 	i_reset    : in std_logic;
			i_adv      : in std_logic;	-- next instruction button	   
			o_cycle    : out std_logic_vector(3 downto 0)
	);
end controller;

architecture Behavioral of controller is
    type ctrl_state is (CLEAR, STORE_A, STORE_B, EXEC);
    signal current_state: ctrl_state := CLEAR;
begin
    process(i_adv)
    begin
        if(i_reset = '1') then
            current_state <= CLEAR;
        else
            if(rising_edge(i_adv)) then
                case current_state is
                    when CLEAR => current_state <= STORE_A;
                    when STORE_A => current_state <= STORE_B;
                    when STORE_B => current_state <= EXEC;
                    when EXEC => current_state <= CLEAR;
                end case;
            end if;
        end if;
    end process;
    
    o_cycle <= "0010" when (current_state = STORE_A) else 
               "0100" when (current_state = STORE_B) else
               "1000" when (current_state = EXEC) else
               "0001";
    
end Behavioral;
