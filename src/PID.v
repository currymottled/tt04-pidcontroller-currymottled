`timescale 1ns / 1ps

module PID(
    input        clk, rst_n, ena,
    input  [5:0] p_contrib,
    input  [5:0] i_contrib,
    input  [5:0] d_contrib,
    output [5:0] u
    );

//This avoids putting the adder at the top level,
//and the module is useful if more things are added later.
assign u = p_contrib + i_contrib + d_contrib;
    
endmodule
