`timescale 1ns / 1ps


module Integrator(
    input  wire       clk, rst_n, ena,
    input  wire [5:0] e,
    input  wire [5:0] K_i,
    output wire [5:0] i_contrib //Integral contribution.
    );
    
reg [5:0] e_sum; //Integral approximation.

    // Reset
    always @(posedge clk) begin
        if (!rst_n) begin
            e_sum       <= 0;
        end 
    end
    // Multiplication takes too much physical space.
    // Repeated addition takes too much file
    // space, therefore it's written elsewhere.
    RepeatedAdder K_d_repadder(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .a(e_sum),
        .b(K_i),
        .a_times_b(i_contrib)
    );
    // Integrator Parameters
    always @(posedge clk) begin 
        // Set e_sum for the next round.
        e_sum <= e_sum + e; 
    end   
    
endmodule

