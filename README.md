# 🚀 MIPS Pipeline Processor Project

## 📝 Overview

This repository contains the VHDL implementation of a 32-bit MIPS pipeline processor developed as a laboratory project for the Computer Architecture course at the Technical University of Cluj-Napoca. The processor is capable of executing a unique program that processes arrays based on specific conditions.

## ✨ Project Description

The main objective was to design and implement a MIPS processor that executes a custom program.

## 🛠️ Program Functionality

The processor executes a program that performs the following operations on an array:

-  Replaces elements less than X with their integer division by 8
-  Replaces elements between X and Y with their doubled value
-  Replaces elements greater than Y with 1

The array is stored in memory starting at address A (A ≥ 4) and has N elements. Values A, N, X, and Y are read from memory addresses 0, 1, 2, and 3 respectively.

## 💻 Implementation Details

### 📋 Instruction Set

The processor implements 15 instructions, including custom instructions:

- Standard R-type instructions: ADD, SUB, SLL, SRL, AND, OR
- Custom R-type instructions: XOR, SLT (Set on Less Than)
- Standard I-type instructions: LW, SW, BEQ, ADDI
- Custom I-type instructions: ANDI, BNE (Branch on Not Equal)
- J-type instructions: J (Jump)

### 🧩 Processor Components

The implementation includes the following units:

- **🔎 IFetch** - Instruction Fetch unit
- **🔍 ID** - Instruction Decode unit
- **🎮 UC** - Control Unit
- **⚙️ EX** - Execution Unit
- **💾 MEM** - Memory Unit
- **✍️ WB** - Write Back Unit

### 🚀 Pipeline Version

The repository also includes an updated pipeline version of the MIPS processor with:

- ↪️ Additional Branch_N signal for BNE instruction
- 🛡️ Handling of data and control hazards using NOPs
- 🔄 Updated control flow for pipeline stages

## 🚦 Usage

To use this project:

1. 📥 Clone the repository
   ```
   git clone https://github.com/MagdalenaCret/MIPS-32-Pipeline-Implementation
   ```
2. 💻 Open it in a VHDL-compatible IDE (such as Vivado or ISE)
3. 🔧 Synthesize and implement the design
4. ✅ Test using the provided test environment

## 🧪 Testing

The processor was tested using Basys3 and Nexys7 FPGA boards. Test results are documented in the project report including:

- 📊 Signal trace table for debugging
- 📈 RTL schematic diagrams
- 🏗️ Pipeline architecture drawings

## 👩‍💻 Authors

- 👩‍🎓 Maria-Magdalena Creț

## 🙏 Acknowledgments

- 🏫 Technical University of Cluj-Napoca
- 🎓 Faculty of Automation and Computer Science
- 📚 Documentation from Computer Architecture course

## 📄 License

This project is provided for educational purposes.
