`timescale 1ns / 1ps

module   PS2KB(input  clk, rst,					// clock and reset (active low)
					inout  PS2C, PS2D, 				// ps2 signals from keyboard
					input  rdn,               		// read (active low) signal from cpu
					output reg [7:0] data,        // keyboard code
					output reg ready         		// queue (fifo) state
					);

localparam Idle = 2'b00, Rece = 2'b01, Even = 2'b10, Stop = 2'b11;

reg [9:0] PS2_shift = 10'b1000000000;						//������λ�Ĵ���
reg [1:0]state = 0;												//״̬����
reg [1:0]Fall_Clk;   											// for detecting the falling-edge of a frame
reg Coen=0, Doen=0, PS2Cio, PS2Dio, PS2Co=0,PS2Do=0;
initial begin
Coen=0;
Doen=0;
PS2Co=0;
PS2Do=0;
end

//Tri-state Buffet
	assign PS2C = Coen? PS2Co : 1'bz;
	assign PS2D = Doen? PS2Do : 1'bz;

/*	assign PS2C = PS2Cio;
	assign PS2D = PS2Dio;
	
	
	always @*begin
		if(Coen) PS2Cio = PS2Co; else PS2Co = 1'bz;
		if(Doen) PS2Dio = PS2Do; else PS2Do = 1'bz;
	end
*/	 
	always @ (posedge clk) begin 					  		// this is a common method to
        Fall_Clk <= {Fall_Clk[0],PS2C};    			// detect
	end                                               // falling-edge
	
	always @ (posedge clk) begin
		if(rst)begin
		  PS2_shift <= 10'b1000000000;						//��λ�Ĵ�����ʼ��
		  state <= Idle;
		  ready	<= 0;				
		end else begin
		  if (!rdn && ready) ready <= 0; 
		  else ready <= ready ;
		  
		  case(state)
			Idle: begin
			  PS2_shift <= 10'b1000000000;						//��λ�Ĵ�����ʼ��
			     if((Fall_Clk == 2'b10) && (!PS2D))		//���ֹͣλ
				   state <= Rece;
				else	state <= Idle;				
			end

			Rece: begin
				if(Fall_Clk == 2'b10)begin							//ʱ���½��أ�����PS2D
			  	  if(PS2_shift[0] && PS2D)begin 			//���յ�ֹͣλ
					ready <= {^ PS2_shift [9:1]}; 				//odd prity��Ч��������Ч
					data <= PS2_shift [8:1];						//ɨ���������ݻ�����
					state	 <= Idle;				  					//����һ֡���ݽ���
			  	  end else begin
					PS2_shift <= {PS2D, PS2_shift[9:1]};	//��������Ĵ�������λ��ǰ
					state <= Rece;										//����Rece״̬������һλ
			  	  end
				end else state <= Rece;								//����Rece״̬������һλ
				  
			end
			
		  endcase
		end
	end
	 
endmodule