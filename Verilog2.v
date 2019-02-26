module Verilog2(
    input clk,rst,jump,kb_clk,kb_data,
    output vga_h_sync,q,
	 output [7:0]key,
    output vga_v_sync,location1,
	 output reg [11:0]addr,
    output reg inDisplayArea,
	 //input [3:0]red,green,blue,	
	 output [3:0]r,g,b
  );
  
  ROM_THREE B1 (addr,clk,q);
  
wire [7:0]req_key;
assign req_key = 8'h57;   
  reg [3:0]addr_count;
 wire [11:0]n;
  reg clk_25,int_count=1'b0;
  reg [7:0]y1=8'd200;
 reg [9:0]obstacle_x1; 
  reg [25:0]clk_div,clk_div_1s; 
	 reg vga_HS, vga_VS;
     reg [9:0] CounterX;
     reg [8:0] CounterY;
    wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480
parameter red=4'b1111,blue=4'b1111,green=4'b1111;
parameter pos_X=12'd500;
parameter pos_Y=12'd10;
parameter RED_GREEN_BLUE=12'hFFF;
parameter x1=7'd23,x2=7'd45; //A=((a>560)&&(a<565)&&(y=11))
reg [7:0] obstacle_y1=8'd225,obstacle_y2=8'd247;

// KEYBOARD_GAME(clk,rst,kb_clk,kb_data,ascii_count);
KEYBOARD_GAME P1(clk,rst,kb_clk,kb_data,key);

//parameter up_arrow_key=15 

wire [9:0]obstacle_x2;
assign obstacle_x2= obstacle_x1+4'd15;

wire [9:0]y2;
assign y2= y1 + 5'd22;
/*25MHz clk*/	 
always @(posedge clk)
    clk_25<=~clk_25;

reg [3:0]num_Counter;	 

/*0-9 MOD-10 Counter*/
always @(posedge clk)
	begin
		if(int_count==1'b1)
			if(num_Counter == 4'd10)
				num_Counter <= 4'd0;
			else
				num_Counter <= num_Counter + 4'd1;
	end

	 NUM_COUNT N1 (num_Counter,n);
	
/*MOD-5 Counter*/
always@(posedge clk_60)
	begin	
		addr<=n;
		if((int_count==1'b1)&&(addr<n+12'd64))
			begin
				if(addr_count==4'd5)
					begin
						addr<=addr+12'd4;
						addr_count <= 4'd0;
					end
				else
					addr_count <= addr_count +4'd1;
			end
	end
/* Score Location*/
 assign location1=((CounterX >= pos_X)&&(CounterX < pos_X+12'd5)&&(CounterY >= pos_Y)&&(CounterY < pos_Y+12'd9));

			
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

	
/*Y axis jump*/
always @(posedge clk_60)
	begin
		if(((jump==1'b0)||(key==req_key))&&(y1>8'd176))
			begin
				y1<=y1 - 8'd5;
				int_count<=1'b1;
			end	
		else
			if((y2==8'd192)||(y1==8'd222))
				y1<=y1 + 8'd5;
			else
				if((x2==obstacle_x1))
					begin
						obstacle_y1 <= obstacle_y1;
						obstacle_x1 <= obstacle_x1;
						int_count<=~int_count;
					end
					else		
						begin
							y1<=y1;
							int_count<=int_count;
						end	
	end
//	

wire [9:0]shift_X;
assign shift_X=obstacle_x1-x2;
wire[7:0]shift_Y;
assign shift_Y=y2-obstacle_y1;

/*Obstacle motion*//*Reset Game*/
always @(posedge clk_60)
	begin
			if((int_count==1'b0))						
				obstacle_x1<=obstacle_x1;
			else 
				if((shift_X<=5)&&(obstacle_x1>x2)||((shift_Y<=5)&&(obstacle_y1>y2)))
					begin
						obstacle_x1<= obstacle_x1 - shift_X;
						//y1<=y1-shift_Y;
					end
				else
					begin
						obstacle_x1<=10'd320;
						obstacle_x1<= obstacle_x1 - 3'd5;
					end						
	end
	

/*Display Cordinates*/
assign r =((inDisplayArea==1'b1)&&((CounterX)&&(CounterY>10'd247)&&(CounterY<10'd249))||((CounterX>x1)&&(CounterX<x2)&&(CounterY>y1)&&(CounterY<y2))||((CounterX>obstacle_x1)&&(CounterX<obstacle_x2)&&(CounterY>obstacle_y1)&&(CounterY<obstacle_y2)))?red:4'h0;
assign g =((inDisplayArea==1'b1)&&((CounterX)&&(CounterY>10'd247)&&(CounterY<10'd249))||((CounterX>x1)&&(CounterX<x2)&&(CounterY>y1)&&(CounterY<y2))||((CounterX>obstacle_x1)&&(CounterX<obstacle_x2)&&(CounterY>obstacle_y1)&&(CounterY<obstacle_y2)))?green:4'h0;
assign b =((inDisplayArea==1'b1)&&((CounterX)&&(CounterY>10'd247)&&(CounterY<10'd249))||((CounterX>x1)&&(CounterX<x2)&&(CounterY>y1)&&(CounterY<y2))||((CounterX>obstacle_x1)&&(CounterX<obstacle_x2)&&(CounterY>obstacle_y1)&&(CounterY<obstacle_y2)))?blue:4'h0;

endmodule	 
	
