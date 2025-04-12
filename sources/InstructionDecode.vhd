----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/12/2024 11:14:19 PM
-- Design Name: 
-- Module Name: InstructionDecode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: MODIFICARE PIPELINE
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

entity InstructionDecode is
Port (
      clk: in std_logic;
      enable: in std_logic;
      RegWrite: in std_logic;
      Instr: in std_logic_vector(25 downto 0);
     -- RegDst: in std_logic; --trebuie eliminat pentru Pipeline
      ExtOp: in std_logic;
      RD1: out std_logic_vector(31 downto 0);
      RD2: out std_logic_vector(31 downto 0);
      WD: in std_logic_vector(31 downto 0);
      Ext_Imm: out std_logic_vector(31 downto 0);
      func: out std_logic_vector(5 downto 0);
      sa: out std_logic_vector(4 downto 0);
      --------------------------------------------
      --modificari Pipeline
      WA: in std_logic_vector(4 downto 0);
      rt: out std_logic_vector(4 downto 0);
      rd: out std_logic_vector(4 downto 0)
      );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

--Register File
type REG is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file: REG := (others => X"00000000");

signal WriteAddress: std_logic_vector(4 downto 0):= (others => '0');
signal RegAddress: std_logic_vector(4 downto 0):= (others => '0');

signal ext_sign: std_logic_vector(15 downto 0):= (others => '0');

begin

  --WriteAddress <= Instr(20 downto 16) when RegDst = '0' else  Instr(15 downto 11);
  --modificare Pipeline
   WriteAddress <= WA; 
   rt <= Instr(20 downto 16);
   rd <= Instr(15 downto 11);
   
    process(clk)
        begin
            if clk'event and clk = '0' then
              if enable = '1' and RegWrite = '1' then
                reg_file(conv_integer(WriteAddress)) <= WD;
              end if;
            end if;
     end process;    

RD1 <= reg_file(conv_integer(Instr(25 downto 21)));
RD2 <= reg_file(conv_integer(Instr(20 downto 16)));

func <= Instr(5 downto 0);
sa <= Instr(10 downto 6);

--Immediate extend
ext_sign <= (others => Instr(15));
Ext_Imm <= X"0000" & Instr(15 downto 0) when ExtOp = '0' else ext_sign & Instr(15 downto 0);

end Behavioral;
