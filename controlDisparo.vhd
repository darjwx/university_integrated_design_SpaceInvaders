----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 09.11.2019 11:01:15
-- Module Name: controlDisparo - Behavioral
-- Project Name: SpaceInv
-- Description: Bloque de control del disparo.
--              Movimiento y posicion en cada instante de la bala.
--              Contempla llegar al final de la pantalla o eliminar a un invasor.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity controlDisparo is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           disparar : in std_logic;
           naveH : in integer range 0 to 19;
           inicio : in std_logic;
           disparoH : out integer range 0 to 19;
           disparoV : out integer range 0 to 14);
end controlDisparo;

architecture Behavioral of controlDisparo is
  component temporizador
    Generic(ancho : integer
    );
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clear : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Cuenta : out unsigned (ancho-1 downto 0)
    );
  end component;

  --Señales del temporizador.
  signal Clear : STD_LOGIC;
  signal Enable : STD_LOGIC;
  signal Cuenta : unsigned (26 downto 0);

  signal s : std_logic;
  signal move : std_logic;
  signal aux : std_logic;
  signal rdisparoV : integer range 0 to 14;

begin
  ctemp: temporizador generic map(27) port map(clk,reset,clear,enable,cuenta);

  --Activa el temporizador cuando disparamos
  process(disparar)
  begin
    if disparar = '1' then
      enable <= '1';
    else
      enable <= '0';
    end if;
  end process;

  --Controla el movimiento de la bala.
  --El movimiento esta condicionado a una señal que depende del temporizador.
  --La bala desaparece si eliminamos a un invasor o si llegamos al final de la pantalla
  process(reset,clk)
  begin
    if reset = '1' then
      disparoH <= 9;
      rdisparoV <= 14;
    elsif rising_edge(clk) then
      if inicio = '1' then
        disparoH <= naveH;
        rdisparoV <= 14;
      elsif disparar = '0' then
        disparoH <= naveH;
        rdisparoV <= 14;
      elsif move = '1' then
        if rdisparoV = 14 then
          disparoH <= naveH;
        end if;
        rdisparoV <= rdisparoV - 1;
      end if;
    end if;
  end process;

 --Limpia la cuenta y manda una señal cuando llegamos al valor definido.
 --Usamos el temporizador para definir la velocidad de la bala.
 --Aproximadamente 55ms
  process(cuenta)
  begin
    if cuenta = 11111111 then
      s <= '1';
      clear <= '1';
    else
      s <= '0';
      clear <= '0';
    end if;
  end process;

  --Detector de flanco de subida.
  --Habilita el movimientode la bala cuando se alcanza el valor de cuenta
  process(reset,clk)
  begin
    if reset = '1' then
      aux <= '0';
    elsif rising_edge(clk) then
      aux <= s;
    end if;
  end process;
  move <= '1' when s = '1' and aux = '0' else '0';

  disparoV <= rdisparoV;



end Behavioral;
