//functional simulator
//timing simulator
//
// Section 1: All libraries required include
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>
//Macros
#define ARRAY_SIZE  9
#define Debug 1
#define read 1
#define msk 4294967292
// Section 2: global declarations
const unsigned int b25_21=0x03E00000, b20_16=0x001F0000, b15_0=0x0000ffff, b15_11=0x0000f800 , b10_6=0x000007c0, b5_0=0x0000003;
unsigned int mem[1024], pointer;
int PC=0;
struct s
{
  int R[32], jump, ari_i, log_i, mem_i, control_i;
  unsigned int i, op, rs, rt, rd, sa, funct;
  short int imm;
}s;
// Section 3: mandatory function declarations
int init();
unsigned int h_d(char buf[ARRAY_SIZE], int line);
int load_mem(char fname[]);
struct s IF(int c);
struct s ID();
struct s EX();
struct s ME();
struct s WB();
int print(struct s print_s);
// Section 4: main function i.e: entry and exit of our program
int main(void)
{
  int clk=0;
  char fname[100]="trace.txt";
  printf("\nEnter memory image file name:");
  // scanf("%c", &fname);
  printf("**********************************************************************\n******************************* ECE586 *******************************\n**********************************************************************\nProject mates are:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tAalap,\t\tPradeep,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tNaveen,\t\tVamsi Krishna.\n..................................................................................................\n");
  pointer = load_mem(fname);
  printf("\n\t\t\tSuccessfullyl loaded %x number of trace file instructions into memory...\n", pointer);
  if(Debug) printf("\n\top\trs\trt\trd\tsa\tfunct\timm\t\n");
  init();
  while(clk < pointer)
  {
    IF(0);
    ID();
    EX();
    ME();
    WB();
    clk++;
  }
  printf("\nNo of clock cycles ran: %x\n", clk);
  print(s);
  return 0;
}
// Section 5: Define all the functions which are declared in section 3
int init()
{
  s.jump = 0;
  s.ari_i = 0;
  s.log_i = 0;
  s.mem_i = 0;
  s.control_i = 0;
  s.i = 0;
  s.op = 0;
  s.rs = 0;
  s.rd = 0;
  s.sa = 0;
  s.funct = 0;
  s.imm = 0;
  for(int i=0; i < 32; i++) s.R[i] = 0;
  return 0;
}

unsigned int h_d(char hex[ARRAY_SIZE], int line) //not using currently
{
  unsigned int dec = 0, base = 1;
  for(int i = strlen(hex); i >= 0; i--)
  {
    if(hex[i] >= '0' && hex[i] <= '9')
    {
      dec += (hex[i] - 48) * base;
      base *= 16;
    }
    else if(hex[i] >= 'A' && hex[i] <= 'F')
    {
      dec += (hex[i] - 55) * base;
      base *= 16;
    }
    else if(hex[i] >= 'a' && hex[i] <= 'f')
    {
      dec += (hex[i] - 87) * base;
      base *= 16;
    }
  }
  return dec;
}

int load_mem(char fname[])
{
  int j=0;
  char buf[15];
  FILE* ptr;
  ptr = fopen(fname, "r");
  if (NULL == ptr)  printf("\nfile can't be opened \n");
  else
  {
    while( !feof(ptr))
    {
        fgets(buf, sizeof(buf), ptr);
        mem[j] = h_d(buf, j);
        j++;
      }
      mem[j-1] = 0;
  }
  for(int i=0; i < (j-1); i++) if(Debug) printf("loaded Mem[%d] = %x\n", i, mem[i]);
  fclose(ptr);
  return (j-1);
}

struct s IF(int c)
{
    if(s.jump > 0)
    {
      PC = PC + s.jump;
      if(Debug) printf("jump %d", s.jump);
      s.jump = 0;
    }
    s.i = mem[PC/4];
    if(Debug) printf("\n\nIF %x PC %d", s.i, PC);
    PC+=4;
  return s;
}

struct s ID()
{    
    //R type
    s.op    = (s.i)          >> 26;
    s.rs    = (s.i & b25_21) >> 21;
    s.rt    = (s.i & b20_16) >> 16;
    s.rd    = (s.i & b15_11) >> 11;
    s.sa    = (s.i & b10_6)  >> 6;
    s.funct = (s.i & b5_0);
    //I type
    s.imm = s.i & b15_0;
    if(Debug) printf("\nID\t%x\t%x\t%x\t%x\t%x\t%x\t%x\t\tinstruction:\t%d", s.op, s.rs, s.rt, s.rd, s.sa, s.funct, s.imm, PC/4);
    return s;
}

struct s EX()
{
  switch(s.op)
  {
    //Arithmeetic instructions
    case 0x0: s.R[s.rd] = s.R[s.rs] + s.R[s.rt];//ADD s.rd, s.rs, s.rt
  arithmetic:
              if(Debug) printf("\nEX op %x R[%d] %x R[%d] %x R[%d] %x imm %x", s.op, s.rd, s.R[s.rd], s.rt, s.R[s.rt], s.rs, s.R[s.rs], s.imm);
              s.ari_i++;
              break;

    case 0x1: s.R[s.rt] = s.R[s.rs] + s.imm;//ADDI s.rt, s.rs, Imm
              goto arithmetic;
    case 0x2: s.R[s.rd] = s.R[s.rt] - s.R[s.rs];//SUB s.rd, s.rs, s.rt
              goto arithmetic;
    case 0x3: s.R[s.rt] = s.R[s.rs] - s.imm;//SUBI s.rt, s.rs, Imm
              goto arithmetic;
    case 0x4: s.R[s.rd] = s.R[s.rs] * s.R[s.rt];//MUL s.rd, s.rs, s.rt
              goto arithmetic;
    case 0x5: s.R[s.rt] = s.R[s.rs] * s.imm;//MULI s.rt s.rs Imm
              goto arithmetic;
    //Logical instructions
    case 0x6: s.R[s.rd] = s.R[s.rs] | s.R[s.rt];//OR s.rd s.rs s.rt
     logical: s.log_i++;
              break;

    case 0x7: s.R[s.rt] = s.R[s.rs] | s.imm;//ORI s.rt s.rs Imm
              goto logical;
    case 0x8: s.R[s.rd] = s.R[s.rs] & s.R[s.rt];//AND s.rd s.rs s.rt
              goto logical;
    case 0x9: s.R[s.rt] = s.R[s.rs] & s.imm;//ANDI s.rt s.rs Imm
              goto logical;
    case 0xA: s.R[s.rd] = s.R[s.rs] ^ s.R[s.rt];//XOR s.rd s.rs s.rt
              goto logical;
    case 0xB: s.R[s.rt] = s.R[s.rs] ^ s.imm;//XORI s.rt s.rs Imm
              goto logical;
    default:  if(Debug) printf("\nEX --");
  }
  s.R[0] = 0;
return s;
}

struct s ME()
{int a;
  switch(s.op)
  {
    // memory access instructions
    case 0xC: s.R[s.rt] = mem[s.R[s.rs] + s.imm];//LDW s.rt s.rs Imm
              if(Debug) printf("\nME R[%d]  mem[%d] %x + %x\tLDW", s.rt, s.rs, mem[s.R[s.rs]+s.imm], s.imm);
      memory: s.mem_i++;
              break;

    case 0xD: a      = s.R[s.rs] + s.imm;
              mem[a] = s.R[s.rt];//STW s.rt s.rs Imm
              if(Debug) printf("\nME %x R[%d] %x\tSTW", a, s.rt, s.R[s.rt]);
              goto memory;

   default:  if(Debug) printf("\nME --");
  }
  return s;
}

struct s WB()
{
  switch(s.op)
  {
    //Control flow instructions
    case 0xE:  if(s.R[s.rs] == 0)//BZ s.rs x
        jump:  {
                 s.control_i++;
                 s.jump = (unsigned int)s.imm;
                 if(Debug) printf("\nju %d", s.jump);
               }
               break;

    case 0xF:  if(s.R[s.rs] == s.R[s.rt])//BEQ s.rs s.rt x
               goto jump;
    case 0x10: PC = s.R[s.rs] & msk;//JR s.rs
               goto jump;
    //HALT
    case 0x11: if(Debug) printf("\nHALT\n");//HALT
               s.control_i++;
               print(s);
               exit(0);
               return s;
       default: if(Debug) printf("\nWB --");
      }
      return s;
  }

int print(struct s print_s)
{
  if(Debug)
  {
    for(int j=0; j < 32; j++)
    if(print_s.R[j] != 0) printf("\nR[%d]:\t%d", j, print_s.R[j]);
    printf("\n\nProgram counter           : %d\nArithmetic instructions   : %d\nLogical instructions      : %d\nMemory access instructions: %d\nControl flow instruction  : %d\n\n", PC, print_s.ari_i, print_s.log_i, print_s.mem_i, print_s.control_i);
    for(int i=0; i < 1024; i++) if(mem[i] != 0) printf("Updated Mem[%d] = %x\n", i, mem[i]);
  }
  return 0;
}
