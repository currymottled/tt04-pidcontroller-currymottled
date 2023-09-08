`timescale 1ns / 1ps

module I2C_tb;

	// Inputs
	reg clk, rst_n, ena;
	reg SCL_in, SDA_in;
	
	// For Looping through SDA_in
	integer SDA_index;
	reg [28:0] SDA_instructions;

	// Outputs
	wire [5:0] K_p, K_i, K_d;
	wire SCL_ena, SCL_out, SDA_ena, SDA_out;
	wire [6:0] device_addr;
	// Indices and data are sent to Registers for writing/reading, and Signals for reading out.
    wire [2:0] addr_index, reg_index, data_index;
    wire [5:0] update_value;
    wire [7:0] read_value;
    wire [7:0] reg_addr;
    // The state is sent to Signals.
    wire [4:0] state;
    wire       read_or_write;
	// Parameters for readability	
	localparam START = 1'b0;
	localparam STOP = 1'b1;
	localparam ACK = 1'b0;
	localparam NACK = 1'b1;
	localparam READ = 1'b0;
	localparam WRITE = 1'b1;
	localparam DEVICE_ADDRESS = 7'b011_1111; // A made up placeholder.
	localparam K_p_ADDRESS = 8'b0100_0000;
    localparam K_i_ADDRESS = 8'b0100_0001;
    localparam K_d_ADDRESS = 8'b0100_0010;
    
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
// System Clock Generation
always begin 
    #(20/2) clk <= ~clk; // 50 MHz
end
//Interface Clock Generation
always begin
    #(160/2) SCL_in <= ~SCL_in; // Simulating the real interface clock speed is unimportant.
end
// Data Generation
always begin
    for (SDA_index = 28; SDA_index > 0; SDA_index = SDA_index - 1) begin
       #160 SDA_in <= SDA_instructions[SDA_index]; // This should be half the rate of the SCL clock; data is read in on the negative half cycle.
    end
end

	initial begin
		clk = 0; SCL_in = 0; ena = 1; rst_n = 0;
		// End the resetting.
		#100 rst_n = 1; 
	    // The frame format is START_deviceAdress[6:0]_read/write_ACK_registerAddress[6:0]_ACK_data[6:0]_ACK_STOP
	    // START should be 0, read/write corresponds to 0/1, ACK/NACK corresponds to 0/1, and STOP should be 1.
	    // Each of these instruction sets takes 29 * 160 = 4640 ns.
        SDA_instructions = {START, DEVICE_ADDRESS, WRITE, ACK, K_p_ADDRESS, ACK, 8'b0001_1110, ACK, STOP};

        // K_p Read Test
	    //#600 SDA_instructions = {START, DEVICE_ADDRESS, READ, ACK, K_p_ADDRESS, ACK, 8'b000_00000, STOP};       
        
		$stop;
	end      
endmodule
