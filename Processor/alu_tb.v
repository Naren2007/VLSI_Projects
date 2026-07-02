`timescale 1ns / 1ps

module alu_tb();

    reg [31:0] srca;
    reg [31:0] srcb;
    reg [3:0]  alucntrl;

    wire        zerosignal;
    wire [31:0] aluresult;

    // Instantiate your exact RV32I ALU
    alu uut (
        .srca(srca), 
        .srcb(srcb), 
        .alucntrl(alucntrl), 
        .zerosignal(zerosignal), 
        .aluresult(aluresult)
    );

    initial begin
        $display("Starting custom RV32I ALU Testbench...");
        srca = 32'd20; srcb = 32'd5; alucntrl = 4'b0000; #10; 
        srca = 32'd20; srcb = 32'd5; alucntrl = 4'b0001; #10; 
        srca = 32'h00000001; srcb = 32'd4; alucntrl = 4'b0101; #10; 
        srca = 32'd55; srcb = 32'd99; alucntrl = 4'b1010; #10; 
        srca = 32'd12; srcb = 32'd12; alucntrl = 4'b0001; #10; 

        $display("Custom RV32I ALU Testbench complete!");
        $finish;
    end
      
endmodule
