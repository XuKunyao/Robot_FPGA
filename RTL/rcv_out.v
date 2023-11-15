/*================================================*\
		  Filename：rcv_out.v
			 Author：XuKunyao
	  Description：红外遥控器的按键按下时产生对应不同keyn_io的高电平
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email：905407267@qq.com
			Company：
\*================================================*/

module rcv_out(
    input		  clk,
	 input 		  rst_n,
	 input [7:0]  data ,        //红外控制码
    output   reg key1_io  ,      
    output   reg key2_io   ,    
    output   reg key3_io   ,      
    output   reg key4_io   ,       
    output   reg key5_io   ,

    output   reg key6_io  ,      
    output   reg key7_io   ,    
    output   reg key8_io   ,      
    output   reg key9_io   ,
	 output   reg key10_io  ,
	 output   reg key11_io  ,
	 output   reg sg90_io
	 );

always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		key1_io <= 1'b0;      
		key2_io <= 1'b0;      
		key3_io <= 1'b0;      
		key4_io <= 1'b0;      
		key5_io <= 1'b0;
//		sg90_io <= 1'b0;
		end      
	else if(data == 8'd64)begin
		key1_io <= 1'b1;      
		key2_io <= 1'b0;      
		key3_io <= 1'b0;      
		key4_io <= 1'b0;      
		key5_io <= 1'b0;
		end
	else if(data == 8'd25)begin
		key1_io <= 1'b0;      
		key2_io <= 1'b1;      
		key3_io <= 1'b0;      
		key4_io <= 1'b0;      
		key5_io <= 1'b0;
		end
	else if(data == 8'd7)begin
		key1_io <= 1'b0;      
		key2_io <= 1'b0;      
		key3_io <= 1'b1;      
		key4_io <= 1'b0;      
		key5_io <= 1'b0;
		end
	else if(data == 8'd9)begin
		key1_io <= 1'b0;      
		key2_io <= 1'b0;      
		key3_io <= 1'b0;      
		key4_io <= 1'b1;      
		key5_io <= 1'b0;
		end
	else if(data == 8'd21)begin
		key1_io <= 1'b0;      
		key2_io <= 1'b0;      
		key3_io <= 1'b0;      
		key4_io <= 1'b0;      
		key5_io <= 1'b1;
		end
	else;
	
always@(posedge clk or negedge rst_n)
	if(!rst_n)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b0;      
		key8_io <= 1'b0;      
		key9_io <= 1'b0;
		key10_io <= 1'b0;
		key11_io <= 1'b0;
		end      
	else if(data == 8'd12)begin
		key6_io <= 1'b1;      
		key7_io <= 1'b0;      
		key8_io <= 1'b0;      
		key9_io <= 1'b0;  
		key10_io <= 1'b0;
		key11_io <= 1'b0;		
		end
	else if(data == 8'd24)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b1;      
		key8_io <= 1'b0;      
		key9_io <= 1'b0;    
		key10_io <= 1'b0;
		key11_io <= 1'b0;
		end
	else if(data == 8'd8)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b0;      
		key8_io <= 1'b1;      
		key9_io <= 1'b0;  
		key10_io <= 1'b0;
		key11_io <= 1'b0;		
		end
	else if(data == 8'd28)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b0;      
		key8_io <= 1'b0;      
		key9_io <= 1'b1; 
		key10_io <= 1'b0;
		key11_io <= 1'b0;		
		end
	else if(data == 8'd66)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b0;      
		key8_io <= 1'b0;      
		key9_io <= 1'b0; 
		key10_io <= 1'b1;
		key11_io <= 1'b0;		
		end
	else if(data == 8'd82)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b0;      
		key8_io <= 1'b0;      
		key9_io <= 1'b0; 
		key10_io <= 1'b0;
		key11_io <= 1'b1;		
		end
	else if(data == 8'd13)begin
		key6_io <= 1'b0;      
		key7_io <= 1'b0;      
		key8_io <= 1'b0;      
		key9_io <= 1'b0;   
		key10_io <= 1'b0;
		key11_io <= 1'b0;		
		end
	else if(data == 8'd69)begin
		sg90_io <= ~sg90_io;      
		end
	else;

endmodule
