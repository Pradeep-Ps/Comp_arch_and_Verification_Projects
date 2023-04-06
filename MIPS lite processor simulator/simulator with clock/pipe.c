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
#define read 5
// Section 2: global declarations
const unsigned int b25_21=0x03E00000, b20_16=0x001F0000, b15_0=0x0000ffff, b15_11=0x0000f800 , b10_6=0x000007c0, b5_0=0x0000003;
unsigned long long clk=1;
unsigned int mem[1024];
int PC=0;
struct s
{
  int R[32], jump, ari_i, log_i, mem_i, control_i;
  unsigned int i, op, rs, rt, rd, sa, funct, ins;
  short int imm;
}s[5];
// Section 3: mandatory function declarations
int init();
int load_mem(char fname[]);
struct s IF(int c); //IF_s
struct s ID();
struct s EX();
struct s ME();
struct s WB();
int print(struct s print_s);
unsigned int h_d(char buf[ARRAY_SIZE], int line);
// Section 4: main function i.e: entry and exit of our program

struct s IF(int c){
  if(c)
  {
    s[0].ins++;
    if(s[3].jump > 0)
    {
      PC = s[3].jump;
    }
    s[0].i = mem[PC];
    // printf("\nIF\t%d\n", s[0].i);
  }
    else  s[0].ins=0;
    return s[0];
}

struct s ID(){
  s[1] = s[0];
  if(s[1].ins)
  {
    //R type
    s[1].op    = (s[1].i)          >> 26;
    s[1].rs    = (s[1].i & b25_21) >> 21;
    s[1].rt    = (s[1].i & b20_16) >> 16;
    s[1].rd    = (s[1].i & b15_11) >> 11;
    s[1].sa    = (s[1].i & b10_6)  >> 6;
    s[1].funct = (s[1].i & b5_0);
    //I type
    s[1].imm = s[1].i & b15_0;
    printf("ID\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\tinstruction:\t%d\n", s[1].op, s[1].rs, s[1].rt, s[1].rd, s[1].sa, s[1].funct, s[1].imm, PC);
  }
  return s[1];
}

struct s EX(){
  s[2] = s[1];
  return s[2];
}

struct s ME(){
  s[3] = s[2];
  return s[3];
}

struct s WB(){
  s[4] = s[3];
  return s[4];
}

int init()
{
  s[0].jump = 0;
  s[0].ari_i = 0;
  s[0].log_i = 0;
  s[0].mem_i = 0;
  s[0].control_i = 0;
  s[0].ins = 0;
  s[0].i = 0;
  s[0].op = 0;
  s[0].rs = 0;
  s[0].rd = 0;
  s[0].sa = 0;
  s[0].funct = 0;
  s[0].imm = 0;
  for(int i=0; i < 32; i++) s[0].R[i] = 0;
  // s[0] = s[0];
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

int print(struct s print_s){
  if(Debug)
  {
    for(int j=0; j < 32; j++)
      if(print_s.R[j] != 0) printf("\nR[%d]:\t%d", j, print_s.R[j]);

    printf("\n\nProgram counter           : %d\nArithmetic instructions   : %d\nLogical instructions      : %d\nMemory access instructions: %d\nControl flow instruction  : %d\n", PC*4, print_s.ari_i, print_s.log_i, print_s.mem_i, print_s.control_i);

    // for(int j=0; j < 1025; j++)
    //   if(mem[j] != 0) printf("\nmem[%d]:\t%x\t%d", j, mem[j], mem[j]);
  }
  return 0;
}

int load_mem(char fname[])
{
  int i=0;
  char buf[15];
  FILE* ptr;
  ptr = fopen(fname, "r");
  while(!feof(ptr))
  {
      fgets(buf, sizeof(buf), ptr);
      mem[i] = h_d(buf, i);
      i++; //only when processing instructions increment
  }
  for(i=0;i<1024;i++) if(mem[i]) printf("Mem[%d] = %x\t%d\n", i, mem[i], mem[i]);
  fclose(ptr);
  return 0;
}

int main()
 {
   char fname[100]="trace.txt";
   printf("**********************************************************************\n******************************* ECE586 *******************************\n**********************************************************************\nProject mates are:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tAalap,\t\tPradeep,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tNaveen,\t\tVamsi Krishna.\n..................................................................................................\n");
   printf("\n\t\t\tSuccessfullyl loaded %d number of trace file instructions into memory...\n", load_mem(fname));
   init();

   printf("\n\top\trs\trt\trd\tsa\tfunct\timm\t\n");
   while(clk < read*2 || s[4].ins != 0 || s[3].ins != 0 || s[2].ins != 0 || s[1].ins != 0 || s[0].ins != 0)
   {
        if(clk & 1)
        {
          s[4] = WB();
          s[3] = ME();
          s[2] = EX();
          s[1] = ID();
          s[0] = IF( (clk <= read*2) ? 1 : 0);
          // printf("\n%lld\tIF %d\tID %d\tEX %d\tME %d\tWB %d\n", clk/2, s[0].ins, s[1].ins, s[2].ins, s[3].ins, s[4].ins);
        }
        else
        {
          // s[4]   = s[0];
          // s[3]   = s[4];
          // s[2]   = s[3];
          // s[1]   = s[2];
          // s[0]   = s[1];
          // s[0] = s[0];
        }
     clk++;
     if(PC < read) PC++;
   }
   if(clk/2 == 0) printf("\nDid not fetch any line from memory");
   else           printf("\nclocks: %lld", clk/2);
   print(s[4]);

   return 0;
}
