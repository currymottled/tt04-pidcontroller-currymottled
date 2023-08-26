`timescale 1ns / 1ps

module ProportionalMultiplier_tb;
reg clk, rst_n, ena;
//Error and integral constant.
reg e, K_p;
//Adjustment contribution to the control.
wire i_contrib;

ProportionalMultiplier uut(
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .e(e),
    .K_p(K_p),
    .p_contrib(p_contrib)
);

always #(20/2) clk = ~clk; // Run the clock at 50MHz.
initial begin
    clk = 0; ena = 1; rst_n = 0; // Reset is active-low; this will test resetting.
    #100 rst_n = 1; // This ends the resetting.
    // Check the shifts (two bits are taken by I2C, and one by sign).
    e = 1;
    #100 K_p = 1;
    #100 K_p = 2;
    #100 K_p = 4;
    #100 K_p = 8; 
    #100 K_p = 16; 
end


endmodule
