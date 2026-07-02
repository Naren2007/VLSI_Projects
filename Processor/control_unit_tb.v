`timescale 1ns / 1ps

module tb_Control_unit();

    // Inputs to the Control Unit
    reg [6:0] opcode;
    reg [31:25] func7;
    reg [14:12] func3;
    reg zero;

    // Outputs from the Control Unit
    wire pcsrc;
    wire [1:0] resultsrc;
    wire memwrite;
    wire [2:0] alucntrl; 
    wire alusrc;
    wire regwrite;   
    wire [2:0] immsrc;

    // Instantiate the Unit Under Test (UUT)
    Control_unit uut (
        .opcode(opcode), 
        .func7(func7), 
        .func3(func3), 
        .zero(zero), 
        .pcsrc(pcsrc), 
        .resultsrc(resultsrc), 
        .memwrite(memwrite), 
        .alucntrl(alucntrl), 
        .alusrc(alusrc), 
        .regwrite(regwrite), 
        .immsrc(immsrc)
    );

    initial begin
        // Monitor setup to print changes directly to the ModelSim transcript console
        $monitor("Time=%0dns | Opcode=%b | f3=%b | f7_30=%b | Zero=%b | PCsrc=%b | RegW=%b | ALUSrc=%b | ALUCntrl=%b | ImmSrc=%b | ResSrc=%b", 
                 $time, opcode, func3, func7[30], zero, pcsrc, regwrite, alusrc, alucntrl, immsrc, resultsrc);

        $display("Starting Control Unit Testbench...");

        // =================================================================
        // Test 1: Load Word (lw) - Opcode 7'b0000011
        // =================================================================
        opcode = 7'b0000011; func3 = 3'b010; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: regwrite=1, alusrc=1, resultsrc=2'b01, immsrc=3'b000, alucntrl=3'b000, pcsrc=0

        // =================================================================
        // Test 2: I-Type Add Immediate (addi) - Opcode 7'b0010011, func3 000
        // =================================================================
        opcode = 7'b0010011; func3 = 3'b000; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: regwrite=1, alusrc=1, resultsrc=2'b00, immsrc=3'b000, alucntrl=3'b000, pcsrc=0

        // =================================================================
        // Test 3: R-Type Addition (add) - Opcode 7'b0110011, func3 000, func7 bit30=0
        // =================================================================
        opcode = 7'b0110011; func3 = 3'b000; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: regwrite=1, alusrc=0, alucntrl=3'b000 (ADD), pcsrc=0

        // =================================================================
        // Test 4: R-Type Subtraction (sub) - Opcode 7'b0110011, func3 000, func7 bit30=1
        // =================================================================
        opcode = 7'b0110011; func3 = 3'b000; func7 = 7'b0100000; zero = 1'b0;
        #10; // Expected: regwrite=1, alusrc=0, alucntrl=3'b001 (SUB), pcsrc=0

        // =================================================================
        // Test 5: Store Word (sw) - Opcode 7'b0100011
        // =================================================================
        opcode = 7'b0100011; func3 = 3'b010; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: memwrite=1, alusrc=1, immsrc=3'b001, alucntrl=3'b000, regwrite=0

        // =================================================================
        // Test 6: Branch Equal (beq) - NOT TAKEN (zero is false)
        // =================================================================
        opcode = 7'b1100011; func3 = 3'b000; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: immsrc=3'b010, alucntrl=3'b001 (SUB), pcsrc=0 (Because zero=0)

        // =================================================================
        // Test 7: Branch Equal (beq) - TAKEN (zero is true)
        // =================================================================
        opcode = 7'b1100011; func3 = 3'b000; func7 = 7'b0000000; zero = 1'b1;
        #10; // Expected: immsrc=3'b010, alucntrl=3'b001 (SUB), pcsrc=1 (Branch taken!)

        // =================================================================
        // Test 8: Unconditional Jump (jal) - Opcode 7'b1101111
        // =================================================================
        opcode = 7'b1101111; func3 = 3'b000; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: regwrite=1, immsrc=3'b011, resultsrc=2'b10 (PC+4), pcsrc=1 (Always Jump)

        // =================================================================
        // Test 9: Load Upper Immediate (lui) - Opcode 7'b0110111
        // =================================================================
        opcode = 7'b0110111; func3 = 3'b000; func7 = 7'b0000000; zero = 1'b0;
        #10; // Expected: regwrite=1, alusrc=1, immsrc=3'b100, alucntrl=3'b101, resultsrc=2'b00

        // End Simulation
        $display("Control Unit Testbench execution complete!");
        $finish;
    end

endmodule
