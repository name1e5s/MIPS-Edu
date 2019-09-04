`timescale 1ns / 1ps

`define LED_LO_ADDR         16'h0000    // 1faf0000
`define LED_HI_ADDR         16'h0004    // 1faf0004
`define NUM_ADDR            16'h0008
`define SWITCH_ADDR         16'h000c    
`define SWITCH_DIP_ADDR     16'h0010
`define VUART_ADDR          16'h0014

module confreg(
    input                   clk,
    input                   rst,

    // SRAM-Like Interface
	input                   conf_en,      
	input [3 :0]            conf_wen,      
	input [31:0]            conf_addr,    
	input [31:0]            conf_wdata,   
	output logic [31:0]     conf_rdata,   

    // Read data from board
    input [7:0]             switch,
    input [7:0]             switch_dip,

    // Control devices on board
    output logic [7:0]      led_hi,
    output logic [7:0]      led_lo,

    output logic [6:0]      seg_a_g_0,
    output logic [3:0]      seg_sel_0,

    output logic [6:0]      seg_a_g_1,
    output logic [3:0]      seg_sel_1
);

    reg [31:0]  led_lo_data;
    reg [31:0]  led_hi_data;
    reg [31:0]  num_data;

    assign led_hi = led_hi_data[15:0];
    assign led_lo = led_lo_data[15:0];

    logic [31:0] conf_rdata_next;

    always_ff @(posedge clk) begin
        if(rst) begin
            conf_rdata <= 32'd0;
        end
        else begin
            conf_rdata <= conf_rdata_next;
        end
    end

    always_comb begin
        unique case(conf_addr)
            `LED_LO_ADDR:
                conf_rdata_next = led_lo_data;
            `LED_HI_ADDR:
                conf_rdata_next = led_hi_data;
            `NUM_ADDR:
                conf_rdata_next = num_data;
            `SWITCH_ADDR:
                conf_rdata_next = {24'd0, switch};
            `SWITCH_DIP_ADDR:
                conf_rdata_next = {24'd0, switch_dip};
            default:
                conf_rdata_next = 32'd0;
        endcase
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            led_lo_data <= 32'd0;
            led_hi_data <= 32'd0;
            num_data    <= 32'd0;
        end
        else if(conf_en && conf_wen != 4'd0) begin
            unique case(conf_addr)
            `LED_LO_ADDR:
                led_lo_data <= conf_wdata;
            `LED_HI_ADDR:
                led_hi_data <= conf_wdata;
            `NUM_ADDR:
                num_data    <= conf_wdata;
            endcase
        end
    end

    wire [7:0]  write_uart_data     = conf_wdata[7:0];
    wire        write_uart_valid    = (conf_en && (conf_wen != 4'd0)) & (conf_addr[15:0]==`V_UART_ADDR);

    seven_segment seven_segment_0(
        .clk        (clk),
        .rst        (rst),
        .data       (led_lo_data[15:0]),
        .seg_a_g    (seg_a_g_0),
        .seg_sel    (seg_sel_0)
    );

    seven_segment seven_segment_1(
        .clk        (clk),
        .rst        (rst),
        .data       (led_hi_data[15:0]),
        .seg_a_g    (seg_a_g_1),
        .seg_sel    (seg_sel_1)
    );

endmodule