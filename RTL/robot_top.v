/*================================================*\
		  Filename��robot_top.v
			 Author��XuKunyao
	  Description�������ļ�
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module robot_top(
	//ʱ�Ӽ���λ
	input					clk		,//50MHZ
   input					rst_n		,//��λ�źţ��͵�ƽ��Ч
	//��������
	input					key1		,
	input					key2		,
   input					key3		,
   input					key4		,
	//���pwm����
	output				dir_l_1	,//������ǰ�����ת��ת
	output				dir_l_2	,//�����������ת��ת
	output				dir_r_1	,//������ǰ�����ת��ת
	output				dir_r_2	,//�����Һ�����ת��ת
	output				f_pwm_l	,//����pwm
	output				f_pwm_r	,//�ҵ��pwm 
    //���������
	input					echo	,//�����ź����ڳ��������
	output				trig	,//��������ź�
	//��̬�����
	output	[7:0]		seg	,//��ѡ�ź�
	output	[5:0]		sel	,//λѡ�ź�
	//hc_sr501�����⼰������
	input					hum_in,//hc_sr501��������
   output      		beep	,//���������ͨ��hc_sr501�ж��Ƿ�����
	//lcd1602��ʾ��
 	output	[7:0] 	dat	,//LCD��8λ���ݿ�
 	output  				rs		,//��������ѡ���źţ��ߵ�ƽ��ʾ���ݣ��͵�ƽ��ʾ����
 	output				rw		,//��д��־���ߵ�ƽ��ʾ�����͵�ƽ��ʾд���ó�������ֻ��Һ��������д����
 	output				en		,//LCD�Ŀ��ƽ�
	//����ң��
	input					ir_tx	,//��������źţ����ں���ң��
	//��е�ۿ���
	output				steer_xpwm,//���1���������½�
	output				steer_ypwm,//���2���Ƽ�ȡ�ɿ�
	output				steer_zpwm,//���3���Ƶײ���ת
	//�к�������
	input					DO1,
	//�𶯼��
	input					DO2,
	//dht11��ʪ�ȼ��
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
	wire			pwm				;//pwm������
	reg	[2:0]	ctrl_cnt=0		;//�����洢С������״̬
   wire	[3:0] data4				;//����ܵ���λ
   wire	[3:0] data5				;//����ܵ���λ
   reg			flag=0			;//flag��־λ�ж�С���Ƿ�������
	wire [18:0] line_data		;
	wire			hr_flag			;
	wire			hr_flag_short	;
	wire			sg90_en			;//��е��ʹ���ź�

//	//��������
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

	//����ң��
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
	 
	//���pwm
	ctrl_moto_pwm uctrl_moto_pwm(
		.clk					(clk	),
		.rst_n				(rst_n),
		.spd_high_time		(10	),//�ߵ�ƽʱ��
		.spd_low_time 		(75	),//�͵�ƽʱ��
		.period_fini		(		),
		.pwm					(pwm	) //�����ź�								
	);
    
	//lcd��ʾ
	lcd_top lcd_top_inst(
		.clk					(clk	),//ϵͳʱ������50M
		.rst_n				(rst_n),//��λ���͵�ƽ��Ч
		.dat					(dat	),//LCD��8λ���ݿ�
		.rs					(rs	),//��������ѡ���źţ��ߵ�ƽ��ʾ���ݣ��͵�ƽ��ʾ����
		.rw					(rw	),//��д��־���ߵ�ƽ��ʾ�����͵�ƽ��ʾд���ó�������ֻ��Һ��������д����
		.en					(en	),//LCD�Ŀ��ƽ�
		.DO1					(DO1	),
		.DO2					(DO2	),
		.dht11  				(dht11)
	 );

	//������
	hc_sr_driver	hc_sr_driver(
		.Clk					(clk				), 
		.Rst_n				(rst_n			), 
		.echo					(echo				),//���յĻ����ź����ڼ������
		.trig					(trig				),//��������ź�
		.data_o				(line_data		),//�����룬����3λС������λ��cm
		.hr_flag 			(hr_flag			),//���볤����־�źţ�25cm����
		.hr_flag_short		(hr_flag_short	) //����̼���־�źţ�10cm����
	);

	//��̬�����
	top_seg_led top_seg_led(
		.sys_clk        	(clk					),
		.sys_rst_n     	(rst_n				),
		.data          	({1'b0,line_data}	),//�������ʾ�ź�
		.point          	(6'b001000			),//С������ʾ������λ��ʾС����
		.seg_sel       	(sel					),//λѡ�ź�
		.seg_led       	(seg					),//��ѡ�ź�
		.data4         	(data4				),//����ܵ���λ
		.data5         	(data5				) //����ܵ���λ
	);
	
	//�Զ�����
	ctrl_moto_dir ctrl_moto_dir_inst(
		.clk					(clk				),
		.rst_n				(rst_n			),
		.key_forward		(key1_out		),//ǰ������
		.key_back			(key2_out		),//���˰���
		.key_left			(key3_out		),//��ת����
		.key_right			(key4_out		),//��ת����
		.key_stop			(key5_out		),//��ͣ����
		.pwm					(pwm				),
		.hr_flag				(hr_flag			),
		.hr_flag_short 	(hr_flag_short	),
		.f_in1_l 			(dir_l_1			),
		.f_in2_l  			(dir_l_2			),
		.f_in1_r  			(dir_r_1			),
		.f_in2_r  			(dir_r_2			),
		.f_pwm_l 			(f_pwm_l			),//����pwm
		.f_pwm_r  			(f_pwm_r			),//�ҵ��pwm
		.move_en				(					) //�Ƿ��ƶ����ж��ź�
	);
	
	//������
	hc_sr501 hc_sr501_inst(
		.clk					(clk				),
		.rst_n				(rst_n			),
		.hum_in				(hum_in			),//����
		.hum_out				(					),//��������ĸߵ�ƽ
		.beep					(beep				) //���������
    );
	
	//��е��sg90�������
	sg90_arm sg90_arm_inst(
		.sys_clk				(clk			),
		.sys_rst_n			(rst_n		),
		.key1					(key6_out	),//����1����
		.key2					(key7_out	),//����2�½�
		.key3					(key8_out	),//����3��ȡ
		.key4					(key9_out	),//����4�ɿ�
		.key5					(key10_out	),//����5��ת		 
		.key6					(key11_out	),//����6��ת
		.sg90_en				(sg90_en		),
		.steer_xpwm			(steer_xpwm	), 
		.steer_ypwm			(steer_ypwm	),
		.steer_zpwm			(steer_zpwm	)
    );
	
endmodule