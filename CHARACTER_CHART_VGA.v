module CHARACTER_CHART_VGA(
    input clk,rst,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
	 //input [3:0]red,green,blue,	
	 output [3:0]r,g,b
  );
  reg clk_25;
  reg [7:0]y1=8'd200;
  reg [25:0]clk_div,clk_div_1s; 
	 reg vga_HS, vga_VS;
     reg [9:0] CounterX;
     reg [8:0] CounterY;
    wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480
parameter red=4'b1111,blue=4'b1111,green=4'b1111;
  
  /*25MHz clk*/	 
always @(posedge clk)
    clk_25<=~clk_25;
	 
/*H-Counter*/    
always @(posedge clk_25)
    if (CounterXmaxed)
      CounterX <= 0;
    else
      CounterX <= CounterX +10'd1;

/*V-Counter*/		
always @(posedge clk_25)
    begin
      if (CounterXmaxed)
      begin
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 9'd1;
      end
    end

/*V-sync & H-sync*/	 
always @(posedge clk_25)
    begin
      vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
      vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
    end

/*Display area*/	 
always @(posedge clk_25)
    begin
        inDisplayArea <= (CounterX < 640) && (CounterY < 480);
    end
	

wire clk_1s,clk_60;	
 //
/*1s clk div*/	 
always @(posedge clk)
	begin
		clk_div_1s<=clk_div_1s+26'd1;
	end
  assign clk_1s=clk_div_1s[23]; 
	 
	 
	 assign vga_h_sync = ~vga_HS;
    assign vga_v_sync = ~vga_VS;
	

/*60Hz clk_div*/	
always @(posedge clk_25,negedge rst)
	begin
		if(!rst)
			y1 <= y1;
		else
				clk_div <= clk_div + 18'd1;
	end
	assign clk_60=clk_div[18];
	//(CounterX==5&Y++ //shift reg o/p 1bit assign &&Q)50Mhz
		assign r =((inDisplayArea==1'b1)&&(CounterX>560)&&(CounterX<569)&&(CounterY>10)&&(CounterY<19))?red:4'h0;
		assign g =((inDisplayArea==1'b1)&&(CounterX>560)&&(CounterX<569)&&(CounterY>10)&&(CounterY<19))?green:4'h0;
		assign b =((inDisplayArea==1'b1)&&(CounterX>560)&&(CounterX<569)&&(CounterY>10)&&(CounterY<19))?blue:4'h0;
	
	
	
endmodule
