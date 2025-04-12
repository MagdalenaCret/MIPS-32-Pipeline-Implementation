----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/12/2024 11:55:25 PM
-- Design Name: 
-- Module Name: UnitControl - Behavioral
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

entity UnitControl is
    Port(
            Instr: in std_logic_vector(5 downto 0);
            RegDst: out std_logic;
            ExtOp: out std_logic;
            ALUSrc: out std_logic;
            Branch: out std_logic;
            Branch_N: out std_logic;
            Jump: out std_logic;
            ALUOp: out std_logic_vector(1 downto 0);
            MemWrite: out std_logic;
            MemToReg: out std_logic;
            RegWrite: out std_logic
        );
end UnitControl;

architecture Behavioral of UnitControl is

begin
    
    process(Instr)
        begin
        
        RegDst <= '0';
        ExtOp  <= '0';
        Branch <= '0';
        Branch_N <= '0';
        Jump <= '0';
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '0';
        ALUSrc <= '0';
        ALUOp <= "00";
        
       case (Instr) is
        
       when "000000" => --R type
            RegDst <= '1';
            RegWrite <= '1';
            ALUOp <= "11";
        when "100000" => --LW type
            ALUSrc <= '1';
            ExtOp  <= '1';
            RegWrite <= '1';
            MemToReg <= '1';
            ALUOp <= "10";
        when "100001" => --SW type
            ALUSrc <= '1';
            ExtOp  <= '1';
            MemWrite <= '1';
            ALUOp <= "10";
        when "100010" => --BEQ type
            ExtOp  <= '1';
            Branch <= '1';
            ALUOp <= "01";
        when "100011" => --ADDI type
            ExtOp  <= '1';
            ALUSrc <= '1';
            RegWrite <= '1';
            ALUOp <= "10";
        when "100100" => --BNE type
            ExtOp  <= '1';
            Branch_N <= '1';
            ALUOp <= "01";
        when "100101" => --ANDI type
            ALUSrc <= '1';
            RegWrite <= '1';
            ALUOp <= "00";
        when "111111" => --J type
            Jump <= '1';
        when others => Jump <= '0'; --Nu ar trebui sa intre niciodata aici
        end case;
    end process;
end Behavioral;
