`timescale 1ns / 1ps
/*
There aren't enough values for a lookup table to be worthwhile,
hence this is only two case statements with three cases each.
*/
module I2C_registers(
    input            clk, rst_n, ena,
    input      [7:0] reg_addr,
    input      [5:0] update_value,
    input            read_or_write, 
    output reg [7:0] read_value,
    output reg [5:0] K_p, K_i, K_d
    );

    localparam K_p_ADDRESS = 8'b0100_0000;
    localparam K_i_ADDRESS = 8'b0100_0001;
    localparam K_d_ADDRESS = 8'b0100_0010;
    
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            K_p <= 0;
            K_i <= 0; 
            K_d <= 0;
        end else begin
        if (ena) begin
            case(read_or_write)
                
                // Writing
                1: begin
                    case(reg_addr)
                        K_p_ADDRESS: K_p <= update_value;
                        K_i_ADDRESS: K_i <= update_value;
                        K_d_ADDRESS: K_d <= update_value;
                    endcase 
                end
                // Reading
                0: begin
                    case(reg_addr)
                        K_p_ADDRESS: read_value <= {2'b00, K_p};
                        K_i_ADDRESS: read_value <= {2'b00, K_i};
                        K_d_ADDRESS: read_value <= {2'b00, K_d};
                    endcase
                end 
            endcase
        end
    end
    end
endmodule
    
