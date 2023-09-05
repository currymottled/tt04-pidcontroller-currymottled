`timescale 1ns / 1ps

module RepeatedAdder_tb;
reg clk, rst_n, ena;
//Error and integral constant.
reg [5:0] a, b;
//Adjustment contribution to the control.
wire [5:0] a_times_b;
// An oversized temporary result "clipped" to a_times_b.
wire [15:0] temp_result;
// Repeated additions are "flagged" to check they happened.
wire [5:0] flag;
RepeatedAdder uut(
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .a(a),
    .b(b),
    .a_times_b(a_times_b),
    .temp_result(temp_result),
    .flag(flag)
);

always #1 begin // The actual clock speed doesn't matter.
    clk = ~clk;
    $display("a = %2.0d b = %2.0d a_times_b = %2.0d temp_result = %2.0d flag = %2.0d temp_sign = %2.0d", 
    a, b, $signed(a_times_b), $signed(temp_result), flag, temp_result[15]);
end
initial begin
    clk = 0; ena = 1; rst_n = 0; // Reset is active-low; this will test resetting.
    #100 rst_n = 1; // This ends the resetting.

    // Check the shifts (two bits are taken by I2C, and one by sign).
    // Valid, Positive Range
    a = -1;
    b = 5; #20;
    b = 10;#40;
    b = 15;#60;
    b = 20;#80;
    b = 25;#100;
    b = 30;#120;
    a = 2;
    b = 5; #20;
    b = 10;#40;
    b = 15;#60;
    a = 3; 
    b = 5; #20;
    b = 10;#40; 
    a = 4; 
    b = 5;  #20;
    //Valid, Negative Range
    a = -1; //-1
    b = 5; #20;
    b = 10;#40;
    b = 15;#60;
    b = 20;#80;
    b = 25;#100;
    b = 30;#120;
    a = -2; 
    b = 5; #20;
    b = 10;#40;
    b = 15;#60;
    a = -3; 
    b = 5; #20;
    b = 10;#40;
    a = -4; 
    b = 5; #20;
    // Clipping    
    a = 2;
    b = 16;#64;
    b = 30;#120;
    a = -2;
    b = 17;#68;
    b = 30;#120;
    
    $stop;

end

endmodule