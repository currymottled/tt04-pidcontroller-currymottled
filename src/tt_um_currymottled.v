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
    // PID wires
    wire [5:0] K_p, K_i, K_d;
    wire [5:0] u, e; //  These use the same lines, so they need to be synchronized and buffered.
    // I2C wires
    wire SCL_in, SCL_out, SDA_in, SDA_out, SCL_ena, SDA_ena; 
    PID                  PID(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .e(e),
        .K_p(K_p),
        .K_i(K_i),
        .K_d(K_d),
        .u(u)
        );     
    I2C_param_config     I2C_Interface(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .SCL_in(SCL_in),
        .SDA_in(SDA_in),
        .SCL_out(SCL_out),
        .SDA_out(SDA_out),
        .SCL_ena(SCL_ena),
        .SDA_ena(SDA_ena),
        .K_p(K_p),
        .K_i(K_i),
        .K_d(K_d)
        ); 
    // Input/Output
    
    // I2C
    assign SDA_in = uio_in[1];
    assign SCL_in = uio_in[0];
    assign uio_out[1:0] = {SDA_out, SCL_out};
    assign uio_oe [1:0] = {SDA_ena, SCL_ena};    
    // PID - Read when clk is high, write when clk is low. 
    assign uio_oe [7:2] = clk ? 6'b00_0000 : 6'b11_1111;
    assign uio_in [7:2] = clk ? e[5:0] : 6'bZ;
    assign uio_out[7:2] = clk ? 6'bZ : u[5:0];
    
endmodule
