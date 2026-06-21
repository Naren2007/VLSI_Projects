module ALU(
    input  [31:0] SrcA,
    input  [31:0] SrcB,
    input  [3:0]  ALUControl,
    output reg [31:0] ALUResult
);
always @(*)
begin
    case (ALUControl)
        4'b0000:
        ALUResult = SrcA + SrcB;
        4'b0001:
        ALUResult = SrcA - SrcB;
        4'b0010:
        ALUResult = SrcA & SrcB;
        4'b0011:
        ALUResult = SrcA | SrcB;
        4'b0100:
        ALUResult = SrcA ^ SrcB;
        4'b0101:
        ALUResult = SrcA << SrcB[4:0];
        4'b0110:
        ALUResult = SrcA >> SrcB[4:0];
        
        4'b0111:
        ALUResult = $signed(SrcA) >>> SrcB[4:0];

        4'b1000:
        ALUResult = ($signed(SrcA) < $signed(SrcB));

        4'b1001:
        ALUResult = (SrcA < SrcB);
        
        4'b1010:
        ALUResult = SrcB;
        
        default:
        ALUResult = 32'b0;
   endcase
end
endmodule