module KEYBOARD_GAME(clk,rst,kb_clk,kb_data,ascii_count);
input clk, rst,kb_clk,kb_data;
//output txd,Txready;
output [7:0] ascii_count;
wire st,rst_st;
//TRANSMITTER(Sin,clk,rst,st,Tx,TxReady,rst_st);
//TRANSMITTER u1(ascii_count,clk,rst,st,txd,Txready,rst_st);

PS2_KEYBOARD U2(kb_data,st,kb_clk,ascii_count,rst,clk);
//PS2_KEYBOARD(kb_data,st,kb_clk,led_out,rst,clk);
endmodule
