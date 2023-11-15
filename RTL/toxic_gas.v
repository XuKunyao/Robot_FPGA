/*================================================*\
		  Filename：toxic_gas.v
			 Author：XuKunyao
	  Description：有毒气体检测模块
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module toxic_gas(
	input		clk,
	input		rst_n,
	input		DO,
	output	reg gas_signal
	 );

	always @(posedge clk or negedge rst_n)
		if(!rst_n) 
			gas_signal <= 1'b0;
		else if(!DO)
			gas_signal <= 1'b1;
		else	   
			gas_signal <= 1'b0;

endmodule
