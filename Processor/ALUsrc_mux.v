module mux_alusrc(
    input sel,
    input [31:0] d0,
    input [31:0] d1,
    output [31:0] y
);

assign y = sel ? d1 : d0;

endmodule
