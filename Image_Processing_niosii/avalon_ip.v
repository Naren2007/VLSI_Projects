module Image_Processor_Avalon_IP (
    input  wire        clk,
    input  wire        reset_n,

    // Avalon-MM Slave Interface
    input  wire        avs_write,
    input  wire        avs_read,
    input  wire [1:0]  avs_address,
    input  wire [31:0] avs_writedata,
    output reg  [31:0] avs_readdata
);
    reg [2:0] operation;
    reg [7:0] pixel_hold_reg; // Buffer to hold the pixel sent by Nios II
    wire [7:0] processed_pixel;

    // --- Writing from Nios II to IP ---
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            operation <= 3'b000;
            pixel_hold_reg <= 8'd0;
        end else if (avs_write) begin
            case(avs_address)
                2'd0: pixel_hold_reg <= avs_writedata[7:0]; // Offset 0: Data
                2'd1: operation      <= avs_writedata[2:0]; // Offset 4: Operation
            endcase
        end
    end

    // --- Reading from IP to Nios II ---
    always @(*) begin
        case(avs_address)
            2'd0:    avs_readdata = {24'd0, processed_pixel}; // Read processed result
            2'd1:    avs_readdata = {29'd0, operation};       // Read back current op
            default: avs_readdata = 32'hDEADBEEF;             // Debugging constant
        endcase
    end

    // --- Logic Interconnection ---
    Image_Processor u_image_processor (
        .clk(clk),
        .rst(!reset_n),
        .input_pixel(pixel_hold_reg), // Now connected to the Nios II write bus
        .operation(operation),
        .output_pixel(processed_pixel) // Now connected to the Nios II read bus
    );

endmodule