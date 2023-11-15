/*================================================*\
		  Filename��hc_sr_echo.v
			 Author��XuKunyao
	  Description��������������ģ�飬��ģ�����۲��Ծ��� 2cm~510cm��������������λС��
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email��905407267@qq.com
			Company��
\*================================================*/

module 	hc_sr_echo(
	input  wire 		Clk		, //clock 50MHz
	input  wire			clk_us	, //system clock 1MHz
	input  wire 		Rst_n	, 
		   
	input  wire 		echo	, //
	output wire [18:00]	data_o,	  //�����룬����3λС����*1000ʵ��
	output reg			hr_flag,
	output reg			hr_flag_short
//	output reg			hr_error
);
/* 		S(um) = 17 * t 		-->  x.abc cm	*/
//Parameter Declarations
	parameter T_MAX = 16'd60_000;//510cm ��Ӧ����ֵ

//Interrnal wire/reg declarations
	reg				r1_echo,r2_echo; //���ؼ��
	wire			echo_pos,echo_neg; //
	
	reg		[15:00]	cnt		; //Counter 
	wire			add_cnt ; //Counter Enable
	wire			end_cnt ; //Counter Reset 
	
	reg		[18:00]	data_r	;
//Logic Description
	//���ʹ��clk_us �����أ���ʱ2us����ֵ����
	always @(posedge Clk or negedge Rst_n)begin  
		if(!Rst_n)begin  
			r1_echo <= 1'b0;
			r2_echo <= 1'b0;
		end  
		else begin  
			r1_echo <= echo;
			r2_echo <= r1_echo;
		end  
	end
	
	assign echo_pos = r1_echo & ~r2_echo;
	assign echo_neg = ~r1_echo & r2_echo;
	
	
	always @(posedge clk_us or negedge Rst_n)begin  
		if(!Rst_n)begin  
			cnt <= 'd0; 
		end 
		else if(add_cnt)begin  
			if(end_cnt)begin  
				cnt <= cnt; 
			end  
			else begin  
				cnt <= cnt + 1'b1; 
			end  
		end  
		else begin  //echo �͵�ƽ ����
			cnt <= 'd0;  
		end  
	end 
	
	assign add_cnt = echo; 
	assign end_cnt = add_cnt && cnt >= T_MAX - 1; //������������Χ�򱣳ֲ���
	
	always @(posedge Clk or negedge Rst_n)begin  
		if(!Rst_n)begin  
			data_r <= 'd2;
		end  
		else if(echo_neg)begin  
			data_r <= (cnt << 4) + cnt;
		end  
		else begin  
			data_r <= data_r;
		end  
	end //always end
	
	assign data_o = data_r >> 1;
	
	// �жϾ����Ƿ�С��20cm
	always @(posedge Clk or negedge Rst_n)begin  
		if(!Rst_n)begin  
			hr_flag <= 1'd0;
		end  
		else if(data_o <= 19'd15_000)begin  
			hr_flag <= 1'd1;
		end   
		else begin  
			hr_flag <= 1'd0;
		end  
	end //always end
	
	// �жϾ����Ƿ�С��10cm
	always @(posedge Clk or negedge Rst_n)begin  
		if(!Rst_n)begin  
			hr_flag_short <= 1'd0;
		end  
		else if(data_o <= 19'd10_000)begin  
			hr_flag_short <= 1'd1;
		end  
		else begin  
			hr_flag_short <= 1'd0;
		end  
	end //always end
	
	// ��������ʾ��247_847ʱ����ִ������hr_error
//	always @(posedge Clk or negedge Rst_n)begin  
//		if(!Rst_n)begin  
//			hr_error <= 1'd0;
//		end  
//		else if(data_o == 18'd247_847)begin  
//			hr_error <= 1'd1;
//		end  
//		else begin  
//			hr_error <= 1'd0;
//		end  
//	end //always end

endmodule 
