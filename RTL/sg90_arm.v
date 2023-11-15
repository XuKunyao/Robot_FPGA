/*================================================*\
		  Filename：sg90_arm.v
			 Author：XuKunyao
	  Description：机械臂三舵机控制模块
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module sg90_arm(
    input       sys_clk,
    input       sys_rst_n,
	 input		 key1,		 //按键1上升
	 input		 key2,		 //按键2下降
	 input		 key3,		 //按键3夹取
	 input		 key4,		 //按键4松开
	 input		 key5,		 //按键5左转
	 input		 key6,		 //按键6右转
	 input		 sg90_en,	 //舵机使能信号
    output      steer_xpwm, 
    output      steer_ypwm,
    output      steer_zpwm  
    );

reg  [19:0]  period_cnt ;        //周期计数器频率：50hz 周期:20ms  计数值:20ms/20ns=1_000_000
reg  [16:0]  duty_cycle1;        //上升下降pwm占空比数值
reg  [16:0]  duty_cycle2;        //夹取pwm占空比数值
reg  [16:0]  duty_cycle3;        //旋转pwm占空比数值
reg  [21:0]	 cnt_006s;		      //计数器计时0.06s
reg			 cnt_flag;		      //计数器计时0.06s输出一个标志信号


//根据占空比和计数值之间的大小关系来输出pwm
assign steer_xpwm = (period_cnt <= duty_cycle1) ?  1'b1  :  1'b0;
assign steer_ypwm = (period_cnt <= duty_cycle2) ?  1'b1  :  1'b0;
assign steer_zpwm = (period_cnt <= duty_cycle3) ?  1'b1  :  1'b0;

//计数器 0.06s
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)begin
        cnt_006s <= 22'd0;
		  cnt_flag <= 1'b0;
		  end
    else if(cnt_006s == 22'd3_000_000)begin
        cnt_006s <= 22'd0;
		  cnt_flag <= 1'b1;
		  end
    else begin
        cnt_006s <= cnt_006s + 1'b1;
		  cnt_flag <= 1'b0;
		  end
end

//周期计数器 20ms
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        period_cnt <= 20'd0;
    else if(period_cnt == 20'd1_000_000)
        period_cnt <= 20'd0;
    else
        period_cnt <= period_cnt + 1'b1;
end

// 按键key1与key2控制舵机1缓慢上升下降
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        duty_cycle1 <= 17'd25_000;
    else if(key1 && duty_cycle1 != 17'd125_000 && cnt_flag == 1'b1)
		duty_cycle1 <= duty_cycle1 + 17'd10_00;
    else if(key2 && duty_cycle1 != 17'd75_000 && cnt_flag == 1'b1)
		duty_cycle1 <= duty_cycle1 - 17'd10_00;
	 else;
		
end

// 按键key3与key4控制舵机2缓慢夹取
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        duty_cycle2 <= 17'd75_000;
    else if(key3 && duty_cycle2 != 17'd125_000 && cnt_flag == 1'b1)
		duty_cycle2 <= duty_cycle2 + 17'd20_00;
    else if(key4 && duty_cycle2 != 17'd25_000 && cnt_flag == 1'b1)
		duty_cycle2 <= duty_cycle2 - 17'd20_00;
	 else; 
		
end

// 按键key5与key6控制舵机3缓慢旋转
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        duty_cycle3 <= 17'd75_000;
    else if(key5 && duty_cycle3 != 17'd125_000 && cnt_flag == 1'b1)
		duty_cycle3 <= duty_cycle3 + 17'd10_00;
    else if(key6 && duty_cycle3 != 17'd25_000 && cnt_flag == 1'b1)
		duty_cycle3 <= duty_cycle3 - 17'd10_00;
	 else;
		
end

endmodule 