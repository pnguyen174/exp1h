`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Ratner Surf Designs
// Engineer:  Template: James Ratner
//            Modified/Designed: Aiden Tung, Peter Nguyen, Ray Liu
// Create Date: 07/07/2018 08:05:03 AM
// Module Name: fsm_template
// Project Name: Experiment 1H FSM
// Description: FSM controlling circuit designed in main circuit module
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
    localparam WAIT=1'b0, SCAN=1'b1; 
    

    //- model the state registers
    always @ (posedge clk)
          PS <= NS; 
    
    
    //- model the next-state and output decoders
    always @ (BTN, RCO, GT ,PS)
    begin
       up = 0; up2 = 0; up3 = 1; we = 0; clr = 0; // assign all outputs
       case(PS)
          WAIT: begin        
              if (BTN == 1) begin // starts circuit
                clr = 1;   
                NS = SCAN; 
             end  
             else begin
                NS = WAIT; 
             end  
          end
          
          SCAN: begin
                up = 1; //always increment RAM
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
                
                if (RCO) NS = WAIT;
                else NS = SCAN;
          end   
             
          default: NS = WAIT; 
            
          endcase
      end              
endmodule
