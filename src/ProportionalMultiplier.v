`timescale 1ns / 1ps

module ProportionalMultiplier(
    input            clk,
    input            rst_n,
    input            ena,
    input      [5:0] e,
    input      [5:0] K_p,
    output reg [5:0] p_contrib //Proprotional contribution.
    );
reg [5:0] i; //Loop index for repeated addition.

//Reset
always @(posedge clk) begin
    if (!rst_n) 
        begin
            p_contrib <= 0;
        end 
end
//Repeated addition of the error by K_p. 
always @(posedge clk) begin    
    if (ena) begin
        if(i < K_p)
 begin
            p_contrib <= p_contrib + e; 
            i <= i+1;
        end
        else i <= 0;
    end
end 
endmodule
