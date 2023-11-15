/*================================================*\
		  Filename��lcd_top.v
			 Author��XuKunyao
	  Description��lcd�����ļ�
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module lcd_top(
	input 			clk	,//ϵͳʱ������50M
	input				rst_n	,//��λ���͵�ƽ��Ч
 	output	[7:0]	dat	,//LCD��8λ���ݿ�
 	output  			rs		,//��������ѡ���źţ��ߵ�ƽ��ʾ���ݣ��͵�ƽ��ʾ����
 	output			rw		,//��д��־���ߵ�ƽ��ʾ�����͵�ƽ��ʾд���ó�������ֻ��Һ��������д����
 	output			en		,//LCD�Ŀ��ƽ�
	input				DO1	,//�к���������ܽ�
	input				DO2	,//����������ܽ�
	inout				dht11
	 );

	wire [7:0]		tempH		;//�¶���������
	wire [7:0]		tempL		;//�¶�����С��
	wire [7:0]		humidityH;//�¶���������
	wire [7:0]		humidityL;//�¶�����С��
	wire				gas_signal;
	wire				shake_signal;

	dht11 dht11_inst(
		.sys_clk			(clk			),
		.rst_n			(rst_n		),
		.dht11_req		(1'b1			),//dht11���ݲɼ�����
		.dht11_done		(				),//dht11���ݲɼ�����
		.dht11_error	(				),//dht11���ݲɼ���ȷ����ж�   1Ϊ����
		.tempH			(tempH		),//�¶���������
		.tempL			(tempL		),//�¶�����С��
		.humidityH		(humidityH	),//�¶���������
		.humidityL		(humidityL	),//�¶�����С��
		.dht11			(dht11		)
	);

	lcd lcd_inst( 
		.clk				(clk			),//ϵͳʱ������50M
		.rst_n			(rst_n		),//��λ���͵�ƽ��Ч
		.tempH			(tempH		),//�¶���������
		.tempL			(tempL		),//�¶�����С��
		.humidityH		(humidityH	),//�¶���������
		.humidityL		(humidityL	),//�¶�����С��
		.gas_signal		(gas_signal	),
		.shake_signal	(shake_signal	),
		.dat				(dat			),//LCD��8λ���ݿ�
		.rs				(rs			),//��������ѡ���źţ��ߵ�ƽ��ʾ���ݣ��͵�ƽ��ʾ����
		.rw				(rw			),//��д��־���ߵ�ƽ��ʾ�����͵�ƽ��ʾд���ó�������ֻ��Һ��������д����
		.en				(en			) //LCD�Ŀ��ƽ�
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
		.DO				(DO2),//��������ӿ�
		.shake_signal	(shake_signal)
    );

endmodule
