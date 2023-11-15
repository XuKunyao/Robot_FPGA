/*================================================*\
		  Filename：hc_sr501.v
			 Author：XuKunyao
	  Description：人体检测模块，可输出高电平信号与无源蜂鸣器驱动信号
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module hc_sr501(
	input			clk,
	input		 	rst_n,
	input			hum_in,
	output reg  hum_out,
	output reg  beep
    );
	 
parameter freq_data = 18'd190839;   //"哆"音调分频计数值（频率262）

reg     [17:0]  freq_cnt    ;   //音调计数器
wire    [16:0]  duty_data   ;   //占空比计数值

//设置50％占空比：音阶分频计数值的一半即为占空比的高电平数
assign  duty_data   =   freq_data   >>    1'b1;

always@(posedge clk or  negedge rst_n)
    if(rst_n == 1'b0)
        freq_cnt    <=  18'd0;
    else    if(freq_cnt == freq_data)
        freq_cnt    <=  18'd0;
    else
        freq_cnt    <=  freq_cnt +  1'b1;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		hum_out <= 1'b0;
	else
		hum_out <= hum_in;

//beep：输出蜂鸣器波形
always@(posedge clk or  negedge rst_n)
    if(rst_n == 1'b0)
        beep    <=  1'b0;
    else if(hum_in)begin
		if(freq_cnt >= duty_data)
			beep    <=  1'b1;
		else
			beep    <=  1'b0;
		end
	 else
			beep    <=  1'b0;

endmodule
