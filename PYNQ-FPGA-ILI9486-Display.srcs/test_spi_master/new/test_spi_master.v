`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/30/2025 10:08:56 PM
// Design Name:
// Module Name: test_spi_master
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module test_spi_master(
    );
    reg clk;
    reg [3:0] btn;
    wire [3:0] led;

    top_module top_module_inst(clk, btn, led);

    initial begin
        clk = 0;         // initialize to zero
        forever #5 clk = ~clk;  // toggle every 5 ps -> 10 ps period
    end

    initial begin
        btn = 0;
        #10 btn[1] = 1;
        #10 btn[1] = 0;
        #10 btn[1] = 1;
        #10 btn[1] = 0;
    end

endmodule
