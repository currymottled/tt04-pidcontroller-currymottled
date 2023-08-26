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
    
    //Registers
    //I2C communication for changing the PID constants will take input/output lines.
    reg [5:0] e;        // Error.
    
    //Wires
    wire [5:0] K_p, K_i, K_d; //PID constants.
    wire [5:0] p_contrib, i_contrib, d_contrib; //PID contributions.
    wire [5:0] u;             // Control variable.

    assign u = p_contrib + i_contrib + d_contrib;
    //The chip output is the control.
    assign uio_out = u;
    
    // Configure uio_oe to set the uio_in as inputs (active low)
    assign uio_oe = 8'b0;
    // Reset
    always @(posedge clk) begin
        if (!rst_n) begin
            uo_out <= 0;
        end 
    end 
// Module Instantiation 
    ProportionalMultiplier P_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .K_p(K_p),
        .e(e),
        .p_contrib(p_contrib));
    Integrator             I_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .e(e),
        .K_i(K_i),
        .i_contrib(i_contrib));
    Differentiator         D_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .e(e),
        .K_d(K_d),
        .d_contrib(d_contrib));   

endmodule
