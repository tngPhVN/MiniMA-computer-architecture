module Control (
    input logic [8:0]  Instruction,

    output  logic   BRANCH, 
                    MEM_TO_REG, 
                    MEM_WRITE,
                    REG_WRITE, 
                    IMMEDIATE, 
                    HALT,
                    ZERO_STORE      // 0: result = R0 , 1: result = R1
);

always_comb begin
  //$display("instruction type %b", Instruction[8:7]);
    // Default list
    BRANCH = 'b0;
    MEM_TO_REG = 'b0;
    MEM_WRITE  = 'b0;
    REG_WRITE  = 'b0;
    IMMEDIATE  = 'b0;
    HALT       = 'b0;
    ZERO_STORE = 'b0;   

    case (Instruction[8:7])
        // R type
        2'b00: begin
            REG_WRITE = 'b1;
            // result stored to R0
            if (Instruction[0] == 0) 
                ZERO_STORE = 'b1;
        end 
        
        // B type 
        2'b10: begin 
		    //  $display ("B type");
            BRANCH = 'b1;
        end
        
        // Mem type 
        2'b01: begin 
            // LB instruction 
            if (Instruction[0] == 0) begin 
				    
                REG_WRITE = 'b1;
                MEM_TO_REG = 'b1;
                ZERO_STORE = 'b1;
            end
            // SB instruction
            else  begin
                REG_WRITE = 'b0; 
                MEM_WRITE = 'b1;
                ZERO_STORE = 'b0;
			  end
        end 

        // IH type 
        2'b11: begin
            // IMM
            if (Instruction[0] == 0) begin
                IMMEDIATE = 'b1;
                REG_WRITE = 'b1;
            end
            // HALT
            else begin
                HALT = 'b1; 
          		REG_WRITE  = 'b0;
              	MEM_WRITE = 'b0;
              	MEM_TO_REG = 'b0;
              	BRANCH = 'b0;
            end
        end

    endcase 
end

endmodule 