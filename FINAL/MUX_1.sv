module MUX_1 (
    input logic data_0, 
                data_1, 
    input logic selector, 
    output logic data_out
);

always_comb begin
    data_out = (selector) ? data_1 : data_0;  
end

endmodule 