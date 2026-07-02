module pc(
    input clk,
    input reset,
    input [31:0] PCNext,
    output reg [31:0] PC
);

always @(posedge clk or posedge reset)
begin
    if (reset)
        PC <= 32'h00000000;
    else
        PC <= PCNext;
end

endmodule
