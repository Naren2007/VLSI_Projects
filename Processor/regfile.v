module register_file(
    input clk,
    input WE3,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
);

reg [31:0] reg_file [31:0];

// Read Ports
assign RD1 = (A1 == 5'd0) ? 32'd0 : reg_file[A1];
assign RD2 = (A2 == 5'd0) ? 32'd0 : reg_file[A2];

// Write Port
always @(posedge clk)
begin
    if (WE3 && (A3 != 5'd0))
        reg_file[A3] <= WD3;
end

endmodule
