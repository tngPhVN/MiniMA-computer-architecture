// source used: ALU.sv from encrypt_proj 

import Definitions::*;

module ALU (
    input [7:0] input_0,
                input_1, 
    input [2:0] op_code, 
    // input       zero_store,   // 0: result = R0 , 1: result = R1 

    output logic zero_flag,
                 parity_flag,
                 not_equal, 
    output logic [7:0] result
); 

op_mne op_mnemonic;	

always_comb op_mnemonic = op_mne'(op_code);
  
// ALU Operation 
always_comb begin
  // NOOp = default
  result = input_0;				                  
  
  case(op_mnemonic)
    AND : result = input_0 & input_1;
    OR 	: result = input_0 | input_1;
    ADD : result = input_0 + input_1;
    SUB : result = input_0 - input_1;
    XOR : result = input_0 ^ input_1;
    LSL : result = input_1 << 1;      
    LSR : result = input_1 >> 1; 
    MOV : result = input_1; 
  endcase
end

always_comb begin 
  // Flag 
  case(result)
	  8'b0 :   zero_flag = 1'b1;
	  default : zero_flag = 1'b0;
  endcase

  not_equal = (input_0 != input_1); 
  parity_flag = ^result; 
end
endmodule