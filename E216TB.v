`timescale 1 ns / 1 ns
module K5_E216B_3x3ConvTree_RTL_TB();
reg  clk, rst; 
wire [143:0] dataOut; 
reg [1727:0] dataIn;
reg [6:0] configIn; 
reg [35:0] controlIn; 
reg [125:0] gcontrolIn; 
reg [15:0] selectedChannel_3x3; 
reg [15:0] selectedChannel_2x2; 

wire ena;
reg [15:0]endLatency;
reg [4:0]startAddr;
reg [15:0]startLatency;
reg [3:0]strideInterval;
reg valid;
reg writeEn;

reg mux_sel;

//reg [42:0] newdatain;

reg [42:0] newdatain;
//assign newdatain = {configIn, controlIn};
//Test 2
MEM_Comp MEM_Comp_i
     (.ComputeDataIn(dataIn),
      .clk(clk),
      .dataIn(newdatain),
      .dataOut(dataOut),
      .ena(ena),
      .endLatency(endLatency),
      .gControlIn(gcontrolIn),
      .rst(rst),
      .startAddr(startAddr),
      .startLatency(startLatency),
      .strideInterval(strideInterval),
      .valid(valid),
      .writeEn(writeEn),
      .mux_sel(mux_sel));
       

always #1 clk = ~clk;
initial begin;
rst = 1'b1;
clk = 1'b1;
dataIn = 0;
configIn = 7'b0000000; 
controlIn = 36'b000000000000000000000000000000000000; 
mux_sel = 0;
#2
rst = 1'b0;
startAddr = 5'd0;
strideInterval = 4'd1;

startLatency = 0;
endLatency = 9;

writeEn = 1;
valid = 1;
// Send in configuration bitstream
#2
valid = 0;
// Start of 3x3 Config
configIn =7'b0000000; 
controlIn =36'b110100110000100100000000000000000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b0100100; 
controlIn =36'b001000000000001000000000000000000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b1101000; 
controlIn =36'b000000001000010000000000000000000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b0000001; 
controlIn =36'b000000000100000000000000111100000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b0100010; 
controlIn =36'b000000000000000000111100000000000000; 
newdatain = {configIn, controlIn};
// End of 3x3 Config
// Start of 2x2 Config 
#2
configIn =7'b0000000; 
controlIn =36'b100000000000000000000000000000000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b1101000; 
controlIn =36'b010000000000000000000000000000000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b0000001; 
controlIn =36'b000000000000110000000000000000000000; 
newdatain = {configIn, controlIn};
#2
configIn =7'b0100010; 
controlIn =36'b000000110000000000000000000000000000; 
newdatain = {configIn, controlIn};
// End of 2x2 Config

#10 

startAddr = 5'd0;
strideInterval = 4'd1;

startLatency = 9;
endLatency = 12;
//startLatency = 5;
//endLatency = 10;

writeEn = 0;
valid = 1;
#2
valid = 0;
assign selectedChannel_3x3 =  dataOut[31:16];
gcontrolIn =126'b000000000000000000000000000000000000000000110110110110000000110110110110000000000000000000000000110000000000000000000000000000; 
// 40 cycles of constant data to test functionality 
#2
valid = 0;

dataIn = {
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd3,16'd3,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
// alter data to test input latency 
#80


startAddr = 5'd5;
strideInterval = 4'd1;

//startLatency = 15;
//endLatency = 20;
startLatency = 15;
endLatency = 20;

writeEn = 0;
valid = 1;
#2
valid = 0;
// 2x2 
assign selectedChannel_2x2 =  dataOut[15:0];
gcontrolIn =126'b000000000000000001000000000000000000000000000000000000000000000000000000000000000000110110000000000000110110000000000000000000; 
// 40 cycles of constant data to test functionality 
#2
valid = 0;
dataIn = {
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd3,16'd3,16'd0,  16'd3,16'd3,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
 // 2x2
 
end


endmodule
