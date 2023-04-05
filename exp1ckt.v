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
logic toROM;
logic ROM1out;
logic ROM2out;
logic [7:0]sum;
logic [7:0]avg;
logic toRAM;
logic displayRAM;

assign avg = {1'b0,sum[7:1]};

clk_2n_div_test #(.n(25)) MY_DIV (
          .clockin   (clk), 
          .fclk_only (1),          
          .clockout  (clk_div)   );  

cntr_up_clr_nb #(.n(16)) MY_CNTR1 (
     .clk   (clk_div), 
     .clr   (BTN), 
     .up    (up1), 
     .ld    (0), 
     .D     (0), 
     .count (toROM), 
     .rco   (RCO1)   ); 
     
 cntr_up_clr_nb #(.n(16)) MY_CNTR2 (
     .clk   (clk_div), 
     .clr   (BTN), 
     .up    (up2), 
     .ld    (0), 
     .D     (0), 
     .count (xxxx) ); 
//     .rco   (xxxx)   ); 
     
cntr_up_clr_nb #(.n(16)) MY_CNTR3 (
     .clk   (clk_div), 
     .clr   (BTN), 
     .up    (up3), 
     .ld    (xxxx), 
     .D     (xxxx), 
     .count (toRAM) ); 
//     .rco   (xxxx)   ); 
 
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
          .cin (1), 
          .sum (sum) 
        //  .co  (xxxx)
          );
 
 comp_nb #(.n(8)) MY_COMP (
          .a  (avg), 
          .b  (8'b00001111), 
         // .eq (xxxx), 
          .gt (xxxx)
         // .lt (xxxx)
          );  

 ram_single_port #(.n(4),.m(8)) my_ram (
      .data_in  (avg),  // m spec
      .addr     (toRAM),  // n spec 
      .we       (xxxx),
      .clk      (clk_div),
      .data_out (displayRAM)
      );  
      
 //  univ_sseg my_univ_sseg (
//     .cnt1    (), 
//     .cnt2    (), 
//     .valid   (), 
//     .dp_en   (), 
//     .dp_sel  (), 
//     .mod_sel (), 
//     .sign    (), 
//     .clk     (), 
//     .ssegs   (), 
//     .disp_en ()    ); 

endmodule
