/*================================================*\
		  Filename��hc_sr_driver.v
			 Author��XuKunyao
	  Description�����������������ļ�
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module 	hc_sr_driver(
	input  wire			Clk	, //system clock 50MHz
	input  wire 		Rst_n	, //reset ��low valid
	
	input  wire 		echo	, //
	output wire  		trig	, //��������ź�
	
	output wire [18:00]	data_o,	  //�����룬����3λС������λ��cm
	output wire			hr_flag,
	output wire			hr_flag_short
);
//Interrnal wire/reg declarations
	wire			clk_us; //	
	
//Module instantiations �� self-build module
	clk_div clk_div(
		.Clk		(Clk		), //system clock 50MHz
		.Rst_n	(Rst_n	), //reset ��low valid		
		.clk_us 	(clk_us 	)  //
	);
	hc_sr_trig hc_sr_trig(
		.clk_us	(clk_us	), //system clock 1MHz
		.Rst_n	(Rst_n	), //reset ，low valid		   
		.trig		(trig		)  //��������ź�
	);

	hc_sr_echo hc_sr_echo(
		.Clk		(Clk		), //clock 50MHz
		.clk_us	(clk_us	), //system clock 1MHz
		.Rst_n	(Rst_n	), //reset ��low valid	   
		.echo		(echo		), //
		.data_o	(data_o	), //�����룬����3λС����*1000ʵ��
		.hr_flag(hr_flag),
		.hr_flag_short(hr_flag_short)
	);

endmodule 
