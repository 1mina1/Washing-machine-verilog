// FILE NAME: WMFSM.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/8/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: washing machine, multi clock input washing machine
//------------------------------------------------
// PURPOSE: finite state machine act as controller for the washing machine
module WMFSM (//defining input and output ports of the FSM
  input    wire   [1:0]    WMFSM_wash_count,
  input    wire            WMFSM_one_min,
  input    wire            WMFSM_Two_min,
  input    wire            WMFSM_five_min,
  input    wire            WMFSM_coin_in,
  input    wire            WMFSM_double_wash,
  input    wire            WMFSM_timer_pause,
  input    wire            WMFSM_CLK,
  input    wire            WMFSM_RST,
  output   reg             WMFSM_wash_done,
  output   reg             WMFSM_cnt_en,
  output   reg             WMFSM_cnt_done,
  output   reg    [2:0]    Current_State);
  
  
  /////////defining the states , gray encoding is used////////
  
  reg      [2:0]     Next_State;
  
  localparam IDLE       = 3'b000,
  Filing_Water          = 3'b001,
  Washing               = 3'b011,
  Rinsing               = 3'b010,
  spining               = 3'b110,
  pause                 = 3'b111;
  
  /////////////////////state transition///////////////////
  always@(posedge WMFSM_CLK or negedge WMFSM_RST)
  begin
    if(!WMFSM_RST)
      Current_State <= IDLE ;
    else
      Current_State <= Next_State ;
  end
  
//////////////////next state logic///////////////////
  always@(*)
  begin
    case(Current_State)
      IDLE                   : begin
                                if(WMFSM_coin_in)
                                  Next_State = Filing_Water;
                                else
                                  Next_State = IDLE; 
                               end
      Filing_Water           : begin
                                if(WMFSM_Two_min)
                                  Next_State = Washing;
                                else
                                  Next_State = Filing_Water;
                               end
      Washing               :  begin
                                if(WMFSM_five_min)
                                  Next_State = Rinsing;
                                else
                                  Next_State = Washing;
                               end
      Rinsing               :  begin
                                if(WMFSM_Two_min)
                                  begin
                                    if((WMFSM_wash_count == 2'b01) & (WMFSM_double_wash))
                                      begin
                                        Next_State = Washing;
                                      end
                                    else
                                      begin
                                        Next_State = spining;
                                      end
                                  end
                                else
                                  Next_State = Rinsing;
                               end
      spining               :  begin
                                if(WMFSM_timer_pause)
                                  begin
                                    Next_State = pause;
                                  end
                                else if(WMFSM_one_min)
                                  begin
                                    Next_State = IDLE;
                                  end
                                else
                                  Next_State = spining;
                                end
      pause                 :  begin
                                if(!WMFSM_timer_pause)
                                  Next_State = spining;
                                else
                                  Next_State = pause;
                               end
      default               :  begin
                                Next_State = IDLE;
                               end
    endcase
  end  
  
  //////////////////output logic///////////////////
  always@(*)
  begin
    case(Current_State)
      IDLE                   : begin
                                WMFSM_wash_done = 1'b1;
                                WMFSM_cnt_en = 1'b0;
                                WMFSM_cnt_done = 1'b1;
                               end
      Filing_Water           : begin
                                WMFSM_wash_done = 1'b0;
                                WMFSM_cnt_en = 1'b1;
                                if(WMFSM_Two_min)
                                  WMFSM_cnt_done = 1'b1;
                                else
                                  WMFSM_cnt_done = 1'b0;
                                end
      Washing               :  begin
                                WMFSM_wash_done = 1'b0;
                                WMFSM_cnt_en = 1'b1;
                                if(WMFSM_five_min)
                                  WMFSM_cnt_done = 1'b1;
                                else
                                  WMFSM_cnt_done = 1'b0;
                               end
      Rinsing               :  begin
                                WMFSM_wash_done = 1'b0;
                                WMFSM_cnt_en = 1'b1;
                                if(WMFSM_Two_min)
                                  WMFSM_cnt_done = 1'b1;
                                else
                                  WMFSM_cnt_done = 1'b0;
                               end
      spining               :  begin
                                WMFSM_cnt_en = 1'b1;
                                WMFSM_cnt_done = 1'b0;
                                if(WMFSM_one_min)
                                  WMFSM_wash_done = 1'b1;
                                else
                                  WMFSM_wash_done = 1'b0;
                               end
      pause                 :  begin
                                WMFSM_wash_done = 1'b0;
                                WMFSM_cnt_en = 1'b0;
                                WMFSM_cnt_done = 1'b0; 
                               end
      default               :  begin
                                WMFSM_wash_done = 1'b1;
                                WMFSM_cnt_en = 1'b0;
                                WMFSM_cnt_done = 1'b0;
                               end
    endcase
  end  
endmodule