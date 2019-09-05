`timescale 1ns / 1ps

module ram_wrapper(
    input                   clk,
    input                   rst,

    input [31:0]            inst_addr,
    output logic [31:0]     inst_data,

    input                   data_en,
    input [3:0]             data_wen,
    input [31:0]            data_addr,
    input [31:0]            data_wdata,
    output logic [31:0]     data_rdata
);

    blk_mem_gen_ram ram_impl(
        .addra              (data_addr[16:2]),
        .clka               (clk),
        .dina               (data_wdata),
        .douta              (data_rdata),
        .ena                (data_en),
        .wea                (data_wen),
        
        .addrb              (inst_addr[16:2]),
        .clkb               (clk),
        .dinb               (32'd0),
        .doutb              (inst_data),
        .enb                (1'd1),
        .web                (4'd0)
    );

endmodule