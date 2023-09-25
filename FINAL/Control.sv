module Control (
    input logic [8:0]  Instruction,

    output  logic   BRANCH, 
                    MEM_TO_REG, 
                    MEM_WRITE,
                    REG_WRITE, 
                    IMMEDIATE, 
                    HALT,
                    ZERO_STORE      // 0: result = R0 , 1: result = R1

    //output logic[2:0] RegWriteIndex
);

always_comb begin
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
                // RegWriteIndex = 3'b000;
            
            //RegWriteIndex = Instruction[3:1];
        end 
        
        // B type 
        2'b10: begin 
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
            else 
                MEM_WRITE = 'b1;
        end 

        // IH type 
        2'b11: begin
            // IMM
            if (Instruction[0] == 0) begin
                IMMEDIATE = 'b1;
                REG_WRITE  = 'b1;
            end
            // HALT
            else 
                HALT = 'b1; 
        end

    endcase 
end

endmodule 