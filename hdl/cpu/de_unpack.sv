`timescale 1ns / 1ps

module de_unpack(
        input [31:0]                instruction,

        output logic [5:0]          opcode,
        output logic [4:0]          rs,
        output logic [4:0]          rt,
        output logic [4:0]          rd,
        output logic [4:0]          shamt,
        output logic [5:0]          funct,
        output logic [15:0]         immed,

        output logic [2:0]          branch_type,
        output logic                is_branch,
        output logic                is_branch_link
);

    assign opcode       = instruction[31:26];
    assign rs           = instruction[25:21];
    assign rt           = instruction[20:16];
    assign rd           = instruction[15:11];
    assign shamt        = instruction[10:6];
    assign funct        = instruction[5:0];
    assign immed        = instruction[15:0];

    // Check if the instruction is a branch/jump function
    always_comb begin
        //BEQ, BNE, BLEZ and BGTZ live here
        if(opcode[5:2] == 4'b0001) begin
            is_branch = 1'b1;
            branch_type = `B_EQNE;
            is_branch_link = 1'b0;
        // BLTZ, BGEZ, BLTZL, BGEZL lives here, but we
        // don't care those branch-likely instructions
        end
        else if(opcode == 6'b000001 && rt[3:1] == 3'b000) begin
            is_branch = 1'b1;
            branch_type = `B_LTGE;
            is_branch_link = rt[4];
        // J, JAL is here
        end
        else if(opcode[5:1] == 5'b00001) begin
            is_branch = 1'b1;
            branch_type = `B_JUMP;
            is_branch_link = opcode[0];
        //  JR, JALR is here
        end
        else if(opcode == 6'b000000 && funct[5:1] == 5'b00100) begin
            is_branch = 1'b1;
            branch_type = `B_JREG;
            is_branch_link = funct[0];
        end
        else begin
            is_branch = 1'b0;
            branch_type = `B_INVA;
            is_branch_link = 1'b0;
        end
    end
endmodule