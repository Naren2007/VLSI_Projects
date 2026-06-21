module ALU_tb;

reg [31:0] SrcA;
reg [31:0] SrcB;
reg [2:0] ALUControl;

wire [31:0] ALUResult;

ALU dut(
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult)
);

initial begin

    SrcA = 10;
    SrcB = 20;

    ALUControl = 3'b000; 
    #10;

    ALUControl = 3'b001; 
    #10;

    ALUControl = 3'b011;
    #10;


end

endmodule