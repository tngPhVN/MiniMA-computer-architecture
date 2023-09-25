module Data_Mem (
    input clk,
          reset, 
          write_en, 
          read_en, 
    input [7:0] base_address,       // base address register pointer 
    input [7:0] offset_address,     // offset for displacement addressing
    input [7:0] data_in,            // data to be stored to a register for sb instruction 
    output logic [7:0] data_out           // data to be loaded from memory 
);

logic [7:0] memory [256];

always_comb begin
    if(read_en) begin
      data_out = memory[base_address + offset_address];
	$display("sb memory[%d] = %b",base_address+offset_address, data_out);
    end 
    else data_out = 8'bZ;
end

always_ff @ (posedge clk) begin
  if(reset) begin
      // Preload desired constants into data_mem[128:255]
      memory[128] <= 0;
    end 
  else if(write_en) begin
    memory[base_address + offset_address] <= data_in;
	$display("lb memory[$d] = %d",base_address+offset_address, data_in);
  end
end
endmodule 