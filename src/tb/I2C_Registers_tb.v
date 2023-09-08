`timescale 1ns / 1ps

module I2C_Registers_tb;
reg clk, rst_n, ena;
reg [7:0] reg_addr;
reg [5:0] update_value;
reg read_or_write;
wire [5:0] read_value;
wire [5:0] K_p, K_i, K_d;

I2C_registers uut(
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .reg_addr(reg_addr),
    .update_value(update_value),
    .read_or_write(read_or_write),
    .read_value(read_value),
    .K_p(K_p),
    .K_i(K_i),
    .K_d(K_d)
);
    localparam K_p_ADDRESS = 8'b0010_0000;
    localparam K_i_ADDRESS = 8'b0010_0001;
    localparam K_d_ADDRESS = 8'b0010_0010;

always #10 clk = ~clk; // 50 Mhz

initial begin
    clk = 0; rst_n = 1; ena = 1; //rst_n is active-low.
    #100 reg_addr = K_p_ADDRESS; read_or_write = 1; update_value = 8;
    #100 reg_addr = K_i_ADDRESS; read_or_write = 1; update_value = 16;
    #100 reg_addr = K_d_ADDRESS; read_or_write = 1; update_value = 32;
    $stop;
end


endmodule
