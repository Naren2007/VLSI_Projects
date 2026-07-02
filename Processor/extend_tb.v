`timescale 1ns / 1ps

module tb_SignExtend();

    reg [31:7] Instr;
    reg [1:0]  ImmSrc;
    wire [31:0] ImmExt;

    // Instantiate SignExtend
    SignExtend uut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin
        $display("Starting Sign Extend Unit Testbench...");
        Instr = 25'b0;
        ImmSrc = 2'b00;
        #10;

        // --- Test 1: I-Type Sign Extension (addi x1, x2, -4) ---
        // Top 12 bits [31:20] are 12'hFFC (which represents -4)
        Instr[31:20] = 12'hFFC; 
        ImmSrc = 2'b00;
        #10; // Expected output: 32'hFFFF_FFFC (-4 in 32-bit hex)

        // --- Test 2: S-Type Sign Extension (sw x1, 4(x2)) ---
        // Immediate split into: [31:25] = 7'b0000000, [11:7] = 5'b00100
        Instr[31:25] = 7'b0000000;
        Instr[11:7]  = 5'b00100;
        ImmSrc = 2'b01;
        #10; // Expected output: 32'h0000_0004 (Positive offset 4)

        // --- Test 3: B-Type Sign Extension (beq x1, x2, offset) ---
        // Setup pieces that represent a negative branch offset jump backward
        Instr[31]    = 1'b1;       // Sign bit (negative)
        Instr[7]     = 1'b1;
        Instr[30:25] = 6'b111111;
        Instr[11:8]  = 4'b1111;
        ImmSrc = 2'b10;
        #10; // Expected output: 32'hFFFF_FFFE (Evaluates to a -2 address step)

        $display("Sign Extend Unit simulation checks complete.");
        $finish;
    end

endmodule
