module mycpu_top(
    input                   clk,
    input                   resetn,
    input  [5:0]            int,

    output                  inst_sram_en,
    output [3:0]            inst_sram_wen,
    output [31:0]           inst_sram_addr,
    output [31:0]           inst_sram_wdata,
    input  [31:0]           inst_sram_rdata,

    output                  data_sram_en,
    output [3:0]            data_sram_wen,
    output [31:0]           data_sram_addr,
    output [31:0]           data_sram_wdata,
    input  [31:0]           data_sram_rdata,

    output                  debug_wb_pc,
    output                  debug_wb_rf_wen,
    output                  debug_wb_rf_wnum,
    output                  debug_wb_rf_wdata
);

    assign inst_sram_en     = 1'd1;
    assign inst_sram_wen    = 4'd0;
    assign inst_sram_wdata  = 32'd0;

    cpu_top cpu(
        .clk                (clk),
        .rst                (~resetn),
        .inst_addr          (inst_sram_addr),
        .inst_data          (inst_sram_rdata),
        .data_en            (data_sram_en),
        .data_wen           (data_sram_wen),
        .data_addr          (data_sram_addr),
        .data_wdata         (data_sram_wdata),
        .data_rdata         (data_sram_rdata)
    );

endmodule