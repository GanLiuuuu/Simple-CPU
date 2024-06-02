# CS202计算机组成原理Project文档



## 一. 成员分工



| 学号     | 姓名   | 负责工作                                                     | 贡献百分比 |
| -------- | ------ | ------------------------------------------------------------ | ---------- |
| 12210729 | 刘淦   | cpu基础部分ALU, Controller，Decoder，Top；pipeline；lui、auipc指令实现 | 33.3%      |
| 12211401 | 石岩松 | cpu基础部分PC；scene1测试；button及消抖，7段数码管           | 33.3%      |
| 12211925 | 笃岳霖 | cpu基础部分IFetch，DMemory；scene2测试                       | 33.3%      |





## 二. 开发计划



1. 开发计划

| 时间      | 具体任务                                                 | 完成情况 |
| --------- | -------------------------------------------------------- | -------- |
| 4.30~5.5  | 实现单周期CPU的构建                                      | 已完成   |
| 5.8~5.17  | 实现测试场景1和2，初步实现pipeline，实现lui和auipc的指令 | 已完成   |
| 5.20~5.27 | 对总体项目进行debug以及测试场景的debug，解决hazard问题   | 已完成   |
| 5.28      | 第15周答辩                                               | 已完成   |



2. 版本修改记录

| 版本  | 修改时间                                           |
| ----- | -------------------------------------------------- |
| 0.0.0 | 5.5 实现一个单周期CPU                              |
| 0.0.1 | 5.17 改进controller和top模块，实现lui和auipc的指令 |
| 0.0.2 | 5.26 项目debug 显示模块，输入模块部分              |
| 0.1.0 | 5.28 实现一个多周期的pipeline的CPU                 |







## 三. CPU特性说明：



1. ### ISA说明：

​		本项目的CPU的ISA是基于RISC-V指令集实现的，实现的指令集包含R-type，I-type，S-type，U-type，B-type，J-type。实现的指令名、对应编码、使用方式如下所示：



- R-type:

| 指令名 | Opcode  | func3 | func7 | 使用方式              |
| ------ | ------- | ----- | ----- | --------------------- |
| ADD    | 0110011 | 0X0   | 0X00  | rd = rs1+rs2          |
| SUB    | 0110011 | 0X0   | 0X20  | rd = rs1-rs2          |
| XOR    | 0110011 | 0X4   | 0X00  | rd = rs1ˆrs2          |
| OR     | 0110011 | 0X6   | 0X00  | rd = rs1              |
| AND    | 0110011 | 0X7   | 0X00  | rd = rs1&rs2          |
| SLL    | 0110011 | 0X1   | 0X00  | rd = rs1«rs2          |
| SRA    | 0110011 | 0X5   | 0X00  | rd = rs1»rs2          |
| SRL    | 0110011 | 0X5   | 0X20  | rd = rs1»rs2 (Arith*) |
| SLT    | 0110011 | 0X2   | 0X00  | rd = (rs1 < rs2)?1:0  |
| SLTU   | 0110011 | 0X3   | 0X00  | rd = (rs1 < rs2)?1:0  |



- I-type:

| 指令名 | Opcode  | func3 | func7          | 使用方式                                   |
| ------ | ------- | ----- | -------------- | ------------------------------------------ |
| addi   | 0010011 | 0x0   |                | rd = rs1+imm                               |
| xori   | 0010011 | 0x4   |                | rd = rs1ˆimm                               |
| ori    | 0010011 | 0x6   |                | rd = rs1\| imm                             |
| andi   | 0010011 | 0x7   |                | rd = rs1&imm                               |
| slli   | 0010011 | 0x1   | imm[11:5]=0x00 | rd = rs1«imm[4:0]                          |
| srli   | 0010011 | 0x5   | imm[11:5]=0x00 | rd = rs1»imm[4:0]                          |
| srai   | 0010011 | 0x5   | imm[11:5]=0x20 | rd = rs1»imm[4:0] (Arith*)                 |
| slti   | 0010011 | 0x2   |                | rd = (rs1 < imm)?1:0                       |
| sltiu  | 0010011 | 0x3   |                | rd = (rs1 < imm)?1:0                       |
| lb     | 0000011 | 0x0   |                | rd = {24’bM[rs1+imm][7],M[rs1+imm][7:0]}   |
| lh     | 0000011 | 0x1   |                | rd = {16’bM[rs1+imm][15],M[rs1+imm][15:0]} |
| lw     | 0000011 | 0x2   |                | rd = M[rs1+imm][31:0]                      |
| lbu    | 0000011 | 0x4   |                | rd = {24’b0,M[rs1+imm][7:0]}               |
| lhu    | 0000011 | 0x5   |                | rd = {16’b0,M[rs1+imm][15:0]}              |
| jalr   | 1100111 | 0x0   |                | rd = PC+4;PC =rs1 + imm                    |



- S-type:

| 指令名 | Opcode  | func3 | func7 | 使用方式                    |
| ------ | ------- | ----- | ----- | --------------------------- |
| sb     | 0100011 | 0x0   |       | M[rs1+imm][7:0]= rs2[7:0]   |
| sh     | 0100011 | 0x1   |       | M[rs1+imm][15:0] =rs2[15:0] |
| sw     | 0100011 | 0x2   |       | M[rs1+imm][31:0] =rs2[31:0] |



- B-type:

| 指令名 | Opcode  | func3 | func7 | 使用方式                           |
| ------ | ------- | ----- | ----- | ---------------------------------- |
| beq    | 1100011 | 0x0   |       | if(rs1 == rs2) PC = PC+ {imm,1’b0} |
| bne    | 1100011 | 0x1   |       | if(rs1 != rs2) PC = PC+ {imm,1’b0} |
| blt    | 1100011 | 0x4   |       | if(rs1 < rs2) PC = PC+ {imm,1’b0}  |
| bge    | 1100011 | 0x5   |       | if(rs1 >= rs2) PC = PC+ {imm,1’b0} |
| bltu   | 1100011 | 0x6   |       | if(rs1 < rs2) PC = PC+ {imm,1’b0}  |
| bgeu   | 1100011 | 0x7   |       | if(rs1 >= rs2) PC = PC+ {imm,1’b0} |



- J-type:

| 指令名 | Opcode  | func3 | func7 | 使用方式                    |
| ------ | ------- | ----- | ----- | --------------------------- |
| jal    | 1101111 |       |       | rd = PC+4;PC =PC+{imm,1’b0} |



- U-type:

| 指令名 | Opcode  | func3 | func7 | 使用方式             |
| ------ | ------- | ----- | ----- | -------------------- |
| lui    | 0110111 |       |       | rd = imm«12          |
| auipc  | 0110111 |       |       | rd = PC + (imm « 12) |



​		本次项目的参考ISA是RV32的ISA指令集体系，没有对参考ISA有其他多余的更新或优化。另外寄存器数量和位宽与RV32相同，实现了32个寄存器，每个寄存器的位宽是32bits。

​		本次项目在软件中实现了对浮点数转整数溢出的异常情况的处理。在软件内部实现，如果输出的整数超过了能处理的范围，那么我输出的结果将会被重置为0x00000000的情况以表示目前的整数输出结果溢出的异常。





2. ### CPU时钟，CPI，pipeline 说明

​		在本次的项目中，我们实现的CPU时钟频率是23Mhz的多周期cpu。这个CPU的CPI是5，并且支持pipeline。——————————pipeline的相关内容——————————————————————————————





3. ### 寻址空间设计

​		我们设计的CPU的寻址空间是基于哈佛架构实现的。寻址单位最小是bit，指令空间和数据空间的大小都是16384个bit。栈空间的基地址是0x00000100并且向上存储数据。我们读取数据的基地址是0xfffff000，led的基地址是0xfffff010，确认案件的基地址是0xfffff020。



4. ### 对外设IO的支持

​		在我们设计的CPU暂时没有支持外设IO的部分。







## 四. CPU接口说明

1. 时钟接口：时钟接口名为 `clk`，使用了 `IOSTANDARD` 为 `LVCMOS33`，`PACKAGE_PIN` 为 `P17`。



2. 复位接口：复位接口名为 `rst_a`，使用了 `IOSTANDARD` 为 `LVCMOS33`，`PACKAGE_PIN` 为 `P15`。



3. 按钮接口：按钮接口名为 `button`，使用了 `IOSTANDARD` 为 `LVCMOS33`，`PACKAGE_PIN` 为 `R11`。



4. 开关输入接口：开关接口名为 `switches[15]` 到 `switches[0]`，分别使用了 `IOSTANDARD` 为 `LVCMOS33`，`PACKAGE_PIN` 分别为 `P5`、`P4`、`P3`、`P2`、`R2`、`M4`、`N4`、`R1`、`U3`、`U2`、`V2`、`V5`、`V4`、`R3`、`T3`、`T5`。我使用这16个二进制开关输入一个16bit的二进制数字。



5. LED 接口：LED 接口名为 `LED[15]` 到 `LED[0]`，分别使用了 `IOSTANDARD` 为 `LVCMOS33`，`PACKAGE_PIN` 分别为 `F6`、`G4`、`G3`、`J4`、`H4`、`J3`、`J2`、`K2`、`K1`、`H6`、`H5`、`J5`、`K6`、`L1`、`M1`、`K3`。同时我的七段数码管的显示将与LED相同，同样能够实现一定时间的数字显示，因此我没有为七段数码管准备单独的接口，而是直接将七段数码管的输入接到了led的部分，与led读取相同的内容。







## 五. CPU内部结构说明



1. #### CPU内部各子模块的接口连接关系图

   在这一部分，由于我的CPU参考了课件上的部分，因此我的CPU的内部子模块的接口连接将与课件内容一致。

   ![ALU](C:\Users\admin\Desktop\cpu项目文档\ALU.png)






2. #### CPU内部子模块的设计说明，包括子模块端口规格及功能说明

​		在我们设计的CPU中，我们的内部子模块主要分为TOP, ALU, Controller, Data_Memory, Decoder, PC, IFetch，Registers等几个主要的内部模块，同时也包括了Button, digital_Presenter, KeyDeb等几个主要的外部输入以及输出、对按键输入进行消抖的外部模块。因为在这里只介绍内部子模块的设计，因此对于外部输入输出的模块我们将暂时不在此处展示。



（1）PC模块：

- 输入端口：

  - `en`：使能信号，表示是否允许 PC 模块更新地址。
  - `Addr_result`：ALU 计算得到的跳转目标地址或分支目标地址（例如 beq 指令的目标地址）。
  - `clock`：时钟信号，驱动时序逻辑的时钟。
  - `reset`：复位信号，用于初始化 PC。
  - `Branch`：控制信号，指示是否进行分支跳转。
  - `Zero`：ALU 输出的零标志，表示 ALU 运算结果是否为零。

  输出端口：

  - `PC`：程序计数器，输出当前的指令地址。

- 功能说明：

1. `PC_plus_4`：`PC` 寄存器的值加上 4，表示下一条指令的地址。
2. `Next_PC`：根据分支指令和零标志，确定下一条指令的地址。如果 `Branch` 为 1 并且 `Zero` 也为 1，则表示发生分支跳转，`Next_PC` 为 `Addr_result`，否则 `Next_PC` 为 `PC_plus_4`。
3. `always` 块：根据时钟信号和复位信号更新程序计数器的值。
   - 如果 `reset` 为 1，表示复位信号激活，将 `PC` 置为 0。
   - 如果 `en` 为 1，表示使能信号激活，根据 `Next_PC` 更新 `PC` 的值。



（2）instruction_fetch模块：

- 输入端口：

  - `clk`：时钟信号，驱动时序逻辑的时钟。
  - `rst`：复位信号，用于初始化或复位模块。
  - `PC`：程序计数器的值，表示要读取的指令的地址。

  输出端口：

  - `instruction`：输出的指令，从指令存储器读取。

- 功能说明：

  - `instructionROM` 实例化：模块中包含了一个指令存储器（ROM），通过 `instructionROM` 实例实现。
  - `.clka(clk)`：将输入时钟信号连接到指令存储器的时钟端口，用于控制指令读取的时序。
  - `.addra(PC[15:2])`：将程序计数器的地址的高 14 位连接到指令存储器的地址端口，用于指定要读取的指令地址。
  - `.douta(instruction)`：将指令存储器输出的指令连接到模块的输出端口，实现将读取的指令输出。



（3）Residters模块：

- 输入端口：

  - `en`：使能信号，表示是否允许寄存器模块进行写操作。
  - `clk`：时钟信号，驱动时序逻辑的时钟。
  - `rst`：复位信号，用于初始化或复位寄存器。
  - `Write`：写使能信号，表示是否要写入数据到寄存器中。
  - `ReadReg1`：要读取数据的第一个寄存器的地址。
  - `ReadReg2`：要读取数据的第二个寄存器的地址。
  - `WriteReg`：要写入数据的寄存器的地址。
  - `WriteData`：要写入的数据。

  输出端口：

  - `ReadData1`：从第一个寄存器读取的数据。
  - `ReadData2`：从第二个寄存器读取的数据。

- 功能说明：

  1. `register`：内部定义的寄存器数组，用于存储32位的数据。
  2. `assign` 语句：将要读取的数据从寄存器数组中读取并输出到输出端口。
  3. `always` 块：根据时钟信号和复位信号更新寄存器的值。
     - 如果 `rst` 为 1，表示复位信号激活，将所有寄存器清零。
     - 如果 `en` 为 1，表示使能信号激活，根据 `Write` 和 `WriteReg` 决定是否写入数据到指定寄存器中。



（4）Controller模块：

- 输入端口：

  - `inst`：32位指令，从主控制单元接收。

  输出端口：

  - `Branch`：分支信号，用于控制分支指令的执行。
  - `ALUOp`：ALU（算术逻辑单元）操作码，用于指示 ALU 进行何种操作。
  - `ALUSrc`：ALU 第二个操作数的来源选择信号，可以是寄存器数据、立即数或常数4。
  - `ALUSrc1`：ALU 第一个操作数的来源选择信号，可以是寄存器数据、PC 或者常数0。
  - `PCSrc`：PC（程序计数器）的选择信号，用于控制 PC 的更新方式。
  - `MemRead`：内存读使能信号，指示是否从内存中读取数据。
  - `MemWrite`：内存写使能信号，指示是否向内存中写入数据。
  - `MemtoReg`：内存写回寄存器的数据来源选择信号，指示是否将内存中的数据写回到寄存器。
  - `RegWrite`：寄存器写使能信号，指示是否向寄存器中写入数据。
  - `sign`：符号位，根据指令中的操作码判断是否为无符号操作。
  - `length`：立即数长度，根据指令中的操作码判断立即数的长度。

- 功能说明：

  1. 根据输入的指令 `inst`，提取操作码 `opcode`。
  2. 根据操作码 `opcode` 生成各种控制信号，具体逻辑如下：
     - `Branch`：根据指令类型判断是否为分支指令，若是则为1，否则为0。
     - `ALUOp`：根据指令类型确定 ALU 的操作码。
     - `ALUSrc` 和 `ALUSrc1`：根据指令类型选择 ALU 的操作数来源。
     - `PCSrc`：根据指令类型选择 PC 的更新方式。
     - `MemRead` 和 `MemWrite`：根据指令类型确定是否需要进行内存读写操作。
     - `MemtoReg` 和 `RegWrite`：根据指令类型确定是否需要进行内存写回寄存器和寄存器写操作。
     - `sign`：根据指令中的操作码判断是否为无符号操作。
     - `length`：根据指令中的操作码判断立即数的长度。



（5）Decoder模块：

- 输入端口：

  - `en`：使能信号，控制模块是否工作。
  - `clk`：时钟信号。
  - `rst`：复位信号，用于清除模块状态。
  - `instruction`：32位指令，从控制单元接收。
  - `WriteData`：待写入寄存器的数据。
  - `Write`：写使能信号，指示是否执行寄存器写操作。

  输出端口：

  - `imm`：立即数，从指令中解析出来的立即数。
  - `ReadData1`：第一个寄存器读取数据。
  - `ReadData2`：第二个寄存器读取数据。

- 功能说明：

  1. 根据输入的指令 `instruction`，提取操作码 `opcode`。
  2. 根据操作码 `opcode` 解析出相关信息，包括：
     - 第一个寄存器的编号 `ReadReg1`，根据指令类型确定是否提取。
     - 第二个寄存器的编号 `ReadReg2`，根据指令类型确定是否提取。
     - 待写入的寄存器的编号 `WriteReg`，根据指令类型确定是否提取。
     - 立即数 `imm`，根据指令类型确定是否提取。
  3. 将解析出的信息传递给寄存器模块 `Registers`，并根据需要执行寄存器读写操作。



（6）ALU模块：

- 输入端口：

  - `PCin`：输入的PC值。
  - `ALUSrc`：选择 ALU 第二个操作数的来源，根据指令类型确定。
  - `ALUSrc1`：选择 ALU 第一个操作数的来源，根据指令类型确定。
  - `PCSrc`：选择 PC 的来源，根据指令类型确定。
  - `ALUOp`：ALU 操作类型，用于确定进行何种操作。
  - `funct3`：指令中的功能字段。
  - `funct7`：指令中的功能字段。
  - `ReadData1`：第一个操作数的值。
  - `ReadData2`：第二个操作数的值。
  - `imm32`：立即数，用于某些指令的运算。

  输出端口：

  - `zero`：零标志位，表示 ALU 运算结果是否为零。
  - `ALUResult`：ALU 运算结果。
  - `PCout`：ALU 输出的 PC 值。

- 功能说明：

  1. 根据输入的操作数来源选择相应的操作数：
     - `operand1` 和 `operand2`：根据 `ALUSrc1` 和 `ALUSrc` 来选择操作数的来源，包括寄存器数据、立即数或常数。
     - `operand3` 和 `operand4`：根据 `PCSrc` 来选择 PC 的来源，即 PC 或者第一个操作数。
  2. 根据指令类型和 ALU 操作类型进行相应的运算：
     - 加法、减法、与、或、异或、移位等运算。
  3. 根据运算结果和指令类型确定控制信号：
     - `control`：根据指令类型和功能码确定 ALU 控制信号，包括加法、减法、与、或、异或、移位等。
  4. 将运算结果传递给 `ALUResult` 输出端口，同时计算零标志位 `zero`。
  5. 计算 `PCout`，根据 `operand3` 和 `operand4` 的值进行加法运算，用于更新 PC。



（7）Data_Memory模块：

- 输入端口：

  - `length`：数据长度，0 表示字节（8位），1 表示半字（16位），2 表示字（32位）。
  - `sign`：数据符号，0 表示无符号数据，1 表示有符号数据。
  - `clk`：时钟信号。
  - `rst`：复位信号。
  - `MemRead`：内存读使能信号。
  - `MemWrite`：内存写使能信号。
  - `addr`：地址信号，指定要读取或写入的内存地址。
  - `din`：写入数据。
  - `buttonOn`：按键信号。
  - `io_rdata_switch`：输入的开关信号。

  输出端口：

  - `dout`：读取的数据输出。
  - `LED`：LED 灯输出。

- 功能说明：

  1. 内存读写控制信号生成：
     - `read_mem`：根据地址的最高位确定读取内存的方式。
     - `write_mem`：根据地址的最高位和写使能信号确定写入内存的方式。
  2. 数据选择和转换：
     - 根据输入的数据长度和符号，选择从内存读取的数据并进行相应的转换，生成 `read_data`。
     - 将写入数据进行转换，生成 `write_data`。
  3. 数据存储和读取：
     - `RAM` 模块用于存储数据，并根据地址和写使能信号写入数据。
     - 读取的数据在时钟下降沿时输出到 `dout`。
  4. LED 控制：
     - 当进行内存写操作时，将写入的数据的低 16 位显示在 LED 上。
  5. 复位处理：
     - 在复位信号为高电平时，将输出数据和 LED 灯清零。



（8）TOP模块：

- 输入端口：

  - `clk`：时钟信号。
  - `rst_a`：复位信号。
  - `switches`：输入的开关信号。
  - `button`：按键信号。

  输出端口：

  - `LED`：LED 灯输出。
  - `seg`：数码管输出。
  - `seg1`：数码管输出。
  - `an`：数码管控制信号。

- 功能说明：

  1. 时钟与复位：
     - `rst_a` 经过取反处理后得到 `rst`。
     - 通过状态机控制时钟 `cpu_clk`，在状态为 `3'b110` 时使能。
  2. 输入处理：
     - 按键信号通过键盘模块 `key_deb` 处理后得到 `buttonOn`。
  3. 子模块连接：
     - `digital_presenter` 模块 `dp` 处理数码管显示。
     - `PC` 模块 `pc` 产生程序计数器。
     - `instruction_fetch` 模块 `iFetch` 用于指令取值。
     - `Controller` 模块 `controller` 控制流程。
     - `Decoder` 模块 `decoder` 解码指令。
     - `ALU` 模块 `alu` 实现算术逻辑运算。
     - `Data_Memory` 模块 `dma` 实现数据存储器。
  4. 信号传递：
     - 控制信号、数据信号通过各个子模块连接传递。
  5. 输出处理：
     - 数码管、LED 灯通过对应的模块输出数据进行显示。







## 六. 系统上板使用说明

![FPGA](C:\Users\admin\Desktop\cpu项目文档\FPGA.png)



1. 开发板上与系统操作相关输入键是16个拨码开关用来输入一个16bit的二进制数，使用对应的16个led灯作为输出结果，同时使用7段数码管，将7段数码管的输入连接到led灯上实现在7段数码管上显示输出。
2. 复位使用的是reset键，复位的相关操作是当按下开关后抬起的一次操作后，系统会进行复位操作。
3. CPU确认键设置为开发板右侧5个开关的右侧开关，当按下后抬起的过程结束后实现一个确认的操作。
4. CPU工作模式切换使用的是左侧较大的8个拨码开关的右侧的3个开关，使用一个3bit的二进制数来控制目前测试的样例。在选择样例后按下确认键并抬起进入相应的测试样例。
5. 输出信号的观测区域是16个led灯与8个七段数码管。我们是使用16个led输出一个16bit的二进制数，并且使用7段数码管显示有符号拓展的这个16bit结果的拓展成32bit的结果，每个七段数码管对应4bit的二进制结果，从右向左为从LSB到MSB。







## 七. 自测试说明

​		我们的测试方法主要包括两个部分：对每个指令的单元测试、对每个测试场景的单元测试以及对整体的scene1和scene2测试场景的集成测试，以及对pipeline的单独测试。以下我将会分开说明我们本次项目的测试方式以及过程：



1. 对每个独立指令的单元测试：

| 测试方法 | 测试类型 | 测试用例描述        | 测试结果 |
| -------- | -------- | ------------------- | -------- |
| 上板     | 单元     | ADD x1, x2, x3      | 通过     |
| 上板     | 单元     | SUB x4, x5, x6      | 通过     |
| 上板     | 单元     | XOR x7, x8, x9      | 通过     |
| 上板     | 单元     | OR x10, x11, x12    | 通过     |
| 上板     | 单元     | AND x13, x14, x15   | 通过     |
| 上板     | 单元     | SLL x16, x17, x18   | 通过     |
| 上板     | 单元     | SRL x19, x20, x21   | 通过     |
| 上板     | 单元     | SRA x22, x23, x24   | 通过     |
| 上板     | 单元     | SLT x25, x26, x27   | 通过     |
| 上板     | 单元     | SLTU x28, x29, x30  | 通过     |
| 上板     | 单元     | ADDI x31, x32, 10   | 通过     |
| 上板     | 单元     | XORI x1, x2, 20     | 通过     |
| 上板     | 单元     | ORI x3, x4, 30      | 通过     |
| 上板     | 单元     | ANDI x5, x6, 40     | 通过     |
| 上板     | 单元     | SLLI x7, x8, 5      | 通过     |
| 上板     | 单元     | SRLI x9, x10, 6     | 通过     |
| 上板     | 单元     | SRAI x11, x12, 7    | 通过     |
| 上板     | 单元     | SLTI x13, x14, 50   | 通过     |
| 上板     | 单元     | SLTIU x15, x16, 60  | 通过     |
| 上板     | 单元     | LB x17, 100(x2)     | 通过     |
| 上板     | 单元     | LH x18, 200(x3)     | 通过     |
| 上板     | 单元     | LW x19, 300(x4)     | 通过     |
| 上板     | 单元     | LBU x20, 400(x5）   | 通过     |
| 上板     | 单元     | LHU x21, 500(x6)    | 通过     |
| 上板     | 单元     | SB x22, 600(x7)     | 通过     |
| 上板     | 单元     | SH x23, 700(x8)     | 通过     |
| 上板     | 单元     | SW x24, 800(x9)     | 通过     |
| 上板     | 单元     | BEQ x10, x11, 900   | 通过     |
| 上板     | 单元     | BNE x12, x13, 1000  | 通过     |
| 上板     | 单元     | BLT x14, x15, 1100  | 通过     |
| 上板     | 单元     | BGE x16, x17, 1200  | 通过     |
| 上板     | 单元     | BLTU x18, x19, 1300 | 通过     |
| 上板     | 单元     | JAL x25, 1400       | 通过     |
| 上板     | 单元     | JALR x26, x27, 1600 | 通过     |
| 上板     | 单元     | LUI x28, 0x1234     | 通过     |
| 上板     | 单元     | AUIPC x29, 0x5678   | 通过     |

测试结论：所有的单独指令运行正常，CPU指令运行部分没有问题。



2. 对每个测试场景的单元测试：

| 测试方法 | 测试类型 | 测试用例描述 | 测试结果 |
| -------- | -------- | ------------ | -------- |
| 上板     | 单元     | scene1-1     | 通过     |
| 上板     | 单元     | scene1-2     | 通过     |
| 上板     | 单元     | scene1-3     | 通过     |
| 上板     | 单元     | scene1-4     | 通过     |
| 上板     | 单元     | scene1-5     | 通过     |
| 上板     | 单元     | scene1-6     | 通过     |
| 上板     | 单元     | scene1-7     | 通过     |
| 上板     | 单元     | scene1-8     | 通过     |
| 上板     | 单元     | scene2-1     | 通过     |
| 上板     | 单元     | scene2-2     | 通过     |
| 上板     | 单元     | scene2-3     | 通过     |
| 上板     | 单元     | scene2-4     | 通过     |
| 上板     | 单元     | scene2-5     | 通过     |
| 上板     | 单元     | scene2-6     | 通过     |
| 上板     | 单元     | scene2-7     | 通过     |
| 上板     | 单元     | scene2-8     | 通过     |

测试结论：对每个分开场景测试运行正常，测试场景独立运行结果正确，led和七段数码管输出结果正确。



3. 对scene1和scene2的集成测试：

| 测试方法 | 测试类型 | 测试用例描述 | 测试结果 |
| -------- | -------- | ------------ | -------- |
| 上板     | 集成     | scene1       | 通过     |
| 上板     | 集成     | scene2       | 通过     |

测试结论：总体测试场景1和2的运行结果正确，对每个测试用例的切换和测试用例的选择没有问题，测试场景输出正确。



4. 对pipeline的自测试：

​		由于各个模块是单独写的，我们进行了半集成测试，即对ALU，Controller和Decoder这三个模块集成后的模块进行了测试，我们在rars中生成了几个不同类型的指令并转成二进制数，写到testbench中作为指令输入到这个半集成模块之中，对波形进行查看，确保每一个模块都能正常运行。

![ALUtb](C:\Users\admin\Desktop\cpu项目文档 2\cpu项目文档\ALUtb.png)







## 八. 问题及总结

1. 开发过程中遇到栈空间不足的情况：将栈空间的基地址放在一个在内存中地址比较小的位置，然后改为向上寻址的结构可以解决。
1. 在开发pipeline的过程中，由于比较仓促没有独立测试每一个字模块，导致了信号的保存和传递有时候会出现问题。在后来我们通过对每一个字模块跑了simulation才一个一个找到了问题。对于这样比较复杂的结构，以后在开发前，应当做好充分的设计工作，在确定每一个信号都没有问题之后再投入到开发之中。

















## 九. Bonus介绍



### 1. Pipeline



#### （1） 设计思路



本项目中的pipeline设计思路参考了课件的五级流水线架构，时钟频率设计为23MHz，每个独立的模块在时钟跳变沿开始执行新的任务，各自保留一定的独立性。

![五级流水线](https://img-blog.csdnimg.cn/cf668c6c97f748f9b7042763dffeb018.JPG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3BhdGljaXRh,size_16,color_FFFFFF,t_70#pic_center)对于pipeline的设计，主要有两个重要的组成部分：

- 数据转发
- Hazards处理



#### （2） 数据转发



##### 2.1 数据在模块之间的转发

在时钟跳变沿时，对于pipeline相邻的两个模块，上一个模块的输出会更新，因此，在下一个模块之中，我们需要使用寄存器来保存上一个模块在上一个时钟周期的输出。对此，我们在各个模块中都有使用寄存器，来保存上一个周期的信号，并传递到下一个模块当中，我们使用如下代码将上一阶段的信号在时钟跳变沿时储存在下一模块之中：

```verilog
always@(negedge clk, posedge rst)begin
        if(rst||flush)begin
            Ex_MemtoReg<=1'b0;
            Ex_RegWrite<=1'b0;
            EX_sign <= 1'b0;
            EX_length <= 2'b00;
            EX_MemWrite <= 1'b0;
            EX_MemRead <= 1'b0;
            EX_WriteReg <= 5'd0;
            EX_ReadData2 <= 32'd0;
        end
        else begin
            if(!stall)begin
               Ex_MemtoReg<=MemtoReg;
               Ex_RegWrite<=RegWrite; 
               EX_length <= ID_length;
               EX_sign <= ID_sign;
               EX_MemWrite <= ID_MemWrite;
               EX_MemRead <= ID_MemRead;
               EX_WriteReg <= ID_WriteReg;
               EX_ReadData2 <= in_ReadData2;
            end
        end
    end
```

这是一段ALU模块的代码，他将从ID阶段传来的信号如ID_length，ID_sign存在ALU的寄存器之中，又将这些寄存器作为输出传递到下一个模块之中，实现了信号在不同周期的保存。

```verilog
module ALU(
    input clk,
    input rst,
    input stall,
    input flush,
    input MemtoReg,
    input RegWrite,
    input [1:0] ID_length,//0 for b, 1 for h, 2 for w
    input ID_sign,
    input [4:0]ID_WriteReg,
    input[`REGWIDTH-1:0] in_PCin,
    input[1:0] in_ALUSrc,
    input[1:0] in_ALUSrc1,
    input in_PCSrc,
    input[`ALUOPWIDTH-1:0] in_ALUOp,
    input[2:0] in_funct3,
    input[6:0] in_funct7,
    input[`REGWIDTH-1:0] in_ReadData1,
    input[`REGWIDTH-1:0] in_ReadData2,
    input[`REGWIDTH-1:0] in_imm32,
    input ID_MemWrite,
    input ID_MemRead,
    output zero,
    output[`REGWIDTH-1:0] ALUResult,
    output[`REGWIDTH-1:0] PCout,
    
    output reg Ex_MemtoReg,
    output reg Ex_RegWrite,
    output reg EX_sign,
    output reg EX_MemWrite,
    output reg EX_MemRead,
    output reg[1:0] EX_length,
    output EX_flush,
    output reg[4:0] EX_WriteReg,
    output reg[31:0] EX_ReadData2,
    output PCsel
);
```



##### 1.2 Forwarding

仅仅在相邻两个模块之中传递信号是不足够的，当遇到如data hazard等情况的时候我们需要模块Forwarding来将信号跨模块传递，例如从上一个时钟周期的ALU输出传到下一个周期的ALU。如下是我们Forward模块的代码部分：

```verilog
module Forward(
input[4:0] rs1,
input[4:0] rs2,
input[4:0] W_rd,

input[4:0] preprerd,
input[4:0] prerd,
input[4:0] EX_rd,
input W_RegWrite,
input W_MemtoReg,
input M_RegWrite,
input M_MemtoReg,
input EX_RegWrite,
input EX_MemtoReg,
input[31:0] prepreMemDout,
input[31:0] prepreALUResult,
input[31:0] preMemDout,
input[31:0] preALUResult,
input[31:0] ALUResult,
output reg forward1,forward2,
output reg[31:0] forwarddata1,
output reg[31:0] forwarddata2,
output reg stall,
output reg flush
    );
    always @(*)begin
        if(EX_MemtoReg&&(EX_rd==rs1||EX_rd==rs2)&&prerd!=5'b00000)begin
            stall = 1'b1;
            flush = 1'b1;
        end
        else begin
            stall = 1'b0;
            flush = 1'b0;
        end
        forwarddata1 = 32'd0;
        forwarddata2 = 32'd0;
        forward1 = 1'b0;
        forward2 = 1'b0;

        if(M_RegWrite && prerd != 5'b00000 && (rs1 == prerd || rs2 == prerd)) begin
            if(rs1 == prerd) 
            begin 
            forwarddata1 =
            (M_MemtoReg == 1 ? preMemDout : prepreALUResult); forward1= 1; 
            end 
            if(rs2 == prerd) begin 
            forwarddata2 =(M_MemtoReg == 1 ? preMemDout : prepreALUResult); forward2= 1; 
            end
        end
        if(EX_RegWrite && EX_rd!= 5'b00000 && (rs1 == EX_rd || rs2 == EX_rd))begin
            if(rs1 == EX_rd) begin forwarddata1 =(ALUResult); forward1= 1; end 
            if(rs2 == EX_rd) begin forwarddata2 =(ALUResult); forward2= 1; end
        end
 
    end
endmodule
```

当遇到datahazard时，我们通过hazard的类型，来判断需要选择什么类型的数据来进行forwarding，并产生一个forward信号，传递到ALU之中分选信号（分选ReadData和Forwarddata）。



#### （3） Hazards处理

##### 3.1 Control hazard & Structure hazard

对于这两种hazards，由于我们设定了cpu在时钟上升沿时做写操作，在下降沿时进行读操作，不会产生对同一资源需求的情况。

##### 3.2 Data hazard

如上述的Forward模块代码，我们会通过ID解析的寄存器来判断当前的hazard类型，比如

```
M_RegWrite && prerd != 5'b00000 && (rs1 == prerd || rs2 == prerd)
```

能够判断下一个指令的所用寄存器是否需要依赖上一条指令的输出结果。如果遇到了data hazard，我们会运用这个数据转发模块来减少nop的次数。对于LOAD-USE类型的datahazard 需要输出stall信号和flush信号，将ALU中的预算结果清空，并且停止IF,ID模块的工作，让PC保留为当前的PC，直到一个周期后数据成功从DMA中加载出来后我们才继续向下执行指令。



### （4）测试

由于我们先开发好了single cycle的cpu，各个模块都能正常运行，在进行了pipeline的升级之后，我们只需要测试pipeline确定其不会出现hazard时的问题。我们采用了如下几个涉及data hazard测试场景对我们的pipeline架构进行设计。

![Screenshot 2024-06-01 at 20.58.47](C:\Users\admin\Desktop\cpu项目文档 2\cpu项目文档\Screenshot 2024-06-01 at 20.58.47.png)

由于需要确定cpu在某个特定模块是否有stall，且stall的时钟周期是否正确，我们写了一个simulation文件进行模拟，对cpu的执行过程进行细致分析。

```verilog
`timescale 1ns / 1ps
`include "variables.vh"
`include "ALUvariables.vh"
module TOPtestcs101tb();
wire forward1;
wire forward2;
reg rst;
reg clk;
wire[4:0] ID_WriteReg;
wire[4:0] EX_WriteReg;
wire[4:0] M_WriteReg;
wire[`REGWIDTH-1:0] PCout;
wire[31:0] ID_PC;
wire[31:0] M_Dout;
wire M_MemtoReg;
wire M_RegWrite;
wire cpu_clk;
wire[31:0] out;
reg[15:0] switches;
wire[15:0] LED;
wire[31:0] inst;
wire[31:0] pc;
wire flush;wire stall;wire PCsel;
wire[31:0] EX_Data1;
wire[31:0] EX_Data2;
wire[31:0] forwarddata1;
wire[31:0] forwarddata2;
wire[4:0] ReadReg1;
wire[4:0] ReadReg2;
wire[`ALUOPWIDTH-1:0] ID_ALUOp;
wire[`ALUSRCWIDTH-1:0] ID_ALUSrc;
wire[`ALUSRCWIDTH-1:0] ID_ALUSrc1;
wire flushEX;
wire [31:0] imm;
wire[31:0] ReadData1;
wire[31:0] ReadData2;
wire preRegWrite;
reg button;
wire[4:0] W_rd;
wire [31:0] W_Dout;
wire ID_MemtoReg;
wire EX_MemtoReg;
TOP top(clk,rst,switches,button,W_rd,W_Dout,ID_MemtoReg,EX_MemtoReg,M_MemtoReg,M_RegWrite,preRegWrite,ID_PC,M_Dout,PCout, ID_WriteReg,EX_WriteReg,M_WriteReg,forward1,forward2,ReadData1,ReadData2,imm,flushEX,ID_ALUOp,ID_ALUSrc,ID_ALUSrc1,ReadReg1,ReadReg2,forwarddata1,forwarddata2,EX_Data1,EX_Data2,out,LED,cpu_clk,pc,inst,stall,flush,PCsel);
initial begin
    switches = 16'b0001_0010_0011_0000;
    clk = 1'b0;
    rst = 1'b1;
    button = 1'b0;
    #5 rst = 1'b0;
end
always begin #10 clk = ~clk; end
endmodule
```

以下是我们的测试结果（波形图）部分截图：

![Screenshot 2024-06-01 at 21.51.24](C:\Users\admin\Desktop\cpu项目文档 2\cpu项目文档\Screenshot 2024-06-01 at 21.51.24.png)

如图所示，当程序遇到LOAD-USE型data hazard时，会出现stall，并且只stall一个周期，保证了pipeline的高效运行。







## 2. 扩展指令 lui，aupic



### （1）设计思路



​		对于这两种指令，主要需要实现的就是如图所示的两种计算，并对操作数进行处理。![Screenshot 2024-06-01 at 19.58.06](/Users/liugan/Desktop/Processing/Screenshot 2024-06-01 at 19.58.06.png)

​		因此，我们对ALU的结构进行了重新设计。

​		在ALU中，我们有两操作数operand1和operand2，由于指令的扩展，我们需要两个分选器分别选出operand1和operand2的信号。对于分选器1，其从ReadData1, imm32, PC中选择操作数；对于分选器二，其从imm, ReadData2和four中获取操作数。

```verilog
assign operand1 = (ALUSrc1 == `REG) ? ReadData1 : (ALUSrc1 == `ZERO) ? 32'd0 : PCin;
assign operand2 = 
  (ALUSrc == `IMM && ALUOp==`I && 
  ({funct7,funct3}==`SLLfunc||{funct7,funct3}==`SRAfunc
 ||{funct7,funct3}==`SRLfunc)) ? {27'b0,imm32[4:0]} :
  (ALUSrc==`IMM) ? imm32 : 
  (ALUSrc == `REG) ? ReadData2 : four;
```

​		选择操作数的过程如上述代码所示，其中，ALUSrc和ALUSrc1会在ID阶段根据instruction本身确定。对于本bonus point需要扩展的两条指令，lui在ALU中的两个操作数为0和imm(立即数已经在ID阶段左移十二位，无需在EX中左移)，auipc在ALU中的两个操作数为PC和imm(立即数已经在ID阶段左移十二位，无需在EX中左移)。

​		除了对于ALU进行了改造，我们对Decoder也进行了一定程度的扩展。由于ALU中的分选器需要分选信号，我们在ID阶段对instruction进行解析获取分选信号ALUSrc和ALUSrc1，代码如下所示：

```verilog
assign ALUSrc = 
(opcode==`RTYPE||opcode==`BTYPE) ? `REG : 
(opcode==`IARITH || opcode == `ILOAD 
|| opcode ==`STYPE||opcode==`LUI ||opcode==`AUIPC) ? `IMM:
`FOUR;
assign ALUSrc1 = (opcode==`RTYPE||opcode==`IARITH
||opcode==`ILOAD||opcode==`STYPE||opcode==`BTYPE)?`REG
:(opcode==`LUI) ? `ZERO : `PC;
```



### （2）测试

// TODO: 石岩松









