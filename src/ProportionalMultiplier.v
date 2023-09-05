`timescale 1ns / 1ps

module ProportionalMultiplier(
    input  wire       clk, rst_n, ena,
    input  wire [5:0] e,
    input  wire [5:0] K_p,
    output wire [5:0] p_contrib // Proportional contribution.
);
    // Multiplication takes too much physical space.
    // Repeated addition takes too much file
    // space, therefore it's written elsewhere.
    RepeatedAdder K_p_repadder(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .a(e),
        .b(K_p),
        .a_times_b(p_contrib)
    );
endmodule