//This avoids putting the adder at the top level,
//and the module is useful if more things are added later.

`timescale 1ns / 1ps

module PID(
    input  wire       clk, rst_n, ena,
    input  wire [5:0] e,
    input  wire [5:0] p_contrib,
    input  wire [5:0] i_contrib,
    input  wire [5:0] d_contrib,
    output wire [5:0] u
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

    assign u = p_contrib + i_contrib + d_contrib;

endmodule
