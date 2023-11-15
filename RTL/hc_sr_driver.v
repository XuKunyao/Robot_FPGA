/*================================================*\
		  Filename：hc_sr_driver.v
			 Author：XuKunyao
	  Description：超声波驱动调度文件
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module 	hc_sr_driver(
	input  wire			Clk	, //system clock 50MHz
	input  wire 		Rst_n	, //reset ，low valid
	
	input  wire 		echo	, //
	output wire  		trig	, //触发测距信号
	
	output wire [18:00]	data_o,	  //检测距离，保留3位小数，单位：cm
	output wire			hr_flag,
	output wire			hr_flag_short
);
//Interrnal wire/reg declarations
	wire			clk_us; //	
	
//Module instantiations ， self-build module
	clk_div clk_div(
		.Clk		(Clk		), //system clock 50MHz
		.Rst_n	(Rst_n	), //reset ，low valid		
		.clk_us 	(clk_us 	)  //
	);
	hc_sr_trig hc_sr_trig(
		.clk_us	(clk_us	), //system clock 1MHz
		.Rst_n	(Rst_n	), //reset 锛宭ow valid		   
		.trig		(trig		)  //触发测距信号
	);

	hc_sr_echo hc_sr_echo(
		.Clk		(Clk		), //clock 50MHz
		.clk_us	(clk_us	), //system clock 1MHz
		.Rst_n	(Rst_n	), //reset ，low valid	   
		.echo		(echo		), //
		.data_o	(data_o	), //检测距离，保留3位小数，*1000实现
		.hr_flag(hr_flag),
		.hr_flag_short(hr_flag_short)
	);

endmodule 
