`timescale 1ns / 1ps

module PID_tb;

reg clk, rst_n, ena; //The last two aren't used.
reg p_contrib, i_contrib, d_contrib; //PID adjustment contributions.
reg u; //Control variable.

PID uut(
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .p_contrib(p_contrib),
    .i_contrib(i_contrib),
    .d_contrib(d_contrib)
);

always #(20/2) clk = ~clk; //50 MHz
initial begin
    clk = 0;
    //This is a sanity check about overflows.
    #100 p_contrib = 6'b011111; i_contrib = 6'b000001; d_contrib = 6'b000001; //000001/01
    #100 p_contrib = 6'b100000; i_contrib = 6'b100000; d_contrib = 6'b100000; //100000/80
    #100 p_contrib = 6'b111111; i_contrib = 6'b111111; d_contrib = 6'b111111; //111101/F1
end

endmodule
 