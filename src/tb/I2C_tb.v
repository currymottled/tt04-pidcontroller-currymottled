`timescale 1ns / 1ps

module I2C_tb;

	// Inputs
	reg clk, rst_n, ena;
	reg SCL_in, SDA_in;
	
	// For Looping through SDA_in
	reg [28:0] SDA_instructions;
	integer SDA_index;

	// Outputs
	wire [5:0] K_p, K_i, K_d;
	wire SCL_ena, SCL_out, SDA_ena, SDA_out;
	
	// Parameters for readability	
	parameter START = 1'b0;
	parameter STOP = 1'b1;
	parameter ACK = 1'b0;
	parameter NACK = 1'b1;
	parameter READ = 1'b0;
	parameter WRITE = 1'b1;
	parameter DEVICE_ADDRESS = 7'b0110_011; // A made up placeholder.
	parameter K_p_ADDRESS = 8'b0000_0000;
    parameter K_i_ADDRESS = 8'b0000_0001;
    parameter K_d_ADDRESS = 8'b0000_0010;
    
	I2C_param_config uut(
		// Inputs
		.clk(clk), 
		.rst_n(rst_n), 
		.ena(ena), 
		.SCL_in(SCL_in),
		.SDA_in(SDA_in),
		// Outputs
		.SCL_ena(SCL_ena),
		.SDA_ena(SDA_ena),
		.SCL_out(SCL_out),
		.SDA_out(SDA_out),
        .K_p(K_p),
        .K_i(K_i),
        .K_d(K_d)
	);
	
always begin 
    #(20/2) clk <= ~clk; // 50 MHz
    #(20/2) SCL_in <= ~SCL_in; // Simulating the real interface clock speed is unimportant.
    for (SDA_index = 28; SDA_index > 0; SDA_index = SDA_index - 1) begin
        SDA_in <= SDA_instructions[SDA_index]; #10;
    end
end

	initial begin
		clk = 0; SCL_in = 0; ena = 1; rst_n = 0;
		// End the resetting.
		#100 rst_n = 1; 
	    // The frame format is START_deviceAdress[6:0]_read/write_ACK_registerAddress[6:0]_ACK_data[6:0]_ACK_STOP
	    // START should be 0, read/write corresponds to 0/1, ACK/NACK corresponds to 0/1, and STOP should be 1.
	    // Each read and right should take 29*20 ns = 580 ns.
	    
	    // K_p Write Tests
	    //#600 SDA_instructions = {START, DEVICE_ADDRESS, WRITE, ACK, K_p_ADDRESS, ACK, 8'b0000_0001, ACK, STOP}; 
	    //#600 SDA_instructions = {START, DEVICE_ADDRESS, WRITE, ACK, K_p_ADDRESS, ACK, 8'b0000_0010, ACK, STOP}; 
        #600 SDA_instructions = {START, DEVICE_ADDRESS, WRITE, ACK, K_p_ADDRESS, ACK, 8'b0100_0000, ACK, STOP}; 
        // K_p Read Test
	    //#600 SDA_instructions = {START, DEVICE_ADDRESS, READ, ACK, K_p_ADDRESS, ACK, 8'b000_00000, STOP};       
        
		$stop;
	end      
endmodule
