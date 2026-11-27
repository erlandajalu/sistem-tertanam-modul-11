library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js11_top is
Port (
    clk100Mhz : in  STD_LOGIC;
    btnR      : in  STD_LOGIC;
    sw        : in  STD_LOGIC_VECTOR(3 downto 0);
    hsync     : out STD_LOGIC;
    vsync     : out STD_LOGIC;
    vgaRed    : out STD_LOGIC_VECTOR(3 downto 0);
    vgaGreen  : out STD_LOGIC_VECTOR(3 downto 0);
    vgaBlue   : out STD_LOGIC_VECTOR(3 downto 0)
);
end js11_top;

architecture Structural of js11_top is
    signal pklk     : STD_LOGIC;
    signal video_on : STD_LOGIC;
    signal h_count  : integer range 0 to 799;
    signal v_count  : integer range 0 to 524;
    signal rgb_raw  : STD_LOGIC_VECTOR(11 downto 0);

    component clk_wiz_0
    port ( clk_in1 : in std_logic; clk_out1 : out std_logic );
    end component;

    component vga_sync
    port (
        pclk, rst : in STD_LOGIC;
        hsync, vsync, video_on : out STD_LOGIC;
        h_count : out integer range 0 to 799;
        v_count : out integer range 0 to 524
    );
    end component;

    component color_bar_pattern
    port (
        h_count : in integer range 0 to 799;
        v_count : in integer range 0 to 524;
        sw      : in std_logic_vector(3 downto 0);
        rgb_out : out std_logic_vector(11 downto 0)
    );
    end component;
begin
    XLXI_1: clk_wiz_0 port map (clk_in1 => clk100Mhz, clk_out1 => pklk);
    XLXI_2: vga_sync port map (pclk => pklk, rst => btnR, hsync => hsync, vsync => vsync, video_on => video_on, h_count => h_count, v_count => v_count);
    XLXI_3: color_bar_pattern port map (h_count => h_count, v_count => v_count, sw => sw, rgb_out => rgb_raw);

    vgaRed   <= rgb_raw(11 downto 8) when video_on = '1' else "0000";
    vgaGreen <= rgb_raw(7 downto 4)  when video_on = '1' else "0000";
    vgaBlue  <= rgb_raw(3 downto 0)  when video_on = '1' else "0000";
end Structural;