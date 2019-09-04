`timescale 1ns / 1ps

module seven_segment(
    input                       clk,
    input                       rst,
    input [15:0]                data,

    output logic [6:0]          seg_a_g,
    output logic [3:0]          seg_sel
);

    logic [1:0] sel;
    logic [3:0] num;

    reg [19:0] count;
    always @(posedge clk) begin
        if(rst) begin
            count <= 20'd0;
        end
        else begin
            count <= count + 1'b1;
        end
    end

    always_comb begin
        unique case(count[19:18])
            2'd0:
                seg_sel = 4'b1000;
            2'd1:
                seg_sel = 4'b0100;
            2'd2:
                seg_sel = 4'b0010;
            2'd3:
                seg_sel = 4'b0001;
            default:
                seg_sel = 4'b0000;
        endcase
    end

    always_comb begin
        unique case(count[19:18])
            2'd0:
                num = data[3:0];
            2'd1:
                num = data[7:4];
            2'd2:
                num = data[11:8];
            2'd3:
                num = data[15:12];
            default:
                num = 4'd8;
        endcase
    end

    always_comb begin
        unique case(num)
            4'd0 : seg_a_g = 7'b1111110;   //0
            4'd1 : seg_a_g = 7'b0110000;   //1
            4'd2 : seg_a_g = 7'b1101101;   //2
            4'd3 : seg_a_g = 7'b1111001;   //3
            4'd4 : seg_a_g = 7'b0110011;   //4
            4'd5 : seg_a_g = 7'b1011011;   //5
            4'd6 : seg_a_g = 7'b1011111;   //6
            4'd7 : seg_a_g = 7'b1110000;   //7
            4'd8 : seg_a_g = 7'b1111111;   //8
            4'd9 : seg_a_g = 7'b1111011;   //9
            4'd10: seg_a_g = 7'b1110111;   //a
            4'd11: seg_a_g = 7'b0011111;   //b
            4'd12: seg_a_g = 7'b1001110;   //c
            4'd13: seg_a_g = 7'b0111101;   //d
            4'd14: seg_a_g = 7'b1001111;   //e
            4'd15: seg_a_g = 7'b1000111;   //f
            default:
                seg_a_g = 7'b0000000;
        endcase
    end

endmodule