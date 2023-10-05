// source used: top_level.sv from encrypt_proj 

module top_level (
    input   Reset,
            Clk,
    output  Done
);

wire [11:0] PgmCtr,             // program counter
            PC_Target;          // where to go next 

wire [8:0] Instruction;         // 9-bit opcode

wire [7:0] Data_In_Reg,         // data in to reg file
            Read_A, Read_B;     // reg_file outputs

wire [7:0] In_A, In_B, 	        // ALU operand inputs
            ALU_Out;            // ALU result

//wire [7:0]  Data_In_Mem,        // data in to data_memory
wire [7:0]  Data_Out_Mem;       // data out from data_memory

wire        Mem_Write,	        // data_memory write enable
            Mem_To_Reg,         // data loaded from mem to reg_file 
            Reg_Write,	        // reg_file write enable
            Zero_Out,		    // ALU output = 0 flag
            Parity,             // parity flag
            Not_Equal,          // Flag for BNE instruction 
            Zero_Store,         // store to register flag 
            Immediate,          // immediate flag 
            Halt,
            Branch_Enabled,     //
            Branch_Signal;      //

wire [2:0]  Translated_Addr,    // Translated register address for BNE 
            Reg_Write_Addr,     // Address of register to write to 
            Reg_Read_Addr;      // Address of register to read from

logic [7:0] Immediate_Val;      // Immediate value 

// Program Counter
PC PC (		                
    .reset        (Reset)            ,      
    .clk          (Clk)              ,       
    .branch       (Branch_Enabled)   ,       
    .target       (PC_Target)        ,       
    .prog_ct      (PgmCtr)           ,
    .halt         (Halt)             , 	   
    .done         (Done)
);	

// Branch LUT
Branch_LUT #(.PC_width(12)) B_LUT (
    .index   (Instruction[2:0]),  // branch address retrieved from instruction 
    .target (PC_Target)     
);

// Immediate LUT 
Immediate_LUT I_LUT(
  .index        (Instruction[6:4]),
    .data         (Immediate_Val)
);

// Branch Register LUT 
Branch_Reg_LUT B_R_LUT(
  .index        (Instruction[4:3]),
    .data         (Translated_Addr)
);

// Instruction Memory 
Inst_ROM #(.A(12),.W(9)) INST_ROM (
    .inst_addr      (PgmCtr)        , 
    .inst_out       (Instruction)
);

// Control Unit
Control CTRL (
    .Instruction(Instruction)       ,
    .MEM_WRITE (Mem_Write)          ,	
    .MEM_TO_REG(Mem_To_Reg)         ,          
    .REG_WRITE(Reg_Write)           ,	        
    .ZERO_STORE (Zero_Store)        ,		    
    .IMMEDIATE (Immediate)          ,  
    .HALT(Halt),
    .BRANCH(Branch_Signal)           
);

// Register File 
Register_File #(.W(8),.D(3)) RF (
    .clk (Clk)                      , 
    .reg_write(Reg_Write)           ,
    .zero_store (Zero_Store)        , 
    .immediate (Immediate)          ,
    .read_addr (Reg_Read_Addr)    ,  
    .write_addr (Reg_Write_Addr)    , 
    .data_in (Data_In_Reg)          , 
    .immediate_val (Immediate_Val)  ,
    .zero_reg_out (Read_A)          , 
    .other_reg_out (Read_B)                 
);

// ALU 
ALU ALU_INS(
  	.halt(Halt),
  	.zero_store(Zero_Store),
  	.immediate(Immediate),
    .op_code(Instruction[6:4])   , 
    .input_0(Read_A)             , 
    .input_1(Read_B)             , 
    .result(ALU_Out)             , 
    .not_equal(Not_Equal)        ,
    .zero_flag(Zero_Out)         ,
    .parity_flag(Parity)     
);

// Data Memory
Data_Mem dm1 (
    .base_address   (Read_B)         , 
	.write_en       (Mem_Write)      , 
    .read_en        (Mem_To_Reg)     ,
	.data_in        (Read_A)         , 
	.data_out       (Data_Out_Mem)   , 
    .offset_address (Immediate_Val)  ,
	.clk 		    (Clk)            ,
    .reset         (Reset)		     
); 

// Branch MUX 
MUX_1 B_MUX (
  .data_0 (1'b0)              ,
    .data_1 (Not_Equal)         ,
    .selector (Branch_Signal)  , 
    .data_out (Branch_Enabled)   
);

// Write Address for Reg File 
MUX_3 WA_MUX (
    .data_0 (Instruction[3:1])              ,
    .data_1 (3'b000)    ,
    .selector (Zero_Store)        , 
    .data_out (Reg_Write_Addr)   
);

// Read Address of the other general register for Reg File 
MUX_3 RA_MUX (
    .data_0 (Instruction[3:1])    ,
    .data_1 (Translated_Addr)     ,
    .selector (Branch_Signal)     , 
    .data_out (Reg_Read_Addr)   
);

// Data to write to Reg File 
MUX_8 D_MUX (
    .data_0 (ALU_Out)        ,
    .data_1 (Data_Out_Mem)             ,
    .selector (Mem_To_Reg)        , 
    .data_out (Data_In_Reg)   
);

endmodule 