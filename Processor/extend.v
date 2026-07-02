module SignExtend(
    input  [31:7] Instr,       // Input bits [31:7] directly from the instruction bus
    input  [2:0]  ImmSrc,      // 3-bit control signal from the Control Unit
    output reg [31:0] ImmExt   // Fully sign-extended 32-bit immediate value
);

    always @(*) begin
        case(ImmSrc)
            // I-Type Immediate (e.g., lw, addi)
            3'b000: begin
                ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            end

            // S-Type Immediate (e.g., sw)
            3'b001: begin
                ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            end

            // B-Type Immediate (e.g., beq)
            3'b010: begin
                ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            end

            // J-Type Immediate (e.g., jal)
            3'b011: begin
                ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
            end

            // U-Type Immediate (e.g., lui, auipc)
            // Takes the upper 20 bits directly and pads the lower 12 bits with zeros
            3'b100: begin
                ImmExt = {Instr[31:12], 12'b0};
            end

            default: begin
                ImmExt = 32'b0;
            end
        endcase
    end

endmodule
