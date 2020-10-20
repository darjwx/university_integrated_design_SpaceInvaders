----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 28.10.2019 09:54:00
-- Module Name: gestionEntradas - Behavioral
-- Project Name: SpaceInv
-- Description: Detector de flancos para cada boton contemplado en el bloque
--              y sistema anti-rebotes.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity gestionEntradas is
    Port ( clk : in std_logic;
           reset : in std_logic;
           botonIz : in STD_LOGIC;
           botonDer : in STD_LOGIC;
           izquierda : out STD_LOGIC;
           derecha : out STD_LOGIC);
end gestionEntradas;

architecture Behavioral of gestionEntradas is

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

  --Señales auxiliares de los detectores de flanco y el sistema anti rebotes
  signal aux1 : std_logic;
  signal aux2 : std_logic;
  signal auxIzquierda : std_logic;
  signal auxDerecha : std_logic;

  --Señales del temporizador
  signal clear : std_logic;
  signal enable : std_logic;
  signal cuenta : unsigned(24 downto 0);

begin

  ctemp: temporizador generic map(25) port map(clk,reset,clear,enable,cuenta);

  --Detector de flanco de bajada del boton izquierda
  process(reset,clk)
  begin
    if reset = '1' then
      aux1 <= '0';
    elsif rising_edge(clk) then
      aux1 <= botonIz;
    end if;
  end process;
  auxIzquierda <= '1' when botonIz = '0' and aux1 = '1' else '0';

  --Solo aceptamos la primera pulsacion. Para evita rebotes usamos un temporizador.
  izquierda <= '1' when auxIzquierda = '1' and cuenta = 0 else '0';

  --Detector de flanco de bajada del boton derecha
  process(reset,clk)
  begin
    if reset = '1' then
      aux2 <= '0';
    elsif rising_edge(clk) then
      aux2 <= botonDer;
    end if;
  end process;
  auxDerecha <= '1' when botonDer = '0' and aux2 = '1' else '0';

  --Solo aceptamos la primera pulsacion. Para evita rebotes usamos un temporizador.
  derecha <= '1' when auxDerecha = '1' and cuenta = 0 else '0';

  --Durante 100ms cada vez que detectamos un flanco de bajada bloqueamos
  --los subsiguientes pulsos para evitar rebotes.
  process(reset,clk)
  begin
    if reset = '1' then
      enable <= '0';
    elsif rising_edge(clk) then
      if auxDerecha = '1' or auxIzquierda = '1' then
        enable <= '1';
        clear <= '0';
      elsif cuenta = 20000000 then
        enable <= '0';
        clear <= '1';
      end if;
    end if;
    end process;

end Behavioral;
