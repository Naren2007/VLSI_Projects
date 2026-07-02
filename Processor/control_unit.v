module Control_unit(
   input [6:0] opcode,
   input [31:25] func7,
   input [14:12] func3,
   input zero,
   output reg pcsrc,
   output reg [1:0] resultsrc,
   output reg memwrite,
   output reg [3:0] alucntrl,
   output reg alusrc,
   output reg regwrite,
   output reg [2:0] immsrc
);

   reg branch;
   reg jump;
   reg branch_taken;

   always @(*) begin
      // Default combinational wire states (prevents latches)
      pcsrc     = 1'b0;
      resultsrc = 2'b00; // 00: ALU result, 01: Data Memory, 10: PC+4, 11: Imm (for LUI/AUIPC depending on datapath)
      memwrite  = 1'b0;
      alucntrl  = 4'b0000;
      alusrc    = 1'b0;
      regwrite  = 1'b0;
      immsrc    = 3'b000; // 000: I-type, 001: S-type, 010: B-type, 011: J-type, 100: U-type
      branch    = 1'b0;
      jump      = 1'b0;

      case(opcode)

         //=========================================
         // LOAD INSTRUCTIONS (lb, lh, lw, lbu, lhu)
         //=========================================
         7'b0000011 : begin
            alusrc    = 1'b1;
            regwrite  = 1'b1;
            resultsrc = 2'b01;   // Route Data Memory output to Register file
            immsrc    = 3'b000;  // I-type immediate sign extension
            alucntrl  = 4'b0000; // Address = rs1 + imm (ADD)
         end

         //=========================================
         // STORE INSTRUCTIONS (sb, sh, sw)
         //=========================================
         7'b0100011 : begin
            memwrite  = 1'b1;
            alusrc    = 1'b1;
            immsrc    = 3'b001;  // S-type immediate alignment
            alucntrl  = 4'b0000; // Address = rs1 + imm (ADD)
         end

         //=========================================
         // I-TYPE ALU (addi, slli, slti, sltiu, xori, srli, srai, ori, andi)
         //=========================================
         7'b0010011: begin
            alusrc    = 1'b1;
            regwrite  = 1'b1;
            immsrc    = 3'b000;  // I-type

            case(func3)
               3'b000: alucntrl = 4'b0000; // addi
               3'b001: alucntrl = 4'b0110; // slli
               3'b010: alucntrl = 4'b0100; // slti
               3'b011: alucntrl = 4'b0101; // sltiu
               3'b100: alucntrl = 4'b1001; // xori
               3'b101: begin
                  if(func7[30])
                     alucntrl = 4'b1000;   // srai
                  else
                     alucntrl = 4'b0111;   // srli
               end
               3'b110: alucntrl = 4'b0011; // ori
               3'b111: alucntrl = 4'b0010; // andi
               default: alucntrl = 4'b0000;
            endcase
         end

         //=========================================
         // R-TYPE ALU (add, sub, sll, slt, sltu, xor, srl, sra, or, and)
         //=========================================
         7'b0110011 : begin
            regwrite = 1'b1;
            alusrc   = 1'b0;     // Choose register source rs2 instead of immediate

            case(func3)
               3'b000: begin
                  if(func7[30])
                     alucntrl = 4'b0001;   // sub
                  else
                     alucntrl = 4'b0000;   // add
               end
               3'b001: alucntrl = 4'b0110; // sll
               3'b010: alucntrl = 4'b0100; // slt
               3'b011: alucntrl = 4'b0101; // sltu
               3'b100: alucntrl = 4'b1001; // xor
               3'b101: begin
                  if(func7[30])
                     alucntrl = 4'b1000;   // sra
                  else
                     alucntrl = 4'b0111;   // srl
               end
               3'b110: alucntrl = 4'b0011; // or
               3'b111: alucntrl = 4'b0010; // and
               default: alucntrl = 4'b0000;
            endcase
         end

         //=========================================
         // BRANCHES (beq, bne, blt, bge, bltu, bgeu)
         //=========================================
         7'b1100011 : begin
            branch    = 1'b1;
            immsrc    = 3'b010;  // B-type imm sign-ext alignment
            
            case(func3)
               3'b000: alucntrl = 4'b0001; // beq  -> uses ALU SUB (eval zero flag)
               3'b001: alucntrl = 4'b0001; // bne  -> uses ALU SUB (eval ~zero flag)
               3'b100: alucntrl = 4'b0100; // blt  -> uses ALU SLT (eval rs1 < rs2 signed)
               3'b101: alucntrl = 4'b0100; // bge  -> uses ALU SLT (eval rs1 >= rs2 signed)
               3'b110: alucntrl = 4'b0101; // bltu -> uses ALU SLTU (eval rs1 < rs2 unsigned)
               3'b111: alucntrl = 4'b0101; // bgeu -> uses ALU SLTU (eval rs1 >= rs2 unsigned)
               default: alucntrl = 4'b0001;
            endcase
         end

         //=========================================
         // JUMP AND LINK REGISTER (jalr)
         //=========================================
         7'b1100111 : begin
            alusrc    = 1'b1;
            regwrite  = 1'b1;
            immsrc    = 3'b000;  // I-type structural layout
            resultsrc = 2'b10;  // Saves PC + 4 to destination rd
            alucntrl  = 4'b0000; // Target address base computation: rs1 + imm (ADD)
            jump      = 1'b1;
         end

         //=========================================
         // JUMP AND LINK (jal)
         //=========================================
         7'b1101111 : begin
            regwrite  = 1'b1;
            immsrc    = 3'b011;  // J-type step format
            resultsrc = 2'b10;  // Saves PC + 4 to destination rd
            jump      = 1'b1;
         end

         //=========================================
         // LUI (Load Upper Immediate)
         //=========================================
         7'b0110111 : begin
            regwrite  = 1'b1;
            alusrc    = 1'b1;
            immsrc    = 3'b100;  // U-type structural format
            resultsrc = 2'b11;  // If your design passes Extended Imm straight to RegFile via multiplexer path 3
         end

         //=========================================
         // AUIPC (Add Upper Immediate to PC)
         //=========================================
         7'b0010111 : begin
            regwrite  = 1'b1;
            alusrc    = 1'b1;
            immsrc    = 3'b100;  // U-type structural format
            // If datapath runs AUIPC over the main ALU by combining PC and Imm:
            alucntrl  = 4'b0000; // Select ALU ADD (Ensuring your Datapath MUX feeds PC to ALU OpA)
            resultsrc = 2'b00;  // Grab output from ALU
         end

         default: begin
            // Safety catch-all state
         end
      endcase

      // Branch evaluation logic based on functional type
      case(func3)
         3'b000:  branch_taken = zero;         // BEQ: take branch if inputs match (diff is 0)
         3'b001:  branch_taken = ~zero;        // BNE: take branch if inputs differ (diff is not 0)
         3'b100:  branch_taken = zero;         // BLT: if (rs1 < rs2), ALU slt returns 1, we map it to compare flag
         3'b101:  branch_taken = ~zero;        // BGE: if (rs1 >= rs2), inverse verification flag
         3'b110:  branch_taken = zero;         // BLTU: Unsigned variant trace
         3'b111:  branch_taken = ~zero;        // BGEU: Unsigned variant trace
         default: branch_taken = 1'b0;
      endcase

      // Establish final Program Counter selector signal routing
      if (jump || (branch && branch_taken))
         pcsrc = 1'b1;
   end

endmodule
