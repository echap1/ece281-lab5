--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(15 downto 0);
        btnU    :   in std_logic; -- reset
        btnC    :   in std_logic; -- next instruction
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
    component controller is
	port ( 	i_reset    : in std_logic;
			i_adv      : in std_logic;	-- next instruction button	   
			o_cycle    : out std_logic_vector(3 downto 0)  -- one hot encoded step
	);
    end component controller;

    component register_unit is
	port ( 	write_enable  : in std_logic;
			input         : in std_logic_vector(7 downto 0);
			output        : out std_logic_vector(7 downto 0)
	);
    end component register_unit;
    
    component ALU is
        Port ( i_op : in  std_logic_vector (2 downto 0);
               i_A : in  signed(7 downto 0);
               i_B : in  signed(7 downto 0);
               o_num : out  signed(7 downto 0);
               o_flag : out  std_logic_vector (2 downto 0)
        );
    end component ALU;
    
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic;
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_reset        : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;
    
    component clock_divider is
        generic ( constant k_DIV : natural := 2    ); -- How many clk cycles until slow clock toggles
                                                   -- Effectively, you divide the clk double this 
                                                   -- number (e.g., k_DIV := 2 --> clock divider of 4)
        port (  i_clk    : in std_logic;
                i_reset  : in std_logic;           -- asynchronous
                o_clk    : out std_logic           -- divided (slow) clock
        );
    end component clock_divider;
    
    component sevenSegDecoder is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
               o_S : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenSegDecoder;
    
    signal w_cycle: std_logic_vector(3 downto 0);
    signal w_reg_a: std_logic_vector(7 downto 0);
    signal w_reg_b: std_logic_vector(7 downto 0);
    
    signal w_num: signed(7 downto 0);
    
    signal w_num_disp: std_logic_vector(7 downto 0);
    signal w_out_num: std_logic_vector(3 downto 0);
    
    signal w_negative: std_logic;
    signal w_negative_vec: std_logic_vector(3 downto 0);
    signal w_hundreds: std_logic_vector(3 downto 0);
    signal w_tens: std_logic_vector(3 downto 0);
    signal w_ones: std_logic_vector(3 downto 0);
    
    signal w_clk: std_logic;
begin
    controller_inst: controller
    port map(
        i_reset => btnU,
        i_adv => btnC,
        o_cycle => w_cycle
    );
    
    reg_A: register_unit
    port map(
        write_enable => w_cycle(1),
        input => sw(7 downto 0),
        output => w_reg_a
    );
            
    reg_B: register_unit
    port map(
        write_enable => w_cycle(2),
        input => sw(7 downto 0),
        output => w_reg_b
    );
    
    alu_inst: ALU
    port map(
        i_op => sw(2 downto 0),
        i_A => signed(w_reg_a),
        i_B => signed(w_reg_b),
        o_num => w_num,
        o_flag => led(15 downto 13)
    );
    
    w_num_disp <= w_reg_a when (w_cycle = "0010") else
                  w_reg_b when (w_cycle = "0100") else
                  std_logic_vector(w_num) when (w_cycle = "1000") else
                  "00000000";
    
    twoscomp_decimal_inst: twoscomp_decimal
    port map(
        i_binary => w_num_disp,
        o_negative => w_negative,
        o_hundreds => w_hundreds,
        o_tens => w_tens,
        o_ones => w_ones
    );
    
    clock_divider_inst: clock_divider
    generic map ( k_DIV => 50000000 / 600 )
    port map(
        i_reset => btnU,
        i_clk => clk,
        o_clk => w_clk
    );
    
    w_negative_vec <= x"A" when (w_negative = '1') else x"B";
    
    tdm: TDM4
    port map(
        i_clk => w_clk,
        i_reset => btnU,
        i_D3 => w_negative_vec,
        i_D2 => w_hundreds,
        i_D1 => w_tens,
        i_D0 => w_ones,
        o_sel => an,
        o_data => w_out_num
    );
    
    led(12 downto 0) <= (
        3 => w_cycle(3),
        2 => w_cycle(2),
        1 => w_cycle(1),
        0 => w_cycle(0),
        others => '0'
    );
    
    sevenSegDecoder_inst: sevenSegDecoder
    port map(
        i_D => w_out_num,
        o_S => seg
    );
    
	
end top_basys3_arch;
