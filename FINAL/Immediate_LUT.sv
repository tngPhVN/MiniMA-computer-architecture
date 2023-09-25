module Immediate_LUT(
    input [2:0] index,
    output logic [7:0] data
);

always_comb case (index)
    3'b000: data = 0;            // 0
    3'b001: data = 1;            // 1 
    3'b010: data = 29;           // 29  
    3'b011: data = 128;           // 128  
    3'b100: data = 59;           // 59 
    3'b101: data = 4;           // 4
    default: data = 8'hx; 
endcase

endmodule 