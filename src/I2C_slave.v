`timescale 1ns / 1ps
/*
This uses a standard frame without "bells and whistles". 

The device register frame is 7 bit, and the register and data
frames are 8 bit.
*/


module I2C_slave(
    input            clk, rst_n, ena,
    input            SCL_in, SDA_in,
    output reg [5:0] update_value,
    output reg [7:0] reg_addr, // addr[2:1] is 00 for P, 01 for I, and 10 for D. addr[0] is the ack bit.
    output reg [4:0] state,
    output reg       read_or_write, // Register handling needs to know whether to read or to write.
    output reg [2:0] data_index // The signal handling needs this for SDA readout.
    );
    
    reg [2:0] addr_index, reg_index;
    reg [6:0] device_addr;
    
    reg       SCL_prev;
    reg [7:0] update_value_temp, reg_addr_temp;
    
    localparam DEVICE_ADDRESS = 7'b011_1111; // A made up placeholder.
    localparam K_p_ADDRESS = 8'b0100_0000;
    localparam K_i_ADDRESS = 8'b0100_0001;
    localparam K_d_ADDRESS = 8'b0100_0010;
    
    // State Parameters
    localparam IDLE          = 0;
	localparam START         = 1;
	localparam DEVICE_ADDR   = 2;
	localparam READ_OR_WRITE = 3;
	localparam ADDR_ACK      = 4;
	localparam REG_ADDR      = 5;
	localparam REG_ACK       = 6;
	localparam WRITE         = 7;
	localparam WRITE_ACK     = 8;
	localparam READ          = 9;
	localparam READ_ACK      = 10;
	localparam STOP          = 11;
    always @ (posedge clk) begin
        if (!rst_n) begin
            state      <= IDLE;
            update_value      <= 0;
            update_value_temp <= 0;
            reg_addr          <= 0;
            reg_addr_temp     <= 0;
            reg_index         <= 0;
            data_index        <= 0;
        end else begin
            if (ena) begin           
                // Edge detect
                SCL_prev <= SCL_in;               
 /*------------------------------------------ Postive Half Cycle -------------------------------------------*/
                if (SCL_in == 1 && SCL_prev == 0) begin
                    case(state)
                        IDLE: begin
                            // Start the process if enabled.
                            if (ena) state <= START;  
                        end           
                        START: begin
                            // Start bit
                            if (SDA_in == 0) state <= DEVICE_ADDR;
                            // Initialize the indices. MSB goes first, LSB goes last.
                            addr_index <= 6;
                            reg_index  <= 7;
                            data_index <= 7;
                        end
                        DEVICE_ADDR: begin                     
                            if (addr_index > 0) begin 
                                // The values are read on the negative half cycle.
                                addr_index <= addr_index - 1;                                                      
                            end else begin 
                                addr_index <= 6;
                                // Check the address is right, otherwise return to idling.
                                if (device_addr == DEVICE_ADDRESS) begin 
                                    state <= READ_OR_WRITE;
                                end 
                                else begin 
                                    state <= IDLE;
                                end  
                            end
                        end    
                        READ_OR_WRITE: begin
                            // If the master is writing, it sends 0, if it is reading it sends 1.
                            if (SDA_in == 0) read_or_write <= 0; // 0 will later be translated to READ.
                            else read_or_write <= 1; // 1 will later be translated to WRITE.
                            state <= ADDR_ACK; 
                        end                  
                        ADDR_ACK: begin
                            // The acknowledge bit is sent on the negative half cycle.                            
                            state <= REG_ADDR;
                        end                   
                        REG_ADDR: begin 
                            if (reg_index > 0) begin
                               reg_index <= reg_index - 1; 
                            end else begin
                                reg_index <= 7;
                                // Check the address is a PID address, otherwise return to idling.
                                if ((reg_addr_temp == K_p_ADDRESS) || (reg_addr_temp == K_i_ADDRESS) || (reg_addr_temp == K_d_ADDRESS)) begin
                                    state <= REG_ACK;
                                end
                                else begin state <= IDLE;
                                end 
                            end 
                        end
                        REG_ACK: begin
                            // The acknowledge bit is sent on the negative half cycle.
                            if(read_or_write == 0) state <= READ;
                            if(read_or_write == 1) state <= WRITE;
                        end                 
                        WRITE: begin
                            // The data is written on the negative half cycle, MSB first, and LSB last. 
                            if (data_index > 0) begin
                                data_index <= data_index - 1;
                            end else begin
                                data_index <= 7;
                                state <= WRITE_ACK;
                            end                            
                        end              
                        WRITE_ACK: begin
                            // Going to IDLE immediately, and through STOP, are not the same because of
                            // the negative half cycle.
                            if (SDA_in == 0) state <= STOP; // If the data is read, proceed.
                            else state <= IDLE; // If the data was not read, the process should be reset. 
                        end
                        READ: begin
                            if (data_index > 0) begin
                                data_index <= data_index - 1;
                            end else begin
                                data_index <= 7;
                                state <= READ_ACK;
                            end
                        end                
                        READ_ACK: begin 
                            // The ACK is sent on the negative half-cycle.
                            state <= STOP;
                        end
                        STOP: begin 
                            // Set the final values now to avoid a partial array matching another register pointer.
                            reg_addr <= reg_addr_temp;
                            update_value <= update_value_temp[5:0];
                            if (SDA_in == 1) state <= IDLE;        
                        end         
                   endcase
                end
    /*------------------------------------------ Negative Half Cycle -------------------------------------------*/
            //START, STOP, ACKs, READ, WRITE (enable), and READ_OR_WRITE are handled by signal logic.
                if (SCL_in == 0 && SCL_prev == 1) begin
                    case(state)
                        IDLE: begin
                            if (ena) state <= START;                   
                        end            
                        DEVICE_ADDR: begin 
                            // Store the device address.                
                            device_addr[addr_index] <= SDA_in;
                        end              
                        REG_ADDR: begin
                            // Store the register adress.
                            reg_addr_temp[reg_index] <= SDA_in;
                        end
                        WRITE: begin
                            update_value_temp[data_index] <= SDA_in;
                        end                               
                   endcase
                end
            end
        end
     end
endmodule
