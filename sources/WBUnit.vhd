----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/13/2024 04:54:39 PM
-- Design Name: 
-- Module Name: WBUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:  MODIFICARE PIPELINE
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity WBUnit is
Port 
    ( 
    MemToReg: in std_logic;
    MemData: in std_logic_vector(31 downto 0);
    ALURes_out: in std_logic_vector(31 downto 0);
    WD: out std_logic_vector(31 downto 0)
    );
end WBUnit;
  
architecture Behavioral of WBUnit is
begin
   
    WD <= ALURes_out when MemToReg = '0' else MemData;

end Behavioral;
