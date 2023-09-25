module MUX_8 (
    input logic [7:0] data_0, 
                      data_1, 
    input logic selector, 
    output logic [7:0] data_out
);

always_comb begin
    data_out = (selector) ? data_1 : data_0;  
end

endmodule 