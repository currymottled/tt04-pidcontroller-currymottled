`timescale 1ns / 1ps

module Differentiator(
    input            clk, rst_n, ena,
    input      [5:0] e,
    input      [5:0] K_d,
    output     [5:0] d_contrib //Differentiator contribution.
    );
    reg [5:0] e_prior; // More "history" values can be used for a better approximations.
    reg [5:0] e_diff;
    reg [5:0] i;       
    // Reset
    always @(posedge clk) begin
        if (!rst_n) begin
            e_prior      <= 0;
            e_diff       <= 0;
        end 
    end
    // Multiplication takes too much physical space.
    // Repeated addition takes too much file
    // space, therefore it's written elsewhere.
    RepeatedAdder K_d_repadder(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .a(e_diff),
        .b(K_d),
        .a_times_b(d_contrib)
    );

    // Differentiator parameters:
    always @(posedge clk) begin
        if (ena) begin
            e_diff <= e - e_prior;
            e_prior <= e;
        end
    end   
endmodule
