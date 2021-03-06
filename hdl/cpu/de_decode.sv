`timescale 1ns / 1ps

`include "common.vh"
`include "alu_op.vh"

module de_decode(
        input [31:0]				instruction,
        input [5:0]                 opcode,
        input [4:0]                 rt,
        input [4:0]                 rd,
        input [5:0]                 funct,
        input                       is_branch,
        input                       is_branch_link,

        output logic				undefined_inst, // 1 as received a unknown operation.
        output logic [5:0]	 		alu_op,         // ALU operation code
        output logic [1:0] 			alu_src,        // ALU oprand 2 source(0 as rt, 1 as immed)
        output logic       			alu_imm_src,    // ALU immediate number source - 1 as unsigned, 0 as signed.
        output logic [1:0] 			mem_type,       // Memory operation type -- load / store
        output logic [2:0] 			mem_size,       // Memory operation size -- B,H,W
        output logic [4:0] 			wb_reg_dest,    // Destination register address
        output logic       			wb_reg_en,      // Writeback is enabled
        output logic       			unsigned_flag,  // Is this a unsigned operation in MEM stage.
        output logic                priv_inst       // Is this instruction a privileged inst?
);

    // Control logic.
    always_comb begin : decoder_logic
        // To prevent latch...
        undefined_inst  = 1'b0;
        priv_inst       = 1'b0;
        alu_op          = `ALU_ADDU;
        alu_src         = 2'd0;
        alu_imm_src     = 1'd1;
        mem_type        = `MEM_NOOP;
        mem_size        = `SZ_FULL;
        wb_reg_dest     = 5'd0;
        wb_reg_en       = 1'd0;
        unsigned_flag   = 1'd0;
        casex({opcode, funct})
            {6'b000000, 6'b100000}: // ADD
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADD, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001000, 6'bxxxxxx}: // ADDI
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADD, `SRC_IMM, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100001}: // ADDU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001001, 6'bxxxxxx}: // ADDIU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100010}: // SUB
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SUB, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100011}: // SUBU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SUBU, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b101010}: // SLT
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SLT, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001010, 6'bxxxxxx}: // SLTI
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SLT, `SRC_IMM, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b101011}: // SLTU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SLTU, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001011, 6'bxxxxxx}: // SLTIU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SLTU, `SRC_IMM, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100100}: // AND
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_AND, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001100, 6'bxxxxxx}: // ANDI
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_AND, `SRC_IMM, `ZERO_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b001111, 6'bxxxxxx}: // LUI
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_LUI, `SRC_IMM, `ZERO_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100111}: // NOR
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_NOR, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100101}: // OR
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_OR, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001101, 6'bxxxxxx}: // ORI
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_OR, `SRC_IMM, `ZERO_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b100110}: // XOR
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_XOR, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b001110, 6'bxxxxxx}: // XORI
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_XOR, `SRC_IMM, `ZERO_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b000100}: // SLLV
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SLL, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b000000}: // SLL
                 {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SLL, `SRC_SFT, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b000111}: // SRAV
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SRA, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b000011}: // SRA
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SRA, `SRC_SFT, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b000110}: // SRLV
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SRL, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b000000, 6'b000010}: // SRL
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_SRL, `SRC_SFT, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rd, 1'b1, `ZERO_EXTENDED};
            {6'b100000, 6'bxxxxxx}: // LB
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_LOAD, `SZ_BYTE, rt, 1'b1, `SIGN_EXTENDED};
            {6'b100100, 6'bxxxxxx}: // LBU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_LOAD, `SZ_BYTE, rt, 1'b1, `ZERO_EXTENDED};
            {6'b100001, 6'bxxxxxx}: // LH
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_LOAD, `SZ_HALF, rt, 1'b1, `SIGN_EXTENDED};
            {6'b100101, 6'bxxxxxx}: // LHU
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_LOAD, `SZ_HALF, rt, 1'b1, `ZERO_EXTENDED};
            {6'b100011, 6'bxxxxxx}: // LW
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_LOAD, `SZ_FULL, rt, 1'b1, `ZERO_EXTENDED};
            {6'b101000, 6'bxxxxxx}: // SB
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_STOR, `SZ_BYTE, rt, 1'b0, `SIGN_EXTENDED};
            {6'b101001, 6'bxxxxxx}: // SH
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_STOR, `SZ_HALF, rt, 1'b0, `SIGN_EXTENDED};
            {6'b101011, 6'bxxxxxx}: // SW
                {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                    {`ALU_ADDU, `SRC_IMM, `SIGN_EXTENDED, `MEM_STOR, `SZ_FULL, rt, 1'b0, `ZERO_EXTENDED};
            default: begin
                if(is_branch && is_branch_link)
                    {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                        {`ALU_OUTA, `SRC_PCA, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, 5'd31, 1'b1, `ZERO_EXTENDED};
                else begin
                    undefined_inst = ~is_branch;
                    {alu_op, alu_src, alu_imm_src, mem_type, mem_size, wb_reg_dest, wb_reg_en, unsigned_flag} = 
                        {`ALU_ADDU, `SRC_REG, `SIGN_EXTENDED, `MEM_NOOP, `SZ_FULL, rt, 1'b0, `ZERO_EXTENDED};
                end
            end
        endcase
    end
endmodule
