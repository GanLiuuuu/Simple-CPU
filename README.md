# Simple-CPU

This is a project implemented in Verilog based on Xilinx Artix-7 FPGA development board, EGO1 (XC7A35T-1CSG324C).

**Change Log**：

|  Name   | version |           description           |
| :-----: | :--: | :----------------------------------: |
| decoder.v | V1.0 | decode instruction |
|ALU.v|V1.0|executor|
|MUX|V1.0|mux in ALU|
|control.v| V1.0 | simple control unit, only compatible with a few specific instructions|
|...|...|...|

[*[Read the detailed project specifications]*]()

[*[Read the detailed project report]*]()

# Preview

### FPGA Board

<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="/imgs/FPGA.png" width = "800">
  </div>
</div>

### Demo Video

<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="/imgs/FPGA.png" width = "800">
  </div>
</div>


# Project Structure
Here is what current structure look like:
<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="/imgs/Structure.png" width = "400">
  </div>
</div>
#### Top
<details><table>
    <tr>
        <td><b>Port</b></td>
        <td><b>I/O</b></td>
        <td><b>Src/Dst</b></td>
        <td><b>Description</b></td>
    </tr>
    <tr>
        <td>clk</td>
        <td>I</td>
        <td>Hardware</td>
        <td>Signal of FPGA clock</td>
    </tr>
    <tr>
        <td>rst</td>
        <td>I</td>
        <td>Hardware</td>
        <td>Signal of reset button</td>
    </tr>
    <tr>
        <td>sw</td>
        <td>I</td>
        <td>Hardware</td>
        <td>Signal of buttons</td>
    </tr>
    <tr>
        <td>led</td>
        <td>O</td>
        <td>Hardware</td>
        <td>LED control</td>
    </tr>
    <tr>
        <td>seg_sel</td>
        <td>O</td>
        <td>Hardware</td>
        <td>Segment tube select signal</td>
    </tr>
    <tr>
        <td>seg</td>
        <td>O</td>
        <td>Hardware</td>
        <td>Segment tube control</td>
    </tr>
</table></details>

### control
```
module control(
    input[31:0] instruction,
    output reg  Branch,
    output reg[1:0] ALUOp,
    output reg ALUSrc,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg RegWrite
);
```
### decoder
<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="/imgs/decoder.png" width = "400">
  </div>
</div>

```
module decoder(
  input clk,
  input rst,
  input[31:0] instruction,
  input[31:0] WriteData,
  output reg[31:0] imm,
  output reg [31:0] ReadData1,
  output reg [31:0] ReadData2
);
```
### ALU
<div style="display: flex; justify-content: space-between;">
  <div>
    <img src="/imgs/ALU.png" width = "400">
  </div>
</div>

```
module ALU(
    input ALUsrc,
    input[1:0] ALUOp,
    input[31:0] instruction,
    input[31:0] ReadData1,
    input[31:0] ReadData2,
    output reg[31:0] imm,
    output reg  zero,
    output reg [31:0] out
);
```

# Functionalities
### Basic Functionalities

### Bonus Functionalities
- Pipeline
  We use a new method to design CPU. The CPU can deal with hazards.
- Complex Instruction
  Our CPU can run complex instruction like(lui, aupic, ecall)
- uart
  idk
- software supporting


# Contributors
+ [Liu Gan](https://github.com/GanLiuuuu)
+ [Kary](https://github.com/Karyl01)
+ [viayuu](https://github.com/viayuu)
  
