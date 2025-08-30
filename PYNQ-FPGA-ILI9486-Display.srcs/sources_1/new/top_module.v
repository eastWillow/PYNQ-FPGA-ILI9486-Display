`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 08/30/2025 07:12:23 PM
// Design Name:
// Module Name: top_module
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
module top_module(
    input sysclk,
    input [3:0] btn,
    output [3:0] led
    );
    reg [3:0] state, next_state;
    parameter NONE=3'd0, S1=3'd1, S2=3'd2, S3=3'd3;
    always @ (*) begin
        case (state)
            NONE : next_state = btn[1] ? S1 : NONE;
            S1   : next_state = btn[1] ? S1 : S2;
            S2   : next_state = btn[1] ? S3 : S2;
            S3   : next_state = btn[1] ? S3 : NONE;
            default : next_state = NONE;
        endcase
    end
    always @ (posedge sysclk) begin
        if(btn[0]) begin
            state <= NONE;
        end else begin
            state <= next_state;
        end
    end
    assign led = state;
endmodule
