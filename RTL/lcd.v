/*================================================*\
		  Filename：lcd.v
			 Author：XuKunyao
	  Description：lcd显示模块
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module lcd ( 
	input 						clk		,//系统时钟输入50M
	input							rst_n		,//复位，低电平有效
	input				[7:0]		tempH		,//温度数据整数
	input				[7:0]		tempL		,//温度数据小数
	input				[7:0]		humidityH,//温度数据整数
	input				[7:0]		humidityL,//温度数据小数
	input							gas_signal,//有害气体数据
	input				[1:0]		shake_signal,//震动数据
 	output	reg	[7:0] 	dat		,//LCD的8位数据口
 	output	reg				rs			,//数据命令选择信号，高电平表示数据，低电平表示命令
 	output						rw			,//读写标志，高电平表示读，低电平表示写，该程序我们只对液晶屏进行写操作
 	output						en			 //LCD的控制脚
 );
 reg	[15:0]	counter		; 
 reg 	[ 5:0] 	current		; 
 reg				clkr			; 
 reg				e				;
 wire	[7:0]		temp0,temp1	;
 wire	[7:0]		humi0,humi1	;
 wire	[7:0] 	gas			;
 wire	[7:0]		shake			;
 
 //定义了LCD状态机需要的状态。
 parameter  set0 =6'd0; 
 parameter  set1 =6'd1; 
 parameter  set2 =6'd2; 
 parameter  set3 =6'd3; 
 parameter  set4 =6'd4;   
 parameter  dat0 =6'd5; 
 parameter  dat1 =6'd6; 
 parameter  dat2 =6'd7; 
 parameter  dat3 =6'd8; 
 parameter  dat4 =6'd9; 
 parameter  dat5 =6'd10;
 parameter  dat6 =6'd11; 
 parameter  dat7 =6'd12; 
 parameter  dat8 =6'd13; 
 parameter  dat9 =6'd14;
 parameter  dat10=6'd15; 
 parameter  dat11=6'd16;
 parameter	dat12=6'd17;  
 parameter	dat13=6'd18; 
 parameter	dat14=6'd19; 
 parameter	dat15=6'd20; 
 parameter	dat16=6'd21; 
 parameter	dat17=6'd22; 
 parameter	dat18=6'd23; 
 parameter  dat19 =6'd24; 
 parameter  dat20 =6'd25; 
 parameter  dat21 =6'd26; 
 parameter  dat22 =6'd27;
 parameter  dat23=6'd28; 
 parameter  dat24=6'd29;
 parameter	dat25=6'd30;  
 parameter	dat26=6'd31; 
 parameter	dat27=6'd32; 
 parameter	dat28=6'd33; 
 parameter	dat29=6'd34; 
 parameter	dat30=6'd35; 
 parameter  fini=6'hF1; 
 
assign temp0 = 8'h30 + tempH % 8'd10;    		// 个位,要在原有十六基础上加8'h30     
assign temp1 = 8'h30 + tempH / 4'd10 % 8'd10;// 十位;

assign humi0 = 8'h30 + humidityH % 8'd10;    // 个位     
assign humi1 = 8'h30 + humidityH / 4'd10 % 8'd10;   // 十位;

assign gas = 8'h30 + gas_signal;//气体
assign shake = 8'h30 + shake_signal;//震动

always @(posedge clk or negedge rst_n)         //da de data_w1 zhong pinlv 
 begin 
 	if(!rst_n)
 		begin
 			counter<=0;
 			clkr<=0;
 		end
 	else
 		begin
  			counter<=counter+1; 
  			if(counter==16'h0011)  
  				clkr<=~clkr; 
  			else
  				;
  		end
end 
always @(posedge clkr or negedge rst_n) 
begin 
	if(!rst_n)
		begin
			current<=set0;
			dat<=0;
			rs<=0;
			e<=1;
		end
	else
		begin
  			case(current) 
    		set0:   begin  e<=0;rs<=0; dat<=8'h38	; 	current<=set1; 		end //*设置8位格式,2行,5*7*
    		set1:   begin  e<=0;rs<=0; dat<=8'h0C	; 	current<=set2; 		end //*整体显示,关光标,不闪烁*/  
    		set2:   begin  e<=0;rs<=0; dat<=8'h06	; 	current<=set3; 		end //*设定输入方式,增量不移位*/  
    		set3:   begin  e<=0;rs<=0; dat<=8'h01	; 	current<=set4; 		end //*清除显示*/   
			set4:   begin  e<=0;rs<=0; dat<=8'h80	; 	current<=dat0; 		end //设置显示第一行
    		dat0:   begin  e<=0;rs<=1; dat<="T"		; 	current<=dat1; 		end    
    		dat1:   begin  e<=0;rs<=1; dat<="e"		; 	current<=dat2; 		end 
    		dat2:   begin  e<=0;rs<=1; dat<="m"		; 	current<=dat3; 		end 
    		dat3:   begin  e<=0;rs<=1; dat<="p"		;	current<=dat4; 		end 
    		dat4:   begin  e<=0;rs<=1; dat<=":"		; 	current<=dat5; 		end 
    		dat5:   begin  e<=0;rs<=1; dat<=" "		; 	current<=dat6; 		end 
    		dat6:   begin  e<=0;rs<=1; dat<=temp1	; 	current<=dat7; 		end 
    		dat7:   begin  e<=0;rs<=1; dat<=temp0	;	current<=dat8; 		end 
    		dat8:   begin  e<=0;rs<=1; dat<="C"		;	current<=dat9; 		end 
    		dat9:   begin  e<=0;rs<=1; dat<=" "		;	current<=dat10; 		end 
    		dat10:  begin  e<=0;rs<=1; dat<="G"		;	current<=dat11; 		end 
    		dat11:  begin  e<=0;rs<=1; dat<="a"		;	current<=dat12; 		end 
    		dat12:  begin  e<=0;rs<=1; dat<="s"		;	current<=dat13; 		end 
    		dat13:  begin  e<=0;rs<=1; dat<=":"		;	current<=dat14; 		end 
    		dat14:  begin  e<=0;rs<=1; dat<=gas		;	current<=dat15; 		end 
			dat15:  begin  e<=0;rs<=0; dat<=8'hC0	; 	current<=dat16; 		end //设置显示第二行
    		dat16:  begin  e<=0;rs<=1; dat<="H" 	; 	current<=dat17; 		end    
    		dat17:  begin  e<=0;rs<=1; dat<="u"		; 	current<=dat18; 		end 
    		dat18:  begin  e<=0;rs<=1; dat<="m"		; 	current<=dat19; 		end 
    		dat19:  begin  e<=0;rs<=1; dat<="i"		;	current<=dat20; 		end 
    		dat20:  begin  e<=0;rs<=1; dat<=":"		; 	current<=dat21; 		end 
    		dat21:  begin  e<=0;rs<=1; dat<=" "		; 	current<=dat22; 		end 
    		dat22:  begin  e<=0;rs<=1; dat<=humi1	; 	current<=dat23; 		end 
    		dat23:  begin  e<=0;rs<=1; dat<=humi0	;	current<=dat24;  		end 
    		dat24:  begin  e<=0;rs<=1; dat<="%"		;	current<=dat25; 		end 
    		dat25:   begin  e<=0;rs<=1; dat<=" "	;	current<=dat26; 		end 
    		dat26:  begin  e<=0;rs<=1; dat<="M"		;	current<=dat27; 		end 
    		dat27:  begin  e<=0;rs<=1; dat<="D"		;	current<=dat28; 		end 
    		dat28:  begin  e<=0;rs<=1; dat<=" "		;	current<=dat29; 		end 
    		dat29:  begin  e<=0;rs<=1; dat<=":"		;	current<=dat30; 		end 
    		dat30:  begin  e<=0;rs<=1; dat<=shake	;	current<=set4; 		end 
//    		fini:   begin  e<=1;rs<=0; dat<=8'h00;       				end
   			default:   current<=set0; 
    		endcase 
    	end
 end 

assign en=clkr|e; 
assign rw=0; 

endmodule  