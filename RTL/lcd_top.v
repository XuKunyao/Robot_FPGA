/*================================================*\
		  Filename：lcd_top.v
			 Author：XuKunyao
	  Description：lcd顶层文件
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module lcd_top(
	input 			clk	,//系统时钟输入50M
	input				rst_n	,//复位，低电平有效
 	output	[7:0]	dat	,//LCD的8位数据口
 	output  			rs		,//数据命令选择信号，高电平表示数据，低电平表示命令
 	output			rw		,//读写标志，高电平表示读，低电平表示写，该程序我们只对液晶屏进行写操作
 	output			en		,//LCD的控制脚
	input				DO1	,//有害气体输入管脚
	input				DO2	,//震动数据输入管脚
	inout				dht11
	 );

	wire [7:0]		tempH		;//温度数据整数
	wire [7:0]		tempL		;//温度数据小数
	wire [7:0]		humidityH;//温度数据整数
	wire [7:0]		humidityL;//温度数据小数
	wire				gas_signal;
	wire				shake_signal;

	dht11 dht11_inst(
		.sys_clk			(clk			),
		.rst_n			(rst_n		),
		.dht11_req		(1'b1			),//dht11数据采集请求
		.dht11_done		(				),//dht11数据采集结束
		.dht11_error	(				),//dht11数据采集正确与否判断   1为错误
		.tempH			(tempH		),//温度数据整数
		.tempL			(tempL		),//温度数据小数
		.humidityH		(humidityH	),//温度数据整数
		.humidityL		(humidityL	),//温度数据小数
		.dht11			(dht11		)
	);

	lcd lcd_inst( 
		.clk				(clk			),//系统时钟输入50M
		.rst_n			(rst_n		),//复位，低电平有效
		.tempH			(tempH		),//温度数据整数
		.tempL			(tempL		),//温度数据小数
		.humidityH		(humidityH	),//温度数据整数
		.humidityL		(humidityL	),//温度数据小数
		.gas_signal		(gas_signal	),
		.shake_signal	(shake_signal	),
		.dat				(dat			),//LCD的8位数据口
		.rs				(rs			),//数据命令选择信号，高电平表示数据，低电平表示命令
		.rw				(rw			),//读写标志，高电平表示读，低电平表示写，该程序我们只对液晶屏进行写操作
		.en				(en			) //LCD的控制脚
	);
	
	toxic_gas toxic_gas_inst(
		.clk				(clk			),
		.rst_n			(rst_n		),
		.DO				(DO1			),
		.gas_signal		(gas_signal	)
	 );
	 
	shake shake_inst(
		.clk				(clk),
		.rst_n			(rst_n),
		.DO				(DO2),//数据输入接口
		.shake_signal	(shake_signal)
    );

endmodule
