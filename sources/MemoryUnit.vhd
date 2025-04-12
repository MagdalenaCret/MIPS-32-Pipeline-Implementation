----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/13/2024 04:54:06 PM
-- Design Name: 
-- Module Name: MemoryUnit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:   MODIFICARE PIPELINE
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemoryUnit is
    Port 
    ( 
        clk: in std_logic;
        enable: in std_logic;
        MemWrite: in std_logic;
        ALURes_in: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        MemData: out std_logic_vector(31 downto 0);
        AluRes_out: out std_logic_vector(31 downto 0)
    );
end MemoryUnit;

architecture Behavioral of MemoryUnit is
type RAM is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram_memory : RAM := (
    B"00000000_00000000_00000000_00000100", --A = adresa : 4   =>HEXA: 4  --ADR 0
    B"00000000_00000000_00000000_00000011", --N = numarul de elemente : 3   =>HEXA: 5 --ADR 1
    B"00000000_00000000_00000000_00000011", --X : 3  =>HEXA: 3 --ADR 2
    B"00000000_00000000_00000000_00010100", --Y : 20  =>HEXA: 14 --ADR3
    B"00000000_00000000_00000000_00000001", --1  =>HEXA: 1 --ADR4
    B"00000000_00000000_00000000_00001101", --13 =>HEXA: D --ADR 5
    B"00000000_00000000_00000000_00011000", --24 =>HEXA: 18 --ADR 6
others => X"00000000");
begin
    
    AluRes_out <= ALURes_in;
    MemData <=  ram_memory(conv_integer(ALURes_in));
    
    process(clk)
        begin
            if clk'event and clk = '1' then
              if enable = '1' then
                    if MemWrite = '1' then
                        ram_memory(conv_integer(ALURes_in)) <= rd2;
                    end if;
              end if;
            end if;
    end process;
end Behavioral;
