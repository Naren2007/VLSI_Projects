module pc
(
    input clk,
    input reset,

    input [31:0] PCNext,

    output reg [31:0] PC
);

always @(posedge clk)
begin
    if(reset)
    begin
        PC<=0;
    end
    else
    PC <= PCNext;
end

endmodule