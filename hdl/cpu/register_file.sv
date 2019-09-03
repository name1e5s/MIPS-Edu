`timescale 1ns / 1ps

module register_file(
        input                       clk,
        input                       rst,

		input [4:0]					raddr_a,
		output logic [31:0] 		rdata_a,

		input [4:0]					raddr_b,
		output logic [31:0] 		rdata_b,

		input 						wen,
		input [4:0]					waddr,
		input [31:0]				wdata
);

    reg [31:0] _register[0:31];

	always_comb begin : read_data_a
        if(wen && waddr == raddr_a)
			rdata_a = wdata;
		else
			rdata_a = _register[raddr_a];
	end

	always_comb begin : read_data_b
        if(wen && waddr == raddr_b)
			rdata_b = wdata;
		else
			rdata_b = _register[raddr_b];
	end

	always_ff @(posedge clk) begin : write_data
		if(rst) begin
			for(int i = 0; i < 31; i++)
				_register[i] <= 32'h0000_0000;
		end
		else if(wen) begin
            _register[waddr] <= wdata;
        end
	end
endmodule
