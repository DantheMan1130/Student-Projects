`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:45 11/11/2017 
// Design Name: 
// Module Name:    Student_Project 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Student_Project(input [3:0] IO_PB, input [7:0] IO_DSW, input M_CLOCK,
							  output reg [7:0] IO_SSEG, output reg [3:0] IO_SSEGD, output [3:0] F_LED, output IO_SSEG_COL, output reg [7:0] IO_LED);

reg [31:0] CYCLE_COUNT = 32'b00000001011111010111100001000000; // (50MHz / (1Hz) / 2) = 25,000,000 cycles (1 second)
reg [31:0] CycleCounter = 32'b00000000000000000000000000000000;
reg clock1 = 1'b0;

reg [31:0] CYCLE_COUNT200Hz = 32'b00000000000000111101000010010000; // (50MHz / (50ms * 2 = 100Hz) / 2) = 250,000 cycles
reg [31:0] CycleCounter2 = 32'b00000000000000000000000000000000;
reg clock2 = 1'b0;

integer display = 0;

// Sequence placeholders.
reg [7:0] sequence = 8'b00000000;
reg [3:0] sequenceHold = 4'b0000;
reg [3:0] sequenceHold1 = 4'b0000;
reg [3:0] sequenceHold2 = 4'b0000;
reg [3:0] sequenceHold3 = 4'b0000;
reg [3:0] sequenceHold4 = 4'b0000;
reg [3:0] sequenceHold5 = 4'b0000;
reg [3:0] sequenceHold6 = 4'b0000;
reg [3:0] sequenceHold7 = 4'b0000;

reg [3:0] score0 = 4'b0000;
reg [3:0] score1 = 4'b0000;
integer decrementFlag = 0;
reg [3:0] PBarray;

// For display.
reg [7:0] score0segs = 8'b11000000;
reg [7:0] score1segs = 8'b11000000;

assign F_LED = 4'b0000;
assign IO_SSEG_COL = 1'b1;

always @(posedge M_CLOCK) begin
	if(CycleCounter <= CYCLE_COUNT)	begin
		CycleCounter = CycleCounter + 1;
	end
		
	else begin
		CycleCounter = 0;
		clock1 = ~clock1;
	end	
end

always @(posedge M_CLOCK) begin
	if(CycleCounter2 <= CYCLE_COUNT200Hz)	begin
		CycleCounter2 = CycleCounter2 + 1;
	end
		
	else begin
		CycleCounter2 = 0;
		clock2 = ~clock2;
	end	
end
	
always @* begin
	case(score0)
		4'b0000:	score0segs = 8'b11000000; //0
		4'b0001: score0segs = 8'b11111001; //1
		4'b0010: score0segs = 8'b10100100; //2
		4'b0011: score0segs = 8'b10110000; //3
		4'b0100: score0segs = 8'b10011001; //4
		4'b0101: score0segs = 8'b10010010; //5
		4'b0110: score0segs = 8'b10000010; //6
		4'b0111: score0segs = 8'b11111000; //7
		4'b1000: score0segs = 8'b10000000; //8
		4'b1001: score0segs = 8'b10011000; //9
		default: score0segs = 8'b11000000;
	endcase
	
	case(score1)
		4'b0000:	score1segs = 8'b11000000; //0
		4'b0001: score1segs = 8'b11111001; //1
		4'b0010: score1segs = 8'b10100100; //2
		4'b0011: score1segs = 8'b10110000; //3
		4'b0100: score1segs = 8'b10011001; //4
		4'b0101: score1segs = 8'b10010010; //5
		4'b0110: score1segs = 8'b10000010; //6
		4'b0111: score1segs = 8'b11111000; //7
		4'b1000: score1segs = 8'b10000000; //8
		4'b1001: score1segs = 8'b10011000; //9
		default: score1segs = 8'b11000000;
	endcase
end

always @(posedge clock2) begin // 100Hz clock.
	if(display == 1)
		display = 0;				
	else
		display = display + 1;
			
	case(display)		
		0: begin
			IO_SSEGD[3:0] = 4'b0111;
			IO_SSEG = score0segs; // Given above.
		end
				
		1: begin
			IO_SSEGD[3:0] = 4'b1011;
			IO_SSEG = score1segs; // Given above.
		end
				
		default: begin
			IO_SSEGD[3:0] = 4'b1111;
			IO_SSEG = 8'b11001100;
		end
	endcase
end

always @* begin
	IO_LED[7:0] = sequence;
	{PBarray[0], PBarray[1], PBarray[2], PBarray[3]} = ~IO_PB[3:0];
end

// Timing counters.
integer i = 0;
integer j = 0;
integer k = 0;
integer l = 0;
integer m = 0;
integer n = 0;
integer p = 0;
integer a = 0;

// State machine variables.
parameter SHOW = 0;
parameter READY = 1;
reg state = SHOW;
reg [2:0] round = 3'b000;
reg [2:0] order = 3'b000;

// Simon says placeholders.
reg [3:0] simonSays = 4'b0000;
reg [3:0] simonSays1 = 4'b0000;
reg [3:0] simonSays2 = 4'b0000;
reg [3:0] simonSays3 = 4'b0000;
reg [3:0] simonSays4 = 4'b0000;
reg [3:0] simonSays5 = 4'b0000;
reg [3:0] simonSays6 = 4'b0000;
reg [3:0] simonSays7 = 4'b0000;

// Memorization game.
always @(posedge clock1) begin
	if(state == SHOW) begin // SHOW state.
		//$srandom(3);
		//color = $urandom_range(3,0);
		if(round == 3'b000) begin // Round 1.
			simonSays[2] = 1'b1; // Set value.
			sequence[7:4] = simonSays; // Set LED to show correct color. (ON)
			sequenceHold = simonSays;
			score0 = 4'b1001; // Give player 9 score (9 second countdown).
			score1 = 4'b0000;
			decrementFlag = 0;
			
			state = READY;
		end
		
		else if(round == 3'b001) begin // Round 2.
			simonSays[0] = 1'b1; // Set value.
			simonSays1[3] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				i = 0;
				sequence[7:4] = simonSays1;
				state = READY;
			end
		end
		
		else if(round == 3'b010) begin // Round 3.
			simonSays[0] = 1'b1; // Set value.
			simonSays1[1] = 1'b1; // Set value.
			simonSays2[2] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequenceHold2 = simonSays2;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				sequence[7:4] = simonSays1;
				j = j + 1;
				if(state == SHOW && j > 1) begin
					i = 0;
					j = 0;
					sequence[7:4] = simonSays2;
					state = READY;
				end
			end
		end
		
		else if(round == 3'b011) begin // Round 4.
			simonSays[3] = 1'b1; // Set value.
			simonSays1[2] = 1'b1; // Set value.
			simonSays2[1] = 1'b1; // Set value.
			simonSays3[0] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequenceHold2 = simonSays2;
			sequenceHold3 = simonSays3;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				sequence[7:4] = simonSays1;
				j = j + 1;
				if(state == SHOW && j > 1) begin
					sequence[7:4] = simonSays2;
					k = k + 1;
					if(state == SHOW && k > 1) begin
						i = 0;
						j = 0;
						k = 0;
						sequence[7:4] = simonSays3;
						state = READY;
					end
				end
			end
		end
		
		else if(round == 3'b100) begin // Round 5.
			simonSays[2] = 1'b1; // Set value.
			simonSays1[3] = 1'b1; // Set value.
			simonSays2[2] = 1'b1; // Set value.
			simonSays3[3] = 1'b1; // Set value.
			simonSays4[0] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequenceHold2 = simonSays2;
			sequenceHold3 = simonSays3;
			sequenceHold4 = simonSays4;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				sequence[7:4] = simonSays1;
				j = j + 1;
				if(state == SHOW && j > 1) begin
					sequence[7:4] = simonSays2;
					k = k + 1;
					if(state == SHOW && k > 1) begin
						sequence[7:4] = simonSays3;
						l = l + 1;
						if(state == SHOW && l > 1) begin
							i = 0;
							j = 0;
							k = 0;
							l = 0;
							sequence[7:4] = simonSays4;
							state = READY;
						end
					end
				end
			end
		end
		
		else if(round == 3'b101) begin // Round 6.
			simonSays[3] = 1'b1; // Set value.
			simonSays1[3] = 1'b1; // Set value.
			simonSays2[0] = 1'b1; // Set value.
			simonSays3[1] = 1'b1; // Set value.
			simonSays4[2] = 1'b1; // Set value.
			simonSays5[3] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequenceHold2 = simonSays2;
			sequenceHold3 = simonSays3;
			sequenceHold4 = simonSays4;
			sequenceHold5 = simonSays5;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				sequence[7:4] = simonSays1;
				j = j + 1;
				if(state == SHOW && j > 1) begin
					sequence[7:4] = simonSays2;
					k = k + 1;
					if(state == SHOW && k > 1) begin
						sequence[7:4] = simonSays3;
						l = l + 1;
						if(state == SHOW && l > 1) begin
							sequence[7:4] = simonSays4;
							m = m + 1;
							if(state == SHOW && m > 1) begin
								i = 0;
								j = 0;
								k = 0;
								l = 0;
								m = 0;
								sequence[7:4] = simonSays5;
								state = READY;
							end
						end
					end
				end
			end
		end
		
		else if(round == 3'b110) begin // Round 7.
			simonSays[2] = 1'b1; // Set value.
			simonSays1[1] = 1'b1; // Set value.
			simonSays2[3] = 1'b1; // Set value.
			simonSays3[0] = 1'b1; // Set value.
			simonSays4[1] = 1'b1; // Set value.
			simonSays5[2] = 1'b1; // Set value.
			simonSays6[2] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequenceHold2 = simonSays2;
			sequenceHold3 = simonSays3;
			sequenceHold4 = simonSays4;
			sequenceHold5 = simonSays5;
			sequenceHold6 = simonSays6;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				sequence[7:4] = simonSays1;
				j = j + 1;
				if(state == SHOW && j > 1) begin
					sequence[7:4] = simonSays2;
					k = k + 1;
					if(state == SHOW && k > 1) begin
						sequence[7:4] = simonSays3;
						l = l + 1;
						if(state == SHOW && l > 1) begin
							sequence[7:4] = simonSays4;
							m = m + 1;
							if(state == SHOW && m > 1) begin
								sequence[7:4] = simonSays5;
								n = n + 1;
								if(state == SHOW && n > 1) begin
									i = 0;
									j = 0;
									k = 0;
									l = 0;
									m = 0;
									n = 0;
									sequence[7:4] = simonSays6;
									state = READY;
								end
							end
						end
					end
				end
			end
		end
		
		else if(round == 3'b111) begin // Round 8.
			simonSays[1] = 1'b1; // Set value.
			simonSays1[0] = 1'b1; // Set value.
			simonSays2[3] = 1'b1; // Set value.
			simonSays3[2] = 1'b1; // Set value.
			simonSays4[1] = 1'b1; // Set value.
			simonSays5[3] = 1'b1; // Set value.
			simonSays6[1] = 1'b1; // Set value.
			simonSays7[2] = 1'b1; // Set value.
			sequenceHold = simonSays;
			sequenceHold1 = simonSays1;
			sequenceHold2 = simonSays2;
			sequenceHold3 = simonSays3;
			sequenceHold4 = simonSays4;
			sequenceHold5 = simonSays5;
			sequenceHold6 = simonSays6;
			sequenceHold7 = simonSays7;
			sequence[7:4] = simonSays;
			
			i = i + 1;
			if(state == SHOW && i > 1) begin
				sequence[7:4] = simonSays1;
				j = j + 1;
				if(state == SHOW && j > 1) begin
					sequence[7:4] = simonSays2;
					k = k + 1;
					if(state == SHOW && k > 1) begin
						sequence[7:4] = simonSays3;
						l = l + 1;
						if(state == SHOW && l > 1) begin
							sequence[7:4] = simonSays4;
							m = m + 1;
							if(state == SHOW && m > 1) begin
								sequence[7:4] = simonSays5;
								n = n + 1;
								if(state == SHOW && n > 1) begin
									sequence[7:4] = simonSays6;
									p = p + 1;
									if(state == SHOW && p > 1) begin
										i = 0;
										j = 0;
										k = 0;
										l = 0;
										m = 0;
										n = 0;
										p = 0;
										sequence[7:4] = simonSays7;
										state = READY;
									end
								end
							end
						end
					end
				end
			end
		end
		a = 0;
	end
	
	// Turn off last LED.
	a = a + 1;
	if(state == READY && a > 1) begin
		a = 0;
		sequence[7:4] = 4'b0000;
	end

	if(state == READY) begin // READY state.
		if(round == 3'b000) begin // Round 1.
			if(sequenceHold == PBarray) begin
				round = 3'b001;
				state = SHOW;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b000;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
		
		else if(round == 3'b001) begin // Round 2.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b001;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b010; // Advance.
				state = SHOW;
				order = 3'b000;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b001;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
			
		else if(round == 3'b010) begin // Round 3.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b010;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b010;
				state = READY;
				order = 3'b010;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold2 == PBarray && order == 3'b010) begin
				round = 3'b011;
				state = SHOW;
				order = 3'b000;
				simonSays2 = 4'b0000;
				sequenceHold2 = 4'b0000;
				score0 = score0 + 2'b11;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b010;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
		
		else if(round == 3'b011) begin // Round 4.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b011;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b011;
				state = READY;
				order = 3'b010;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold2 == PBarray && order == 3'b010) begin
				round = 3'b011;
				state = READY;
				order = 3'b011;
				simonSays2 = 4'b0000;
				sequenceHold2 = 4'b0000;
				score0 = score0 + 2'b11;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold3 == PBarray && order == 3'b011) begin
				round = 3'b100;
				state = SHOW;
				order = 3'b000;
				simonSays3 = 4'b0000;
				sequenceHold3 = 4'b0000;
				score0 = score0 + 3'b100;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b011;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
		
		else if(round == 3'b100) begin // Round 5.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b100;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b100;
				state = READY;
				order = 3'b010;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold2 == PBarray && order == 3'b010) begin
				round = 3'b100;
				state = READY;
				order = 3'b011;
				simonSays2 = 4'b0000;
				sequenceHold2 = 4'b0000;
				score0 = score0 + 2'b11;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold3 == PBarray && order == 3'b011) begin
				round = 3'b100;
				state = READY;
				order = 3'b100;
				simonSays3 = 4'b0000;
				sequenceHold3 = 4'b0000;
				score0 = score0 + 3'b100;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold4 == PBarray && order == 3'b100) begin
				round = 3'b101;
				state = SHOW;
				order = 3'b000;
				simonSays4 = 4'b0000;
				sequenceHold4 = 4'b0000;
				score0 = score0 + 3'b101;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b100;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
		
		else if(round == 3'b101) begin // Round 6.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b101;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b101;
				state = READY;
				order = 3'b010;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold2 == PBarray && order == 3'b010) begin
				round = 3'b101;
				state = READY;
				order = 3'b011;
				simonSays2 = 4'b0000;
				sequenceHold2 = 4'b0000;
				score0 = score0 + 2'b11;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold3 == PBarray && order == 3'b011) begin
				round = 3'b101;
				state = READY;
				order = 3'b100;
				simonSays3 = 4'b0000;
				sequenceHold3 = 4'b0000;
				score0 = score0 + 3'b100;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold4 == PBarray && order == 3'b100) begin
				round = 3'b101;
				state = READY;
				order = 3'b101;
				simonSays4 = 4'b0000;
				sequenceHold4 = 4'b0000;
				score0 = score0 + 3'b101;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold5 == PBarray && order == 3'b101) begin
				round = 3'b110;
				state = SHOW;
				order = 3'b000;
				simonSays5 = 4'b0000;
				sequenceHold5 = 4'b0000;
				score0 = score0 + 3'b110;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b101;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
		
		else if(round == 3'b110) begin // Round 7.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b110;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b110;
				state = READY;
				order = 3'b010;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold2 == PBarray && order == 3'b010) begin
				round = 3'b110;
				state = READY;
				order = 3'b011;
				simonSays2 = 4'b0000;
				sequenceHold2 = 4'b0000;
				score0 = score0 + 2'b11;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold3 == PBarray && order == 3'b011) begin
				round = 3'b110;
				state = READY;
				order = 3'b100;
				simonSays3 = 4'b0000;
				sequenceHold3 = 4'b0000;
				score0 = score0 + 3'b100;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold4 == PBarray && order == 3'b100) begin
				round = 3'b110;
				state = READY;
				order = 3'b101;
				simonSays4 = 4'b0000;
				sequenceHold4 = 4'b0000;
				score0 = score0 + 3'b101;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold5 == PBarray && order == 3'b101) begin
				round = 3'b110;
				state = READY;
				order = 3'b110;
				simonSays5 = 4'b0000;
				sequenceHold5 = 4'b0000;
				score0 = score0 + 3'b110;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold6 == PBarray && order == 3'b110) begin
				round = 3'b111;
				state = SHOW;
				order = 3'b000;
				simonSays6 = 4'b0000;
				sequenceHold6 = 4'b0000;
				score0 = score0 + 3'b111;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b110;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
		
		else if(round == 3'b111) begin // Round 8.
			if(sequenceHold == PBarray && order == 3'b000) begin
				round = 3'b111;
				state = READY;
				order = 3'b001;
				simonSays = 4'b0000;
				sequenceHold = 4'b0000;
				score0 = score0 + 1'b1;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold1 == PBarray && order == 3'b001) begin
				round = 3'b111;
				state = READY;
				order = 3'b010;
				simonSays1 = 4'b0000;
				sequenceHold1 = 4'b0000;
				score0 = score0 + 2'b10;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold2 == PBarray && order == 3'b010) begin
				round = 3'b111;
				state = READY;
				order = 3'b011;
				simonSays2 = 4'b0000;
				sequenceHold2 = 4'b0000;
				score0 = score0 + 2'b11;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold3 == PBarray && order == 3'b011) begin
				round = 3'b111;
				state = READY;
				order = 3'b100;
				simonSays3 = 4'b0000;
				sequenceHold3 = 4'b0000;
				score0 = score0 + 3'b100;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold4 == PBarray && order == 3'b100) begin
				round = 3'b111;
				state = READY;
				order = 3'b101;
				simonSays4 = 4'b0000;
				sequenceHold4 = 4'b0000;
				score0 = score0 + 3'b101;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold5 == PBarray && order == 3'b101) begin
				round = 3'b111;
				state = READY;
				order = 3'b110;
				simonSays5 = 4'b0000;
				sequenceHold5 = 4'b0000;
				score0 = score0 + 3'b110;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold6 == PBarray && order == 3'b110) begin
				round = 3'b111;
				state = READY;
				order = 3'b111;
				simonSays6 = 4'b0000;
				sequenceHold6 = 4'b0000;
				score0 = score0 + 3'b111;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else if(sequenceHold7 == PBarray && order == 3'b111) begin
				round = 3'b000; // Reset to first round.
				state = SHOW;
				order = 3'b000;
				simonSays7 = 4'b0000;
				sequenceHold7 = 4'b0000;
				score0 = score0 + 4'b1000;
				if(score0 > 4'b1001) begin
					score0 = score0 - 4'b1010;
					score1 = score1 + 1'b1;
				end
			end
			
			else begin
			round = 3'b111;
			state = READY;
				if((score0 != 4'b0000) || (score1 != 4'b0000)) begin // For decrementing score.
					score0 = score0 - 4'b0001;
					if(decrementFlag == 1) begin
						score0 = 4'b1001;
						score1 = score1 - 4'b0001;
						decrementFlag = 0;
					end
					if(score0 == 0) begin
						decrementFlag = 1;
					end
				end
				
				else begin
					decrementFlag = 0;
					score0 = 1'b0;
				end
			end
		end
	end
end
endmodule
