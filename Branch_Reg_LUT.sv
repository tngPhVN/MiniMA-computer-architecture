// This LUT used to translate the encode 2-bit string when BNE is called to 3-bit register address
module Branch_Reg_LUT(
    input [1:0] index,
    output logic [2:0] data
);

always_comb case (index)
    2'b00: data = 3'b000;       // r0
    2'b01: data = 3'b101;       // r5 
    2'b10: data = 3'b110;       // r6  
    2'b11: data = 3'b111;       // r7  
endcase

endmodule 