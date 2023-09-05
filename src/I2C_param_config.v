/*
This is written as a slave that intakes an "address" and updates
registers depending on their (hard-coded) "addresses". 

The slave intakes data from the master, the signal logic does enables 
and outputs, and the register handling updates registers and reads them
to signal handling to be read to the master.
*/

`timescale 1ns / 1ps

module I2C_param_config(
    input  wire       clk, rst_n, ena,
    input  wire       SCL_in, SDA_in, 
    output wire       SCL_ena, SDA_ena, // These are connected to the enable path of the chip.
    output wire       SCL_out, SDA_out,
    output wire [5:0] K_p, K_i, K_d
    );
    // Indices and data are sent to Registers for writing/reading, and Signals for reading out.
    wire [2:0] reg_index, data_index;
    wire [5:0] update_value, read_value;
    wire [7:0] reg_addr;
    // The state is sent to Signals.
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
        .SCL_in(SCL_in),
        .SDA_in(SDA_in),
        .update_value(update_value),
        .reg_addr(reg_addr),
        .reg_index(reg_index),
        .data_index(data_index),
        .state(state)
    );  
        I2C_signals    Signals (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .state(state),
        .read_value(read_value),
        .data_index(data_index),
        .SCL_in(SCL_in),
        .SCL_out(SCL_out),
        .SDA_out(SDA_out),
        .SCL_ena(SCL_ena),
        .SDA_ena(SDA_ena)
        ); 
    
     
endmodule
