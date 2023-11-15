module count(
    //mudule clock
    input                   clk  ,      // 时钟信号
    input                   rst_n,      // 复位信号
    
    //user interface
  //  output   reg [ 5:0]     point,    // 小数点的位置,高电平点亮对应数码管位上的小数点
    output   reg            en   ,      // 数码管使能信号
    output   reg            sign        // 符号位，高电平时显示负号，低电平不显示负号
);

//*****************************************************
//**                    main code
//*****************************************************

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n)begin
       // point <=6'b000000;
        en    <= 1'b0;
        sign  <= 1'b0;
    end 
    else begin
       // point <= 6'b001000;           //显示一位小数点
        en    <= 1'b1;                  //打开数码管使能信号
        sign  <= 1'b0;                  //不显示负号
    end 
end 

endmodule 