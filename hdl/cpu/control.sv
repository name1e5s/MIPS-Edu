`timescale 1ns / 1ps
`include "common.vh"

module control(
    input [4:0]                 id_rs,
    input [4:0]                 id_rt,

    input [4:0]                 ex_reg_dest,
    input                       ex_mem_type,

    input                       mem_stall,

    output logic                if_id_en,
    output logic                id_ex_en,
    output logic                ex_mem_en,
    output logic                mem_wb_en
);

    logic [3:0] en;
    logic load_use_hazard;

    assign { if_id_en, id_ex_en, ex_mem_en, mem_wb_en } = en;

    always_comb begin : generate_enable_signals
        if(mem_stall)
            en = 4'b0000;
        else if(load_use_hazard)
            en = 4'b0011;
        else 
            en = 4'b1111;
    end

    always_comb begin : detect_load_use_hazard
        load_use_hazard = 1'd0;
        if(ex_mem_type == `MEM_LOAD &&
           (ex_reg_dest == id_rs || ex_reg_dest == id_rt))
            load_use_hazard = 1'd1;
    end

endmodule