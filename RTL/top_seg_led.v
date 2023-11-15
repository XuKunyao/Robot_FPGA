/*================================================*\
		  Filename：top_seg_led.v
			 Author：XuKunyao
	  Description：动态数码管模块
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module top_seg_led(
    //global clock
    input wire         sys_clk  ,       // 全局时钟信号
    input wire         sys_rst_n,       // 复位信号（低有效）
    input wire [19:0]  data,     // 数码管显示的数值
    input wire [ 5:0]  point,                // 数码管小数点的位置
    
/**********************备用功能*********************** 
    input wire [ 5:0]  point,                // 数码管小数点的位置
    input wire         en,                   // 数码管显示使能信号
    input wire         sign,                 // 数码管显示数据的符号位
*****************************************************/
    
    //seg_led interface
    output    [5:0]  seg_sel  ,       // 数码管位选信号
    output    [7:0]  seg_led  ,        // 数码管段选信号
    output    [3:0]  data4,          
    output    [3:0]  data5 
);

//*****************************************************
//**                    main code
//*****************************************************


//计数器模块，产生数码管需要显示的数据
count u_count(
    .clk           (sys_clk  ),       // 时钟信号
    .rst_n         (sys_rst_n),       // 复位信号

    //.point         (point    ),     // 小数点具体显示的位置,高电平有效
    .en            (en       ),       // 数码管使能信号
    .sign          (sign     )        // 符号位
);

//数码管动态显示模块
seg_led u_seg_led(
    .clk           (sys_clk  ),       // 时钟信号
    .rst_n         (sys_rst_n),       // 复位信号

    .data          (data     ),       // 显示的数值
    .point         (point    ),       // 小数点具体显示的位置,高电平有效
    .en            (en       ),       // 数码管使能信号
    .sign          (sign     ),       // 符号位，高电平显示负号(-)
    
    .seg_sel       (seg_sel  ),       // 位选
    .seg_led       (seg_led  ),       // 段选
    .data4         (data4),
    .data5         (data5)
);

endmodule