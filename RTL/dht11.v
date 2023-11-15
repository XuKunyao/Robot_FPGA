/*================================================*\
		  Filename��dht11.v
			 Author��XuKunyao
	  Description����ʪ�ȼ��
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module dht11(

	input				sys_clk,
	input				rst_n,
	
	input				dht11_req,   //dht11���ݲɼ�����
	output			dht11_done,	 //dht11���ݲɼ�����
	output			dht11_error, //dht11���ݲɼ���ȷ����ж�   1Ϊ����
	
	output[7:0]		tempH,			//�¶���������
	output[7:0]		tempL,			//�¶�����С��
	output[7:0]		humidityH,		//�¶���������
	output[7:0]		humidityL,		//�¶�����С��
	
	
	inout				dht11
);


//ʱ��Ϊ50MHZ��20ns
localparam	TIME18ms = 'd1000_099;//��ʼ̬������18ms,900_000��ʱ�����ڣ������ʵ����ӳ�������ʱ�䡣
localparam	TIME35us = 'd1_750;   //���ݴ�������У�����0���ߵĳ���



localparam S_IDLE			 =		'd0;  //����̬
localparam S_START_FPGA	 =		'd1;  //FPGA����ɼ����ݿ�ʼ
localparam S_START_DHT11 =    'd2;  //DHT11��ʼ����Ӧ��
localparam S_DATA			 =		'd3;	//���ݴ���
localparam S_STOP			 =		'd4;  //���ݽ���
localparam S_DOEN			 =		'd5;  //���ݲɼ����


reg[2:0]		state , next_state;

reg[22:0]	DHT11_Cnt;		//��ʱ��
reg[5:0]		DHT11Bit_Cnt;  // ����dht11����bit������

reg[39:0]	dht11_data;


reg 			dht11_d0 , dht11_d1;
wire 			dht11_negedge;  


//���dht11�����±���   
assign dht11_negedge = (~dht11_d0) & dht11_d1;

assign dht11 = (state == S_START_FPGA && (DHT11_Cnt <= TIME18ms)) ? 1'b0 : 1'bz;
assign dht11_done = (state == S_DOEN) ? 1'b1 : 1'b0;



assign tempH 		= dht11_data[23:16];
assign tempL 		= dht11_data[15:8];

assign humidityH	= dht11_data[39:32];
assign humidityL 	= dht11_data[31:24];



always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		dht11_d0 <= 1'b1;
		dht11_d1 <= 1'b1;
	end
	else 
	begin
		dht11_d0 <= dht11;
		dht11_d1 <= dht11_d0;
	end
end



always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		state <= S_IDLE;
	else
		state <= next_state;
end


always@(*)
begin
	case(state)
	S_IDLE:
		if(dht11_req == 1'b1)   //���ݲɼ�����������뿪ʼ̬
			next_state <= S_START_FPGA;
		else
			next_state <= S_IDLE;
	S_START_FPGA:                        
		if((DHT11_Cnt >= TIME18ms) && dht11_negedge == 1'b1)   //FPGA�����������
			next_state <= S_START_DHT11;
		else
			next_state <= S_START_FPGA;
	S_START_DHT11:
		if((DHT11_Cnt > TIME35us) && dht11_negedge == 1'b1)  //��ʱһ��ʱ���ͨ���ж�dht11���ߵ��½��أ��Ƿ������Ӧ
			next_state <= S_DATA;
		else
			next_state <= S_START_DHT11;
	S_DATA:
		if(DHT11Bit_Cnt == 'd39 && dht11_negedge == 1'b1)  //���յ�40bit���ݺ󣬽���ֹ̬ͣ
			next_state <= S_STOP;
		else
			next_state <= S_DATA;
	S_STOP:
		if(DHT11_Cnt == TIME35us + TIME35us)  //���ݴ�����ɺ󣬵ȴ���������50us,������70us
			next_state <= S_DOEN;
		else
			next_state <= S_STOP;
	S_DOEN:
		next_state <= S_IDLE;
			
	default: next_state <= S_IDLE;
	endcase
end


/*����ģ��*/
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		DHT11_Cnt <= 'd0;
	else if(state != next_state)      //״̬�任��ʱ�򣬼�ʱ����0
		DHT11_Cnt <= 'd0; 
	else if(state == S_START_FPGA)   
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else if(state == S_START_DHT11)
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else if(state == S_DATA && dht11_negedge == 1'b0)   //���ݵ�ʱ��ֻ��Ҫ�ڸߵ�ƽ��ʱ�����
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else if(state == S_STOP)
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else
		DHT11_Cnt <= 'd0;		
end



/*�������ݴ洢*/
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		dht11_data <= 'd0;
	else if(state == S_DATA)
		if((DHT11_Cnt <= TIME35us + 'd3000) && dht11_negedge == 1'b1) //'d3000Ϊ�͵�ƽʱ�䣬�ߵ�ƽ����ʱ�����35us��Ϊ������0
			dht11_data <= {dht11_data[38:0],1'b0};
		else if(dht11_negedge == 1'b1)
			dht11_data <= {dht11_data[38:0],1'b1};
		else
			dht11_data <= dht11_data;
	else
		dht11_data <= dht11_data;
end

/*����bit����*/
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		DHT11Bit_Cnt <= 'd0;
	else if(state == S_DATA && dht11_negedge == 1'b1)
		DHT11Bit_Cnt <= DHT11Bit_Cnt + 1'b1;
	else if(state == S_DOEN)   //������bit��������
		DHT11Bit_Cnt <= 'd0;
	else
		DHT11Bit_Cnt <= DHT11Bit_Cnt;
end

endmodule 
