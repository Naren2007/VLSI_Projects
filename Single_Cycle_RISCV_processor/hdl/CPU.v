module CPU(
    input clk,
    input reset
);

    // PC Stage
    wire [31:0] PC;
    wire [31:0] PCNext;
    wire [31:0] PCImm;
    
    wire Branch;
    wire [2:0] BranchType;
    wire Jump;
    wire Jalr;
    //wire Zero;

    wire PCSrc;
    
    wire [1:0] PCSel;

    wire [31:0] PCTarget;
    wire [31:0] PCPlus4;
    
    
    // Instruction
    wire [31:0] Instr;

    // Control Signals
    wire RegWrite;
    wire ALUSrc;
    wire [2:0] ImmSrc;
    wire [3:0] ALUControl;

    // Register File
    wire [31:0] RD1;
    wire [31:0] RD2;

    // Immediate Generator
    wire [31:0] ImmExt;

    // ALU Mux Output
    wire [31:0] SrcB;

    // ALU Output
    wire [31:0] ALUResult;
    
    assign PCPlus4 = PC + 32'd4;
    
    assign PCTarget = PC + ImmExt;
    
    assign PCImm = PC + ImmExt;
    
    
    wire [31:0] JalrTarget;

    //assign JalrTarget = RD1 + ImmExt;
    assign JalrTarget = (RD1 + ImmExt) & 32'hFFFFFFFE;
    
    //assign Zero = (RD1 == RD2);
    
    
    reg BranchTaken;
    
    //assign PCSrc = Branch & Zero;
    
    
    wire [31:0] ReadData;
    wire [31:0] Result;
    
    
    wire [2:0] LoadType;

    wire MemWrite;
    wire [1:0] ResultSrc;
    
    wire [1:0] StoreType;
    
    always @(*)
    begin

    case(BranchType)

        3'b000:
            BranchTaken = (RD1 == RD2);

        3'b001:
            BranchTaken = (RD1 != RD2);

        3'b010:
            BranchTaken = ($signed(RD1) < $signed(RD2));

        3'b011:
            BranchTaken = ($signed(RD1) >= $signed(RD2));

        3'b100:
            BranchTaken = (RD1 < RD2);

        3'b101:
            BranchTaken = (RD1 >= RD2);

        default:
            BranchTaken = 0;

    endcase

    end
    
    assign PCSrc = Jump | (Branch & BranchTaken);
    
    
    assign PCSel =Jalr ? 2'b10 :(Jump | (Branch & BranchTaken)) ? 2'b01 :2'b00;
    
    
    pc program_count(
    .clk(clk),
    .PCNext(PCNext),
    .PC(PC),
    .reset(reset)
    );
    
   instruction_memory imem(
    .A(PC),
    .RD(Instr)
    );
    
    wire [6:0] opcode;

    assign opcode = Instr[6:0];
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[31:25];
    
    ControlUnit cu(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl),
    .Branch(Branch),
    .BranchType(BranchType),
    .Jump(Jump),
    .Jalr(Jalr),
    .StoreType(StoreType),
    .LoadType(LoadType)
    );
    
    Extend ext(
    .Instr(Instr),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
    );
    
    regfile regf(

    .clk(clk),

    .A1(Instr[19:15]),
    .A2(Instr[24:20]),
    .A3(Instr[11:7]),

    .WD3(Result),

    .WE3(RegWrite),

    .RD1(RD1),
    .RD2(RD2)
    );
    
    Mux2 ALUSrcMux(

    .D0(RD2),
    .D1(ImmExt),

    .S(ALUSrc),

    .Y(SrcB)
    );
    ALU alu(

    .SrcA(RD1),
    .SrcB(SrcB),

    .ALUControl(ALUControl),

    .ALUResult(ALUResult)
    );
    
    DataMemory dmem(
    .clk(clk),
    .A(ALUResult),
    .WD(RD2),
    .WE(MemWrite),
    .RD(ReadData),
    .StoreType(StoreType),
    .LoadType(LoadType)
    );
    
    /*Mux2 ResultMux(

    .D0(ALUResult),

    .D1(ReadData),

    .S(ResultSrc),

    .Y(Result)

    );*/
    
    /*Mux3 ResultMux(

    .D0(ALUResult),

    .D1(ReadData),

    .D2(PCPlus4),

    .S(ResultSrc),

    .Y(Result)

    ); */
    
    Mux4 ResultMux(

    .D0(ALUResult),

    .D1(ReadData),

    .D2(PCPlus4),

    .D3(PCImm),

    .S(ResultSrc),

    .Y(Result)
    );
    
    
    
    /*Mux2 PCMux(

    .D0(PCPlus4),

    .D1(PCTarget),

    .S(PCSrc),

    .Y(PCNext)

    );*/
    
    
    Mux3 PCMux(

    .D0(PCPlus4),

    .D1(PCTarget),

    .D2(JalrTarget),

    .S(PCSel),

    .Y(PCNext)

    );
    
    
endmodule