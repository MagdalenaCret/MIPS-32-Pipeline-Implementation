----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/12/2024 10:26:36 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
    Port( 
        clk: in std_logic;
        enable: in std_logic;
        reset: in std_logic;
        JumpAddress: in std_logic_vector(31 downto 0);
        BranchAddress: in std_logic_vector(31 downto 0);
        Jump: in std_logic;
        PCSrc: in std_logic;
        PcOut: out std_logic_vector (31 downto 0);
        Instruction: out std_logic_vector(31 downto 0)
         );
end IFetch;

architecture Behavioral of IFetch is
--Rom Memory
type ROM is array(0 to 127) of std_logic_vector(31 downto 0); --am modificat memoria pentru introducerea NoOp-urilot
signal rom_mem:  ROM:=(
-- PROGRAM DE TEST

-- CERINTA: 

--Sa se înlocuiasca toate elementele dintr-un sir cu impartirea lor la 8 ca intreg, daca sunt mai mici decât X, daca e intre X si Y cu dublul lor 
--si daca sunt mai mari ca Y, se inlocuiesc cu 1. 
--Sirul se afla în memorie începând cu adresa A (A<=4) ?i are N elemente. A, N, X, Y se citesc din memorie de la adresele 0, 1, 2, respectiv 3. 
--Constrangere: X <= Y
--Pentru verificare, se poate adauga o bucla de citire a elementelor sirului, la final.

--Cod MIPS 32:

--#initializare registrii
--andi $1 $1 0    => 100101_00001_00001_0000000000000000
--andi $2 $2 0	=> 100101_00010_00010_0000000000000000
--andi $3 $3 0	=> 100101_00011_00011_0000000000000000
--andi $4 $4 0	=> 100101_00100_00100_0000000000000000
--andi $10 $10 0  --contor => 100101_01010_01010_0000000000000000

--# salvare variabile
--lw $reg1, 0($1)  # adresa A => 100011_00001_00001_0000000000000000
--lw $reg2, 1($2)  # numarul de elemente N => 100011_00010_00010_0000000000000001
--lw $reg3, 2($3)  # valoarea de referin?? X => 100011_00011_00011_0000000000000010
--lw $reg4, 3($4)  # valoarea de referin?? Y => 100011_00100_00100_0000000000000011

--loop:
--	lw $reg5, 0($1)         # reg5 parcurge fiecare element din memorie    => 100011_00001_00101_0000000000000000
--	andi $reg6 $6 0         # ok			    => 100101_00110_00110_0000000000000000	
--	slt $reg6, $reg5, $reg3 # reg5< reg3(X) -> reg6=1   => 000000_00101_00011_00110_00000_000111

--	andi $reg7 $7 0					    => 100101_00111_00111_0000000000000000	
--	addi $reg7 $7 1         # am pus in reg7 1          => 100011_00111_00111_0000000000000001

--	bne $reg6 $reg7 3  (et1)# daca ok!=1 sare la adresa et1 => 100100_00110_00111_0000000000000011
--	srl $reg5 $reg5, 3      # altfel sfiftare la dreapta 3 biti, /8  => 000000_00000_00101_00101_00011_000011
--	sw $reg5, 0($1)         # pun rezultatul final		         => 100001_00001_00101_0000000000000000
--	j 29 (comp_N)							 => 111111_00000000000000000000011101

--	et1:                    # elementul > X

--	# Pentru Y				
--	andi $reg6 $6 0         # ok			    => 100101_00110_00110_0000000000000000	
--	slt $reg6, $reg5, $reg4 # reg5< reg4(Y) -> reg6=1   => 000000_00101_00100_00110_00000_000111

--	andi $reg7 $7 0				            => 100101_00111_00111_0000000000000000
--	addi $reg7 $7 1         # am pus in reg7 1          => 100011_00111_00111_0000000000000001

--	bne $reg6 $reg7 3 (et2) # daca ok!=1 sare la adresa et2        => 100100_00110_00111_0000000000000011
--	sll $reg5 $reg5, 1      # altfel sfiftare la stanga 1 bit, *2  => 000000_00000_00101_00101_00001_000010
--	sw $reg5, 0($1)         # pun rezultatul final                 => 100001_00001_00101_0000000000000000
--	j 29 (comp_N)                                                  => 111111_00000000000000000000011101

--	et2:                    # elementul > Y
--	andi $reg5 $reg5 0					       => 100101_00101_00101_0000000000000000
--	addi $reg5 $reg5 1					       => 100011_00101_00101_0000000000000001
--	sw $reg5, 0($1)					               => 100001_00001_00101_0000000000000000


--	comp_N:
--	addi $reg10 $10 1					       => 100011_01010_01010_0000000000000001
--	beq $reg2 $reg10 2 (afisare)  #am parcurs tot                  => 100010_00010_01010_0000000000000010
--	addi $reg1 $reg1 1                                             => 100011_00001_00001_0000000000000001
--	j 9 (loop)			  #se intoarce din nou in loop => 111111_00000000000000000000001001

--afisare:
	
--	andi $1 $1 0			=> 100101_00001_00001_0000000000000000
--	andi $10 $10 0			=> 100101_01010_01010_0000000000000000
--	lw $reg1, 0($1)			=> 100000_00001_00001_0000000000000000

--loop_afisare:
--	lw $reg5, 0($1) 		=> 100000_00001_00101_0000000000000000
--	addi $reg10 $10 1		=> 100011_01010_01010_0000000000000001
--	beq $reg2 $reg10 3 (final)   #am parcurs tot	=> 100010_00010_01010_0000000000000011
--	addi $reg1 $reg1 1           #incrementare	=> 100011_00111_00111_0000000000000001
--	j 36 (loop_afisare)				=> 111111_00000000000000000000100100
--final:

--- S-au modificat hazardurile din programul de mai sus, prin aduagarea de NoOP, au fost prezente hazarduri structurale, de date ;i de control(la Branch si Jump)
--- Obs: NoOp este considerat SLL $0 $0 0, astfel ca are opcode-ul instructiunii SLL, ales in tabelul de la Mips Ciclu Unic: 000000
----------------------------------------------------------------------------------------------
    B"100101_00001_00001_0000000000000000", --andi $1 $1 0      =>HEXA: 94210000
    B"100101_00010_00010_0000000000000000", --andi $2 $2 0      =>HEXA: 94420000 
    B"100101_00011_00011_0000000000000000", --andi $3 $3 0      =>HEXA: 94630000
    B"100101_00100_00100_0000000000000000", --andi $4 $4 0      =>HEXA: 94840000
    B"100101_01010_01010_0000000000000000", --andi $10 $10 0    =>HEXA: 954A0000
    B"100000_00001_00001_0000000000000000", --lw $reg1, 0($1)   =>HEXA: 80210000
    B"100000_00010_00010_0000000000000001", --lw $reg2, 1($2)   =>HEXA: 80420001
    B"100000_00011_00011_0000000000000010", --lw $reg3, 2($3)   =>HEXA: 80630002
    B"100000_00100_00100_0000000000000011", --lw $reg4, 3($4)   =>HEXA: 80840003
    B"100000_00001_00101_0000000000000000", --loop: lw $reg5, 0($1)   =>HEXA: 80250000
    B"100101_00110_00110_0000000000000000", --andi $reg6 $6 0   =>HEXA: 94C60000
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00101_00011_00110_00000_000111", --slt $reg6, $reg5, $reg3  =>HEXA: 00A33007
    B"100101_00111_00111_0000000000000000", --andi $reg7 $7 0   =>HEXA: 94E70000
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100011_00111_00111_0000000000000001", --addi $reg7 $7 1   =>HEXA: 8CE70001
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100100_00110_00111_0000000000001001", --bne $reg6 $reg7 9 =>HEXA: 90C70003
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00101_00101_00011_000011", --srl $reg5 $reg5, 3 =>HEXA: 000528C3
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100001_00001_00101_0000000000000000", --sw $reg5, 0($1)      =>HEXA: 84250000
    B"111111_00000000000000000000110110",   --j 54 (comp_N)        
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100101_00110_00110_0000000000000000", --andi $reg6 $6 0      =>HEXA: 94C60000
    B"000000_00101_00100_00110_00000_000111", --slt $reg6, $reg5, $reg4  =>HEXA: 00A43007
    B"100101_00111_00111_0000000000000000", --andi $reg7 $7 0      =>HEXA: 94E70000
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100011_00111_00111_0000000000000001", --addi $reg7 $7 1      =>HEXA: 8CE70001
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100100_00110_00111_0000000000001001", --bne $reg6 $reg7 9    =>HEXA: 90C70003
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00101_00101_00001_000010", --sll $reg5 $reg5, 1  =>HEXA: 00052842
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100001_00001_00101_0000000000000000", --sw $reg5, 0($1)      =>HEXA: 84250000
    B"111111_00000000000000000000110110",   --j 54   
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0           
    B"100101_00101_00101_0000000000000000", --andi $reg5 $reg5 0   =>HEXA: 94A50000
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100011_00101_00101_0000000000000001", --addi $reg5 $reg5 1   =>HEXA: 8CA50001
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100001_00001_00101_0000000000000000", --sw $reg5, 0($1)      =>HEXA: 84250000
    B"100011_01010_01010_0000000000000001", --comp N: addi $reg10 $10 1    =>HEXA: 8D4A0001
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100010_00010_01010_0000000000000110", --beq $reg2 $reg10 6   
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100011_00001_00001_0000000000000001", --addi $reg1 $reg1 1   =>HEXA: 8C210001
    B"111111_00000000000000000000001001",   --j 9 (loop)           =>HEXA: FC000009
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100101_00001_00001_0000000000000000", ---afisare: andi $1 $1 0 =>HEXA: 94210000
    B"100101_01010_01010_0000000000000000", --andi $10 $10 0       =>HEXA: 954A0000
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100000_00001_00001_0000000000000000", --lw $reg1, 0($1)      =>HEXA: 80210000
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100000_00001_00101_0000000000000000", --loop_afisare: lw $reg5, 0($1)      =>HEXA: 80250000 
    B"100011_01010_01010_0000000000000001", --addi $reg10 $10 1    =>HEXA: 8D4A0001
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100010_00010_01010_0000000000000111", --beq $reg2 $reg10 7   
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
    B"100011_00001_00001_0000000000000001", --addi $reg1 $reg1 1   =>HEXA: 8C210001
    B"111111_00000000000000000001000110",   --j 70 (loop_afisare)  
    B"000000_00000_00000_00000_00000_000000", --No Op echivalent cu SLL $0 $0 0
others => (others => '0')
);

signal pc_in: std_logic_vector(31 downto 0) := (others => '0');
signal pc_out: std_logic_vector(31 downto 0) := (others => '0');

signal mux1_out: std_logic_vector(31 downto 0) := (others => '0');

signal sum_out: std_logic_vector(31 downto 0) := (others => '0');

begin

--Program Counter
process(clk, reset)
  begin
    if reset = '1' then pc_out <= (others => '0');
    elsif clk'event and clk = '1' then
        if(enable = '1') then pc_out <= pc_in;
        end if;
    end if;
end process;

sum_out <= pc_out + 4;
PcOut <= sum_out;

mux1_out <= BranchAddress when PCSrc = '1' else sum_out;
pc_in <= JumpAddress when Jump = '1' else mux1_out;

Instruction <= rom_mem(conv_integer(pc_out(7 downto 2)));

end Behavioral;
