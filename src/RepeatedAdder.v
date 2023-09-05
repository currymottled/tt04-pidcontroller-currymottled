`timescale 1ns / 1ps

module RepeatedAdder(
    input  wire               clk, rst_n, ena,
    input  wire signed [5:0]  a, 
    input  wire        [5:0]  b,
    output reg  signed [5:0]  a_times_b,
    output reg  signed [15:0] temp_result, // This is oversized to avoid the sign bit being flipped.
    output reg         [5:0]  flag // Set on each addition to check it happened.
    );
    reg signed [15:0] a_reg; // Made to match the size of temp_result.
    reg [5:0] index;
    // Reset
    always @(posedge clk) begin 
        if (!rst_n) begin
           temp_result <= 0;
           flag <= 0;
        end else begin
    // Clipping Multiplier
        if (ena) begin
            // Do the repeated addition "naively".
            if (index <= b) begin
                // Sign Extension
                a_reg <= {{10{a[5]}}, a};
                temp_result <= temp_result[15:0] + a_reg[15:0];   
                index <= index + 1;
                flag <= flag + 1;
                // "Clip" the result. 
                case (temp_result[15])
                // Positive Range
                    0:  begin
                        if (temp_result[14:0] > 14'd31) begin 
                            a_times_b <= 6'b01_1111;
                        end
                        else a_times_b <= {1'b0, temp_result[4:0]};                             
                    end

                // Negative Range
                    1:  begin
                        if (-temp_result[14:0] > 14'd32) begin
                            a_times_b <= 6'b10_0000;
                        end
                        else a_times_b <= {1'b1, temp_result[4:0]}; // E.g., 11_0000 is less negative than 10_0000.
                    end                                            
                endcase             
            end else begin               
                // Reset
                index <= 0;
                temp_result <= 0; 
                flag <= 0;           
            end
        end
    end
    end
endmodule
