module tt_um_currymottled
(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output reg [7:0] uo_out,    // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // 8-bit Adder Logic (combinational part)
    wire [7:0] sum;       // Sum of ui_in and uio_in
    assign sum = ui_in + uio_in;

    // Configure uio_oe to set the uio_in as inputs (active low)
    assign uio_oe = 8'b0;

    // Clocked Adder Logic with Synchronous Reset
    always @(posedge clk) begin
        if (!rst_n) begin
            uo_out <= 8'b0; // Synchronous reset
        end else if (ena) begin
            uo_out <= sum;  // Capture the sum if enabled
        end
    end

endmodule
