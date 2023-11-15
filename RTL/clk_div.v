/*================================================*\
		  Filename：clk_div.v
			 Author：XuKunyao
	  Description：产生周期为1us的时钟信号
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module 	clk_div(
	input  wire			Clk		, //system clock 50MHz
	input  wire 		Rst_n	, //reset 锛宭ow valid
		   
	output wire  		clk_us 	  //
);
//Parameter Declarations
	parameter CNT_MAX = 19'd50;//1us的计数值为 50 * Tclk（20ns）

//Interrnal wire/reg declarations
	reg		[5:00]	cnt		; //Counter 
	wire			add_cnt ; //Counter Enable
	wire			end_cnt ; //Counter Reset 
	
//Logic Description
	
	always @(posedge Clk or negedge Rst_n)begin  
		if(!Rst_n)begin  
			cnt <= 'd0; 
		end  
		else if(add_cnt)begin  
			if(end_cnt)begin  
				cnt <= 'd0; 
			end  
			else begin  
				cnt <= cnt + 1'b1; 
			end  
		end  
		else begin  
			cnt <= cnt;  
		end  
	end 
	
	assign add_cnt = 1'b1; 
	assign end_cnt = add_cnt && cnt >= CNT_MAX - 19'd1;
	
	assign clk_us = end_cnt;
	

endmodule 
