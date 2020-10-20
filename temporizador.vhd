-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 21.10.2019 21:27:52
-- Module Name: temporizador - Behavioral
-- Project Name: SpaceInv
-- Description: Temporizador generico que permite definir un valor de cuenta maxima.
--              Reset asincrono. Enable y clear sincronos.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity temporizador is
  --Permite definir una cuenta maxima diferente con cada instanciacion
  --Por defecto cuenta es de 8 bits.
  generic(
    ancho : integer := 8
  );
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clear : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Cuenta : out unsigned (ancho-1 downto 0)
    );
end temporizador;

architecture Behavioral of temporizador is
  signal rCuenta : unsigned (ancho-1 downto 0);

begin

  --Incrementa la cuenta con cada flanco de reloj.
  process(clk,reset)
  begin
    if reset = '1' then
      rCuenta <= (Others => '0');
    elsif rising_edge(clk) then
      if enable = '1' then
        rCuenta <= rCuenta + 1;
      end if;
      if clear = '1' then
        rCuenta <= (Others => '0');
      end if;
    end if;
  end process;

  Cuenta <= rCuenta;

end Behavioral;
