import re

def process_reg_branch(str):
    if str == "r0":
        return "00"
    if str == "r5":
        return "01"
    if str == "r6":
        return "10"
    if str == "r7":
        return "11"
    else:
        raise Exception ("I don't you as any register, and try again :)")

def process_reg(str):
  if str == "r0":
    return "000"
  if str == "r1":
    return "001"
  if str == "r2":
    return "010"
  if str == "r3":
    return "011"
  if str == "r4":
    return "100"
  if str == "r5":
    return "101"
  if str == "r6":
    return "110"
  if str == "r7":
    return "111"
  else:
    raise Exception ("I don't you as any register, and try again :)")

def parse_code(str):
  return str

def decimal_to_binary(x):
  if x == 0:
    return "0"
  if x == 1:
    return "1"
  if x == 128:
    return "011"
  if x == 59:
    return "100"
  if x == 29:
    return "010"
# Branch target
  if x == 4:
    return "101"
  if x == 2: 
    return "110"
  if x > 1:
    return decimal_to_binary(x // 2) + str(x%2)

def process_decimal(x):
  res = decimal_to_binary(int(x))
  return (3-len(res)) * "0" + res

def process_decimal_imm(x):
  res = decimal_to_binary(int(x))
  return (4-len(res)) * "0" + res

#keep track of index and file line number
line_num = 0
labels_num = 0
opcodes = ["AND", "OR", "ADD", "SUB", "XOR", "LSL", "LSR", "MOV", "LB", "SB", "BNE", "IMM", "HALT"]

# # machine code 
# mach_code = [] 

write_file = open("machine_code_1.txt","w")

with open("program1.txt", "r")  as f:
    lut_file = open("lut_file.txt", 'w')

    #reads through assembly and collects labels to populate lookup table
    lut = {}
    for line in f:
        instr = line.split();
        line_num += 1

        # Skip comment line or newline 
        if not instr or instr[0] == "//" or instr[0] == "\n" :
            continue

        #check if it is a label or not
        if instr[0] not in opcodes:
            lut[instr[0].replace(':', '')] = line_num
            lut_file.write(str(line_num) + '\n')
            print(lut[instr[0].replace(':', '')])
            labels_num += 1

    # Move to the start of the assembler file
    f.seek(0)

    for line in f:
        # Split the assembly code into chunks, "imm r0 1" -> ["imm", "r0, "1"]
        str_array = line.split()     
        
        # Skip comment line or newline 
        if not str_array or str_array[0] == "//" or str_array[0] == "\n" :
            continue

        instr = str_array[0]

        # Translated machine code 
        mach_code = [] 

        if instr not in opcodes:
            continue

        elif instr == "ADD":
            if str_array[1] != "r0":
                des = "1"
            else: 
                des = "0"

            if str_array[2] != "r0":
                operand = str_array[2]
            else:
                operand = str_array[3]  

            op = parse_code("00010" + process_reg(operand) + des)
            mach_code.append(op)

        elif instr == "SUB":
            if str_array[1] != "r0":
                des = "1"
            else: 
                des = "0"

            if str_array[2] != "r0":
                operand = str_array[2]
            else:
                operand = str_array[3]  

            op = parse_code("00011" + process_reg(operand) + des)
            mach_code.append(op)

        elif instr == "XOR":
            if str_array[1] != "r0":
                des = "1"
            else: 
                des = "0"

            if str_array[2] != "r0":
                operand = str_array[2]
            else:
                operand = str_array[3]  

            op = parse_code("00100" + process_reg(operand) + des)
            mach_code.append(op)

        elif instr == "AND":
            if str_array[1] != "r0":
                des = "1"
            else: 
                des = "0"

            if str_array[2] != "r0":
                operand = str_array[2]
            else:
                operand = str_array[3]  

            op = parse_code("00000" + process_reg(operand) + des)
            mach_code.append(op)

        elif instr == "OR":
            if str_array[1] != "r0":
                des = "1"
            else: 
                des = "0"

            if str_array[2] != "r0":
                operand = str_array[2]
            else:
                operand = str_array[3]  

            op = parse_code("00001" + process_reg(operand) + des)
            mach_code.append(op)

        elif instr == "LSL":
            if str_array[1] != "r0":
                op = parse_code("00010" + process_reg(str_array[1]) + "1")
            else: 
                op = parse_code("00010" + process_reg(str_array[2]) + "0")

            mach_code.append(op)

        elif instr == "LSR":
            if str_array[1] != "r0":
                op = parse_code("00110" + process_reg(str_array[1]) + "1")
            else: 
                op = parse_code("00110" + process_reg(str_array[2]) + "0")

            mach_code.append(op)

        elif instr == "MOV": 
            if str_array[1] != "r0":
                op = parse_code("00111" + process_reg(str_array[1]) + "1")
            else: 
                op = parse_code("00111" + process_reg(str_array[2]) + "0")
            
            mach_code.append(op)

        elif instr == "SB":
            # assembly: SB r5 1[r4]
            # str_array[2] = "1[r4]"
            # mem_des_arr = ["1", "r4]"]
            mem_des_arr = str_array[2].split("[")
            # after this line, mem_des_arr = ["1", "r4"]
            mem_des_arr[1] = mem_des_arr[1].rstrip("]")
            
            if mem_des_arr[0] != "": 
                offset_num = parse_code(process_decimal(mem_des_arr[0]))
            else:
               offset_num = parse_code("000")

            op = parse_code("01" + offset_num + process_reg(mem_des_arr[1]) + "1")
            mach_code.append(op)

        elif instr == "LB":
            # assembly: LB r5 1[r4]
            # str_array[2] = "1[r4]"
            # mem_source_arr = ["1", "r4]"]
            mem_source_arr = str_array[2].split("[")
            # after this line, mem_source_arr = ["1", "r4"]
            mem_source_arr[1] = mem_source_arr[1].rstrip("]")
            
            if mem_source_arr[0] != "": 
                offset_num = parse_code(process_decimal(mem_source_arr[0]))
            else:
               offset_num = parse_code("000")

            op = parse_code("01" + offset_num + process_reg(mem_source_arr[1]) + "0")
            mach_code.append(op)

        elif instr == "BNE":
            # BNE r1 r6 loop   
            # str_array = ["BNE", "r1", "r6", "loop"]
            # do a look up label in lut dictionary 
            op = parse_code("10" + process_reg_branch(str_array[1]) + process_reg_branch(str_array[2]) + process_decimal(lut[str_array[3]]))
            mach_code.append(op)

        elif instr == "IMM":
            offset_num = parse_code(process_decimal(str_array[2]))
            op = parse_code("11" + offset_num + process_reg(str_array[1]) + "0")
            mach_code.append(op)
        elif instr == "HALT":
            op = parse_code("111111111")
            mach_code.append(op)
        else:
            raise Exception ("OH NO, CAN NOT RECOGNIZE YOUR INSTR")
        
        for code in mach_code:
            write_file.write(code + "\n")

write_file.close()
lut_file.close()