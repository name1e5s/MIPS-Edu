`timescale 1ns / 1ps
`include "alu_op.vh"

module ex_alu(
        input                       clk,
        input                       rst,

        input [5:0]                 alu_op,
        input [31:0]                src_a,
        input [31:0]                src_b,

        output logic [31:0]         result
);

    wire [63:0] 			     hilo       = src_hilo;
    wire [31:0] 			     hi         = hilo[63:32];
    wire [31:0] 			     lo         = hilo[31:0];
    wire [31:0] 			     add_result = src_a + src_b;
    wire [31:0] 			     sub_result = src_a - src_b;

    // Regular operation.
    always_comb begin : alu_operation
        unique case(alu_op)
            `ALU_ADD, `ALU_ADDU:
                result = add_result;
            `ALU_SUB, `ALU_SUBU:
                result = sub_result;
            `ALU_SLT:
                result = $signed(src_a) < $signed(src_b) ? 32'd1 : 32'd0;
            `ALU_SLTU:
                result = src_a < src_b? 32'd1 : 32'd0;
            `ALU_AND:
                result = src_a & src_b;
            `ALU_LUI:
                result = { src_b[15:0], 16'h0000 };
            `ALU_NOR:
                result = ~(src_a | src_b);
            `ALU_OR:
                result = src_a | src_b;
            `ALU_XOR:
                result = src_a ^ src_b;
            `ALU_SLL:
                result = src_b << src_a[4:0];
            `ALU_SRA:
                result = $signed(src_b) >>> src_a[4:0];
            `ALU_SRL:
                result = src_b >> src_a[4:0];
            `ALU_MFHI:
                result = hi;
            `ALU_MFLO:
                result = lo;
            `ALU_OUTA:
                result = src_a;
            `ALU_OUTB:
                result = src_b;
            `ALU_MFC0:
                result = cop0_data;
            `ALU_MTC0:
                result = cop0_addr;
            default:
                result = 32'h0000_0000; // Prevent dcache error
        endcase
    end

    always_comb begin : set_overflow
        unique case (alu_op)
            `ALU_ADD:
                exp_overflow = ((src_a[31] ~^ src_b[31]) & (src_a[31] ^ add_result[31]));
            `ALU_SUB:
                exp_overflow = ((src_a[31]  ^ src_b[31]) & (src_a[31] ^ sub_result[31]));
            default:
                exp_overflow = 1'b0;
        endcase
    end
endmodule
