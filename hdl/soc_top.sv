`timescale 1ns / 1ps

module soc_top(
    input                   clk,
    input                   rst,

    input [7:0]             switch,
    input [7:0]             switch_dip,

    output logic [7:0]      led_hi,
    output logic [7:0]      led_lo,

    output logic [6:0]      seg_a_g_0,
    output logic [3:0]      seg_sel_0,

    output logic [6:0]      seg_a_g_1,
    output logic [3:0]      seg_sel_1
);
    wire real_clk;

    clk_wiz0 clk_wiz(
        .clk_in1        (clk),
        .clk_out1       (real_clk)
    );

    wire [31:0]         cpu_inst_addr;
    wire [31:0]         cpu_inst_data;

    wire                cpu_data_en;
    wire [3:0]          cpu_data_wen;
    wire [31:0]         cpu_data_addr;
    wire [31:0]         cpu_data_wdata;
    wire [31:0]         cpu_data_rdata;

    cpu_top cpu(
        .clk            (real_clk),
        .rst            (rst),
        .inst_addr      (cpu_inst_addr),
        .inst_data      (cpu_inst_data),
        .data_en        (cpu_data_en),
        .data_wen       (cpu_data_wen),
        .data_addr      (cpu_data_addr),
        .data_wdata     (cpu_data_wdata),
        .data_rdata     (cpu_data_rdata)
    );

    wire                conf_en;     
	wire [3:0]          conf_wen;     
	wire [31:0]         conf_addr;   
	wire [31:0]         conf_wdata;   
	wire [31:0]         conf_rdata;

    wire                data_en;     
	wire [3:0]          data_wen;     
	wire [31:0]         data_addr;   
	wire [31:0]         data_wdata;   
	wire [31:0]         data_rdata;

    bridge bridge_0(
        .clk            (real_clk),
        .rst            (rst),
        .bridge_en      (cpu_data_en),
        .bridge_wen     (cpu_data_wen),
        .bridge_addr    (cpu_data_addr),
        .bridge_wdata   (cpu_data_wdata),
        .bridge_rdata   (cpu_data_rdata),
        .conf_en        (conf_en),
        .conf_wen       (conf_wen),
        .conf_addr      (conf_addr),
        .conf_wdata     (conf_wdata),
        .conf_rdata     (conf_rdata),
        .data_en        (data_en),
        .data_wen       (data_wen),
        .data_addr      (data_addr),
        .data_wdata     (data_wdata),
        .data_rdata     (data_rdata)
    );

    confreg confreg_0(
        .clk            (real_clk),
        .rst            (rst),
        .conf_en        (conf_en),
        .conf_wen       (conf_wen),
        .conf_addr      (conf_addr),
        .conf_wdata     (conf_wdata),
        .conf_rdata     (conf_rdata),
        .switch         (switch),
        .switch_dip     (switch_dip),
        .led_hi         (led_hi),
        .led_lo         (led_lo),
        .seg_a_g_0      (seg_a_g_0),
        .seg_sel_0      (seg_sel_0),
        .seg_a_g_1      (seg_a_g_1),
        .seg_sel_1      (seg_sel_1)
    );

endmodule