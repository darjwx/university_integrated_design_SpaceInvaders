----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07.10.2019 11:46:58
-- Design Name:
-- Module Name: SpaceInv - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SpaceInv is
    Port ( Clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC;
           R : out UNSIGNED (3 downto 0);
           G : out UNSIGNED (3 downto 0);
           B : out UNSIGNED (3 downto 0));
end SpaceInv;

architecture Behavioral of SpaceInv is
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
                 Color : out UNSIGNED (2 downto 0)
                );
      end component;

      signal color : unsigned (2 downto 0);
      signal X : unsigned (9 downto 0);
      signal Y : unsigned (9 downto 0);

begin

cvga: vga port map(Clk,Reset,Color,Hsync,Vsync,R,G,B,X,Y);
cformVga: formatoVga port map(X,Y,color);


end Behavioral;
