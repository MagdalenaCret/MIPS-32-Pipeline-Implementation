----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/13/2024 04:53:25 PM
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ExecutionUnit is
    Port 
    ( 
        RD1: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        ALUSrc: in std_logic;
        Ext_Imm: in std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector(5 downto 0);
        ALUOp: in std_logic_vector(1 downto 0);
        PC4: in std_logic_vector(31 downto 0);
        Zero: out std_logic;
        ALURes: out std_logic_vector(31 downto 0);
        BranchAddress: out std_logic_vector(31 downto 0);
        ------------------------------------------------
        --modificari Pipeline
        rt: in std_logic_vector(4 downto 0);
        rd: in std_logic_vector(4 downto 0);
        RegDst: in std_logic;
        rWA: out std_logic_vector(4 downto 0)
    );
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is

signal mux_out: std_logic_vector(31 downto 0) := (others => '0');
signal alu_ctrl: std_logic_vector(2 downto 0) := (others => '0');
signal alu_result: std_logic_vector(31 downto 0) := (others => '0');

begin

    mux_out <= RD2 when ALUSrc = '0' else Ext_Imm;
    BranchAddress <= PC4 + (Ext_Imm(29 downto 0) & "00"); --Branch Address
    ALURes <= alu_result; --ALU result
    
    --modificari Pipeline
    rWa <= rt when RegDst = '0' else rd; -- un mux suplimentar
    
   process (ALUOp, func)
      begin
        case ALUOp is
        when "11" => 
            case func is
                when "000000" => 
                    alu_ctrl <= "001";
                when "000001" => 
                    alu_ctrl <= "010";
                when "000010" => 
                    alu_ctrl <= "100";
                when "000011" => 
                    alu_ctrl <= "101";
                when "000100" => 
                    alu_ctrl <= "011";
                when "000101" => 
                    alu_ctrl <= "110";
                when "000110" => 
                    alu_ctrl <= "111";
                when "000111" => 
                    alu_ctrl <= "000";    
                when others => 
                    alu_ctrl <= "000";  --Nu ar trebui sa intre niciodata aici
            end case;
         when "10" => alu_ctrl <= "001";    
         when "01" => alu_ctrl <= "010";
         when "00" => alu_ctrl <= "011";
        end case;
    end process;
      
    process (RD1, mux_out, sa, alu_ctrl) 
     begin
      case alu_ctrl is
       when "001" => 
            alu_result <= RD1 + mux_out;  --adunare
       when "010" => 
            alu_result <= RD1 - mux_out;  --scadere
       when "100" => 
            alu_result <= to_stdlogicvector(to_bitvector(mux_out) sll conv_integer(sa));  --shiftare stanga
       when "101" => 
            alu_result <= to_stdlogicvector(to_bitvector(mux_out) srl conv_integer(sa));  --shiftare stanga                              
       when "011" => 
             alu_result <= RD1 and mux_out; --and logic
       when "110" => 
              alu_result <= RD1 or mux_out; --or logic     
       when "111" =>
              alu_result <= RD1 xor mux_out; --xor logic
       when "000" =>
              if signed(RD1) < signed(mux_out) then  --compare
                alu_result <= X"00000001";
              else
                alu_result <= X"00000000";
              end if;
       when others =>  
             alu_result <= (others => '0'); --Nu ar trebui sa intre niciodata aici 
       end case;
       
       case alu_result is --case ul pentru Zero ca iesire din ALU
            when X"0000" =>  Zero <= '1';
            when others =>  Zero <= '0';
       end case;
    end process;
    
end Behavioral;
