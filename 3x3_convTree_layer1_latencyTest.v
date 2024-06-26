// 3x3ConvTree
// Trying to get data out every clock cycle after initial latency period.

`timescale 1ns / 1ns

module K5_E216B_3x3ConvTree_layer1_latencyTest_RTL_TB();
reg  clk, rst; 
wire [143:0] dataOut; 
reg [1727:0] dataIn; 
reg [6:0] configIn; 
reg [35:0] controlIn; 
reg [125:0] gcontrolIn; 
reg [15:0] selectedChannel; 

// To test latency of inputs of layer1 with 3x3 kernel of stride 1.
reg [575:0] L1in; // Layer 1 input = input to 3x3 convolution with stride = 1.
reg [143:0] K1;  //  Layer 1 3x3 convolution kernel.
reg [15:0] in11, in12, in13, in14, in15, in16, in21, in22, in23, in24, in25, in26, in31, in32, in33, in34, in35, in36; // easier inputs to track
reg [15:0] in41, in42, in43, in44, in45, in46, in51, in52, in53, in54, in55, in56, in61, in62, in63, in64, in65, in66; // easier inputs to track

ArrayTop uut(
.clk(clk),
.rst(rst),
.dataOut(dataOut),
.dataIn(dataIn),
.configIn(configIn),
.controlIn(controlIn),
.gControlIn(gcontrolIn)
);

always #1 clk = ~clk;

initial begin;

rst = 1'b1;
clk = 1'b1;
dataIn = 0;

L1in = {
16'd2,  16'd3,  16'd4,  16'd5,  16'd6,  16'd7,
16'd3,  16'd4,  16'd5,  16'd6,  16'd7,  16'd8,
16'd4,  16'd5,  16'd6,  16'd7,  16'd8,  16'd9,
16'd5,  16'd6,  16'd7,  16'd8,  16'd9,  16'd10,
16'd6,  16'd7,  16'd8,  16'd9,  16'd10, 16'd11,
16'd7,  16'd8,  16'd9,  16'd10, 16'd11, 16'd12
};
in11 = L1in[575:560];
in12 = L1in[559:544];
in13 = L1in[543:528];
in14 = L1in[527:512];
in15 = L1in[511:496];
in16 = L1in[495:480];
in21 = L1in[479:464];
in22 = L1in[463:448];
in23 = L1in[447:432];
in24 = L1in[431:416];
in25 = L1in[415:400];
in26 = L1in[399:384];
in31 = L1in[383:368];
in32 = L1in[367:352];
in33 = L1in[351:336];
in34 = L1in[335:320];
in35 = L1in[319:304];
in36 = L1in[303:288];
in41 = L1in[287:272];
in42 = L1in[271:256];
in43 = L1in[255:240];
in44 = L1in[239:224];
in45 = L1in[223:208];
in46 = L1in[207:192];
in51 = L1in[191:176];
in52 = L1in[175:160];
in53 = L1in[159:144];
in54 = L1in[143:128];
in55 = L1in[127:112];
in56 = L1in[111:96];
in61 = L1in[95:80];
in62 = L1in[79:64];
in63 = L1in[63:48];
in64 = L1in[47:32];
in65 = L1in[31:16];
in66 = L1in[15:0];


K1 = {
16'd2,  16'd3,  16'd4,
16'd3,  16'd4,  16'd5,
16'd4,  16'd5,  16'd6
};


#20
rst = 1'b0;
// Send in configuration bitstream. 5 + 4 = 9 cycles of programming latency.
configIn =7'b0000000; 
controlIn =36'b110100110000100100000000000000000000; 
#2
configIn =7'b0100100; 
controlIn =36'b001000000000001000000000000000000000; 
#2
configIn =7'b1101000; 
controlIn =36'b000000001000010000000000000000000000; 
#2
configIn =7'b0000001; 
controlIn =36'b000000000100000000000000111100000000; 
#2
configIn =7'b0100010; 
controlIn =36'b000000000000000000111100000000000000; 
#2
// This is your output channel 
assign selectedChannel =  dataOut[31:16];   // Because output partitioned into 2 by 2 PE tiles. outputVIdxX = 2, outputVIdxY = 0, so 2nd 16 bit output.
// Your input IO Config
//000000000000000000000000110110110110000000110110110110000000000000000000000000110000000000000000000000000000
// Your output IO Config
//000000000000000000
// Put together
// Send in IO Configuration 
gcontrolIn =126'b000000000000000000000000000000000000000000110110110110000000110110110110000000000000000000000000110000000000000000000000000000; 
// 40 cycles of constant data to test functionality 
#2

/*  // 3x3convTree INPUT MAP ('IN1' to 'IN18'). Maps to 'Your input IO Config' 1 locations above.
dataIn = {
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  IN15,IN16,16'd0,    IN11,IN12,16'd0,    IN7,IN8,16'd0,      IN3,IN4,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  IN13,IN14,16'd0,    IN9,IN10,16'd0,     IN5,IN6,16'd0,      IN1,IN2,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  IN17,IN18,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
*/

// save this block for template of kernal locations
/*
dataIn = {
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,  K1[63:48],16'd0,16'd0,  K1[95:80],16'd0,16'd0,  K1[127:112],16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],16'd0,16'd0,  K1[79:64],16'd0,16'd0, K1[111:96],16'd0,16'd0, K1[143:128],16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],16'd0,16'd0,   16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0};
#2
*/

// START SEQUENCE
dataIn = {
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      K1[31:16],in32,16'd0,   K1[63:48],in23,16'd0,   K1[95:80],in21,16'd0,   K1[127:112],in12,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      K1[47:32],16'd0,16'd0,  K1[79:64],16'd0,16'd0,  K1[111:96],16'd0,16'd0, K1[143:128],16'd0,16'd0, 
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      K1[15:0],16'd0,16'd0,   16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0};
#2
dataIn = {
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in33,16'd0,   K1[63:48],in24,16'd0,   K1[95:80],in22,16'd0,   K1[127:112],in13,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in31,16'd0,   K1[79:64],in22,16'd0,   K1[111:96],in13,16'd0,  K1[143:128],in11,16'd0, 
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],16'd0,16'd0,   16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,  
16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0,      16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in34,16'd0,    K1[63:48],in25,16'd0,   K1[95:80],in23,16'd0,     K1[127:112],in14,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in32,16'd0,   K1[79:64],in23,16'd0,    K1[111:96],in14,16'd0,      K1[143:128],in12,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],16'd0,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in35,16'd0,    K1[63:48],in26,16'd0,   K1[95:80],in24,16'd0,     K1[127:112],in15,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in33,16'd0,   K1[79:64],in24,16'd0,    K1[111:96],in15,16'd0,      K1[143:128],in13,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],16'd0,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in42,16'd0,    K1[63:48],in33,16'd0,   K1[95:80],in31,16'd0,     K1[127:112],in22,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in34,16'd0,   K1[79:64],in25,16'd0,    K1[111:96],in16,16'd0,      K1[143:128],in14,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],16'd0,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in43,16'd0,    K1[63:48],in34,16'd0,   K1[95:80],in32,16'd0,     K1[127:112],in23,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in41,16'd0,   K1[79:64],in32,16'd0,    K1[111:96],in23,16'd0,      K1[143:128],in21,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],16'd0,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in44,16'd0,    K1[63:48],in35,16'd0,   K1[95:80],in33,16'd0,     K1[127:112],in24,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in42,16'd0,   K1[79:64],in33,16'd0,    K1[111:96],in24,16'd0,      K1[143:128],in22,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in33,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in45,16'd0,    K1[63:48],in36,16'd0,   K1[95:80],in34,16'd0,     K1[127:112],in25,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in43,16'd0,   K1[79:64],in34,16'd0,    K1[111:96],in25,16'd0,      K1[143:128],in23,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in34,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in52,16'd0,    K1[63:48],in43,16'd0,   K1[95:80],in41,16'd0,     K1[127:112],in32,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in44,16'd0,   K1[79:64],in35,16'd0,    K1[111:96],in26,16'd0,      K1[143:128],in24,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in35,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in53,16'd0,    K1[63:48],in44,16'd0,   K1[95:80],in42,16'd0,     K1[127:112],in33,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in51,16'd0,   K1[79:64],in42,16'd0,    K1[111:96],in33,16'd0,      K1[143:128],in31,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in36,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in54,16'd0,    K1[63:48],in45,16'd0,   K1[95:80],in43,16'd0,     K1[127:112],in34,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in52,16'd0,   K1[79:64],in43,16'd0,    K1[111:96],in34,16'd0,      K1[143:128],in32,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in43,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in55,16'd0,    K1[63:48],in46,16'd0,   K1[95:80],in44,16'd0,     K1[127:112],in35,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in53,16'd0,   K1[79:64],in44,16'd0,    K1[111:96],in35,16'd0,      K1[143:128],in33,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in44,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in62,16'd0,    K1[63:48],in53,16'd0,   K1[95:80],in51,16'd0,     K1[127:112],in42,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in54,16'd0,   K1[79:64],in45,16'd0,    K1[111:96],in36,16'd0,      K1[143:128],in34,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in45,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in63,16'd0,    K1[63:48],in54,16'd0,   K1[95:80],in52,16'd0,     K1[127:112],in43,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in61,16'd0,   K1[79:64],in52,16'd0,    K1[111:96],in43,16'd0,      K1[143:128],in41,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in46,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in64,16'd0,    K1[63:48],in55,16'd0,   K1[95:80],in53,16'd0,     K1[127:112],in44,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in62,16'd0,   K1[79:64],in53,16'd0,    K1[111:96],in44,16'd0,      K1[143:128],in42,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in53,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],in65,16'd0,    K1[63:48],in56,16'd0,   K1[95:80],in54,16'd0,     K1[127:112],in45,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in63,16'd0,   K1[79:64],in54,16'd0,    K1[111:96],in45,16'd0,      K1[143:128],in43,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in54,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,    K1[63:48],16'd0,16'd0,   K1[95:80],16'd0,16'd0,     K1[127:112],16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],in64,16'd0,   K1[79:64],in55,16'd0,    K1[111:96],in46,16'd0,      K1[143:128],in44,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in55,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,    K1[63:48],16'd0,16'd0,   K1[95:80],16'd0,16'd0,     K1[127:112],16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],16'd0,16'd0,   K1[79:64],16'd0,16'd0,    K1[111:96],16'd0,16'd0,      K1[143:128],16'd0,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in56,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,    K1[63:48],16'd0,16'd0,   K1[95:80],16'd0,16'd0,     K1[127:112],16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],16'd0,16'd0,   K1[79:64],16'd0,16'd0,    K1[111:96],16'd0,16'd0,      K1[143:128],16'd0,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in63,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,    K1[63:48],16'd0,16'd0,   K1[95:80],16'd0,16'd0,     K1[127:112],16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],16'd0,16'd0,   K1[79:64],16'd0,16'd0,    K1[111:96],16'd0,16'd0,      K1[143:128],16'd0,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in64,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,    K1[63:48],16'd0,16'd0,   K1[95:80],16'd0,16'd0,     K1[127:112],16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],16'd0,16'd0,   K1[79:64],16'd0,16'd0,    K1[111:96],16'd0,16'd0,      K1[143:128],16'd0,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in65,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
dataIn = {16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[31:16],16'd0,16'd0,    K1[63:48],16'd0,16'd0,   K1[95:80],16'd0,16'd0,     K1[127:112],16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[47:32],16'd0,16'd0,   K1[79:64],16'd0,16'd0,    K1[111:96],16'd0,16'd0,      K1[143:128],16'd0,16'd0, 16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  K1[15:0],in66,16'd0,    16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0,  16'd0,16'd0,16'd0};
#2
// END SEQUENCE


dataIn = {16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0,16'd0};

end


endmodule