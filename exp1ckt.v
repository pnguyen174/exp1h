`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aiden Tung, Peter Nguyen, Ray Liu
// 
// Create Date: 04/05/2023 01:21:38 PM
// Module Name: exp1ckt
// Project Name: Experiment 1H
// Description: Circuit designed to read values from two ROM's and check if the average of those
// values is greater than 15 (rounded up). If so, writes to a RAM then displays number of valid values 
// and values written using a 7-segment display on the Basys3 board
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module exp1ckt(
  input BTN, 
  input clk, 
  output logic [3:0]An, 
  output logic [7:0]seg, 
  output logic [3:0]led
  );
   
// wires 
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


assign led = toRAM; // displaying address of RAM to LED
assign avg = {1'b0,sum[7:1]}; // bit slicing to average two values (rounding up)

clk_2n_div_test #(.n(24)) MY_DIV ( 
     .clockin   (clk), 
     .fclk_only (0),          
     .clockout  (clk_div)  
     );  

cntr_up_clr_nb #(.n(4)) MY_CNTR1 ( // counter for ROM's
     .clk   (clk_div), 
     .clr   (clr), 
     .up    (up1), 
     .ld    (0), 
     .D     (0), 
     .count (toROM), 
     .rco   (RCO1)   
     ); 
     
cntr_up_clr_nb #(.n(5)) MY_CNTR2 ( // counter for tracking valid values
     .clk   (clk_div), 
     .clr   (clr), 
     .up    (up2), 
     .ld    (0), 
     .D     (0), 
     .count (count2out), 
     .rco   ()   
     ); 
     
cntr_up_clr_nb #(.n(4)) MY_CNTR3 ( // counter for cycling thorugh RAM address
     .clk   (clk_div), 
     .clr   (clr), 
     .up    (up3), 
     .ld    (0), 
     .D     (0), 
     .count (toRAM), 
     .rco   ()   
     ); 
 
ROM_16x8a my_ROM (
     .addr  (toROM),  
     .data  (ROM1out),  
     .rd_en (1)    
     );

ROM_16x8b my_ROM2 (
      .addr  (toROM),  
      .data  (ROM2out),  
      .rd_en (1)    
      );
 
 rca_nb #(.n(8)) MY_RCA (
      .a   (ROM1out), 
      .b   (ROM2out), 
      .cin (8'b00000001), // adding 1 as carry-in allows for rounding up when bit slicing
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
      .data_in  (avg), 
      .addr     (toRAM),  
      .we       (WE),
      .clk      (clk_div),
      .data_out (displayRAM)
      );  
      
   univ_sseg my_univ_sseg (
      .cnt1    ({6'b000000, displayRAM}), 
      .cnt2    ({3'b000, count2out}), 
      .valid   (1), 
      .dp_en   (0), 
      .dp_sel  (2'b00), 
      .mod_sel (2'b01), 
      .sign    (0), 
      .clk     (clk), 
      .ssegs   (seg), 
      .disp_en (An)
      ); 
   
   fsm_template FSM (
      .BTN(BTN),
      .RCO(RCO1),
      .GT(GT),
      .clk(clk_div),
      .up(up1),
      .up2(up2),
      .up3(up3),
      .we(WE),
      .clr(clr)
      );

endmodule
