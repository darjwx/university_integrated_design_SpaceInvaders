----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 22.11.2019 17:29:31
-- Module Name: controlLeds - Behavioral
-- Project Name: SpaceInv
-- Description: Bloque de control de los 16 leds de la placa.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity controlLeds is
  --Recibe informacion de diferentes aspectos de la partida y genera
  --un ambiente luminico acorde a cada situacion.
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         win : in std_logic;
         lose : in std_logic;
         numInvasores : in integer range 0 to 10;
         mode : in unsigned (1 downto 0);
         municion : in integer range 0 to 12;
         leds : out unsigned (15 downto 0)
         );
end controlLeds;

architecture Behavioral of controlLeds is

begin

  --
  process(reset,clk)
  begin
    if reset = '1' then
      leds <= (OTHERS => '0');
    elsif rising_edge(clk) then
      --Modo normal
      if mode = "01" then
        -- Los leds indican el numero de invasores vivos en binario.
        -- I 10
        leds <= to_unsigned(numInvasores,16);
        --Modo dificil
      elsif mode = "10" then
        -- Los leds indican el numero de balas disponibles en binario.
        -- B 12
        leds <= to_unsigned(municion,16);
        --Victoria
      elsif win = '1' then
        --Ilumina todos los leds.
        --Has ganado, el puente esta tendido.
        leds <= "1111111111111111";
        --Derrota
      elsif lose = '1' or municion = 0 then
        --Solo algunos leds iluminados.
        --No alcanzaras tus metas con una derrota.
        leds <= "1111100000000000";
      end if;
    end if;
  end process;



end Behavioral;
