/*================================================*\
		  Filename£ºctrl_moto_dir.v
			 Author£ºXuKunyao
	  Description£º×Ô¶¯±ÜÕÏÄ£¿é£¬×´Ì¬»úÊµÏÖ
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email£º905407267@qq.com
			Company£º
\*================================================*/

module ctrl_moto_dir(
	input		clk,
	input		rst_n,
	input		key_forward,
	input		key_back,
	input		key_left,
	input		key_right,
	input		key_stop,
	input		pwm,
	input		hr_flag,
	input		hr_flag_short,
//	input		hr_error,
	output	reg	f_in1_l=0,
	output	reg	f_in2_l=0,
	output	reg	f_in1_r=0,
	output	reg	f_in2_r=0,
	output	reg	f_pwm_l=0,
	output	reg	f_pwm_r=0,
	 
	output		 move_en
	);
	parameter	IDLE			= 3'd0;
	parameter	FORWARD     = 3'd1;
	parameter	BACK	      = 3'd2;
	parameter	LEFT			= 3'd3;
	parameter	RIGHT			= 3'd4;
	parameter	BZHOU		   = 3'd5;//±ÜÕÏºóÍË
	parameter	BZYOU		   = 3'd6;//±ÜÕÏÓÒ×ª
	parameter	STOP			= 3'd7;//±ÜÕÏÔİÍ£
//	parameter	ERROR			= 3'd8;//±ÜÕÏ´íÎó
	
	reg	[3:0]	curr_st;
	assign	move_en=(curr_st==IDLE)?0:1;
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				curr_st<=IDLE;
			else case(curr_st)
				IDLE:
					begin
						if(key_forward)
							curr_st<=FORWARD;
						else if(key_back)
							curr_st<=BACK;
						else if(key_left)
							curr_st<=LEFT;
						else if(key_right)
							curr_st<=RIGHT;
						else	;
					end
				FORWARD:
					begin
						if(key_stop)
							curr_st<=IDLE;
						else if(key_back)
							curr_st<=BACK;
						else if(key_left)
							curr_st<=LEFT;
						else if(key_right)
							curr_st<=RIGHT;
						else if(hr_flag)
							curr_st<=STOP;
						else if(hr_flag_short)
							curr_st<=STOP;
//						else if(hr_error)
//							curr_st<=ERROR;
						else
							;
					end
				BACK:
					begin
						if(key_stop)
							curr_st<=IDLE;
						else if(key_forward)
							curr_st<=FORWARD;
						else if(key_left)
							curr_st<=LEFT;
						else if(key_right)
							curr_st<=RIGHT;
//						else if(hr_error)
//							curr_st<=ERROR;
						else
							;
					end
				LEFT:
					begin
						if(key_stop)
							curr_st<=IDLE;
						else if(key_forward)
							curr_st<=FORWARD;
						else if(key_back)
							curr_st<=BACK;
						else if(key_right)
							curr_st<=RIGHT;
						else if(hr_flag)
							curr_st<=BZHOU;
//						else if(hr_error)
//							curr_st<=ERROR;
						else
							;
					end
				RIGHT:
					begin
						if(key_stop)
							curr_st<=IDLE;
						else if(key_forward)
							curr_st<=FORWARD;
						else if(key_back)
							curr_st<=BACK;
						else if(key_left)
							curr_st<=LEFT;
						else if(hr_flag)
							curr_st<=BZHOU;
//						else if(hr_error)
//							curr_st<=ERROR;
						else
							;
					end
				BZHOU:
					begin
						if(key_stop)
							curr_st<=IDLE;
						else if(key_forward)
							curr_st<=FORWARD;
						else if(key_back)
							curr_st<=BACK;
						else if(key_left)
							curr_st<=LEFT;
						else if(key_right)
							curr_st<=RIGHT;
						else if(!hr_flag)
							curr_st<=BZYOU;
//						else if(hr_error)
//							curr_st<=ERROR;
						else
							;
					end
				BZYOU:
					begin
						if(key_stop)
							curr_st<=IDLE;
						else if(key_forward)
							curr_st<=FORWARD;
						else if(key_back)
							curr_st<=BACK;
						else if(key_left)
							curr_st<=LEFT;
						else if(key_right)
							curr_st<=RIGHT;
//						else if(hr_flag_short)
//							curr_st<=BZHOU;
						else if(!hr_flag)
							curr_st<=FORWARD;
//						else if(hr_error)
//							curr_st<=ERROR;
						else
							;
					end
				STOP:
					begin
						if(key_forward)
							curr_st<=FORWARD;
						else if(key_back)
							curr_st<=BACK;
						else if(key_left)
							curr_st<=LEFT;
						else if(key_right)
							curr_st<=RIGHT;
						else if(hr_flag_short)
							curr_st<=BZHOU;
						else if(!hr_flag_short)
							curr_st<=BZYOU;
//						else if(hr_error)
//							curr_st<=ERROR;
						else	;
					end
//				ERROR:
//					begin
//						if(key_forward)
//							curr_st<=FORWARD;
//						else if(key_back)
//							curr_st<=BACK;
//						else if(key_left)
//							curr_st<=LEFT;
//						else if(key_right)
//							curr_st<=RIGHT;
//						else if(!hr_flag)
//							curr_st<=FORWARD;
//						else	;
//					end
				default:;
			endcase
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					f_in1_l<=0;
					f_in2_l<=0;
					f_in1_r<=0;
					f_in2_r<=0;
					f_pwm_l<=0;
					f_pwm_r<=0;
					
				end
			else if(curr_st==IDLE)	
				begin
					f_in1_l<=0;
					f_in2_l<=0;
					f_in1_r<=0;
					f_in2_r<=0;
					f_pwm_l<=0;
					f_pwm_r<=0;
					
				end
			else if(curr_st==FORWARD)
				begin
					f_in1_l<=1;
					f_in2_l<=0;
					f_in1_r<=1;
					f_in2_r<=0;
					f_pwm_l<=pwm;
					f_pwm_r<=pwm;
				end
			else if(curr_st==BACK)
				begin
					f_in1_l<=0;
					f_in2_l<=1;
					f_in1_r<=0;
					f_in2_r<=1;
					f_pwm_l<=pwm;
					f_pwm_r<=pwm;
				end
			else if(curr_st==LEFT)
				begin
					f_in1_l<=0;
					f_in2_l<=0;
					f_in1_r<=1;
					f_in2_r<=0;
					f_pwm_l<=0;
					f_pwm_r<=pwm;
				end
			else if(curr_st==RIGHT)
				begin
					f_in1_l<=1;
					f_in2_l<=0;
					f_in1_r<=0;
					f_in2_r<=0;
					f_pwm_l<=pwm;
					f_pwm_r<=0;
				end
			else if(curr_st==BZHOU)
				begin
					f_in1_l<=0;
					f_in2_l<=1;
					f_in1_r<=0;
					f_in2_r<=1;
					f_pwm_l<=pwm;
					f_pwm_r<=pwm;
				end
			else if(curr_st==BZYOU)
				begin
					f_in1_l<=1;
					f_in2_l<=0;
					f_in1_r<=0;
					f_in2_r<=0;
					f_pwm_l<=pwm;
					f_pwm_r<=0;
				end
			else if(curr_st==STOP)
				begin
					f_in1_l<=0;
					f_in2_l<=0;
					f_in1_r<=0;
					f_in2_r<=0;
					f_pwm_l<=0;
					f_pwm_r<=0;
				end
//			else if(curr_st==ERROR)
//				begin
//					f_in1_l<=0;
//					f_in2_l<=1;
//					f_in1_r<=0;
//					f_in2_r<=1;
//					f_pwm_l<=pwm;
//					f_pwm_r<=pwm;
//				end
			else
				;
		end
endmodule