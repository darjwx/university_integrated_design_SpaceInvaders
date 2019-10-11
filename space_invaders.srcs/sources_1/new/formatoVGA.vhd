----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07.10.2019 11:44:18
-- Design Name:
-- Module Name: formatoVGA - Behavioral
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

entity formatoVGA is
    Port ( X : in UNSIGNED (9 downto 0);
           Y : in UNSIGNED (9 downto 0);
           Color : out UNSIGNED (3 downto 0));
end formatoVGA;

architecture Behavioral of formatoVGA is
signal rX: unsigned (4 downto 0);
signal rY: unsigned (4 downto 0);
begin

  rX <= X(9)&X(8)&X(7)&X(6)&X(5);
  rY <= Y(9)&Y(8)&Y(7)&Y(6)&Y(5);

  process(X,Y)
  begin
    if rY(0) = '0' and rX(0) = '0' then
      --color blanco
    elsif rY(0) = '0' and rX(0) = '1' then
      --color negro
    elsif rY(0) ='1' and rX(0) = '0' then
      ----color negro
    elsif rY(0) = '1' and rX(0) = '1' then
      --blanco
    end if;
  end process;


end Behavioral;
