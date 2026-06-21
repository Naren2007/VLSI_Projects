module instruction_memory_tb;
   reg [31:0] A;
   wire [31:0] RD;
   instruction_memory dut(A,RD);
   initial
   begin
       A=0;
       #10;
       A=4;
       #10;
       A=8;
       #10;
   end
endmodule