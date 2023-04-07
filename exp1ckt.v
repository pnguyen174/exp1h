`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 01:21:38 PM
// Design Name: 
// Module Name: exp1ckt
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


module exp1ckt( input BTN, input clk, output logic [3:0]An, output logic [7:0]seg, output logic [3:0]led );

logic up1;
logic up2;
logic up3;
logic clk_div;
logic RCO1;
logic [3:0]toROM;
logic [7:0]ROM1out;
logic [7:0]ROM2out;
logic [7:0]sum;
logic [7:0]avg;
logic [3:0]toRAM;
logic [7:0]displayRAM;
logic [3:0]count2out;
logic GT;
logic WE;
logic clr;

always_comb begin
    led = toRAM;
    avg = {1'b0,sum[7:1]}; end

clk_2n_div_test #(.n(24)) MY_DIV ( //25
          .clockin   (clk), 
          .fclk_only (0),          //1 for simulation
          .clockout  (clk_div)   );  

cntr_up_clr_nb #(.n(16)) MY_CNTR1 (
     .clk   (clk_div), 
     .clr   (clr), 
     .up    (up1), 
     .ld    (0), 
     .D     (0), 
     .count (toROM), 
     .rco   (RCO1)   ); 
     
 cntr_up_clr_nb #(.n(16)) MY_CNTR2 (
     .clk   (clk_div), 
     .clr   (clr), 
     .up    (up2), 
     .ld    (0), 
     .D     (0), 
     .count (count2out), 
     .rco   ()   ); 
     
cntr_up_clr_nb #(.n(16)) MY_CNTR3 (
     .clk   (clk_div), 
     .clr   (clr), 
     .up    (up3), 
     .ld    (0), 
     .D     (0), 
     .count (toRAM), 
     .rco   ()   ); 
 
ROM_16x8a my_ROM (
      .addr  (toROM),  
      .data  (ROM1out),  
      .rd_en (1)    );

ROM_16x8b my_ROM2 (
      .addr  (toROM),  
      .data  (ROM2out),  
      .rd_en (1)    );
 
 rca_nb #(.n(8)) MY_RCA (
          .a   (ROM1out), 
          .b   (ROM2out), 
          .cin (8'b00000001), 
          .sum (sum), 
          .co  ()
          );
 
 comp_nb #(.n(8)) MY_COMP (
          .a  (avg), 
          .b  (8'b00001111), 
          .eq (), 
          .gt (GT),
          .lt ()
          );  

 ram_single_port #(.n(4),.m(8)) my_ram (
      .data_in  (avg),  // m spec
      .addr     (toRAM),  // n spec 
      .we       (WE),
      .clk      (clk_div),
      .data_out (displayRAM)
      );  
      
   univ_sseg my_univ_sseg (
     .cnt1    (displayRAM), 
     .cnt2    (count2out), 
     .valid   (1), 
     .dp_en   (0), 
     .dp_sel  (00), 
     .mod_sel (01), 
     .sign    (0), 
     .clk     (clk), 
     .ssegs   (seg), 
     .disp_en (An)    ); 
   
   fsm_template FSM (
     .BTN(BTN),
     .RCO(RCO1),
     .GT(GT),
     .clk(clk_div),
     .up(up1),
     .up2(up2),
     .up3(up3),
     .we(WE),
     .clr(clr));

endmodule
