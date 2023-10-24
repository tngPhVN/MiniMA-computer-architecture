# MiniMa architecture 

MiniMA is a small-scaled design of computer architecture, built using SystemVerilog and Python, that adapts the original
load-store and accumulator machines with a change in the number of bits using, 9-bit machine code. The intention of
this design is to prioritize simplicity in memory while able to ensure time efficiency. 

This is a coursework project and has been continued of maintaining and debug since. Project partner: [Thu Mai](https://www.linkedin.com/in/thu-mai-237992259/)  

The report of ISA of this machine is included here : [MiniMa Report](/document/ThanhPhan_ThuMai_CSE141L_FINAL_REPORT.pdf)

program 1: Given a series of fifteen 11-bit message blocks in data mem[0:29], generate the corresponding 16-bit encoded versions and store these in data mem[30:59].

testbench 1: generates random 15 messages and expects 15 outputs that are decoded message stored in memory. 
