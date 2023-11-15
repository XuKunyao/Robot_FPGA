/*================================================*\
		  Filename：dht11.v
			 Author：XuKunyao
	  Description：温湿度检测
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module dht11(

	input				sys_clk,
	input				rst_n,
	
	input				dht11_req,   //dht11数据采集请求
	output			dht11_done,	 //dht11数据采集结束
	output			dht11_error, //dht11数据采集正确与否判断   1为错误
	
	output[7:0]		tempH,			//温度数据整数
	output[7:0]		tempL,			//温度数据小数
	output[7:0]		humidityH,		//温度数据整数
	output[7:0]		humidityL,		//温度数据小数
	
	
	inout				dht11
);


//时钟为50MHZ，20ns
localparam	TIME18ms = 'd1000_099;//开始态的拉低18ms,900_000个时钟周期，这里适当的延长了拉低时间。
localparam	TIME35us = 'd1_750;   //数据传输过程中，数据0拉高的出现



localparam S_IDLE			 =		'd0;  //空闲态
localparam S_START_FPGA	 =		'd1;  //FPGA请求采集数据开始
localparam S_START_DHT11 =    'd2;  //DHT11开始请求应答
localparam S_DATA			 =		'd3;	//数据传输
localparam S_STOP			 =		'd4;  //数据结束
localparam S_DOEN			 =		'd5;  //数据采集完成


reg[2:0]		state , next_state;

reg[22:0]	DHT11_Cnt;		//计时器
reg[5:0]		DHT11Bit_Cnt;  // 接收dht11传输bit数计数

reg[39:0]	dht11_data;


reg 			dht11_d0 , dht11_d1;
wire 			dht11_negedge;  


//检测dht11的上下边沿   
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
		if(dht11_req == 1'b1)   //数据采集请求过来进入开始态
			next_state <= S_START_FPGA;
		else
			next_state <= S_IDLE;
	S_START_FPGA:                        
		if((DHT11_Cnt >= TIME18ms) && dht11_negedge == 1'b1)   //FPGA请求结束结束
			next_state <= S_START_DHT11;
		else
			next_state <= S_START_FPGA;
	S_START_DHT11:
		if((DHT11_Cnt > TIME35us) && dht11_negedge == 1'b1)  //延时一段时间后，通过判断dht11总线的下降沿，是否结束响应
			next_state <= S_DATA;
		else
			next_state <= S_START_DHT11;
	S_DATA:
		if(DHT11Bit_Cnt == 'd39 && dht11_negedge == 1'b1)  //接收到40bit数据后，进入停止态
			next_state <= S_STOP;
		else
			next_state <= S_DATA;
	S_STOP:
		if(DHT11_Cnt == TIME35us + TIME35us)  //数据传输完成后，等待总线拉低50us,这里是70us
			next_state <= S_DOEN;
		else
			next_state <= S_STOP;
	S_DOEN:
		next_state <= S_IDLE;
			
	default: next_state <= S_IDLE;
	endcase
end


/*计数模块*/
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		DHT11_Cnt <= 'd0;
	else if(state != next_state)      //状态变换的时候，计时器置0
		DHT11_Cnt <= 'd0; 
	else if(state == S_START_FPGA)   
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else if(state == S_START_DHT11)
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else if(state == S_DATA && dht11_negedge == 1'b0)   //数据的时候，只需要在高电平的时候计数
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else if(state == S_STOP)
		DHT11_Cnt <= DHT11_Cnt + 1'b1;
	else
		DHT11_Cnt <= 'd0;		
end



/*接收数据存储*/
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		dht11_data <= 'd0;
	else if(state == S_DATA)
		if((DHT11_Cnt <= TIME35us + 'd3000) && dht11_negedge == 1'b1) //'d3000为低电平时间，高电平持续时间低于35us认为是数据0
			dht11_data <= {dht11_data[38:0],1'b0};
		else if(dht11_negedge == 1'b1)
			dht11_data <= {dht11_data[38:0],1'b1};
		else
			dht11_data <= dht11_data;
	else
		dht11_data <= dht11_data;
end

/*接收bit计数*/
always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
		DHT11Bit_Cnt <= 'd0;
	else if(state == S_DATA && dht11_negedge == 1'b1)
		DHT11Bit_Cnt <= DHT11Bit_Cnt + 1'b1;
	else if(state == S_DOEN)   //结束后，bit计数清零
		DHT11Bit_Cnt <= 'd0;
	else
		DHT11Bit_Cnt <= DHT11Bit_Cnt;
end

endmodule 
