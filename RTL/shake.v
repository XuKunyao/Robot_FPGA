/*================================================*\
		  Filename：shake.v
			 Author：XuKunyao
	  Description：震动检测模块，分三个等级
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module shake(
	input						clk,
	input						rst_n,
	input						DO,//数据输入接口
	output	reg [1:0]	shake_signal
    );
	 
	 reg [31:0] cnt_shake;
	 
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		cnt_shake <= 32'b0;
	else if (DO == 1'b0)
		cnt_shake <= 32'b0;
	else if (cnt_shake == 32'd999_999_999)
		cnt_shake <= 32'd999_999_998;
	else if (DO == 1'b1)
		cnt_shake <= cnt_shake +1'b1;
	else;
	 
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		shake_signal <= 2'b0;
	else if(cnt_shake >= 32'd999_999 && cnt_shake < 32'd49_999_999)
		shake_signal <= 2'b1;
	else if(cnt_shake >= 32'd49_999_999 && cnt_shake <= 32'd999_999_999)
		shake_signal <= 2'd2;
	else;

endmodule
