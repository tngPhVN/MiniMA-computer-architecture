// source used: RegFile.sv from encrypt_proj 

module Register_File #(parameter W=8, D=3)(
    input clk,
    input reg_write,    // write register flag 
          zero_store,   // flag for where to store data_in 
          immediate, 

    input logic [W-1:0] data_in,
                        immediate_val,

    //input [D-1:0] read_addr_a,
    input [D-1:0] read_addr,
                  write_addr, 

    output logic [W-1:0] zero_reg_out,     // Value of zero register 
    output logic [W-1:0] other_reg_out    // Value of the other register 
);

logic [W-1:0] registers[2**D];      // registers 

// always read at zero register and some other choice of gen registers 
always_comb 
begin
	zero_reg_out = registers[0];   
	other_reg_out = registers[read_addr];
end 

always_ff @ (posedge clk)
  if (reg_write) begin 
    if (immediate) begin 
      //$display("imm val is %d =====", immediate_val);
      //$display("write_addr %d\n", write_addr);
      registers[write_addr] <= immediate_val; 
    end 
    else begin
      //$display ("data_in is %b", data_in);
      //$display ("write_addr is %d", write_addr);
      //$display ("zero_store? is %d", zero_store);
       
      if (zero_store) 
        registers[0] <= data_in; 
      else 
        registers[write_addr] <= data_in;
    end
  end

endmodule 