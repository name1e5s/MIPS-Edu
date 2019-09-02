`timescale 1ns / 1ps

module de_bypass(
    input                   ex_reg_en,
    input  [5:0]            ex_reg_addr,
    input  [31:0]           ex_reg_data,
    input                   mem_reg_en,
    input  [5:0]            mem_reg_addr,
    input  [31:0]           mem_reg_data,
    input  [5:0]            id_reg_addr,
    input  [31:0]           id_reg_data,
    output logic [31:0]     reg_value
);

    always_comb begin : bypass_network
        if(id_reg_addr == 5'd0)
            reg_value = 32'd0;
        else begin
            if(ex_reg_en && ex_reg_addr == id_reg_addr)
                reg_value = ex_reg_data;
            else if(mem_reg_en && mem_reg_addr == id_reg_addr)
                reg_value = mem_reg_data;
            else
                reg_value = id_reg_data;
        end
    end

endmodule