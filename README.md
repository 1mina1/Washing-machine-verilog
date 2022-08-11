# Washing machine
this a multiclock washing machine microcontroller(FSM) done using verilog implemented into main blocks and one top module the main blocks are :<br />
1- FSM <br />
2- counter <br />

# FSM
the finite state machine is used as a main controller for the washing machine and determines in which state the machine are in, the states are as in the following :<br />
1-IDLE<br />
2-Filling water(2 min)<br />
3-Washing(5 min) <br />
4-Rinsing(2 min) <br />
5-Spining(1 min) <br />
and for each state besides the idle state the washing machine spends a time calculated with the help of the counter <br />
# counter
the counter is used to calculate seconds, minutes while a 10 us is emulating the 1s for the sake of the simulating, and for the different clock frequencies,<br />
the counter calculates different number of clocks to reach on second, the washing machine can have the following clock frequencies :<br />
1-1 Mhz<br />
2-2 Mhz<br />
3-4 Mhz<br />
4-8 Mhz<br />
