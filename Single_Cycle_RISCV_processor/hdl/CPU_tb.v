//`timescale 1ns / 1ps

module CPU_tb;

    reg clk;
    reg reset;
    // DUT
    CPU dut(
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation
    initial begin
        clk = 0;
    end
   always #50
   begin
       clk=~clk;
   end
    // Simulation Control
    initial begin
         reset=1;
         #100;
         reset=0;
        $display("Starting Simulation...");

        #100000;

        $display("--------------------------------");
        $display("PC = %d", dut.PC);
        $display("x0 = %d", dut.regf.rf[0]);
        $display("x1 = %d", dut.regf.rf[1]);
        $display("x2 = %d", dut.regf.rf[2]);
        $display("x3 = %d", dut.regf.rf[3]);
        //$display("x4 = %d", dut.regf.rf[4]);
       // $display("x5 = %d", dut.regf.rf[5]);
       // $display("x6 = %d", dut.regf.rf[6]);
       // $display("x7 = %d", dut.regf.rf[7]);
        //$display("x8 = %d", dut.regf.rf[8]);
        //$display("x9 = %d", dut.regf.rf[9]);
        //$display("x10 = %d", dut.regf.rf[10]);
        //$display("mem[25] = %d", dut.dmem.mem[25]);
        //$display("mem[26] = %d", dut.dmem.mem[26]);
        //$display("x11 = %d", dut.regf.rf[11]);
        //$display("x12 = %d", dut.regf.rf[12]);
        //$display("x13 = %d", dut.regf.rf[13]);
        //$display("x14 = %d", dut.regf.rf[14]);
        //$display("x15 = %d", dut.regf.rf[15]);
        /*$display("x16 = %d", dut.regf.rf[16]);
        $display("x17 = %d", dut.regf.rf[17]);
        $display("x18 = %d", dut.regf.rf[18]);
        $display("x19 = %d", dut.regf.rf[19]);
        $display("x20 = %d", dut.regf.rf[20]);*/
        //$display("x21 = %d", dut.regf.rf[21]);
        //$display("x22 = %d", dut.regf.rf[22]);
        //$display("x23 = %d", dut.regf.rf[23]);
        //$display("x24 = %d", dut.regf.rf[24]);
        //$display("x25 = %d", dut.regf.rf[25]);
        //$display("x26 = %d", dut.regf.rf[26]);
        //$display("x27 = %d", dut.regf.rf[27]);
        //$display("x28 = %d", dut.regf.rf[28]);
        //$display("x29 = %d", dut.regf.rf[29]);
        //$display("x30 = %d", dut.regf.rf[30]);
        //$display("x31 = %d", dut.regf.rf[31]);
        
        
        $display("--------------------------------"); 
        $finish;

    end


endmodule