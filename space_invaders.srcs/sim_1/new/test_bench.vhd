----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 13.10.2019 17:35:23
-- Design Name:
-- Module Name: test_bench - Behavioral
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

entity test_bench is
--  Port ( );
end test_bench;

architecture Behavioral of test_bench is

    component SpaceInv
      Port ( Clk : in STD_LOGIC;
             Reset : in STD_LOGIC;
             Hsync : out STD_LOGIC;
             Vsync : out STD_LOGIC;
             R : out UNSIGNED (3 downto 0);
             G : out UNSIGNED (3 downto 0);
             B : out UNSIGNED (3 downto 0));
    end component;

    signal Clk : std_logic := '0';
    signal Reset : std_logic;
    signal Hsync : std_logic;
    signal Vsync : std_logic;
    signal R : unsigned (3 downto 0);
    signal G : unsigned (3 downto 0);
    signal B : unsigned (3 downto 0);
begin

    csinv: SpaceInv port map(Clk,Reset,Hsync,Vsync,R,G,B);

    --Reset <= '1', '0' after 10 ns;
    --Clk <= not Clk after 5 ps;


end Behavioral;
