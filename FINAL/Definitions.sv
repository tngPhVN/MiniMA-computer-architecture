package Definitions;
    
  typedef enum logic[2:0] {
      AND = 3'b000,
      OR = 3'b001,
      ADD = 3'b010,
      SUB = 3'b011, 
      XOR = 3'b100,
      LSL = 3'b101,
      LSR = 3'b110,
      MOV = 3'b111 } op_mne;
    
endpackage // definitions