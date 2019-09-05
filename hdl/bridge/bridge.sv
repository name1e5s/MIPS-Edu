`timescale 1ns / 1ps

module bridge #(parameter PREFIX=16'h1faf) (
    input                   clk,
    input                   rst,

	input                   bridge_en,
	input [3 :0]            bridge_wen,
	input [31:0]            bridge_addr,   
	input [31:0]            bridge_wdata,   
	output logic [31:0]     bridge_rdata,

    output logic            conf_en,     
	output logic [3:0]      conf_wen,     
	output logic [31:0]     conf_addr,   
	output logic [31:0]     conf_wdata,   
	input [31:0]            conf_rdata,

    output logic            data_en,     
	output logic [3:0]      data_wen,     
	output logic [31:0]     data_addr,   
	output logic [31:0]     data_wdata,   
	input [31:0]            data_rdata
);

    reg [31:0]  addr_prev;

    always_ff @(posedge clk) begin
        if(rst)
            addr_prev <= 32'd0;
        else
            addr_prev <= bridge_addr;
    end

    always_comb begin
        conf_en     = 1'd0;
        conf_wen    = 4'd0;
        conf_addr   = bridge_addr;
        conf_wdata  = bridge_wdata;

        data_en     = 1'd0;
        data_wen    = 4'd0;
        data_addr   = bridge_addr;
        data_wdata  = bridge_wdata;

        bridge_rdata= 32'd0;

        if(bridge_addr[31:16] == PREFIX) begin
            conf_en     = bridge_en;
            conf_wen    = bridge_wen;
        end
        else begin
            data_en     = bridge_en;
            data_wen    = bridge_wen;
        end

        bridge_rdata    = (addr_prev[31:16] == PREFIX) ? conf_rdata : data_rdata;

    end

endmodule