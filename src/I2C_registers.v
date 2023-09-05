`timescale 1ns / 1ps
/*
There aren't enough values for a lookup table to be worthwhile,
hence this is only two case statements with three cases each.
*/

module I2C_registers(
    input            clk, rst_n, ena,
    input      [7:0] reg_addr,
    input      [5:0] update_value, 
    output reg [5:0] read_value,
    output reg [5:0] K_p, K_i, K_d
    );
    
    parameter K_p_ADDRESS = 8'b0000_0000;
    parameter K_i_ADDRESS = 8'b0000_0001;
    parameter K_d_ADDRESS = 8'b0000_0010;
    
    // Writing
    always @ (posedge clk) begin
        if (!rst_n) begin
            K_p <= 0;
            K_i <= 0; 
            K_d <= 0;
        end else begin
            case(reg_addr)
                K_p_ADDRESS: K_p <= update_value;
                K_i_ADDRESS: K_i <= update_value;
                K_d_ADDRESS: K_d <= update_value;
            endcase
        end
    end 
    // Reading
    always @ (posedge clk) begin
            case(reg_addr)
                K_p_ADDRESS: read_value <= K_p;
                K_i_ADDRESS: read_value <= K_i;
                K_d_ADDRESS: read_value <= K_d;
            endcase
    end
endmodule
    
