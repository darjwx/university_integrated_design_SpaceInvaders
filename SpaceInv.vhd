----------------------------------------------------------------------------------
-- Company: UC3M
-- Engineers: Dario Jimenez Juiz
--            Gabriel Minelli Lli
--            Alvaro Manzanero Moran
--
-- Create Date: 07.10.2019 11:46:58
-- Parent entity
-- Module Name: SpaceInv - Behavioral
-- Project Name: SpaceInv
-- Description: Entidad superior.
--              Enlaza las demas entidades y recoge el valor de todos los pulsadores
--              y otros elementos de la placa.
--              Control general del estado del juego y asignacion condicional de determinadas salidas
--              mediante una maquina de estados.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SpaceInv is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           botonIz : in std_logic;
           botonDer : in std_logic;
           Disparo : in std_logic;
           Inicio : in std_logic;
           Salir : in std_logic;
           Load : in std_logic;
           GameMode : in std_logic;
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           R : out UNSIGNED (3 downto 0);
           G : out UNSIGNED (3 downto 0);
           B : out UNSIGNED (3 downto 0);
           leds : out unsigned (15 downto 0));
end SpaceInv;

architecture Behavioral of SpaceInv is
  --Instanciaciones de los distintos bloques del sistema.
    component vga
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
      end component;

      component formatoVga
          Port ( X : in UNSIGNED (9 downto 0);
                 Y : in UNSIGNED (9 downto 0);
                 test : in std_logic;
                 invadersH : in unsigned (0 to 19);
                 invadersV : in integer range 0 to 14;
                 naveH : in integer range 0 to 19;
                 disparoH : in integer range 0 to 19;
                 disparoV : in integer range 0 to 14;
                 mensajeV : in std_logic;
                 mensajeD : in std_logic;
                 Color : out UNSIGNED (2 downto 0));
      end component;

      component invasores
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
      end component;

      component nave
        Port ( clk : in std_logic;
               reset : in std_logic;
               derecha : in STD_LOGIC;
               izquierda : in STD_LOGIC;
               Inicio : in std_logic;
               mode : in unsigned (1 downto 0);
               naveH : out integer range 0 to 19
               );
      end component;

      component gestionEntradas
        Port ( clk : in std_logic;
               reset : in std_logic;
               botonIz : in STD_LOGIC;
               botonDer : in STD_LOGIC;
               izquierda : out STD_LOGIC;
               derecha : out STD_LOGIC
        );
      end component;

      component controlDisparo
        Port ( reset : in STD_LOGIC;
               clk : in STD_LOGIC;
               disparar : in std_logic;
               naveH : in integer range 0 to 19;
               inicio : in std_logic;
               disparoH : out integer range 0 to 19;
               disparoV : out integer range 0 to 14
        );
      end component;

      component controlLeds is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               win : in std_logic;
               lose : in std_logic;
               numInvasores : in integer range 0 to 10;
               mode : in unsigned (1 downto 0);
               municion : in integer range 0 to 12;
               leds : out unsigned (15 downto 0)
               );
      end component;

      signal color : unsigned (2 downto 0);
      signal X : unsigned (9 downto 0);
      signal Y : unsigned (9 downto 0);
      signal test : std_logic;

      signal invadersH : unsigned (0 to 19);
      signal invadersV : integer range 0 to 14;
      signal win : std_logic;
      signal lose : std_logic;
      signal mensajeV : std_logic;
      signal mensajeD : std_logic;

      signal derecha : std_logic;
      signal izquierda : std_logic;
      signal naveH : integer range 0 to 19;

      signal disparoH : integer range 0 to 19;
      signal disparoV : integer range 0 to 14;
      signal eliminado : std_logic;
      signal disparar : std_logic;

      signal numInvasores : integer range 0 to 10;
      signal mode : unsigned (1 downto 0); --00 Apagado, 01 normalMode, 10 hardMode, 11 disparando
      signal municion : integer range 0 to 12;

      type estados is (debug,start,normalMode,hardMode,disparando,ganado,perdido);
      signal actual,siguiente : estados;



begin

-- Instanciaciones de componentes
--Bloque funcional de la vga
cvga: vga port map(Clk,Reset,Color,Hsync,Vsync,R,G,B,X,Y);
--Manda los colores y lo que se pinta a la vga
cformVga: formatoVga port map(X,Y,test,invadersH,invadersV,naveH,disparoH,disparoV,mensajeV,mensajeD,color);
--Bloque de control de los invasores
cinvasores: invasores port map(clk,reset,inicio,disparoH,disparoV,mode,invadersH,invadersV,eliminado,win,lose,numInvasores);
--Bloque de control de la nave
cnave: nave port map(clk,reset,derecha,izquierda,Inicio,mode,naveH);
--Bloque de control de las entradas. Boton izquierda y derecha. Sistema anti-rebotes
cgestionEntradas: gestionEntradas port map(clk,reset,botonIz,botonDer,izquierda,derecha);
--Bloque de control del disparo
ccontroldisparo: controlDisparo port map(reset,clk,disparar,naveH,inicio,disparoH,disparoV);
--Bloque de control de los leds
cleds: controlLeds port map(clk,reset,win,lose,numInvasores,mode,municion,leds);

-- Maquina de estados
process(reset,clk)
begin
  if reset = '1' then
    actual <= debug;
  elsif rising_edge(clk) then
    actual <= siguiente;
  end if;
end process;

process(actual,inicio,disparo,win,lose,eliminado,disparoV,Salir,Load,GameMode,municion)
begin
  case actual is
    when debug =>
    test <= '1';
    disparar <= '0';
    mensajeV <= '0';
    mensajeD <= '0';
    mode <= "00";
    if Load = '1' then
      siguiente <= start;
    else
      siguiente <= debug;
    end if;

    when start =>
    test <= '0';
    disparar <= '0';
    mensajeV <= '0';
    mensajeD <= '0';
    mode <= "00";
    -- Espera tecla para iniciar
    -- Dos modos de juego
    if Inicio = '1' then
      siguiente <= normalMode;
    elsif GameMode = '1' then
      siguiente <= hardMode;
    else
      siguiente <= start;
    end if;

    when normalMode =>
    test <= '0';
    disparar <= '0';
    mensajeV <= '0';
    mensajeD <= '0';
    mode <= "01";
      if disparo = '1' then
        siguiente <= disparando;
      elsif win = '1' then
        siguiente <= ganado;
      elsif lose = '1' then
        siguiente <= perdido;
      else
        siguiente <= normalMode;
      end if;

    when hardMode =>
    test <= '0';
    disparar <= '0';
    mensajeV <= '0';
    mensajeD <= '0';
    mode <= "10";
      if disparo = '1' and municion > 0 then
        siguiente <= disparando;
      elsif win = '1' then
        siguiente <= ganado;
      elsif lose = '1' or municion = 0 then
        siguiente <= perdido;
      else
        siguiente <= hardMode;
      end if;
    when disparando =>
    test <= '0';
    disparar <= '1';
    mensajeV <= '0';
    mensajeD <= '0';
    mode <= "11";
      if (eliminado = '1' or disparoV = 0) and GameMode = '0' then --Normal
        siguiente <= normalMode;
      elsif (eliminado = '1' or disparoV = 0) and GameMode = '1' then --Hard
        siguiente <= hardMode;
      else
        siguiente <= disparando;
      end if;
    when ganado =>
    -- Mensaje victoria
    test <= '0';
    disparar <= '0';
    mensajeV <= '1';
    mensajeD <= '0';
    mode <= "00";
    --Dar a elegir que hacer
    if inicio = '1' then
      siguiente <= start;
    else
      siguiente <= ganado;
    end if;
    when perdido =>
    -- Mensaje derrota
    test <= '0';
    disparar <= '0';
    mensajeV <= '0';
    mensajeD <= '1';
    mode <= "00";
    --Dar a elegir que hacer
    if Salir = '1' then
      siguiente <= debug;
    else
      siguiente <= perdido;
    end if;

    when others =>
    test <= '0';
    disparar <= '0';
    mensajeV <= '0';
    mensajeD <= '0';
    mode <= "00";
    siguiente <= debug;

  end case;
end process;

-- Control de la municion para el modo dificil
process(reset,clk)
begin
  if reset = '1' then
    municion <= 12;
  elsif rising_edge(clk) then
    if disparo = '1' and mode /= "11" then
      municion <= municion - 1;
    end if;
  end if;
end process;




end Behavioral;
