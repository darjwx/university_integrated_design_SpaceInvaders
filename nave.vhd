----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 21.10.2019 12:46:22
-- Module Name: nave - Behavioral
-- Project Name: SpaceInv
-- Description: Bloque de control de la nave.
--              Movimiento y posicion en cada instante.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity nave is
    Port ( clk : in std_logic;
           reset : in std_logic;
           derecha : in STD_LOGIC;
           izquierda : in STD_LOGIC;
           Inicio : in std_logic;
           mode : in unsigned (1 downto 0);
           naveH : out integer range 0 to 19
           );
end nave;

architecture Behavioral of nave is

--Coordenada horizontal de la nave
--Vertical = 14 siempre
signal rNaveH : integer range 0 to 19;

begin

  --Mueve la nave siempre que se recibe un 1 en la entrada izquierda o derecha.
  --Esas entradas se controlan en otro bloque y tienen proteccion anti rebotes.
  --Si la nave se encuentra en un extremo de la pantalla no se movera al recibir
  --una orden hacia ese lado.
  process(reset,clk)
  begin
    if reset = '1' then
      rNaveH <= 9;
    elsif rising_edge(clk) then
      if inicio = '1' then
        rNaveH <= 9;
      elsif derecha = '1' and mode /= "00" then
        if rNaveH < 19 then
          rNaveH <= rNaveH + 1;
        end if;
      elsif izquierda = '1' and mode /= "00" then
        if rNaveH > 0 then
          rNaveH <= rNaveH - 1;
        end if;
      end if;
    end if;
  end process;
  naveH <= rNaveH;

end Behavioral;
