module datapath(

    input clk,
    input reset,

    // Control signals
    input RegWrite,
    input ALUSrc,
    input MemWrite,
    input [1:0] ResultSrc,
    input PCSrc,
    input [3:0] ALUControl,
    input [2:0] ImmSrc,

    // Outputs to Control Unit
    output Zero,
    output [31:0] Instr,
    output [31:0] PC

);

    // Internal Wires
    wire [31:0] PCNext;
    wire [31:0] PCPlus4;
    wire [31:0] PCTarget;

    wire [31:0] RD1;
    wire [31:0] RD2;

    wire [31:0] SrcA; // <-- Added for AUIPC multiplexing
    wire [31:0] SrcB;

    wire [31:0] ALUResult;

    wire [31:0] ReadData;

    wire [31:0] Result;

    wire [31:0] ImmExt;

    //-------------------------------------------------------
    // Program Counter
    //-------------------------------------------------------

    pc PC_Reg(
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    //-------------------------------------------------------
    // Instruction Memory
    //-------------------------------------------------------

    InstructionMemory IM(
        .A(PC),
        .RD(Instr)
    );

    //-------------------------------------------------------
    // Register File
    //-------------------------------------------------------

    register_file RF(

        .clk(clk),
        .WE3(RegWrite),

        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),

        .WD3(Result),

        .RD1(RD1),
        .RD2(RD2)
    );

    //-------------------------------------------------------
    // Immediate Generator
    //-------------------------------------------------------

    SignExtend EXT(

        .Instr(Instr[31:7]),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)

    );

    //-------------------------------------------------------
    // ALU Source A MUX (Added for AUIPC)
    //-------------------------------------------------------
    // If opcode is AUIPC, choose PC; otherwise choose register data RD1
    assign SrcA = (Instr[6:0] == 7'b0010111) ? PC : RD1;

    //-------------------------------------------------------
    // ALU Source B MUX
    //-------------------------------------------------------

    mux_alusrc ALUMUX(

        .sel(ALUSrc),
        .d0(RD2),
        .d1(ImmExt),
        .y(SrcB)

    );

    //-------------------------------------------------------
    // ALU
    //-------------------------------------------------------

    alu ALU(

        .srca(SrcA), // <-- Swapped out RD1 for the new multiplexed SrcA wire!
        .srcb(SrcB),
        .alucntrl(ALUControl),

        .aluresult(ALUResult),
        .zerosignal(Zero)

    );

    //-------------------------------------------------------
    // Data Memory
    //-------------------------------------------------------

    DataMemory DM(

        .clk(clk),

        .WE(MemWrite),

        .A(ALUResult),

        .WD(RD2),

        .RD(ReadData)

    );

    //-------------------------------------------------------
    // Write Back MUX
    //-------------------------------------------------------

 mux_resultsrc RESMUX (
        .sel(ResultSrc),
        .d0(ALUResult),
        .d1(ReadData),
        .d2(PCPlus4),
        .d3(ImmExt),     // Hooked up perfectly
        .y(Result)
    );
    //-------------------------------------------------------
    // PC + 4
    //-------------------------------------------------------

    pc_plus4 ADD4(

        .PC(PC),

        .PCPlus4(PCPlus4)

    );

    //-------------------------------------------------------
    // Branch Target
    //-------------------------------------------------------

    pc_target TARGET(

        .PC(PC),

        .ImmExt(ImmExt),

        .PCTarget(PCTarget)

    );

    //-------------------------------------------------------
    // Next PC MUX
    //-------------------------------------------------------

    mux_pcsrc PCMUX(

        .sel(PCSrc),

        .d0(PCPlus4),

        .d1(PCTarget),

        .y(PCNext)

    );

endmodule
