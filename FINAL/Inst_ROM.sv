// A = program counter width
// W = machine code width
module Inst_ROM #(parameter A=12, W=9) (
  input       [A-1:0] inst_addr,
  output logic[W-1:0] inst_out);
	 
  logic[W-1:0] inst_rom[2**A];
  always_comb inst_out = inst_rom[inst_addr];
 
  initial begin		                 
  	$readmemb("machine_code_1.txt",inst_rom);
  end 

endmodule 