/*================================================*\
		  Filename��hc_sr_trig.v
			 Author��XuKunyao
	  Description���������������ģ�飬��������300us��ǰ10us�ߵ�ƽ����290us�͵�ƽ
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module 	hc_sr_trig(
	input  wire			clk_us	, //system clock 1MHz
	input  wire 		Rst_n		, //reset ��low valid
		   
	output wire  		trig	  	  //��������ź�
);
//Parameter Declarations
	parameter CYCLE_MAX = 19'd300_000;

//Interrnal wire/reg declarations
	reg		[18:00]	cnt		; //Counter 
	wire			add_cnt ; //Counter Enable
	wire			end_cnt ; //Counter Reset 

//Logic Description	
	
	always @(posedge clk_us or negedge Rst_n)begin  
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
	assign end_cnt = add_cnt && cnt >= CYCLE_MAX - 9'd1; 
	
	assign trig = cnt < 15 ? 1'b1 : 1'b0;

endmodule 
