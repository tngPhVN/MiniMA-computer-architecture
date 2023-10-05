// source used: ALU.sv from encrypt_proj 

module ALU (
  	input halt, 
  		  immediate, 
    input [7:0] input_0,
                input_1, 
    input [2:0] op_code, 
    input       zero_store,   // 0: result = R0 , 1: result = R1 

    output logic zero_flag,
                 parity_flag,
                 not_equal, 
    output logic [7:0] result
); 
  
// ALU Operation 
always_comb begin
  if (!halt) begin  		
      case(op_code)
        3'b000 : result = input_0 & input_1;
        3'b001 : result = input_0 | input_1;
        3'b010 : result = input_0 + input_1;
        3'b011 : result = input_0 - input_1;
        3'b100 : result = input_0 ^ input_1;
        3'b101 : result = input_1 << 1;      
        3'b110 : result = input_1 >> 1; 
        3'b111 : result = zero_store ? input_1 : input_0;
        default: result = 0;
      endcase
  end
  else begin 
  	// NOOp = default
    result = 0;
  end
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