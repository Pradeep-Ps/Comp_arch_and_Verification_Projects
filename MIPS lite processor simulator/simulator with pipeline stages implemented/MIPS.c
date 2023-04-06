//functional simulator
//timing simulator
//
// Section 1: All libraries required include
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <math.h>
//Macros
#define ARRAY_SIZE  9
#define Debug 1
#define read 5
// Section 2: global declarations
int R[32], jump=0;
unsigned int mem[1024], b25_21=0x03E00000, b20_16=0x001F0000, b15_0=0x0000ffff, b15_11=0x0000f800 , b10_6=0x000007c0, b5_0=0x0000003F, PC=0;
// Section 3: mandatory function declarations
int IF(char fname[]);
int ID(unsigned int i, int line);
int EX();
unsigned int h_d(char buf[ARRAY_SIZE], int line);
// Section 4: main function i.e: entry and exit of our program
int main(void)
{
  char fname[100]="trace.txt";
  int c;
  printf("**********************************************************************\n******************************* ECE586 *******************************\n**********************************************************************\nProject mates are:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tAalap,\t\tPradeep,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tNaveen,\t\tVamsi Krishna.\n..................................................................................................\n");
  // scanf("%d", &c);
  // Debug(c);
  // scanf("%s", &fname);
  IF(fname);//create stdin to get string ***
  return 0;
}
// Section 5: Define all the functions which are declared in section 3
int IF(char fname[])
{
  char buf[15];
  FILE* ptr;
  ptr = fopen(fname, "r");
  int i=0;
  printf("\n\top\trs\trt\trd\tsa\tfunct\timm\t\n");
  while(!feof(ptr))
  {
      fgets(buf, sizeof(buf), ptr);
      mem[i] = h_d(buf, i);
      i++; //only when processing instructions increment
  }
  fclose(ptr);

  while(PC <= read)
  {
    if(jump > 0)  PC = jump;

    if(ID(mem[PC], PC) == 1) break;
    // printf("halt 2");
    PC++;
  }

  for(int j=0; j < 32; j++)
  {
    R[0] = 0;
    printf("\nR[%d]:\t%d", j, R[j]);
  }
  printf("\nNo of instructions loaded: %d\nProgram counter          : %d\n", i, PC*4);
  for(int j=0; j < 1025; j++)
  {
    if(mem[j] != 0) printf("\nmem[%d]:\t%x", j, mem[j]);
  }
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
    // printf("\nline: %d Hex: %s\t Dec: %lu", line, hex, dec);
    return dec;
}

int ID(unsigned int i, int line){    // unsigned int b25_21=65011712, b20_16=2031616, b15_0=255, b15_11=31744 , b10_6=1984 , b5_0=63;
    unsigned int op, rs, rt, rd, sa, funct;
    short int imm;
    //R type
    op = i >> 26;
    rs = (i & b25_21) >> 21;
    rt = (i & b20_16) >> 16;
    rd = (i & b15_11) >> 11;
    sa = (i & b10_6)  >> 6;
    funct = i & b5_0;
    //I type
    imm = i & b15_0;
    switch(op){
      //Arithmeetic instructions
      case 0x0: R[rd] = R[rs] + R[rt];//ADD Rd, Rs, Rt
             p:
                //printf("\nop %x R[%d] %x R[%d] %x imm %x\n", op, rd, R[rd], rs, R[rs], imm);
                break;
      case 0x1: R[rd] = R[rs] + imm;//ADDI Rt, Rs, Imm
                goto p;
      case 0x2: R[rd] = R[rt] - R[rs];//SUB Rd, Rs, Rt
                goto p;
      case 0x3: R[rt] = R[rs] - imm;//SUBI Rt, Rs, Imm
                goto p;
      case 0x4: R[rd] = R[rs] * R[rt];//MUL Rd, Rs, Rt
                goto p;
      case 0x5: R[rt] = R[rs] * imm;//MULI Rt Rs Imm
                goto p;
      //Logical instructions
      case 0x6: R[rd] = R[rs] | R[rt];//OR Rd Rs Rt
                goto p;
      case 0x7: R[rt] = R[rs] | imm;//ORI Rt Rs Imm
                goto p;
      case 0x8: R[rd] = R[rs] & R[rt];//AND Rd Rs Rt
                goto p;
      case 0x9: R[rt] = R[rs] & imm;//ANDI Rt Rs Imm
                goto p;
      case 0xA: R[rd] = R[rs] ^ R[rt];//XOR Rd Rs Rt
                goto p;
      case 0xB: R[rt] = R[rs] ^ imm;//XORI Rt Rs Imm
                goto p;
      //memory access instructions
      case 0xC: R[rt] = mem[R[rs] + imm];//LDW Rt Rs Imm
                goto p;
      case 0xD: mem[R[rs] + imm] = R[rt];//STW Rt Rs Imm
                goto p;
      //Control flow instructions
      case 0xE:  if(rs == 0)//BZ Rs x
          jump:  jump = (unsigned int)imm;
                 break;
      case 0xF:  if(R[rs] == R[rt])//BEQ Rs Rt x
                 goto jump;
      case 0x10: PC = R[rs];//JR Rs
                 goto jump;
      case 0x11: printf("\nHALT\n");//HALT
                 exit;
                 return 1;
      default:  printf("\nnone\n");
    }
    if(Debug) printf("\t %d\t%d\t%d\t%d\t%d\t%d\t%d\t\tinstruction:\t%d\n", op, rs, rt, rd, sa, funct, imm, line);
    return 0;
}

int EX(){
return 0;
}
