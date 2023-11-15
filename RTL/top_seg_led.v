/*================================================*\
		  Filename��top_seg_led.v
			 Author��XuKunyao
	  Description����̬�����ģ��
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module top_seg_led(
    //global clock
    input wire         sys_clk  ,       // ȫ��ʱ���ź�
    input wire         sys_rst_n,       // ��λ�źţ�����Ч��
    input wire [19:0]  data,     // �������ʾ����ֵ
    input wire [ 5:0]  point,                // �����С�����λ��
    
/**********************���ù���*********************** 
    input wire [ 5:0]  point,                // �����С�����λ��
    input wire         en,                   // �������ʾʹ���ź�
    input wire         sign,                 // �������ʾ���ݵķ���λ
*****************************************************/
    
    //seg_led interface
    output    [5:0]  seg_sel  ,       // �����λѡ�ź�
    output    [7:0]  seg_led  ,        // ����ܶ�ѡ�ź�
    output    [3:0]  data4,          
    output    [3:0]  data5 
);

//*****************************************************
//**                    main code
//*****************************************************


//������ģ�飬�����������Ҫ��ʾ������
count u_count(
    .clk           (sys_clk  ),       // ʱ���ź�
    .rst_n         (sys_rst_n),       // ��λ�ź�

    //.point         (point    ),     // С���������ʾ��λ��,�ߵ�ƽ��Ч
    .en            (en       ),       // �����ʹ���ź�
    .sign          (sign     )        // ����λ
);

//����ܶ�̬��ʾģ��
seg_led u_seg_led(
    .clk           (sys_clk  ),       // ʱ���ź�
    .rst_n         (sys_rst_n),       // ��λ�ź�

    .data          (data     ),       // ��ʾ����ֵ
    .point         (point    ),       // С���������ʾ��λ��,�ߵ�ƽ��Ч
    .en            (en       ),       // �����ʹ���ź�
    .sign          (sign     ),       // ����λ���ߵ�ƽ��ʾ����(-)
    
    .seg_sel       (seg_sel  ),       // λѡ
    .seg_led       (seg_led  ),       // ��ѡ
    .data4         (data4),
    .data5         (data5)
);

endmodule