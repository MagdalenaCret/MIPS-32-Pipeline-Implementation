----------------------------------------------------------------------------------
-- Company: 
-- Student: Cret Maria-Magdalena
-- Group: 30223
-- Create Date: 04/12/2024 09:56:41 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);   --pentru Nexys 7  
            --an : out STD_LOGIC_VECTOR (3 downto 0);   --pentru Basys 3  
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is --monoimpuls
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is   --display 7 segments
    Port ( clk : in STD_LOGIC;
          digits : in STD_LOGIC_VECTOR(31 downto 0); -- --pentru Nexys 7 
           --digits : in STD_LOGIC_VECTOR(15 downto 0); --pentru Basys 3
           --an : out STD_LOGIC_VECTOR(3 downto 0); --pentru Basys 3
           an: out STD_LOGIC_VECTOR(7 downto 0); -- --pentru Nexys 7 
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;


component IFetch is
    Port( 
        clk: in std_logic;
        enable: in std_logic;
        reset: in std_logic;
        JumpAddress: in std_logic_vector(31 downto 0);
        BranchAddress: in std_logic_vector(31 downto 0);
        Jump: in std_logic;
        PCSrc: in std_logic;
        PcOut: out std_logic_vector (31 downto 0);
        Instruction: out std_logic_vector(31 downto 0));
end component;

component UnitControl  is
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
            RegWrite: out std_logic);
end component;

component InstructionDecode is
Port (
      clk: in std_logic;
      enable: in std_logic;
      RegWrite: in std_logic;
      Instr: in std_logic_vector(25 downto 0);
     -- RegDst: in std_logic;
      ExtOp: in std_logic;
      RD1: out std_logic_vector(31 downto 0);
      RD2: out std_logic_vector(31 downto 0);
      WD: in std_logic_vector(31 downto 0);
      Ext_Imm: out std_logic_vector(31 downto 0);
      func: out std_logic_vector(5 downto 0);
      sa: out std_logic_vector(4 downto 0);
       --modificari Pipeline
      WA: in std_logic_vector(4 downto 0);
      rt: out std_logic_vector(4 downto 0);
      rd: out std_logic_vector(4 downto 0));
end component;

component ExecutionUnit is
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
         --modificari Pipeline
        rt: in std_logic_vector(4 downto 0);
        rd: in std_logic_vector(4 downto 0);
        RegDst: in std_logic;
        rWA: out std_logic_vector(4 downto 0));
end component;

component MemoryUnit is
    Port 
    ( 
        clk: in std_logic;
        enable: in std_logic;
        MemWrite: in std_logic;
        ALURes_in: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        MemData: out std_logic_vector(31 downto 0);
        AluRes_out: out std_logic_vector(31 downto 0));
end component;

component WBUnit is
Port 
    ( 
    MemToReg: in std_logic;
    MemData: in std_logic_vector(31 downto 0);
    ALURes_out: in std_logic_vector(31 downto 0);
    WD: out std_logic_vector(31 downto 0));
end component;

--semnale definite
    signal enable: std_logic := '0';
    signal reset: std_logic := '0';
    --pentru reg IF/ID
    signal Instruction_in: std_logic_vector(31 downto 0) := (others => '0');
    signal Instruction_out: std_logic_vector(31 downto 0) := (others => '0');
    
    signal PC4_in: std_logic_vector(31 downto 0) :=(others => '0');
    signal PC4_out: std_logic_vector(31 downto 0) :=(others => '0');
    signal PC4_out_2: std_logic_vector(31 downto 0) :=(others => '0'); --pentru ID/EX
   -----------------------------------------------------------------
    signal JumpAddress: std_logic_vector(31 downto 0) := (others => '0');
    signal BranchAddress: std_logic_vector(31 downto 0) :=(others => '0');
    signal BranchAddress_out: std_logic_vector(31 downto 0) :=(others => '0'); --pentru EX/MEM
    
    --pentru reg ID/EX
    signal RD1: std_logic_vector(31 downto 0) := (others => '0');
    signal RD1_out: std_logic_vector(31 downto 0) := (others => '0');
    signal RD2: std_logic_vector(31 downto 0) := (others => '0');
    signal RD2_out: std_logic_vector(31 downto 0) := (others => '0');
    signal RD2_out2: std_logic_vector(31 downto 0) := (others => '0');
    
    signal WD: std_logic_vector(31 downto 0) :=(others => '0');
    
    signal Ext_Imm_in: std_logic_vector(31 downto 0) := (others => '0');
    signal Ext_Imm_out: std_logic_vector(31 downto 0) := (others => '0'); --pentru ID/EX
    
    signal opCode:  std_logic_vector(5 downto 0) := (others => '0');
    signal func: std_logic_vector(5 downto 0) := (others => '0');
    signal func_out: std_logic_vector(5 downto 0) := (others => '0');
    signal sa: std_logic_vector(4 downto 0) := (others => '0');
    signal sa_out: std_logic_vector(4 downto 0) := (others => '0');
    signal ExtOp: std_logic := '0';
    signal PCSrc: std_logic := '0';
    ----------------------------------------------------------------
    signal RegDst_in: std_logic := '0';
    signal RegDst_out: std_logic := '0';
    signal ALUSrc_in: std_logic := '0';
    signal ALUSrc_out: std_logic := '0';
    signal MemWrite_in: std_logic := '0';
    signal MemWrite_out: std_logic := '0';
    signal MemWrite_out2: std_logic := '0'; --pentru EX/MEM
    signal MemToReg_in: std_logic := '0';
    signal MemToReg_out: std_logic := '0';
    signal MemToReg_out2: std_logic := '0';
    signal MemToReg_out3: std_logic := '0';
    signal Branch_in: std_logic := '0';
    signal Branch_out: std_logic := '0';
    signal Branch_out2: std_logic := '0';
    signal Branch_N_in: std_logic := '0'; --pentru EX/MEM
    signal Branch_N_out: std_logic := '0';
    signal Branch_N_out2: std_logic := '0'; --pentru EX/MEM
    signal Jump_in: std_logic := '0';
    signal Jump_out: std_logic := '0';
    signal ALUOp_in: std_logic_vector(1 downto 0) := "00";
    signal ALUOp_out: std_logic_vector(1 downto 0) := "00";
    ---------------------------------------------------------------
    signal RegWrite: std_logic := '0';
    signal RegWrite_out: std_logic := '0'; --pentru ID/EX
    signal RegWrite_out2: std_logic := '0'; --pentru EX/MEM
    signal RegWrite_out3: std_logic := '0'; --pentru MEM/WB
    
    signal Zero: std_logic := '0';
    signal Zero_out: std_logic := '0'; --pentru EX/MEM
    signal ALUIntermidate: std_logic_vector(31 downto 0) := (others => '0');
    signal ALUIntermidate_out: std_logic_vector(31 downto 0) := (others => '0');
    signal MemData: std_logic_vector(31 downto 0) :=(others => '0');
    signal MemData_out: std_logic_vector(31 downto 0) :=(others => '0');  --pentru MEM/WB
    signal ALUResult: std_logic_vector(31 downto 0) := (others => '0');
    signal ALUResult_out: std_logic_vector(31 downto 0) := (others => '0'); --pentru MEM/WB
    signal selection: std_logic_vector(2 downto 0) := "000";
    signal ssdOut: std_logic_vector(31 downto 0) := (others => '0'); --pentru Nexys7
    --signal ssdOut: std_logic_vector(15 downto 0) := (others => '0'); ---pentru Basys 3
    --Modificari pentru Pipeline
    signal WA: std_logic_vector(4 downto 0) := (others => '0');  --o iesire de alt pipeline
    signal rt: std_logic_vector(4 downto 0) := (others => '0');
    signal rd: std_logic_vector(4 downto 0) := (others => '0');
    
    signal rt_out: std_logic_vector(4 downto 0) := (others => '0');   --pentru ID/EX
    signal rd_out: std_logic_vector(4 downto 0) := (others => '0');   --pentru ID/EX
    
    signal rWA: std_logic_vector(4 downto 0) := (others => '0');
    signal rWA_out: std_logic_vector(4 downto 0) := (others => '0'); --pentru EX/MEM
    signal rWA_out2: std_logic_vector(4 downto 0) := (others => '0'); --pentru MEM/WB
   
    --semnale suplimentare
    signal REG_IF_ID: std_logic_vector(63 downto 0) := (others => '0');
    signal REG_ID_EX: std_logic_vector(157 downto 0) := (others => '0');
    signal REG_EX_MEM: std_logic_vector(106 downto 0) := (others => '0');
    signal REG_MEM_WB: std_logic_vector(70 downto 0) := (others => '0');
 
begin

    PCSrc <= (Branch_out2 and Zero_out) or (Branch_N_out2 and (not Zero_out));
    opCode <= Instruction_out(31 downto 26);
    JumpAddress <= PC4_out(31 downto 28) & (Instruction_out(25 downto 0) & "00");
    
    selection <= sw(2)&sw(1)&sw(0);
    led(1 downto 0) <= ALUOp_in;
    led(2) <= RegDst_in;
    led(3) <= ExtOp; 
    led(4) <= ALUSrc_in;
    led(5) <= MemWrite_in;
    led(6) <= MemToReg_in;
    led(7) <= RegWrite;
    led(8) <= Branch_in;
    led(9) <= Branch_N_in;
    led(10) <= PCSrc;
    led(11) <= Jump_in;
    led(15 downto  12) <= "0000";
    
    process(selection, Instruction_in, RD1, RD2, PC4_in, Ext_Imm_in, ALUResult, MemData, WD, sw(3))
        begin
        -- if sw(3) = '0' then ----pentru Basys 3
            case selection is
            
                when "000" => ssdOut <= Instruction_in;
                when "001" => ssdOut <= PC4_in;
                when "010" => ssdOut <= RD1;
                when "011" => ssdOut <= RD2; --aici cu rd1/rd1 si ex_imm atentie
                when "100" => ssdOut <= Ext_Imm_in; --de modificat apoi pentru Nexys 7
                when "101" => ssdOut <= ALUIntermidate;
                when "110" => ssdOut <= MemData;
                when others => ssdOut <= WD;
            end case;   

        
--            else ----pentru Basys 3
--            case selection is
--                when "000" => ssdOut <= Instruction_in(31 downto 16);
--                when "001" => ssdOut <= PC4_in(31 downto 16);
--                when "010" => ssdOut <= RD1(31 downto 16);
--                when "011" => ssdOut <= RD2(31 downto 16);
--                when "100" => ssdOut <= Ext_Imm_in(31 downto 16);
--                when "101" => ssdOut <= ALUIntermidate(31 downto 16);
--                when "110" => ssdOut <= MemData(31 downto 16);
--                when others => ssdOut <= WD(31 downto 16);
--             end case; 
        -- end if; 
    end process;
  
MPG_port1: MPG port map(btn => btn(0), enable=>enable, clk => clk);
MPG_port2: MPG port map(enable => reset, btn => btn(1), clk => clk);
IFetch_port: IFetch port map(clk => clk, 
                             enable => enable, 
                             reset => reset, 
                             JumpAddress => JumpAddress, 
                             Jump => Jump_in, 
                             BranchAddress => BranchAddress_out, 
                             PCSrc => PCSrc, 
                             PcOut => PC4_in, 
                             Instruction => Instruction_in);
--IF/ID
    process(clk, enable)
      begin
      if clk = '1' and clk'event then
          if enable = '1' then
             REG_IF_ID(31 downto 0) <= PC4_in;
             REG_IF_ID(63 downto 32) <= Instruction_in;
          end if;
       end if;
    end process;
 PC4_out <=  REG_IF_ID(31 downto 0);
 Instruction_out <= REG_IF_ID(63 downto 32);
 
InstructionDecode_port: InstructionDecode port map(clk => clk, 
                                                   enable => enable, 
                                                   RegWrite => RegWrite_out3, 
                                                   Instr => Instruction_out(25 downto 0), 
                                                   ExtOp => ExtOp, 
                                                   RD1 => RD1, 
                                                   RD2 => RD2, 
                                                   WD => WD, 
                                                   Ext_Imm => Ext_Imm_in, 
                                                   func => func, 
                                                   sa => sa, 
                                                   WA => rWa_out2, 
                                                   rt => rt, 
                                                   rd => rd);
                                                   
UnitControl_port: UnitControl port map(Instr => opCode, 
                                       RegDst => RegDst_in, 
                                       ExtOp => ExtOp, 
                                       ALUSrc => ALUSrc_in, 
                                       Branch => Branch_in, 
                                       Branch_N => Branch_N_in, 
                                       Jump => Jump_in, 
                                       ALUOp => ALUOp_in, 
                                       MemWrite => MemWrite_in, 
                                       MemToReg => MemToReg_in, 
                                       RegWrite => RegWrite);
--ID/EX
    process(clk, enable)
      begin
      if clk = '1' and clk'event then
          if enable = '1' then
             REG_ID_EX(157) <= MemToReg_in;
             REG_ID_EX(156) <= RegWrite;
             REG_ID_EX(155) <= MemWrite_in;
             REG_ID_EX(154) <= RegDst_in;
             REG_ID_EX(153) <= Branch_in;
             REG_ID_EX(152) <= Branch_N_in;
             REG_ID_EX(151) <= AluSrc_in;
             REG_ID_EX(150 downto 149) <= AluOp_in;
             REG_ID_EX(148 downto 117) <= RD1;
             REG_ID_EX(116 downto 85) <= RD2;
             REG_ID_EX(84 downto 53) <= Ext_Imm_in;
             REG_ID_EX(52 downto 21) <= Pc4_out;
             REG_ID_EX(20 downto 16) <= rt;
             REG_ID_EX(15 downto 11) <= rd;
             REG_ID_EX(10 downto 6) <= sa;
             REG_ID_EX(5 downto 0) <= func;
          end if;
       end if;
    end process;
    MemToReg_out <= REG_ID_EX(157);
    RegWrite_out <= REG_ID_EX(156);
    MemWrite_out <= REG_ID_EX(155);
    RegDst_out <= REG_ID_EX(154);
    Branch_out <= REG_ID_EX(153);
    Branch_N_out <= REG_ID_EX(152);
    AluSrc_out <= REG_ID_EX(151);
    AluOp_out <= REG_ID_EX(150 downto 149);
    RD1_out <= REG_ID_EX(148 downto 117);
    RD2_out <= REG_ID_EX(116 downto 85);
    Ext_Imm_out <= REG_ID_EX(84 downto 53);
    PC4_out_2 <=  REG_ID_EX(52 downto 21);
    rt_out<= REG_ID_EX(20 downto 16);
    rd_out<= REG_ID_EX(15 downto 11);
    sa_out <= REG_ID_EX(10 downto 6);
    func_out <= REG_ID_EX(5 downto 0);
   
    
ExecutionUnit_port: ExecutionUnit port map(RD1 => RD1_out, 
                                           RD2 => RD2_out, 
                                           ALUSrc => ALUSrc_out, 
                                           Ext_Imm => Ext_Imm_out, 
                                           sa => sa_out, 
                                           func => func_out, 
                                           ALUOp => ALUOp_out, 
                                           PC4 => PC4_out_2, 
                                           Zero => Zero, 
                                           ALURes => ALUIntermidate, 
                                           BranchAddress => BranchAddress, 
                                           rt => rt_out, 
                                           rd => rd_out ,
                                           RegDst => RegDst_out, 
                                           rWa=> rWa);

--EX/MEM
    process(clk, enable)
      begin
      if clk = '1' and clk'event then
          if enable = '1' then
             REG_EX_MEM(106) <= MemToReg_out;
             REG_EX_MEM(105) <= RegWrite_out;
             REG_EX_MEM(104) <= MemWrite_out;
             REG_EX_MEM(103) <= Branch_out;
             REG_EX_MEM(102) <= Branch_N_out;
             REG_EX_MEM(101 downto 70) <= BranchAddress;
             REG_EX_MEM(69) <= Zero;
             REG_EX_MEM(68 downto 37) <= ALUIntermidate;
             REG_EX_MEM(36 downto 5) <= RD2_out;
             REG_EX_MEM(4 downto 0) <= rWa;
          end if;
       end if;
    end process;
    MemToReg_out2 <= REG_EX_MEM(106);
    RegWrite_out2 <= REG_EX_MEM(105);
    MemWrite_out2 <= REG_EX_MEM(104);
    Branch_out2 <= REG_EX_MEM(103);
    Branch_N_out2 <= REG_EX_MEM(102);
    BranchAddress_out <= REG_EX_MEM(101 downto 70);
    Zero_out <= REG_EX_MEM(69);
    ALUIntermidate_out <= REG_EX_MEM(68 downto 37);
    RD2_out2 <= REG_EX_MEM(36 downto 5);
    rWa_out <=  REG_EX_MEM(4 downto 0);
  
    MemoryUnit_port: MemoryUnit port map(clk => clk, 
                                         enable => enable, 
                                         MemWrite => MemWrite_out2, 
                                         ALURes_in => ALUIntermidate_out, 
                                         AluRes_out=>AluResult, 
                                         RD2 => RD2_out2, 
                                         MemData => MemData);
--MEM/WB
    process(clk, enable)
      begin
      if clk = '1' and clk'event then
          if enable = '1' then
             REG_MEM_WB(70) <= MemToReg_out2;
             REG_MEM_WB(69) <= RegWrite_out2;
             REG_MEM_WB(68 downto 37) <= MemData;
             REG_MEM_WB(36 downto 5) <= AluResult;
             REG_MEM_WB(4 downto 0) <= rWa_out;
   
          end if;
       end if;
    end process;
    MemToReg_out3 <=  REG_MEM_WB(70);
    RegWrite_out3 <= REG_MEM_WB(69);
    MemData_out <= REG_MEM_WB(68 downto 37);
    ALUResult_out <= REG_MEM_WB(36 downto 5);
    rWa_out2  <=  REG_MEM_WB(4 downto 0);

WBUnit_port: WBUnit port map(MemToReg => MemToReg_out3, MemData => MemData_out, ALURes_out => ALUResult_out, WD => WD);
SSD_port: SSD port map(clk => clk, digits => ssdOut, an => an, cat => cat);

   
end Behavioral;
