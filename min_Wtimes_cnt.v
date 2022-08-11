// FILE NAME: min_Wtimes_cnt.v
// TYPE: module
// DEPARTMENT: communication and electronics department
// AUTHOR: Mina Hanna
// AUTHOR EMAIL: mina.hannaone@gmail.com
//------------------------------------------------
// Release history
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 8/8/2022 Mina Hanna final version
//------------------------------------------------
// KEYWORDS: counter, minutes counter
//------------------------------------------------
// PURPOSE: counter for minutes and washing times for double wash
module min_Wtimes_cnt (//defining input and output ports of the counter
input    wire    [1:0]    CNT_clk_freq,
input    wire             CNT_done,//signal used for reseting the counter
input    wire             CNT_en,
input    wire             CNT_CLK,
input    wire             CNT_RST,
output   wire             one_min,
output   wire             Two_min,
output   wire             five_min,
output   reg     [1:0]    CNT_wash_count);


reg    [23:0]    clocks;
reg    [23:0]    clocks_comb;
reg    [7:0]     seconds;
reg    [7:0]     seconds_comb;
reg    [2:0]     min_comb;
reg    [2:0]     CNT_min;
reg    [1:0]     CNT_wash_count_comb;
reg              clock_finish;
wire             second_finish;
//////////////////counter sequentional logic\\\\\\\\\\\\\\\\\
always@(posedge CNT_CLK or negedge CNT_RST)
begin
  if(!CNT_RST)
    begin
      CNT_wash_count <= 2'b0;
      clocks  <= 24'b0;
      seconds <= 8'b0;
      CNT_min <= 3'b0;
    end
  else
    begin
      clocks  <= clocks_comb;
      seconds <= seconds_comb;
      CNT_min <= min_comb;
      CNT_wash_count <= CNT_wash_count_comb;
    end
end
//////////////////seconds combinational logic//////////////////////
always@(*)
    begin
      clock_finish =1'b0;
      if(CNT_en)
        begin
          case(CNT_clk_freq)
            2'b00         : begin//for 1Mhz clock
                             if(clocks == 24'd9)
                               begin
                                 clock_finish =1'b1;
                                 if(!second_finish)
                                   begin
                                     seconds_comb = seconds + 8'd1;
                                   end
                                 else
                                   begin
                                    seconds_comb = 8'b0;
                                   end
                               end
                             else
                               begin
                                 seconds_comb = seconds;
                               end
                            end
            2'b01         : begin//for 2Mhz clock
                             if(clocks == 24'd19)
                               begin
                                 clock_finish =1'b1;
                                 if(!second_finish)
                                   begin
                                     seconds_comb = seconds + 8'd1;
                                   end
                                 else
                                   begin
                                    seconds_comb = 8'b0;
                                   end
                               end
                             else
                               begin
                                 seconds_comb = seconds;
                               end
                            end
            2'b10         : begin//for 4Mhz clock
                             if(clocks == 24'd39)
                               begin
                                 clock_finish =1'b1;
                                 if(!second_finish)
                                   begin
                                     seconds_comb = seconds + 8'd1;
                                   end
                                 else
                                   begin
                                    seconds_comb = 8'b0;
                                   end
                               end
                             else
                               begin
                                 seconds_comb = seconds;
                               end
                            end
            2'b11         : begin//for 8Mhz clock
                             if(clocks == 24'd79)
                               begin
                                 clock_finish =1'b1;
                                 if(!second_finish)
                                   begin
                                     seconds_comb = seconds + 8'd1;
                                   end
                                 else
                                   begin
                                    seconds_comb = 8'b0;
                                   end
                               end
                             else
                               begin
                                 seconds_comb = seconds;
                               end
                            end
          endcase
        end
      else
        begin
          seconds_comb = seconds;
        end
    end

assign second_finish = (seconds == 8'd59);
/////////////////////////minutes combinational logic/////////////////////
always@(*)
begin
  if(CNT_done)
    begin
      min_comb = 3'b0;
    end
  else 
    begin
      if(CNT_en)
        begin
          if(second_finish && clock_finish)
            begin
              min_comb = CNT_min + 3'd1;
            end
          else
            begin
              min_comb = CNT_min;
            end
        end
      else
        begin
          min_comb = CNT_min;
        end
    end
end

///////////////////////clocks combinational logic////////////////////////////
always@(*)
begin
  if(CNT_done)
    begin
      clocks_comb = 24'b0;
    end
else if(clock_finish)
    begin
      clocks_comb = 24'b0;
    end
  else
    begin
      if(CNT_en)
        begin
          clocks_comb = clocks +24'd1;
        end
      else
        begin
          clocks_comb = clocks;
        end
    end
end
/////////////////////wash sequentional logic/////////////////////////
always@(*)
begin
  if(CNT_en)
    begin
      if(five_min)
        begin
          CNT_wash_count_comb = CNT_wash_count +2'b1;
        end
      else
        begin
          CNT_wash_count_comb = CNT_wash_count;
        end
    end
  else
    begin
      CNT_wash_count_comb = 2'b0;
    end
end
assign one_min = ((CNT_min == 3'b000) && second_finish && clock_finish);
assign Two_min = ((CNT_min == 3'b001) && second_finish && clock_finish);
assign five_min = ((CNT_min == 3'b100) && second_finish && clock_finish);
endmodule