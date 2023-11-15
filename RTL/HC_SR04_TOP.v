/*================================================*\
		  Filename �
			Author �
	  Description  �
		 Called by �
Revision History   �mm/dd/202x
		  			  Revision 1.0
  			  Email�
			Company�
\*================================================*/
module 	HC_SR04_TOP(
	input  			Clk		, //system clock 50MHz
	input   		Rst_n	, //reset ，low valid
	
	input   		echo	, //
	output   		trig	, //触发测距信号
	output	[19:0] data
);
//Interrnal wire/reg declarations

	
	
//Module instantiations �self-build module
	hc_sr_driver	hc_sr_driver(
		/*input  wire		*/.Clk		(Clk	), //system clock 50MHz
		/*input  wire 		*/.Rst_n	(Rst_n	), //reset ，low valid

		/*input  wire 		*/.echo		(echo	), //
		/*output wire  		*/.trig		(trig	), //触发测距信号

		/*output reg [18:00]*/.data_o	(data)  //检测距离，保留3位小数，单位：cm
);


//top_seg_led top_seg_led(
//    .sys_clk        (Clk),       // 全局时钟信号
//    .sys_rst_n      (Rst_n),       // 复位信号（低有效�
//    .data           (line_data),     // 数码管显示的数�
//    .point          (6'b001000),                // 数码管小数点的位�
//    .seg_sel        (sel),       // 数码管位选信�
//    .seg_led        (seg),         // 数码管段选信�
//    .data4          (data4),
//    .data5          (data5)
//);

//Logic Description
	

endmodule 
