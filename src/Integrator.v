`timescale 1ns / 1ps
/* Multiplication takes too much physical space.
   Repeated addition takes too much file
   space, therefore it's written elsewhere. */

module Integrator(
    input  wire       clk, rst_n, ena,
    input  wire [5:0] e,
    input  wire [5:0] K_i,
    output wire [5:0] i_contrib //Integral contribution.
    );
// The integral appromximation and error input should be signed.   
reg signed [5:0] e_sum; 

    RepeatedAdder K_d_repadder(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .a(e_sum),
        .b(K_i),
        .a_times_b(i_contrib)
    );  
    
        
    always @(posedge clk) begin
        // Reset
        if (!rst_n) begin
            e_sum <= 0;
        end else begin
            // Set e_sum for the next contribution.
            e_sum <= $signed(e) + e_sum;
        end 
    end 
endmodule

