/*================================================*\
		  Filename��sg90_arm.v
			 Author��XuKunyao
	  Description����е�����������ģ��
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module sg90_arm(
    input       sys_clk,
    input       sys_rst_n,
	 input		 key1,		 //����1����
	 input		 key2,		 //����2�½�
	 input		 key3,		 //����3��ȡ
	 input		 key4,		 //����4�ɿ�
	 input		 key5,		 //����5��ת
	 input		 key6,		 //����6��ת
	 input		 sg90_en,	 //���ʹ���ź�
    output      steer_xpwm, 
    output      steer_ypwm,
    output      steer_zpwm  
    );

reg  [19:0]  period_cnt ;        //���ڼ�����Ƶ�ʣ�50hz ����:20ms  ����ֵ:20ms/20ns=1_000_000
reg  [16:0]  duty_cycle1;        //�����½�pwmռ�ձ���ֵ
reg  [16:0]  duty_cycle2;        //��ȡpwmռ�ձ���ֵ
reg  [16:0]  duty_cycle3;        //��תpwmռ�ձ���ֵ
reg  [21:0]	 cnt_006s;		      //��������ʱ0.06s
reg			 cnt_flag;		      //��������ʱ0.06s���һ����־�ź�


//����ռ�ձȺͼ���ֵ֮��Ĵ�С��ϵ�����pwm
assign steer_xpwm = (period_cnt <= duty_cycle1) ?  1'b1  :  1'b0;
assign steer_ypwm = (period_cnt <= duty_cycle2) ?  1'b1  :  1'b0;
assign steer_zpwm = (period_cnt <= duty_cycle3) ?  1'b1  :  1'b0;

//������ 0.06s
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

//���ڼ����� 20ms
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        period_cnt <= 20'd0;
    else if(period_cnt == 20'd1_000_000)
        period_cnt <= 20'd0;
    else
        period_cnt <= period_cnt + 1'b1;
end

// ����key1��key2���ƶ��1���������½�
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        duty_cycle1 <= 17'd25_000;
    else if(key1 && duty_cycle1 != 17'd125_000 && cnt_flag == 1'b1)
		duty_cycle1 <= duty_cycle1 + 17'd10_00;
    else if(key2 && duty_cycle1 != 17'd75_000 && cnt_flag == 1'b1)
		duty_cycle1 <= duty_cycle1 - 17'd10_00;
	 else;
		
end

// ����key3��key4���ƶ��2������ȡ
always @(posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        duty_cycle2 <= 17'd75_000;
    else if(key3 && duty_cycle2 != 17'd125_000 && cnt_flag == 1'b1)
		duty_cycle2 <= duty_cycle2 + 17'd20_00;
    else if(key4 && duty_cycle2 != 17'd25_000 && cnt_flag == 1'b1)
		duty_cycle2 <= duty_cycle2 - 17'd20_00;
	 else; 
		
end

// ����key5��key6���ƶ��3������ת
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