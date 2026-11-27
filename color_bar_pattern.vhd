library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_bar_pattern is
Port (
    h_count  : in  integer range 0 to 799;
    v_count  : in  integer range 0 to 524;
    sw       : in  std_logic_vector(3 downto 0);
    rgb_out  : out std_logic_vector(11 downto 0)
);
end color_bar_pattern;

architecture Behavioral of color_bar_pattern is
    constant BLOCK_SIZE : integer := 32;
    signal box_x_start  : integer;
    signal box_x_end    : integer;
begin
    box_x_start <= to_integer(unsigned(sw)) * 32;
    box_x_end   <= box_x_start + 64;

    process(h_count, v_count, box_x_start, box_x_end)
        variable checker : std_logic;
    begin
        if ((h_count / BLOCK_SIZE) mod 2) = ((v_count / BLOCK_SIZE) mod 2) then
            checker := '1';
        else
            checker := '0';
        end if;

        if (h_count >= box_x_start and h_count < box_x_end and v_count >= 200 and v_count < 280) then
            rgb_out <= x"F0F"; -- Warna Kotak Interaktif (Magenta)
        else
            if checker = '1' then
                 rgb_out <= x"FFF"; -- Putih
            else
                 rgb_out <= x"008"; -- Biru Tua
            end if;
        end if;
    end process;
end Behavioral;