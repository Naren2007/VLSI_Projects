`timescale 1ns/1ps

module pc_tb;

reg clk;
reg reset;
reg [31:0] PCNext;
wire [31:0] PC;

// Instantiate DUT
pc uut(
    .clk(clk),
    .reset(reset),
    .PCNext(PCNext),
    .PC(PC)
);

// Clock Generation
always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;
    PCNext = 32'h00000000;

    // Hold reset
    #10;

    reset = 0;

    // First update
    PCNext = 32'h00000004;
    #10;

    // Second update
    PCNext = 32'h00000008;
    #10;

    // Jump example
    PCNext = 32'h00000040;
    #10;

    // Branch example
    PCNext = 32'h00000024;
    #10;

    // Another sequential address
    PCNext = 32'h00000028;
    #10;

    $finish;
end

initial
begin
    $monitor("Time=%0t | Reset=%b | PCNext=%h | PC=%h",
             $time, reset, PCNext, PC);
end

endmodule
