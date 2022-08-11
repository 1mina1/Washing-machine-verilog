// FILE NAME: Washing_Machine.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/8/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: washing machine, double wash
//------------------------------------------------
// PURPOSE: top module for washing machine
module Washing_Machine (
  input    wire    [1:0]    clk_freq,
  input    wire             coin_in,
  input    wire             double_wash,
  input    wire             timer_pause,
  input    wire             CLK,
  input    wire             RST,
  output   wire             wash_done,
  output   wire    [2:0]    current_state);
  
  wire                 OneMin;
  wire                 TwoMin;
  wire                 FiveMin;
  wire                 SevenMin;
  wire    [1:0]        wash_count;
  wire                 cnt_done;
  wire                 cnt_en;
  //////////////////designs instantiations//////////////////
  WMFSM U0_WMFSM(
  .WMFSM_wash_count(wash_count),
  .WMFSM_one_min(OneMin),
  .WMFSM_Two_min(TwoMin),
  .WMFSM_five_min(FiveMin),
  .WMFSM_coin_in(coin_in),
  .WMFSM_double_wash(double_wash),
  .WMFSM_timer_pause(timer_pause),
  .WMFSM_CLK(CLK),
  .WMFSM_RST(RST),
  .WMFSM_wash_done(wash_done),
  .WMFSM_cnt_en(cnt_en),
  .WMFSM_cnt_done(cnt_done),
  .Current_State(current_state));
  
  min_Wtimes_cnt U0_min_Wtimes_cnt(
  .CNT_clk_freq(clk_freq),
  .CNT_done(cnt_done),
  .CNT_en(cnt_en),
  .CNT_CLK(CLK),
  .CNT_RST(RST),
  .one_min(OneMin),
  .Two_min(TwoMin),
  .five_min(FiveMin),
  .CNT_wash_count(wash_count));
  
endmodule
