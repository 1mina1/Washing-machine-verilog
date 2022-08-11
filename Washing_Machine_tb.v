// FILE NAME: Washing_Machine_tb.v
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
// PURPOSE: test bench for washing machine
`timescale 1ns/1ps
module Washing_Machine_tb();
  ////////////////testbench signals//////////////////
  reg    [1:0]    clk_freq_tb;
  reg             coin_in_tb;
  reg             double_wash_tb;
  reg             timer_pause_tb;
  reg             CLK_tb;
  reg             CLK1_tb;
  reg             CLK2_tb;
  reg             CLK3_tb;
  reg             CLK4_tb;
  reg             RST_tb;
  wire            wash_done_tb;
  wire   [2:0]    Current_State_tb;
  integer         pass;
  integer         here = 0;
  
  localparam clk1_half_width = 500,
             clk2_half_width = 250,
             clk3_half_width = 125,
             clk4_half_width = 62.5;
  /////////////////initial block   //////////////////
  initial
  begin
    initialize();
    check_single_wash_8();
    check_double_wash_8();
    check_pause_only_work_in_spining_8();
    check_single_wash_4();
    check_double_wash_4();
    check_pause_only_work_in_spining_4();
    check_single_wash_2();
    check_double_wash_2();
    check_pause_only_work_in_spining_2();
    check_single_wash_1();
    check_double_wash_1();
    check_pause_only_work_in_spining_1();
    #100
    $finish;
  end
  /////////////////initialize block//////////////////
  task initialize;
   begin
     CLK4_tb = 1'b0;
     here =0;
     double_wash_tb = 1'b0;
     timer_pause_tb = 1'b0;
     clk_freq_tb = 2'b11;//start with the fastest clock
     RST_tb = 1'b0;
     #5
     RST_tb = 1'b1;
   end
 endtask
 //////////////////task check single wash/////////////////////////////////
 task check_single_wash_8;
 begin
   pass =1;
   coin_in_tb = 1'b1;
  #(clk4_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state/////////////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*5)*clk4_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes
   //////check if its in the spining state//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*1)*clk4_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("single wash check successfully for 8 Mhz");
   else
     $display("single wash check failed for 8 Mhz");
 end
 endtask 
//////////////////task check double wash//////////////////////////
 task check_double_wash_8;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b1;
   #(2*clk4_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes   
    //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*5)*clk4_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*5)*clk4_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*1)*clk4_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("double wash check successfully for 8 Mhz");
   else
     $display("double wash check failed for 8 Mhz");
 end
 endtask
 //////////////////check_pause_only_work_in_spining//////////////////////////
 task check_pause_only_work_in_spining_8;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b0;
   timer_pause_tb = 1'b1;
   #(2*clk4_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*5)*clk4_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((160*60*2)*clk4_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #(2*clk4_half_width)
   ////////////////check if it is gone in pause state////////
   if(!(Current_State_tb  == 3'b111 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
    timer_pause_tb = 1'b0;
   #((160*60*1)*clk4_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("pause check successfully for 8 Mhz");
   else
     $display("pause wash check failed for 8 Mhz");
 end
 endtask
  //////////////////task check single wash/////////////////////////////////
 task check_single_wash_4;
 begin
   CLK3_tb = 1'b0;
   pass =1;
   clk_freq_tb = 2'b10;
   coin_in_tb = 1'b1;
  #(clk3_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state/////////////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*5)*clk3_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes
   //////check if its in the spining state//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*1)*clk3_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("single wash check successfully for 4 Mhz");
   else
     $display("single wash check failed for 4 Mhz");
 end
 endtask 
//////////////////task check double wash//////////////////////////
 task check_double_wash_4;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b1;
   #(2*clk3_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes   
    //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*5)*clk3_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*5)*clk3_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*1)*clk3_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("double wash check successfully for 4 Mhz");
   else
     $display("double wash check failed for 4 Mhz");
 end
 endtask
 //////////////////check_pause_only_work_in_spining//////////////////////////
 task check_pause_only_work_in_spining_4;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b0;
   timer_pause_tb = 1'b1;
   #(2*clk3_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*5)*clk3_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((80*60*2)*clk3_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #(2*clk3_half_width)
   ////////////////check if it is gone in pause state////////
   if(!(Current_State_tb  == 3'b111 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
    timer_pause_tb = 1'b0;
   #((80*60*1)*clk3_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("pause check successfully for 4 Mhz");
   else
     $display("pause wash check failed for 4 Mhz");
 end
 endtask
 //////////////////task check single wash/////////////////////////////////
 task check_single_wash_2;
 begin
   CLK2_tb = 1'b0;
   pass =1;
   clk_freq_tb = 2'b01;
   coin_in_tb = 1'b1;
  #(clk2_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state/////////////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*5)*clk2_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes
   //////check if its in the spining state//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*1)*clk2_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("single wash check successfully for 2 Mhz");
   else
     $display("single wash check failed for 2 Mhz");
 end
 endtask 
//////////////////task check double wash//////////////////////////
 task check_double_wash_2;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b1;
   #(2*clk2_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes   
    //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*5)*clk2_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*5)*clk2_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*1)*clk2_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("double wash check successfully for 2 Mhz");
   else
     $display("double wash check failed for 2 Mhz");
 end
 endtask
 //////////////////check_pause_only_work_in_spining//////////////////////////
 task check_pause_only_work_in_spining_2;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b0;
   timer_pause_tb = 1'b1;
   #(2*clk2_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*5)*clk2_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((40*60*2)*clk2_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #(2*clk2_half_width)
   ////////////////check if it is gone in pause state////////
   if(!(Current_State_tb  == 3'b111 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
    timer_pause_tb = 1'b0;
   #((40*60*1)*clk2_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("pause check successfully for 2 Mhz");
   else
     $display("pause wash check failed for 2 Mhz");
 end
 endtask
 //////////////////task check single wash/////////////////////////////////
 task check_single_wash_1;
 begin
   CLK1_tb = 1'b0;
   pass =1;
   clk_freq_tb = 2'b00;
   coin_in_tb = 1'b1;
  #(clk1_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state/////////////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*5)*clk1_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes
   //////check if its in the spining state//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*1)*clk1_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("single wash check successfully for 1 Mhz");
   else
     $display("single wash check failed for 1 Mhz");
 end
 endtask 
//////////////////task check double wash//////////////////////////
 task check_double_wash_1;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b1;
   #(2*clk1_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes   
    //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*5)*clk1_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*5)*clk1_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*1)*clk1_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("double wash check successfully for 1 Mhz");
   else
     $display("double wash check failed for 1 Mhz");
 end
 endtask
 //////////////////check_pause_only_work_in_spining//////////////////////////
 task check_pause_only_work_in_spining_1;
 begin
   pass =1;
   coin_in_tb = 1'b1;
   double_wash_tb = 1'b0;
   timer_pause_tb = 1'b1;
   #(2*clk1_half_width)
   coin_in_tb = 1'b0;
   ////check if its in filling state////
   if(!(Current_State_tb  == 3'b001 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes 
   //////check if its in the washing state//////////////
   if(!(Current_State_tb  == 3'b011 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*5)*clk1_half_width)//wait for 5 minutes
   //////check if its in the rinsing state//////////////
   if(!(Current_State_tb  == 3'b010 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #((20*60*2)*clk1_half_width)//wait for 2 minutes
   //////check if its in the spiningstate//////////////
   if(!(Current_State_tb  == 3'b110 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
   #(2*clk1_half_width)
   ////////////////check if it is gone in pause state////////
   if(!(Current_State_tb  == 3'b111 && wash_done_tb == 1'b0))
     begin
       pass =0;
     end
    timer_pause_tb = 1'b0;
   #((20*60*1)*clk1_half_width)//wait for 1 minutes
   //////check if its in the ideal state//////////////
   if(!(Current_State_tb  == 3'b000 && wash_done_tb == 1'b1))
     begin
       pass =0;
     end
   if(pass)
     $display("pause check successfully for 1 Mhz");
   else
     $display("pause wash check failed for 1 Mhz");
 end
 endtask            
  /////////////////clocks definitions////////////////
  always #clk1_half_width CLK1_tb = ~CLK1_tb;
  always #clk2_half_width CLK2_tb = ~CLK2_tb;
  always #clk3_half_width CLK3_tb = ~CLK3_tb;
  always #clk4_half_width CLK4_tb = ~CLK4_tb;
  always@(*)
  begin
    case(clk_freq_tb)
      2'b00        : begin
                      CLK_tb = CLK1_tb;
                     end
      2'b01        : begin
                      CLK_tb = CLK2_tb;
                     end
      2'b10        : begin
                      CLK_tb = CLK3_tb;
                     end
      2'b11        : begin
                      CLK_tb = CLK4_tb;
                     end
    endcase
  end
  //////////////Design instantiation/////////////////
  Washing_Machine DUT (
  .clk_freq(clk_freq_tb),
  .coin_in(coin_in_tb),
  .double_wash(double_wash_tb),
  .timer_pause(timer_pause_tb),
  .CLK(CLK_tb),
  .RST(RST_tb),
  .wash_done(wash_done_tb),
  .current_state(Current_State_tb));
  
endmodule