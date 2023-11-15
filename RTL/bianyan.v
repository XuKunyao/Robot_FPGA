/*================================================*\
		  Filename：bianyan.v
			 Author：XuKunyao
	  Description：将持续的高电平转化为一个持续两个时钟周期的高电平脉冲
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module bianyan(
    input clk,
	 input rst_n,
    input key_io  ,      
	 output key_flag
	 );

reg key_podge_flag1;
reg key_podge_flag2;

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		key_podge_flag1 <= 1'b0;
	   key_podge_flag2 <= 1'b0;
		end
	else begin
		key_podge_flag1 <= key_io;
	   key_podge_flag2 <= key_podge_flag1;
		end
		
assign key_flag = key_podge_flag1 & (~key_podge_flag2);
		

endmodule
