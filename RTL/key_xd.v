/*================================================*\
		  Filename£ºkey_xd.v
			 Author£ºXuKunyao
	  Description£º°´¼üÏû¶¶
  Target Devices: XC6SLX16-2FTG256-2C
   Tool versions: ISE 14.6(nt64/P.68d) 
  			  Email£º905407267@qq.com
			Company£º
\*================================================*/

module key_xd(
		input clk,
		input rst_n,
		input key_in,
		output reg	key_out
		);
reg	[3:0] curr_st;
reg	[15:0] wait_cnt;
reg	[15:0] key_valid_cnt;
reg		key_in_ff1;
reg		key_in_ff2;
//parameter wait_time=50000;
//parameter key_valid_num=10000;
//for sim
parameter wait_time=20000;
parameter key_valid_num=1000;
parameter IDLE=4'd0,
					START=4'd1,
					WAIT=4'd2,
					KEY_VALID=4'd3,
					FINISH=4'd4;
always@(posedge clk)key_in_ff1<=key_in;
always@(posedge clk)key_in_ff2<=key_in_ff1;
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			curr_st<=IDLE;
		else
			case(curr_st)
				IDLE:
					begin
						if(key_in_ff2==0)
							curr_st<=START;
						else
							;
					end
				START:
					begin
						if(key_in_ff2==1)
							curr_st<=IDLE;
						else if(wait_cnt==wait_time)
							curr_st<=WAIT;
						else
							;
					end
				WAIT:
					begin
						if(key_in_ff2==1)
							curr_st<=IDLE;
						else if(key_in_ff2==0)
							curr_st<=KEY_VALID;
						else
							curr_st<=IDLE;
					end
				KEY_VALID:curr_st<=FINISH;
				FINISH:
					begin
						if(key_in_ff2==1)
							curr_st<=IDLE;
						else
							;
					end
				default:curr_st<=IDLE;
			endcase
	end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				wait_cnt<=0;
			else if(curr_st==START)
				wait_cnt<=wait_cnt+1;
			else
				wait_cnt<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				key_valid_cnt<=0;
			else if(curr_st==KEY_VALID)
				key_valid_cnt<=key_valid_cnt+1;
			else
				key_valid_cnt<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				key_out<=0;
			else if(curr_st==KEY_VALID)
				key_out<=1;
			else
				key_out<=0;
		end
	endmodule
	