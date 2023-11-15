/*================================================*\
		  Filename��rcv_top.v
			 Author��XuKunyao
	  Description������ң�ض����ļ�
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module rcv_top(
	 input 		clk			,
	 input 		rst_n			,
	 input 		ir_tx			,//��������źţ����ں���ң��
    output		key1_out 	,      
    output		key2_out 	,    
    output		key3_out 	,      
    output		key4_out 	,       
    output		key5_out 	,
    output		key6_out 	,    
    output		key7_out 	,      
    output		key8_out 	,       
    output		key9_out 	,
	 output		key10_out	,
	 output		key11_out	,
	 output		sg90_en
    );

	wire [7:0] data;
	wire	key1_io;
	wire	key2_io;
	wire	key3_io;
	wire	key4_io;
	wire	key5_io;

	//����ң���������
	remote_rcv remote_rcv_inst(
		.sys_clk   (clk		),//ϵͳʱ��
		.sys_rst_n (rst_n		),//ϵͳ��λ�źţ��͵�ƽ��Ч
		.remote_in (ir_tx		),//��������ź�
		.repeat_en (repeat_en),//�ظ�����Ч�ź�
		.data_en   (data_en	),//������Ч�ź�
		.data      (data		) //���������
    );
	
	//ң���źŲ���
	rcv_out rcv_out_inst(
		.clk       (clk 		),
		.rst_n     (rst_n		),
		.data      (data		),        //���������
		.key1_io  (key1_io	),      
		.key2_io  (key2_io	),    
		.key3_io  (key3_io	),      
		.key4_io  (key4_io	),       
		.key5_io  (key5_io	),
		.key6_io  (key6_out	),    
		.key7_io  (key7_out	),      
		.key8_io  (key8_out	),       
		.key9_io  (key9_out	),
		.key10_io (key10_out	),
		.key11_io (key11_out	),
		.sg90_io  (sg90_en)
	 );
	
	//��־�������
	bianyan bianyan_top1(
		.clk			(clk		),
		.rst_n		(rst_n	),
		.key_io 		(key1_io	),//����      
		.key_flag	(key1_out) //��־�źŲ���
	);
	bianyan bianyan_top2(
		.clk			(clk		),
		.rst_n		(rst_n	),
		.key_io 		(key2_io	),      
		.key_flag	(key2_out)
	);
	bianyan bianyan_top3(
		.clk			(clk		),
		.rst_n		(rst_n	),
		.key_io 		(key3_io	),      
		.key_flag	(key3_out)
	);
	bianyan bianyan_top4(
    .clk			(clk		),
	 .rst_n		(rst_n	),
    .key_io 	(key4_io	),      
	 .key_flag	(key4_out)
	);
	bianyan bianyan_top5(
		.clk			(clk		),
		.rst_n		(rst_n	),
		.key_io 		(key5_io	),      
		.key_flag	(key5_out)
	);

endmodule
