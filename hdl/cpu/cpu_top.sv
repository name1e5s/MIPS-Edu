module cpu_top(
    input                   clk,
    input                   rst,

    output logic [31:0]     inst_addr,
    input  [31:0]           inst_data,

    output logic            data_en,
    output logic [3:0]      data_wen,
    output logic [31:0]     data_addr,
    output logic [31:0]     data_wdata,
    input [31:0]            data_rdata
);

    // CONTROL SIGNALS
    wire        if_id_en, id_ex_en, ex_mem_en, mem_wb_en;

    // IF SIGNALS
    wire [31:0] if_pc_address;

    // ID SIGNALS
    wire [5:0]  id_opcode;
    wire [4:0]  id_rs, id_rt, id_rd, id_shamt;
    wire [5:0]  id_funct;
    wire [15:0] id_immed;
    wire [2:0]  id_branch_type;
    wire        id_is_branch;
    wire        id_is_branch_link;

    wire        id_undefined_inst;
    wire [5:0]  id_alu_op;
    wire [1:0]  id_alu_src;
    wire        id_alu_imm_src;
    wire [1:0]  id_mem_type;
    wire [2:0]  id_mem_size;
    wire [4:0]  id_wb_reg_dest;
    wire        id_wb_reg_en;
    wire        id_unsigned_flag;
    wire        id_priv_inst;

    wire        id_branch_taken;
    wire [31:0] id_branch_address;

    wire [31:0] id_rs_value_raw;
    wire [31:0] id_rt_value_raw;
    wire [31:0] id_rs_value;
    wire [31:0] id_rt_value;

    logic[31:0] id_alu_src_a;
    logic[31:0] id_alu_src_b;

    // EX SIGNALS
    wire [7:0]  ex_cop0_addr;
    wire        ex_cop0_wen;
    wire        ex_exp_overflow;
    wire        ex_exp_eret;
    wire        ex_exp_syscall;
    wire        ex_exp_break;
    wire        ex_hilo_wen;
    wire [63:0] ex_hilo_result;
    wire [31:0] ex_result;
    wire        ex_stall_o;

    wire [63:0] ex_hilo_value;

    // MEM SIGNALS
    wire [31:0] mem_result;
    wire        mem_stall;

    // WB SIGNALS
    wire        wb_wen;
    wire [4:0]  wb_dest;
    wire [31:0] wb_wdata;

    // IF-ID REGISTERS
    reg  [31:0] if_id_pc_address;

    // ID-EX REGISTERS
    reg  [31:0] id_ex_pc_address;

    reg  [4:0]  id_ex_rt;

    reg         id_ex_is_branch_link;

    reg  [5:0]  id_ex_alu_op;
    reg  [1:0]  id_ex_mem_type;
    reg  [2:0]  id_ex_mem_size;
    reg  [4:0]  id_ex_wb_reg_dest;
    reg         id_ex_wb_reg_en;
    reg         id_ex_unsigned_flag;

    reg  [31:0] id_ex_alu_src_a;
    reg  [31:0] id_ex_alu_src_b;

    reg  [31:0] id_ex_rt_value;

    // EX-MEM REGISTERS
    reg  [31:0] ex_mem_pc_address;

    reg         ex_mem_is_branch_link;

    reg  [1:0]  ex_mem_mem_type;
    reg  [2:0]  ex_mem_mem_size;
    reg  [4:0]  ex_mem_wb_reg_dest;
    reg         ex_mem_wb_reg_en;
    reg         ex_mem_unsigned_flag;

    reg  [31:0] ex_mem_result;
    reg  [31:0] ex_mem_rt_value;

    // MEM-WB REGISTERS
    reg  [31:0] mem_wb_pc_address;
    reg  [31:0] mem_wb_result;

    reg  [4:0]  mem_wb_reg_dest;
    reg         mem_wb_reg_en;

    reg         mem_wb_is_branch_link;

    // OUTPUT SIGNAL
    assign inst_addr = if_id_en? if_pc_address : if_id_pc_address;

    control control(
        .id_rs              (id_rs),
        .id_rt              (id_rt),
        .ex_reg_dest        (id_ex_wb_reg_dest),
        .ex_mem_type        (id_ex_mem_type),
        .mem_stall          (mem_stall),
        .if_id_en           (if_id_en),
        .id_ex_en           (id_ex_en),
        .ex_mem_en          (ex_mem_en),
        .mem_wb_en          (mem_wb_en)
    );

    register_file register_file(
        .clk                (clk),
        .rst                (rst),
        .raddr_a            (id_rs),
        .rdata_a            (id_rs_value_raw),
        .raddr_b            (id_rt),
        .rdata_b            (id_rt_value_raw),
        .wen                (wb_wen),
        .waddr              (wb_dest),
        .wdata              (wb_wdata)
    );

    if_pc if_pc(
        .clk                (clk),
        .rst                (rst),
        .pc_en              (if_id_en),
        .branch_taken       (id_branch_taken),
        .branch_address     (id_branch_address),
        .pc_address         (if_pc_address)
    );

    always_ff @(posedge clk) begin : if_id
        if(rst) begin
            if_id_pc_address <= 32'd0;
        end
        else if(if_id_en) begin
            if_id_pc_address <= if_pc_address;
        end
    end

    de_unpack de_unpack(
        .instruction        (inst_data),
        .opcode             (id_opcode),
        .rs                 (id_rs),
        .rt                 (id_rt),
        .rd                 (id_rd),
        .shamt              (id_shamt),
        .funct              (id_funct),
        .immed              (id_immed),
        .branch_type        (id_branch_type),
        .is_branch          (id_is_branch),
        .is_branch_link     (id_is_branch_link)
    );

    de_decode de_decode(
        .instruction        (inst_data),
        .opcode             (id_opcode),
        .rt                 (id_rt),
        .rd                 (id_rd),
        .funct              (id_funct),
        .is_branch          (id_is_branch),
        .is_branch_link     (id_is_branch_link),
        .undefined_inst     (id_undefined_inst),
        .alu_op             (id_alu_op),
        .alu_src            (id_alu_src),
        .alu_imm_src        (id_alu_imm_src),
        .mem_type           (id_mem_type),
        .mem_size           (id_mem_size),
        .wb_reg_dest        (id_wb_reg_dest),
        .wb_reg_en          (id_wb_reg_en),
        .unsigned_flag      (id_unsigned_flag),
        .priv_inst          (id_priv_inst)
    );

    de_bypass de_bypass_rs(
        .ex_reg_en          (id_ex_wb_reg_en),
        .ex_reg_addr        (id_ex_wb_reg_dest),
        .ex_reg_data        (ex_result),
        .mem_reg_en         (ex_mem_wb_reg_en),
        .mem_reg_addr       (ex_mem_wb_reg_dest),
        .mem_reg_data       (mem_result),
        .id_reg_addr        (id_rs),
        .id_reg_data        (id_rs_value_raw),
        .reg_value          (id_rs_value)
    );

    de_bypass de_bypass_rt(
        .ex_reg_en          (id_ex_wb_reg_en),
        .ex_reg_addr        (id_ex_wb_reg_dest),
        .ex_reg_data        (ex_result),
        .mem_reg_en         (ex_mem_wb_reg_en),
        .mem_reg_addr       (ex_mem_wb_reg_dest),
        .mem_reg_data       (mem_result),
        .id_reg_addr        (id_rt),
        .id_reg_data        (id_rt_value_raw),
        .reg_value          (id_rt_value)
    );

    // Branch Unit
    de_branch_unit de_branch_unit(
        .pc_address         (if_id_pc_address),
        .instruction        (inst_data),
        .is_branch_instr    (id_is_branch),
        .branch_type        (id_branch_type),
        .data_rs            (id_rs_value),
        .data_rt            (id_rt_value),
        .branch_taken       (id_branch_taken),
        .branch_address     (id_branch_address)
    );

    // Get alu sources
    always_comb begin : get_alu_src_a
        if(id_alu_src == `SRC_SFT)
            id_alu_src_a = { 27'd0 ,id_shamt};
        else if(id_alu_src == `SRC_PCA)
            id_alu_src_a = if_id_pc_address + 32'd8;
        else
            id_alu_src_a = id_rs_value;
    end

    always_comb begin: get_alu_src_b
        unique case(id_alu_src)
            `SRC_IMM: begin
            if(id_alu_imm_src)
                id_alu_src_b = { 16'd0, id_immed };
            else
                id_alu_src_b = { {16{id_immed[15]}}, id_immed};
            end
            default:
                id_alu_src_b = id_rt_value;
        endcase
    end

    always_ff @(posedge clk) begin : id_ex
        if(rst || (!id_ex_en && ex_mem_en)) begin
            id_ex_pc_address    <= 32'd0;
            id_ex_rt            <= 5'd0;
            id_ex_alu_op        <= 6'd0;
            id_ex_mem_type      <= `MEM_NOOP;
            id_ex_mem_size      <= `SZ_FULL;
            id_ex_wb_reg_dest   <= 5'd0;
            id_ex_wb_reg_en     <= 1'd0;
            id_ex_unsigned_flag <= 1'd0;
            id_ex_alu_src_a     <= 32'd0;
            id_ex_alu_src_b     <= 32'd0;
            id_ex_is_branch_link<= 1'd0;
            id_ex_rt_value      <= 32'd0;
        end
        else if(id_ex_en) begin
            id_ex_pc_address    <= if_id_pc_address;
            id_ex_rt            <= id_rt;
            id_ex_alu_op        <= id_alu_op;
            id_ex_mem_type      <= id_mem_type;
            id_ex_mem_size      <= id_mem_size;
            id_ex_wb_reg_dest   <= id_wb_reg_dest;
            id_ex_wb_reg_en     <= id_wb_reg_en;
            id_ex_unsigned_flag <= id_unsigned_flag;
            id_ex_alu_src_a     <= id_alu_src_a;
            id_ex_alu_src_b     <= id_alu_src_b;
            id_ex_is_branch_link<= id_is_branch_link;
            id_ex_rt_value      <= id_rt_value;
        end
    end

    ex_alu ex_alu(
        .clk                    (clk),
        .rst                    (rst),
        .alu_op                 (id_ex_alu_op),
        .src_a                  (id_ex_alu_src_a),
        .src_b                  (id_ex_alu_src_b),
        .result                 (ex_result)
    );

    always_ff @(posedge clk) begin : ex_mem
        if(rst || (!ex_mem_en && mem_wb_en)) begin
            ex_mem_pc_address       <= 32'd0;
            ex_mem_is_branch_link   <= 1'd0;
            ex_mem_mem_type         <= `MEM_NOOP;
            ex_mem_mem_size         <= `SZ_FULL;
            ex_mem_wb_reg_dest      <= 5'd0;
            ex_mem_wb_reg_en        <= 1'd0;
            ex_mem_unsigned_flag    <= 1'd0;
            ex_mem_result           <= 32'd0;
            ex_mem_rt_value         <= 32'd0;
        end
        else if(ex_mem_en) begin
            ex_mem_pc_address       <= id_ex_pc_address;
            ex_mem_is_branch_link   <= id_ex_is_branch_link;
            ex_mem_mem_type         <= id_ex_mem_type;
            ex_mem_mem_size         <= id_ex_mem_size;
            ex_mem_wb_reg_dest      <= id_ex_wb_reg_dest;
            ex_mem_wb_reg_en        <= id_ex_wb_reg_en;
            ex_mem_unsigned_flag    <= id_ex_unsigned_flag;
            ex_mem_result           <= ex_result;
            ex_mem_rt_value         <= id_ex_rt_value;
        end
    end

    mem_memory mem_memory(
        .clk                    (clk),
        .rst                    (rst),
        .address                (ex_mem_result),
        .rt_value               (ex_mem_rt_value),
        .mem_type               (ex_mem_mem_type),
        .mem_size               (ex_mem_mem_size),
        .mem_signed             (ex_mem_unsigned_flag),
        .mem_en                 (data_en),
        .mem_wen                (data_wen),
        .mem_addr               (data_addr),
        .mem_wdata              (data_wdata),
        .mem_rdata              (data_rdata),
        .result                 (mem_result),
        .stall                  (mem_stall)
    );

    always_ff @(posedge clk) begin : mem_wb
        if(rst) begin
            mem_wb_pc_address       <= 32'd0;
            mem_wb_result           <= 32'd0;
            mem_wb_reg_dest         <= 5'd0;
            mem_wb_reg_en           <= 1'd0;
            mem_wb_is_branch_link   <= 1'd0;
        end
        else if(mem_wb_en) begin
            mem_wb_pc_address       <= ex_mem_pc_address;
            mem_wb_result           <= mem_result;
            mem_wb_reg_dest         <= ex_mem_wb_reg_dest;
            mem_wb_reg_en           <= ex_mem_wb_reg_en;
            mem_wb_is_branch_link   <= ex_mem_is_branch_link;
        end
    end

    wb_writeback wb_writeback(
        .clk                    (clk),
        .rst                    (rst),
        .result                 (mem_wb_result),
        .pc_address             (mem_wb_pc_address),
        .reg_dest               (mem_wb_reg_dest),
        .write_en               (mem_wb_reg_en),
        .branch_link            (mem_wb_is_branch_link),
        .reg_write_en           (wb_wen),
        .reg_write_dest         (wb_dest),
        .reg_write_data         (wb_wdata)
    );

endmodule