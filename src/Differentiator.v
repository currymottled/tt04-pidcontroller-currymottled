`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2023 12:29:31 PM
// Design Name: 
// Module Name: Differentiator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Differentiator(
    input            clk,
    input            rst_n,
    input            ena,
    input      [5:0] e,
    input      [5:0] K_d,
    output reg [5:0] d_contrib //Differentiator contribution.
    );
reg [5:0] e_prior; //Last value. More values can be used for a better approximations.
reg [5:0] i;       //Loop index for repeated addition.
// Reset
always @(posedge clk) begin
    if (!rst_n) begin
        e_prior      <= 0;
        d_contrib    <= 0;
    end 
end
// Integrator
always @(posedge clk) begin
    if (ena) begin
        //Loop for multiplying e - e_prior by K_d.
        if(i < K_d) begin
            d_contrib <= d_contrib + e - e_prior;
            i <= i+1;
        end
        //Reset the loop index.
        else begin 
            i <= 0; 
        end
    end
end   
endmodule
