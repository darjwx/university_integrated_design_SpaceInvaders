----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 21.10.2019 12:00:51
-- Module Name: invasores - Behavioral
-- Project Name: SpaceInv
-- Description: Bloque de control de los invasores.
--              Movimiento, posicion y numero de invasores en cada instante y
--              condiciones de victoria relacionadas con ellos.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity invasores is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           inicio : in std_logic;
           disparoH : in integer range 0 to 19;
           disparoV : in integer range 0 to 14;
           mode : in unsigned (1 downto 0);
           invadersH : out unsigned (0 to 19);
           invadersV : out integer range 0 to 14;
           eliminado : out std_logic;
           win : out std_logic;
           lose : out std_logic;
           numInvasores : out integer range 0 to 10
           );
end invasores;

architecture Behavioral of invasores is
  component temporizador
    generic(
      ancho : integer
      );
    port(Clk : in STD_LOGIC;
         Reset : in STD_LOGIC;
         Clear : in STD_LOGIC;
         Enable : in STD_LOGIC;
         Cuenta : out unsigned (ancho-1 downto 0)
         );
       end component;
  signal rInvadersH : unsigned (0 to 19);
  signal rInvadersV : integer range 0 to 14;

  signal dir : std_logic;

  signal clear : std_logic;
  signal cuenta : unsigned(26 downto 0);
  signal enable : std_logic;
  signal move : std_logic;

  signal s : std_logic;
  signal aux : std_logic;

  signal numInv : integer range 0 to 10;

begin
  --Instanciacion del temporizador. Define la velocidad de movimiento de los invasores.
  uut: temporizador generic map(27) port map(clk,reset,clear,enable,cuenta);

  --Asigna a las salidas la posicion de los invasores y el numero de ellos vivos.
  invadersH <= rInvadersH;
  invadersV <= rInvadersV;
  numInvasores <= numInv;

  --Movimiento de los invasores
  process(reset,clk)
  begin
    if reset = '1' then
      rInvadersH <= "00000000001111111111";
      rInvadersV <= 0;
      dir <= '1';
      numInv <= 10;
    elsif rising_edge(clk) then
      if rInvadersV = disparoV and rInvadersH(disparoH) = '1' then
        rInvadersH(disparoH) <= '0';
        eliminado <= '1';
        numInv <= numInv - 1;
      else
        eliminado <= '0';
      end if;
      if inicio = '1' then
        rInvadersH <= "00000000001111111111";
        rInvadersV <= 0;
      elsif move = '1' and mode /= "00" then
        if dir = '0' then
          --11111111110000000000
          if rInvadersH(19) = '1' then
            rInvadersV <= rInvadersV + 1;
            dir <= '1';
          else
            rInvadersH <= '0' & rInvadersH(0 to 18);
          end if;
        elsif dir = '1' then
          --00000000001111111111
          if rInvadersH(0) = '1' then
            rInvadersV <= rInvadersV + 1;
            dir <= '0';
          else
            rInvadersH <= rInvadersH(1 to 19) & '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  enable <= '1';
  process(cuenta,numInv)
  begin
    -- La velocidad de los invasores aumenta cada vez que uno muere
    --Tiempo inicial: 450ms (10 vivos)
    --Tiempo final: 260ms (1 vivo)
    if cuenta = (50000000 + 2000000 * numInv)  then
      s <= '1';
      clear <= '1';
    else
      s <= '0';
      clear <= '0';
    end if;
  end process;

  --Habilita elmovimiento de los invasores
  process(reset,clk)
  begin
    if reset = '1' then
      aux <= '0';
    elsif rising_edge(clk) then
      aux <= s;
    end if;
  end process;
  move <= '1' when s = '1' and aux = '0' else '0';

  --Define si hemos ganado o no en funcion del numero de invasores y de su posicion vertical.
  process(rInvadersH,rInvadersV)
  begin
    if rInvadersH = 0 then
      win <= '1';
      lose <= '0';
    elsif rInvadersV = 14 then
      win <= '0';
      lose <= '1';
    else
      win <= '0';
      lose <= '0';
    end if;
  end process;

end Behavioral;
