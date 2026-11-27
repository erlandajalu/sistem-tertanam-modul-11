library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
Port (
    pclk     : in  STD_LOGIC; -- pixel clock baru, 40 MHz
    rst      : in  STD_LOGIC;
    hsync    : out STD_LOGIC;
    vsync    : out STD_LOGIC;
    video_on : out STD_LOGIC;
    h_count  : out integer range 0 to 1055; -- Total horizontal 800 + porch/sync = 1056
    v_count  : out integer range 0 to 627   -- Total vertikal 600 + porch/sync = 628
);
end vga_sync;

architecture Behavioral of vga_sync is
    -- Parameter Pewaktuan untuk Resolusi 800x600@60Hz (Pixel Clock ~40 MHz)
    constant H_DISPLAY : integer := 800;
    constant H_FPORCH  : integer := 40;
    constant H_SYNC    : integer := 128;
    constant H_BPORCH  : integer := 88;
    constant H_TOTAL   : integer := 1056;

    constant V_DISPLAY : integer := 600;
    constant V_FPORCH  : integer := 1;
    constant V_SYNC    : integer := 4;
    constant V_BPORCH  : integer := 23;
    constant V_TOTAL   : integer := 628;

    signal hc : integer range 0 to 1056 := 0;
    signal vc : integer range 0 to 628  := 0;
begin

    process(pclk, rst)
    begin
        if rst = '1' then
            hc <= 0;
            vc <= 0;
        elsif rising_edge(pclk) then
            if hc = H_TOTAL - 1 then
                hc <= 0;
                if vc = V_TOTAL - 1 then
                    vc <= 0;
                else
                    vc <= vc + 1;
                end if;
            else
                hc <= hc + 1;
            end if;
        end if;
    end process;

    hsync    <= '0' when (hc >= H_DISPLAY + H_FPORCH) and (hc < H_DISPLAY + H_FPORCH + H_SYNC) else '1';
    vsync    <= '0' when (vc >= V_DISPLAY + V_FPORCH) and (vc < V_DISPLAY + V_FPORCH + V_SYNC) else '1';
    video_on <= '1' when (hc < H_DISPLAY) and (vc < V_DISPLAY) else '0';
    
    h_count  <= hc;
    v_count  <= vc;

end Behavioral;