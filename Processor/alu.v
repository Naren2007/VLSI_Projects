module alu (
    input  [31:0] srca,      
    input  [31:0] srcb,      
    input  [3:0]  alucntrl,   
    output        zerosignal, 
    output reg [31:0] aluresult
);

    always @(*) begin
        case(alucntrl)
            4'b0000: aluresult = srca + srcb;                        // ADD
            4'b0001: aluresult = srca - srcb;                        // SUB
            4'b0010: aluresult = srca & srcb;                        // AND
            4'b0011: aluresult = srca | srcb;                        // OR
            4'b0100: aluresult = ($signed(srca) < $signed(srcb)) ? 32'd1 : 32'd0; // SLT (Updated to 4'b0100)
            4'b0101: aluresult = (srca < srcb) ? 32'd1 : 32'd0;       // SLTU (Updated to 4'b0101)
            4'b0110: aluresult = srca << srcb[4:0];                  // SLL (Updated to 4'b0110)
            4'b0111: aluresult = srca >> srcb[4:0];                  // SRL (Updated to 4'b0111)
            4'b1000: aluresult = $signed(srca) >>> srcb[4:0];        // SRA (Updated to 4'b1000)
            4'b1001: aluresult = srca ^ srcb;                        // XOR (Updated to 4'b1001)
            4'b1010: aluresult = srcb;                               // Pass SrcB
            default: aluresult = 32'b0;
        endcase
    end

    // Zero signal used for branching instructions (like BEQ)
    assign zerosignal = (aluresult == 32'd0) ? 1'b1 : 1'b0;

endmodule
