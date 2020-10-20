----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 07.10.2019 11:42:42
-- Module Name: vga - Behavioral
-- Project Name: SpaceInv
-- Description: Divide la pantalla en una cuadricula.
--              Sigue el protocolo de control de una entrada vga.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;

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
  --Señales que almacenan la cuenta de cada contador
  signal cont_4: unsigned (1 downto 0);
  signal cont_800: unsigned (9 downto 0);
  signal cont_521: unsigned (9 downto 0);

  --Señales de habilitacion del sistema de contadores encadenados
  signal enableDiv: std_logic;
  signal enableH: std_logic;
  signal enableV: std_logic;


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
  --Coordeanada X
  process(reset,clk)
  begin
    if reset = '1' then
      cont_800 <= (OTHERS => '0');
    elsif rising_edge(clk) then
      if enableDiv = '1' then
        if enableH = '1' then
          cont_800 <= (OTHERS => '0');
        else
          cont_800 <= cont_800 + 1;
        end if;
      end if;
    end if;
  end process;
  enableH <= '1' when cont_800 = 799 else '0';

  --Contador 521
  --Coordenada Y
  process(reset,clk)
  begin
    if reset = '1' then
      cont_521 <= (OTHERS => '0');
    elsif rising_edge(clk) then
      if enableH = '1' and enableDiv = '1' then
        if enableV = '1' then
          cont_521 <= (OTHERS => '0');
        else
          cont_521 <= cont_521 + 1;
        end if;

      end if;
    end if;
  end process;
  enableV <= '1' when cont_521 = 520 else '0';

  --Asigna los colores en funcion de la señal de entrada que recibe de formatoVga
  process(color,cont_800,cont_521)
  begin
    if cont_800 <= 639 and cont_521 <= 479 then
      R <= (others => color(2));
      G <= (others => color(1));
      B <= (others => color(0));
    else
      R <= (others => '0');
      G <= (others => '0');
      B <= (others => '0');
    end if;
  end process;

  --Envia señales de sincronizacion
  Hsync <= '0' when cont_800 > 653 AND cont_800 <= 751 else '1';
  Vsync <= '0' when cont_521 > 489 AND cont_521 <= 491 else '1';


  --Envia x,y
  X <= cont_800;
  Y <= cont_521;


end Behavioral;
