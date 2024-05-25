`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 06:52:52 PM
// Design Name: 
// Module Name: Mux_two_in
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

module Mux_two_in(in1,in2,mux_select,mux_out);

input [1727:0] in1;
input [1727:0] in2;
input mux_select;
output [1727:0] mux_out;

assign mux_out = mux_select ? in2 : in1;

endmodule
