`timescale 1ns / 1ps

module Differentiator(
    input  wire       clk, rst_n, ena,
    input  wire [5:0] e,
    input  wire [5:0] K_d,
    output wire [5:0] d_contrib //Differentiator contribution.
    );
    reg signed [5:0] e_prior, e_diff; // More "history" values can be used for a better approximations.
    
    
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

    always @(posedge clk) begin
        if (!rst_n) begin
            e_prior <= 0;
            e_diff  <= 0;
        end else begin
        if (ena) begin
            // Set the error parameters for the next round.
            e_diff <= $signed(e) - e_prior;
            e_prior <= e;
        end
    end
    end   
endmodule
