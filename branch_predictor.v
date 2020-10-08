module bimodal_branch_pred(clk , PC , reset , pred_intruc , Mem , branch , IF_ID_IR) ;
	input clk  ; 
	input reg [31:0] PC ;
	input reset ; 
	input reg [31:0] IF_ID_IR ; 
	input reg[31:0] Mem [0:1023] ;
	output reg branch ; 


	reg [2:0] state ;
	reg branch ; 

	parameter ST = 2'b00 , 
			  WT = 2'b01 , 
			  WNT = 2'b10 , 
			  SNT = 2'b11 ; 
			  taken = 1'b1 ; 
			  nottaken = 1'b0 ; 

	initial 
	begin 
		#2 reset = 1 ; 
		#2 state <= WNT ; 
		#2 reset <= 0 ; 


/// considering BEQZ = 6'b101010 ; 
/// and BNEQZ = 6'b101011 ; 

	always @ (posedge clk) 
	begin 
		if(!reset)
		begin 
			case(state)
				ST 		: begin 
						    if(Mem[PC] == 101010)
						    begin  
						  	    state <= ST ;
						  	    branch <= taken ; 
						    end  
						    else
						  	begin  
						  		state <= WT ;
						  		branch <= taken ; 
						  	end  
						  end 

				WT 		: begin 
						    if(Mem[PC] == 101010)
						    begin  
						  	    state <= ST ;
						  	    branch <= taken ; 
						    end  
						    else
						  	begin  
						  		state <= WNT ;
						  		branch <= nottaken ; 
						  	end  
						  end 

				WNT 	: begin 
						    if(Mem[PC] == 101010)
						    begin  
						  	    state <= WT ;
						  	    branch <= taken ; 
						    end  
						    else
						  	begin  
						  		state <= SNT ;
						  		branch <= nottaken ; 
						  	end  
						  end 

				SNT 	: begin 
						    if(Mem[PC] == 101010)
						    begin  
						  	    state <= WNT ;
						  	    branch <= nottaken ; 
						    end  
						    else
						  	begin  
						  		state <= WNT ;
						  		branch <= nottaken ; 
						  	end  
						  end 

				default :   state <= WNT ; 
							reset <= 1 ; 
			endcase 
		else
		begin 
			reset <= 1 ; 
			state <= WNT ;
		end 
	end 

	always @ (posedge clk) 
	begin 
		case(branch) 
			taken 		: IF_ID_IR <= Mem[PC] ; 

			nottaken 	: IF_ID_IR <= Mem[PC + 1] ;

			defaut 		: reset <= 1 ; 

		endcase
	end  
endmodule  



