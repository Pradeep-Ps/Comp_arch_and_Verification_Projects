int ID(unsigned int i, int line){    // unsigned int b25_21=65011712, b20_16=2031616, b15_0=255, b15_11=31744 , b10_6=1984 , b5_0=63;
    // unsigned int ins_d_arg.op, ins_d_arg.rs, ins_d_arg.rt, ins_d_arg.rd, ins_d_arg.sa, ins_d_arg.funct;
    // short int imm;
    struct ins_decoded
    {
      unsigned int
      short int
    } ins_d_arg;
    //R type
    ins_d_arg.op = i >> 26;
    ins_d_arg.rs = (i & b25_21) >> 21;
    ins_d_arg.rt = (i & b20_16) >> 16;
    ins_d_arg.rd = (i & b15_11) >> 11;
    ins_d_arg.sa = (i & b10_6)  >> 6;
    ins_d_arg.funct = i & b5_0;
    //I type
    imm = i & b15_0;
    switch(ins_d_arg.op){
      //Arithmeetic instructions
      case 0x0: R[ins_d_arg.rd] = R[ins_d_arg.rs] + R[ins_d_arg.rt];//ADD ins_d_arg.rd, ins_d_arg.rs, ins_d_arg.rt
             p:
                //printf("\nop %x R[%d] %x R[%d] %x imm %x\n", ins_d_arg.op, ins_d_arg.rd, R[ins_d_arg.rd], ins_d_arg.rs, R[ins_d_arg.rs], imm);
                break;
      case 0x1: R[ins_d_arg.rd] = R[ins_d_arg.rs] + imm;//ADDI ins_d_arg.rt, ins_d_arg.rs, Imm
                goto p;
      case 0x2: R[ins_d_arg.rd] = R[ins_d_arg.rt] - R[ins_d_arg.rs];//SUB ins_d_arg.rd, ins_d_arg.rs, ins_d_arg.rt
                goto p;
      case 0x3: R[ins_d_arg.rt] = R[ins_d_arg.rs] - imm;//SUBI ins_d_arg.rt, ins_d_arg.rs, Imm
                goto p;
      case 0x4: R[ins_d_arg.rd] = R[ins_d_arg.rs] * R[ins_d_arg.rt];//MUL ins_d_arg.rd, ins_d_arg.rs, ins_d_arg.rt
                goto p;
      case 0x5: R[ins_d_arg.rt] = R[ins_d_arg.rs] * imm;//MULI ins_d_arg.rt ins_d_arg.rs Imm
                goto p;
      //Logical instructions
      case 0x6: R[ins_d_arg.rd] = R[ins_d_arg.rs] | R[ins_d_arg.rt];//OR ins_d_arg.rd ins_d_arg.rs ins_d_arg.rt
                goto p;
      case 0x7: R[ins_d_arg.rt] = R[ins_d_arg.rs] | imm;//ORI ins_d_arg.rt ins_d_arg.rs Imm
                goto p;
      case 0x8: R[ins_d_arg.rd] = R[ins_d_arg.rs] & R[ins_d_arg.rt];//AND ins_d_arg.rd ins_d_arg.rs ins_d_arg.rt
                goto p;
      case 0x9: R[ins_d_arg.rt] = R[ins_d_arg.rs] & imm;//ANDI ins_d_arg.rt ins_d_arg.rs Imm
                goto p;
      case 0xA: R[ins_d_arg.rd] = R[ins_d_arg.rs] ^ R[ins_d_arg.rt];//XOR ins_d_arg.rd ins_d_arg.rs ins_d_arg.rt
                goto p;
      case 0xB: R[ins_d_arg.rt] = R[ins_d_arg.rs] ^ imm;//XORI ins_d_arg.rt ins_d_arg.rs Imm
                goto p;
      //memory access instructions
      case 0xC: R[ins_d_arg.rt] = mem[R[ins_d_arg.rs] + imm];//LDW ins_d_arg.rt ins_d_arg.rs Imm
                goto p;
      case 0xD: mem[R[ins_d_arg.rs] + imm] = R[ins_d_arg.rt];//STW ins_d_arg.rt ins_d_arg.rs Imm
                goto p;
      //Control flow instructions
      case 0xE:  if(ins_d_arg.rs == 0)//BZ ins_d_arg.rs x
          jump:  jump = (unsigned int)imm;
                 break;
      case 0xF:  if(R[ins_d_arg.rs] == R[ins_d_arg.rt])//BEQ ins_d_arg.rs ins_d_arg.rt x
                 goto jump;
      case 0x10: PC = R[ins_d_arg.rs];//JR ins_d_arg.rs
                 goto jump;
      case 0x11: printf("\nHALT\n");//HALT
                 exit;
                 return 1;
      default:  printf("\nnone\n");
    }
    if(Debug) printf("\t %d\t%d\t%d\t%d\t%d\t%d\t%d\t\tinstruction:\t%d\n", ins_d_arg.op, ins_d_arg.rs, ins_d_arg.ins_d_arg.rt, ins_d_arg.rd, ins_d_arg.sa, ins_d_arg.funct, imm, line);
    return ins_d_arg;
}
