module NUM_COUNT(
input [11:0]Count_In,
output [11:0]initial_addr
);

assign initial_addr= (Count_In == 12'd1)?12'd64:
							(Count_In == 12'd2)?12'd128:
							(Count_In == 12'd3)?12'd192:
							(Count_In == 12'd4)?12'd256:
							(Count_In == 12'd5)?12'd320:
							(Count_In == 12'd6)?12'd384:
							(Count_In == 12'd7)?12'd448:
							(Count_In == 12'd8)?12'd512:
							(Count_In == 12'd9)?12'd576:12'd0;
endmodule							