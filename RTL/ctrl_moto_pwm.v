/*================================================*\
		  Filename��ctrl_moto_pwm.v
			 Author��XuKunyao
	  Description����������ģ�飬ͨ�������������Ƶ�ʼ�ռ�ձ�������С���Ŀ���
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module ctrl_moto_pwm(
	input					clk			 ,//ʱ��50M
	input					rst_n			 ,//��λ���͵�ƽ��Ч
	input	[7:0]			spd_high_time,
	input	[7:0]			spd_low_time ,
	output				period_fini  ,
	output	reg		pwm			  //�����ź�									
	);
				
	//״̬��
	parameter			idle								= 8'h0,//����״̬
						step_high 							= 8'h1,//����ߵ�ƽ״̬����Ϊ��״̬ʱ��pwmΪ�ߵ�ƽ
						step_low  							= 8'h2;//����͵�ƽ״̬����Ϊ��״̬ʱ��pwmΪ�͵�ƽ
						
	reg	[7:0]		curr_st			;
	reg	[7:0]		curr_st_ff1		;
	reg	[10:0]	step_high_time	;
	reg	[10:0]	step_low_time	;
	reg	[10:0]	step_high_cnt	;
	reg	[10:0]	step_low_cnt	;
	// wire[10:0]	spd_high_time	;
	// wire[10:0]	spd_low_time	;
	wire[10:0]	hspd_high_time		;
	wire[10:0]	hspd_low_time 		;
	// assign	spd_high_time=20	;
	// assign	spd_low_time =10	;
	assign	period_fini=(step_low_cnt==step_low_time)?1'b1:1'b0;
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					step_high_time<=0;
					step_low_time<=0;
				end
			else
				begin
					step_high_time<=spd_high_time;
					step_low_time<=spd_low_time;
				end
		end
	always@(posedge clk)curr_st_ff1<=curr_st	;
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				curr_st<=idle;
			else case(curr_st)
				idle:curr_st<=step_high	;
				step_high:
					begin
						if(step_high_cnt==step_high_time)
							curr_st<=step_low;
						else
							;
					end
				step_low:
					begin
						if(step_low_cnt==step_low_time)
							curr_st<=step_high;
						else
							;
					end
				default:;
			endcase
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				step_high_cnt<=0;
			else if(curr_st==idle)
				step_high_cnt<=0;
			else if(curr_st==step_high)
				step_high_cnt<=step_high_cnt+1;
			else
				step_high_cnt<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				step_low_cnt<=0;
			else if(curr_st==idle)
				step_low_cnt<=0;
			else if(curr_st==step_low)
				step_low_cnt<=step_low_cnt+1;
			else
				step_low_cnt<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					pwm<=0;
				end
			else if(curr_st==idle)
				begin
					pwm<=0;
				end
			else if(curr_st==step_high)
				pwm<=1;
			else if(curr_st==step_low)
				pwm<=0;
			else
				pwm<=1;
		end
endmodule