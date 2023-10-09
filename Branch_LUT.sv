module Branch_LUT #(PC_width = 12)(
    input [2:0] index,
    output logic [PC_width-1:0] target
);

always_comb case (index)
    3'b101: target = 1;   
    default: target = 12'bx; 
endcase

endmodule 