/*================================================*\
		  Filename：robot_top.v
			 Author：XuKunyao
	  Description：顶层文件
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module robot_top(
	//时钟及复位
	input					clk		,//50MHZ
   input					rst_n		,//复位信号，低电平有效
	//按键控制
	input					key1		,
	input					key2		,
   input					key3		,
   input					key4		,
	//电机pwm控制
	output				dir_l_1	,//控制左前电机正转或反转
	output				dir_l_2	,//控制左后电机正转或反转
	output				dir_r_1	,//控制右前电机正转或反转
	output				dir_r_2	,//控制右后电机正转或反转
	output				f_pwm_l	,//左电机pwm
	output				f_pwm_r	,//右电机pwm 
    //超声波测距
	input					echo	,//回声信号用于超声波测距
	output				trig	,//触发测距信号
	//动态数码管
	output	[7:0]		seg	,//段选信号
	output	[5:0]		sel	,//位选信号
	//hc_sr501人体检测及蜂鸣器
	input					hum_in,//hc_sr501检测输入口
   output      		beep	,//蜂鸣器输出通过hc_sr501判断是否有人
	//lcd1602显示屏
 	output	[7:0] 	dat	,//LCD的8位数据口
 	output  				rs		,//数据命令选择信号，高电平表示数据，低电平表示命令
 	output				rw		,//读写标志，高电平表示读，低电平表示写，该程序我们只对液晶屏进行写操作
 	output				en		,//LCD的控制脚
	//红外遥控
	input					ir_tx	,//红外接收信号，用于红外遥控
	//机械臂控制
	output				steer_xpwm,//舵机1控制上升下降
	output				steer_ypwm,//舵机2控制夹取松开
	output				steer_zpwm,//舵机3控制底部旋转
	//有害气体检测
	input					DO1,
	//震动检测
	input					DO2,
	//dht11温湿度检测
	inout					dht11    
	);
	
	wire			key1_out;
	wire			key2_out;
	wire			key3_out;
	wire			key4_out;
	wire			key5_out;
			
	wire			key6_out;
	wire			key7_out;
	wire			key8_out;
	wire			key9_out;
	wire			key10_out;
	wire			key11_out;
	wire			pwm				;//pwm电机输出
	reg	[2:0]	ctrl_cnt=0		;//用来存储小车运行状态
   wire	[3:0] data4				;//数码管第四位
   wire	[3:0] data5				;//数码管第五位
   reg			flag=0			;//flag标志位判断小车是否在运行
	wire [18:0] line_data		;
	wire			hr_flag			;
	wire			hr_flag_short	;
	wire			sg90_en			;//机械臂使能信号

//	//按键控制
//	key_xd Ukey1_xd(
//		.clk				(clk),
//		.rst_n			(rst_n),
//		.key_in			(key1),
//		.key_out    	(key1_io)
//	);
//	key_xd Ukey2_xd(
//		.clk				(clk),
//		.rst_n			(rst_n),
//		.key_in			(key2),
//		.key_out    	(key2_io)
//	);
//	key_xd Ukey3_xd(
//		.clk				(clk),
//		.rst_n			(rst_n),
//		.key_in			(key3),
//		.key_out    	(key3_io)
//	);
//	key_xd Ukey4_xd(
//		.clk				(clk),
//		.rst_n			(rst_n),
//		.key_in			(key4),
//		.key_out    	(key4_io)
//	);
//	key_xd Ukey5_xd(
//		.clk				(clk),
//		.rst_n			(rst_n),
//		.key_in			(key5),
//		.key_out    	(key5_out)
//	);

	//红外遥控
	rcv_top rcv_top_inst(
		.clk					(clk		),
		.rst_n				(rst_n	),
		.ir_tx				(ir_tx	),
		.key1_out  			(key1_out),      
		.key2_out  			(key2_out),    
		.key3_out  			(key3_out),      
		.key4_out  			(key4_out),       
		.key5_out  			(key5_out),
		.key6_out			(key6_out),
		.key7_out			(key7_out),
		.key8_out			(key8_out),
		.key9_out			(key9_out),
		.key10_out			(key10_out),
		.key11_out			(key11_out),
		.sg90_en				(sg90_en)
    );	
	 
	//电机pwm
	ctrl_moto_pwm uctrl_moto_pwm(
		.clk					(clk	),
		.rst_n				(rst_n),
		.spd_high_time		(10	),//高电平时间
		.spd_low_time 		(75	),//低电平时间
		.period_fini		(		),
		.pwm					(pwm	) //脉冲信号								
	);
    
	//lcd显示
	lcd_top lcd_top_inst(
		.clk					(clk	),//系统时钟输入50M
		.rst_n				(rst_n),//复位，低电平有效
		.dat					(dat	),//LCD的8位数据口
		.rs					(rs	),//数据命令选择信号，高电平表示数据，低电平表示命令
		.rw					(rw	),//读写标志，高电平表示读，低电平表示写，该程序我们只对液晶屏进行写操作
		.en					(en	),//LCD的控制脚
		.DO1					(DO1	),
		.DO2					(DO2	),
		.dht11  				(dht11)
	 );

	//超声波
	hc_sr_driver	hc_sr_driver(
		.Clk					(clk				), 
		.Rst_n				(rst_n			), 
		.echo					(echo				),//接收的回声信号用于计算距离
		.trig					(trig				),//触发测距信号
		.data_o				(line_data		),//检测距离，保留3位小数，单位：cm
		.hr_flag 			(hr_flag			),//距离长检测标志信号，25cm产生
		.hr_flag_short		(hr_flag_short	) //距离短检测标志信号，10cm产生
	);

	//动态数码管
	top_seg_led top_seg_led(
		.sys_clk        	(clk					),
		.sys_rst_n     	(rst_n				),
		.data          	({1'b0,line_data}	),//数码管显示信号
		.point          	(6'b001000			),//小数点显示，第三位显示小数点
		.seg_sel       	(sel					),//位选信号
		.seg_led       	(seg					),//段选信号
		.data4         	(data4				),//数码管第四位
		.data5         	(data5				) //数码管第五位
	);
	
	//自动避障
	ctrl_moto_dir ctrl_moto_dir_inst(
		.clk					(clk				),
		.rst_n				(rst_n			),
		.key_forward		(key1_out		),//前进按键
		.key_back			(key2_out		),//后退按键
		.key_left			(key3_out		),//左转按键
		.key_right			(key4_out		),//右转按键
		.key_stop			(key5_out		),//暂停按键
		.pwm					(pwm				),
		.hr_flag				(hr_flag			),
		.hr_flag_short 	(hr_flag_short	),
		.f_in1_l 			(dir_l_1			),
		.f_in2_l  			(dir_l_2			),
		.f_in1_r  			(dir_r_1			),
		.f_in2_r  			(dir_r_2			),
		.f_pwm_l 			(f_pwm_l			),//左电机pwm
		.f_pwm_r  			(f_pwm_r			),//右电机pwm
		.move_en				(					) //是否移动的判断信号
	);
	
	//人体检测
	hc_sr501 hc_sr501_inst(
		.clk					(clk				),
		.rst_n				(rst_n			),
		.hum_in				(hum_in			),//输入
		.hum_out				(					),//输出持续的高电平
		.beep					(beep				) //输出蜂鸣器
    );
	
	//机械臂sg90舵机控制
	sg90_arm sg90_arm_inst(
		.sys_clk				(clk			),
		.sys_rst_n			(rst_n		),
		.key1					(key6_out	),//按键1上升
		.key2					(key7_out	),//按键2下降
		.key3					(key8_out	),//按键3夹取
		.key4					(key9_out	),//按键4松开
		.key5					(key10_out	),//按键5左转		 
		.key6					(key11_out	),//按键6右转
		.sg90_en				(sg90_en		),
		.steer_xpwm			(steer_xpwm	), 
		.steer_ypwm			(steer_ypwm	),
		.steer_zpwm			(steer_zpwm	)
    );
	
endmodule