module count(
    //mudule clock
    input                   clk  ,      // ʱ���ź�
    input                   rst_n,      // ��λ�ź�
    
    //user interface
  //  output   reg [ 5:0]     point,    // С�����λ��,�ߵ�ƽ������Ӧ�����λ�ϵ�С����
    output   reg            en   ,      // �����ʹ���ź�
    output   reg            sign        // ����λ���ߵ�ƽʱ��ʾ���ţ��͵�ƽ����ʾ����
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
       // point <= 6'b001000;           //��ʾһλС����
        en    <= 1'b1;                  //�������ʹ���ź�
        sign  <= 1'b0;                  //����ʾ����
    end 
end 

endmodule 