`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Ratner Surf Designs
// Engineer:  James Ratner
// 
// Create Date: 07/07/2018 08:05:03 AM
// Design Name: 
// Module Name: fsm_template
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generic FSM model with both Mealy & Moore outputs. 
//    Note: data widths of state variables are not specified 
//
// Dependencies: 
// 
// Revision:
// Revision 1.00 - File Created (07-07-2018) 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fsm_template(BTN, RCO, GT, clk, up, up2, up3, we, clr); 
    input  BTN, RCO, GT, clk; 
    output reg up, up2, up3, we, clr;
     
    //- next state & present state variables
    reg NS, PS; //[1:0]
    //- bit-level state representations
    parameter WAIT=1'b0, SCAN=1'b1; 
    

//- model the state registers
    always @ (posedge clk)
          PS <= NS; 
    
    
    //- model the next-state and output decoders
    always @ (BTN, RCO, GT ,PS)
    begin
       up = 0; up2 = 0; up3 = 1; we = 0; clr = 0;// assign all outputs
       case(PS)
          WAIT:
          begin        
             if (BTN == 1)
             begin
                clr = 1;   
                NS = SCAN; 
             end  
             else
             begin
                NS = WAIT; 
             end  
          end
          
          SCAN:
             begin
                if (RCO == 0) begin
                    if (GT == 1) begin
                    up2 = 1;
                    we = 1;
                    up3 = 1;
                    end 
                    else begin
                    up2 = 0;
                    we = 0;
                    up3 = 0;
                    end
                end
                else
                   NS = WAIT;
             end   
             
          default: NS = WAIT; 
            
          endcase
      end              
endmodule



