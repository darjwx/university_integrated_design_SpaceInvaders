----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07.10.2019 11:42:42
-- Design Name:
-- Module Name: vga - Behavioral
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
use ieee.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( Clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           color : in UNSIGNED (2 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           R : out UNSIGNED (3 downto 0);
           G : out UNSIGNED (3 downto 0);
           B : out UNSIGNED (3 downto 0);
           X : out UNSIGNED (9 downto 0);
           Y : out UNSIGNED (9 downto 0)
      );
end vga;

architecture Behavioral of vga is
  signal cont_4: unsigned (1 downto 0);
  signal cont_800: unsigned (9 downto 0);
  signal cont_521: unsigned (9 downto 0);

  signal enableDiv: std_logic;
  signal enableH: std_logic;
  signal enableV: std_logic;

  signal rX: unsigned (9 downto 0);
  signal rY: unsigned (9 downto 0);

begin
  -- Contador divisor de frecuancia
  process(reset,clk)
  begin
    if reset = '1' then
      cont_4 <= "00";
    elsif rising_edge(clk) then
      cont_4 <= cont_4 + 1;
    end if;
  end process;
  enableDiv <= '1' when cont_4 = "11" else '0';

  -- Contador 800
  process(reset,clk)
  begin
    if reset = '1' then
      cont_800 <= (OTHERS => '0');
    elsif rising_edge(clk) then
      if enableDiv = '1' then
      cont_800 <= cont_800 + 1;
      end if;
      if enableH = '1' then
        cont_800 <= (OTHERS => '0');
      end if;
    end if;
  end process;
  enableH <= '1' when cont_800 = 799 else '0';

  --Contador 521
  process(reset,clk)
  begin
    if reset = '1' then
      cont_521 <= (OTHERS => '0');
    elsif rising_edge(clk) then
      if enableH = '1' then
      cont_521 <= cont_521 + 1;
      end if;
      if enableV = '1' then
        cont_521 <= (OTHERS => '0');
      end if;
    end if;
  end process;
  enableV <= '1' when cont_521 = 520 else '0';

  process(color)
  begin
    if color = "000" then
      R <= "0000";
      G <= "0000";
      B <= "0000";
    elsif color = "111" then
      R <= "1111";
      G <= "1111";
      B <= "1111";
    end if;
  end process;

  --Envia señales de sincronizacion
  Hsync <= '1' when cont_800 > 653 AND cont_800 < 751 else '0';
  Vsync <= '1' when cont_521 > 489 AND cont_521 < 491 else '0';

  --Envia x,y
  X <= cont_800;
  Y <= cont_521;

end Behavioral;
