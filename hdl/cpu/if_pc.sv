`timescale 1ns / 1ps

module if_pc(
    input                   clk,
    input                   rst,

    input                   pc_en,

    input                   branch_taken,
    input [31:0]            branch_address,

    output logic [31:0]     pc_address
);

    logic [31:0] pc_address_next;

    always_comb begin : generate_next_pc_address
        if(rst) begin
            pc_address_next = 32'hbfc0_0000;
        end
        else if(pc_en) begin
            if(branch_taken)
                pc_address_next = branch_address;
            else
                pc_address_next = pc_address + 32'd4;
        end
        else begin
            pc_address_next = pc_address;
        end
    end

    always_ff @(posedge clk) begin
        pc_address <= pc_address_next;
    end
endmodule