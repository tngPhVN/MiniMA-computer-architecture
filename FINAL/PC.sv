module PC (
    input       clk,
    input       reset,
    input       halt,
    input logic branch,
    input [11:0] target, 
    
    output logic done, 
    output logic[11:0] prog_ct);

always_ff @(posedge clk) begin
	if (reset) begin
	    prog_ct <= 0;
            done <= 0; 
        end 
        else if (halt) begin
            done <= 'b1;
        end
		else if (branch) begin
			prog_ct <= target;
        end 
		else begin
			prog_ct <= prog_ct + 'b1; 
        end
end
endmodule 