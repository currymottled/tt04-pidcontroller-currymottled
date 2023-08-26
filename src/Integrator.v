`timescale 1ns / 1ps


module Integrator(
    input            clk,
    input            rst_n,
    input            ena,
    input      [5:0] e,
    input      [5:0] K_i,
    output reg [5:0] i_contrib //Integral contribution.
    );
    
reg [5:0] e_sum; //Integral approximation.
reg [5:0] i;     //Loop index for repeated addition.

// Reset
always @(posedge clk) begin
    if (!rst_n) begin
        e_sum       <= 0;
        i_contrib   <= 0;
        i           <= 0;
    end 
end
// Integrator.
always @(posedge clk) begin
    if (ena) begin
        //Loop for multiplying e_sum by K_i.
        //e_sum needs to be updated after the loop; use the value it will be next.
        if(i < K_i) begin
            i_contrib <= i_contrib + e + e_sum;
        end
        //Reset the loop index and update the integral estimate.
        else begin 
            i <= 0; 
            e_sum <= e_sum + e; 
        end
    end
end   
    
endmodule

