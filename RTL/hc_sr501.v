/*================================================*\
		  Filename��hc_sr501.v
			 Author��XuKunyao
	  Description��������ģ�飬������ߵ�ƽ�ź�����Դ�����������ź�
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module hc_sr501(
	input			clk,
	input		 	rst_n,
	input			hum_in,
	output reg  hum_out,
	output reg  beep
    );
	 
parameter freq_data = 18'd190839;   //"��"������Ƶ����ֵ��Ƶ��262��

reg     [17:0]  freq_cnt    ;   //����������
wire    [16:0]  duty_data   ;   //ռ�ձȼ���ֵ

//����50��ռ�ձȣ����׷�Ƶ����ֵ��һ�뼴Ϊռ�ձȵĸߵ�ƽ��
assign  duty_data   =   freq_data   >>    1'b1;

always@(posedge clk or  negedge rst_n)
    if(rst_n == 1'b0)
        freq_cnt    <=  18'd0;
    else    if(freq_cnt == freq_data)
        freq_cnt    <=  18'd0;
    else
        freq_cnt    <=  freq_cnt +  1'b1;

always@(posedge clk or negedge rst_n)
	if(!rst_n)
		hum_out <= 1'b0;
	else
		hum_out <= hum_in;

//beep���������������
always@(posedge clk or  negedge rst_n)
    if(rst_n == 1'b0)
        beep    <=  1'b0;
    else if(hum_in)begin
		if(freq_cnt >= duty_data)
			beep    <=  1'b1;
		else
			beep    <=  1'b0;
		end
	 else
			beep    <=  1'b0;

endmodule
