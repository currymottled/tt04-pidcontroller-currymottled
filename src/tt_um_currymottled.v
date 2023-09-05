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
    // Wires
    // I2C
    wire SCL_in, SCL_out, SCL_ena;
    wire SDA_in, SDA_out, SDA_ena; 
    //PID
    wire [5:0] K_p, K_i, K_d; 
    wire [5:0] p_contrib, i_contrib, d_contrib; //PID contributions.
    wire [5:0] u, e; // u is the control, e is the error. 
    // I2C
    assign SCL_in = uio_in[0];
    assign SDA_in = uio_in[1];
    assign SCL_out = uio_out[0];
    assign SDA_out = uio_out[1]; 
    assign uio_oe = {6'b0, SDA_ena, SCL_ena};
    // Input/Output
    assign e = uio_in[7:2];
    assign u = uio_out[7:2];    
    // Module Instantiation
    PID                  PID_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .p_contrib(p_contrib),
        .i_contrib(i_contrib),
        .d_contrib(d_contrib),
        .u(u)
        );     
    ProportionalMultiplier P_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .K_p(K_p),
        .e(e),
        .p_contrib(p_contrib)
        );
    Integrator             I_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .e(e),
        .K_i(K_i),
        .i_contrib(i_contrib)
        );
    Differentiator         D_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .e(e),
        .K_d(K_d),
        .d_contrib(d_contrib)
        );
    I2C_param_config     I2C_ins(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .SCL_in(SCL_in),
        .SCL_out(SCL_out),
        .SCL_ena(SCL_ena),
        .SDA_in(SDA_in),
        .SDA_out(SDA_out),
        .SDA_ena(SDA_ena),
        .K_p(K_p),
        .K_i(K_i),
        .K_d(K_d)       
        ); 
endmodule
