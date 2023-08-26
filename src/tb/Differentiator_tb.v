`timescale 1ns / 1ps

module Differentiator_tb;
reg clk, rst_n, ena;
//Error and integral constant.
reg e, K_d;
//Adjustment contribution to the control.
wire d_contrib;

Differentiator uut(
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .e(e),
    .K_d(K_d),
    .d_contrib(d_contrib)
);

always #(20/2) clk = ~clk; // Run the clock at 50MHz.
initial begin
    clk = 0; ena = 1; rst_n = 0; // Reset is active-low; this will test resetting.
    #100 rst_n = 1; // This ends the resetting.
    // Check the shifts (two bits are taken by I2C, and one by sign).
    e = 1;
    #100 K_d = 1;
    #100 K_d = 2;
    #100 K_d = 4;
    #100 K_d = 8; 
    #100 K_d = 16; 
    #100 e = 2; //"e - e_prior" should be -1.
    #100 K_d = 1;
    #100 K_d = 2; 
    #100 K_d = 4;
    #100 K_d = 8;
    #100 K_d = 16;
end


endmodule
