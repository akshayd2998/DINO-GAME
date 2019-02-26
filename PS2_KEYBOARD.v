module PS2_KEYBOARD(kb_data,st,kb_clk,led_out,rst,clk);
input kb_data,clk,kb_clk,rst;
output [8:0]led_out;
output reg st;
reg [5:0]count;
reg [32:0]shift;
wire delay_kb_clk;
wire [8:0]areg;
reg [2:0]delay_kb_clk_shift_reg;

reg [1:0]ps,ns;
parameter idle = 2'b00, rst_count = 2'd1,gen_st=2'd2;

always @(posedge clk,negedge rst)
	begin
		if(!rst)
			delay_kb_clk_shift_reg<=3'd0;
		else
			delay_kb_clk_shift_reg<={kb_clk,delay_kb_clk_shift_reg[2:1]};
	end

assign delay_kb_clk=delay_kb_clk_shift_reg[0];	

always @(negedge delay_kb_clk,negedge rst)
	begin
		if(!rst)
			shift<=33'd0;
		else
			shift<={kb_data,shift[32:1]};
	end

assign led_out=shift[8:0];
	
always @(posedge clk,negedge rst)
	begin
		if(!rst)
			ps <= idle;
		else
			ps <= ns;
end

always @(ps, count)
begin
		case (ps)
		idle:
			if (count == 6'd33)
				ns <= rst_count;
			else
				ns <= idle;
		rst_count:
				ns <= gen_st;
		default:
				ns <= idle;
		endcase		
end

// Generate ST
always @(posedge clk,negedge rst)
	begin
		if(!rst)
			st <= 1'b1;
		else
			if (ps== idle)
				st<= 1'b1;
			else
				if (ps == gen_st)
					st <= 1'b0;
				else
					st <= st;

	end					

/*reset counter*/
wire rst_counter;
//assign rst_counter = (ps== rst_count)?1'b0:
//							(rst== 1'b0)?1'b0:1'b1;
assign rst_counter = (rst== 1'b0)?1'b0:1'b1	;						
always @(posedge delay_kb_clk,negedge rst_counter)
	begin
		if(!rst_counter)	
			count<=6'd0;
		else
			count<=count+	6'd1;
	end
	
endmodule			