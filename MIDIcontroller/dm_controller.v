`define dm_word             3'b000
`define dm_halfword         3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte             3'b011
`define dm_byte_unsigned     3'b100

module dm_controller(
    input         mem_w,              
    input  [31:0] Addr_in,            
    input  [31:0] Data_write,        
    input  [2:0]  dm_ctrl,            
    input  [31:0] Data_read_from_dm,  
    output reg [31:0] Data_read,      
    output reg [31:0] Data_write_to_dm, 
    output reg [3:0]  wea_mem        
);


    always @(*) begin
        case (dm_ctrl)
            `dm_word: 
                Data_read = Data_read_from_dm;
            `dm_halfword: 
                Data_read = Addr_in[1]?{{16{Data_read_from_dm[31]}}, Data_read_from_dm[31:16]} 
                                       : {{16{Data_read_from_dm[15]}}, Data_read_from_dm[15:0]};           
            `dm_halfword_unsigned:
                Data_read = Addr_in[1] ? {16'b0, Data_read_from_dm[31:16]} 
                                       : {16'b0, Data_read_from_dm[15:0]};          
            `dm_byte: 
                case (Addr_in[1:0])
                    2'b00: Data_read = {{24{Data_read_from_dm[7]}},  Data_read_from_dm[7:0]};
                    2'b01: Data_read = {{24{Data_read_from_dm[15]}}, Data_read_from_dm[15:8]};
                    2'b10: Data_read = {{24{Data_read_from_dm[23]}}, Data_read_from_dm[23:16]};
                    2'b11: Data_read = {{24{Data_read_from_dm[31]}}, Data_read_from_dm[31:24]};
                    default: Data_read = 32'b0;
                endcase
            `dm_byte_unsigned: 
                case (Addr_in[1:0])
                    2'b00: Data_read = {24'b0, Data_read_from_dm[7:0]};
                    2'b01: Data_read = {24'b0, Data_read_from_dm[15:8]};
                    2'b10: Data_read = {24'b0, Data_read_from_dm[23:16]};
                    2'b11: Data_read = {24'b0, Data_read_from_dm[31:24]};
                    default: Data_read = 32'b0;
                endcase
            
            default: Data_read = 32'b0;
        endcase
    end

    always @(*) begin
        wea_mem = 4'b0000;
        Data_write_to_dm = 32'b0;
        
        if (mem_w) begin
            case (dm_ctrl)
                `dm_word: begin
                    wea_mem = 4'b1111;
                    Data_write_to_dm = Data_write;
                end
                
                `dm_halfword, `dm_halfword_unsigned: begin
                    wea_mem = Addr_in[1] ? 4'b1100 : 4'b0011;
                    Data_write_to_dm = {2{Data_write[15:0]}}; // 高低无所谓，用weamem区分
                end
                
                `dm_byte, `dm_byte_unsigned: begin
                    Data_write_to_dm = {4{Data_write[7:0]}}; 
                    case (Addr_in[1:0])
                        2'b00: wea_mem = 4'b0001;
                        2'b01: wea_mem = 4'b0010;
                        2'b10: wea_mem = 4'b0100;
                        2'b11: wea_mem = 4'b1000;
                        default: wea_mem = 4'b0000;
                    endcase
                end
                default: wea_mem = 4'b0000;
            endcase
        end
    end

endmodule