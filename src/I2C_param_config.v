/*
This is written as a slave that intakes an "address" and updates
registers depending on their (here written) "addresses". 

The device register frame is 7 bit, and the register and data
frames are 8 bit.

The updating and reading don't use lookup tables in other files because there
are only three values and I don't plan to add many more.

The register handling module gets input from the slave, and the slave and 
signal modules input and output to each other. 
*/

`timescale 1ns / 1ps

module I2C_param_config(
    input  wire       clk, rst_n, ena,
    input  wire       SCL_in, SDA_in, 
    output wire       SCL_ena, SDA_ena, // These are connected to the enable path of the chip.
    output wire       SCL_out, SDA_out,
    output wire [5:0] K_p, K_i, K_d
    );
    // Register Reading/Writing
    wire [7:0] reg_addr;
    wire [5:0] update_value, read_value;
    // Signal Logic
    wire [4:0] state;
    
     I2C_registers Registers ( 
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .reg_addr(reg_addr),
        .update_value(update_value),
        .read_value(read_value),
        .K_p(K_p),
        .K_i(K_i),
        .K_d(K_d)
        );       
    I2C_slave     Slave_settings(
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .SCL_out(SCL_out),
        .SDA_out(SDA_out),
        .SCL_ena(SCL_ena),
        .SDA_ena(SDA_ena),
        .state(state)
    );  
        I2C_signals    Signals (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .state(state),
        .SCL_in(SCL_in),
        .SCL_out(SCL_out),
        .SCL_ena(SCL_ena),
        .SDA_in(SDA_in),
        .SDA_out(SDA_out),
        .SDA_ena(SDA_ena)
        ); 
    
     
endmodule
