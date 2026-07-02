module DataMemory(
    input [31:0]  A,          // Address Input (from ALUResult)
    input [31:0]  WD,         // Write Data Input (from Register File RD2)
    input         WE,         // Write Enable Input (from Control Unit MemWrite)
    input         clk,        // System Clock
    output [31:0] RD          // Read Data Output (to Result Mux pin 1)
);

    // 256 entries of 32-bit words (Total 1KB of memory workspace)
    reg [31:0] mem [0:255];

    // --- Combinational Read ---
    // According to your schematic, reading is completely asynchronous/combinational. 
    // The data is read out instantly during the execution phase.
    // We shift the address line by 2 (A[31:2]) to strip the byte offsets and get the word index.
    assign RD = mem[A[31:2]];

    // --- Synchronous Sequential Write ---
    // Writing to memory safely updates only on the rising clock edge when WE is active.
    always @(posedge clk) begin
        if (WE) begin
            mem[A[31:2]] <= WD;
        end
    end

endmodule
