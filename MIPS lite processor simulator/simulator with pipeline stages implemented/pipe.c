/*
ECE586 Computer Architecture Project
Simulating a 5 stage pielined MIPS-lite processor

colloborator1: PRADEEP GOVINDAN
colloborator2: VAMSI KRISHNA
colloborator3: AALAP KHANOLKAR
colloborator4: NAVEEN MANIVANNAN
*/
//functional simulator
//timing simulator

// Section 1: All libraries required include
#include<stdio.h> //
#include<string.h> //for string functions
#include<stdlib.h> //standar input and output
#include<math.h> //for mathematical functions

//Macros
#define ARRAY_SIZE  9 //for buffer size
#define Debug 0 //0 - Results, 1 - timing simulaotr, 2 - functional simulator, 4 - all

// Section 2: global declarations
const unsigned int b25_21=0x03E00000, b20_16=0x001F0000, b15_0=0x0000ffff, b15_11=0x0000f800 , b10_6=0x000007c0, b5_0=0x0000003; //constants used to decode instructions
signed long long clk=0;
unsigned int mem[1024], pointer, updated[1056];
int PC=0, ari_i, log_i, mem_i, control_i, drain, R[32], ALU[32], I_count[1024];

struct s //struct used to store all insstruction data
{
  int  jump, NOP;
  unsigned int op, rs, rt, rd, sa, funct, i;
  short int imm;
}s[5], temp_s;

// Section 3: mandatory function declarations
struct s init();
unsigned int h_d(char buf[ARRAY_SIZE], int line);
int load_mem(char fname[]);
struct s IF(int c); //instruction fetch stage
struct s ID(); //instruction decode stage
struct s EX(); //instruction execute stage
struct s ME(); //memroy execute stage
struct s WB(); //write back stage
int functional_sim_print(struct s print_s); //function to print final register and memory

// Section 4: main function i.e: entry and exit of our program
struct s init() //initialising all variables, memory, struct and register
{
  s[2].jump = 0;
  s[1].NOP = 0;
  ari_i = 0;
  log_i = 0;
  mem_i = 0;
  control_i = 0;
  s[0].i = 0;
  s[0].op = 0;
  s[0].rs = 0;
  s[0].rd = 0;
  s[0].sa = 0;
  s[0].funct = 0;

  for(int i=0; i < 32; i++) ALU[i] = 0;
  for(int i=0; i < 1056; i++) updated[i] = -1;

  s[0].imm = 0;
  s[4] = s[0];
  s[3] = s[0];
  s[2] = s[0];
  s[1] = s[0];
  return s[0];
}

unsigned int h_d(char hex[ARRAY_SIZE], int line) //converting hexadecimal to decimal values
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

    return dec; //returning back decimal value
}

int functional_sim_print(struct s print_s) //function to print all the results
{
  printf("\n\t\tInstruction counts:\n\nTotal instructions : %d\nArithmetic instructions   : %d\nLogical instructions      : %d\nMemory access instructions: %d\nControl flow instruction  : %d\n\n\t\tFinal register states:\n\nProgram counter           : %d", (ari_i+log_i+mem_i+control_i-1), ari_i-1, log_i, mem_i, control_i, PC);
  for(int j=0; j < 32; j++) printf("\nR[%d]:\t%d", j, R[j]);

  printf("\n\n\t\tFinal memory states:\n\n");
  for(int i=0; i < 1024; i++)  if(updated[i] != -1) printf("Address: %d,\tContents: %d\n", i, mem[i]);

  printf("\n\nClock: %lld\n\n", (clk>>1)-1); //printing final value of clock
  return 0;
}

int load_mem(char fname[]) //loading instruction from file to memory
{
  int j=0;
  char buf[15]; //store fetched line from file
  FILE* ptr;
  ptr = fopen(fname, "r"); //opening file in read mode

  if (NULL == ptr)  printf("\nfile can't be opened \n");
  else
  {
    while( !feof(ptr)) //read until end of file
    {
        fgets(buf, sizeof(buf), ptr);
        mem[j] = h_d(buf, j);
        j++;
      }
      mem[j-1] = 0;
  }

  for(int i=0; i < (j-1); i++) if(Debug > 3) printf("loaded Mem[%d] = %x\n", i, mem[i]); //print loaded memory

  fclose(ptr); //close file
  return (j-1);
}

int main()
{
  char fname[100] = "trace.txt"; //default file name
  printf("**********************************************************************\n******************************* ECE586 *******************************\n**********************************************************************\nProject mates are:\t\t\tAalap,\t\tPradeep,\n\t\t\t\t\tNaveen,\t\tVamsi Krishna.\n..................................................................................................\n");
  // scanf("%s", &fname);
  // printf("\nFile name is %s\n", fname );
  pointer = load_mem(fname);

  if(pointer > 0)
  {
    printf("\n\t\t\tSuccessfullyl loaded %d number of trace file instructions into memory...\n", pointer);
    temp_s = init();

    if(Debug > 1) printf("\n\top\trs\trt\trd\tsa\tfunct\timm\t\n");

    while(clk < pointer*2+5 || s[4].i != 0 || s[3].i != 0 || s[2].i != 0 || s[1].i != 0 || s[0].i != 0) //pipeline clock generation
    {
      if(clk & 1) //execute all stages only on the posedge of clock
      {
        s[4] = WB();
        s[3] = ME();
        s[2] = EX();
        s[1] = ID();
        s[0] = IF((clk <= pointer*2) ? 1 : 0);
        drain = (clk <= pointer*2) ? 0 : 1;

        if(Debug > 0) printf("\n\tIF %x\tID %x\tEX %x\tME %x\tWB %x PC %d instruction %d\n", s[0].i, s[1].i, s[2].i, s[3].i, s[4].i, PC, PC/4);
      }
      clk++;
    }
  }
  else
    printf("\n\t\tNo instruction loaded into memory\n");
  if(clk>>1 == 0) printf("\nDid not fetch any line from memory");
  // else printf("\n\nclocks: %lld\n\n", (clk>>1)-1);

  functional_sim_print(s[4]);
  return 0;
}

struct s IF(int c)
{
      if(c)
        {
            if(s[2].jump != 0) //only if there is jump
            {
              PC = PC + s[2].jump*4;
              if(Debug > 1) printf("ju1 %d PC %d\n", s[2].jump, PC);
              s[1].jump = 0;
            }

            s[0].i = (s[2].jump > 0) ? 0xffffffff : mem[PC/4]; //after loading data increment program counter
            PC+=4;

            if(Debug > 1) printf("\n\nIF %x PC %d", s[0].i, PC);
         }
    else  s[0].i=0; //for draining data
    return s[0];
}

struct s ID(){
  s[1] = s[0];
      if(s[1].i)
      {
        //R type
        s[1].op    = (s[1].i)          >> 26; //decoding all instruction types
        s[1].rs    = (s[1].i & b25_21) >> 21;
        s[1].rt    = (s[1].i & b20_16) >> 16;
        s[1].rd    = (s[1].i & b15_11) >> 11;
        s[1].sa    = (s[1].i & b10_6)  >> 6;
        s[1].funct = (s[1].i & b5_0);
        //I type
        s[1].imm = s[1].i & b15_0;

        if(Debug > 1) printf("\nID\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t\tPC\t%d\n", s[1].op, s[1].rs, s[1].rt, s[1].rd, s[1].sa, s[1].funct, s[1].imm, PC);

        switch(s[1].op)
          {
              case 0xE:  if(R[s[1].rs] == 0)//BZ s[2].rs x
                   jump:  {
                            if(!drain) control_i++;
                            s[1].jump = (unsigned int)s[1].imm;
                            if(Debug > 1) printf("\nju %d", s[1].jump);
                          }
                          break;

               case 0xF:  if(R[s[1].rs] == R[s[1].rt])//BEQ s[2].rs s[2].rt x
                          goto jump;
            }
      }
               return s[1];
}

struct s EX(){
  s[2] = s[1];
  switch(s[2].op)
  {
    //Arithmeetic instructions
    case 0x0: ALU[s[2].rd] = R[s[2].rs] + R[s[2].rt];//ADD s[2].rd, s[2].rs, s[2].rt
  arithmetic:
              if(Debug > 1) printf("\nEX op %x R[%d] %x R[%d] %x R[%d] %x imm %x ari %d", s[2].op, s[2].rd, R[s[2].rd], s[2].rt, R[s[2].rt], s[2].rs, R[s[2].rs], s[2].imm, ari_i);
              if(!drain) ari_i++;
              break;

    case 0x1: ALU[s[2].rt] = R[s[2].rs] + s[2].imm;//ADDI s[2].rt, s[2].rs, Imm
              goto arithmetic;
    case 0x2: ALU[s[2].rd] = R[s[2].rt] - R[s[2].rs];//SUB s[2].rd, s[2].rs, s[2].rt
              goto arithmetic;
    case 0x3: ALU[s[2].rt] = R[s[2].rs] - s[2].imm;//SUBI s[2].rt, s[2].rs, Imm
              goto arithmetic;
    case 0x4: ALU[s[2].rd] = R[s[2].rs] * R[s[2].rt];//MUL s[2].rd, s[2].rs, s[2].rt
              goto arithmetic;
    case 0x5: ALU[s[2].rt] = R[s[2].rs] * s[2].imm;//MULI s[2].rt s[2].rs Imm
              goto arithmetic;
    //Logical instructions
    case 0x6: ALU[s[2].rd] = R[s[2].rs] | R[s[2].rt];//OR s[2].rd s[2].rs s[2].rt
    logical:  if(Debug > 1) printf("\nEX op %x R[%d] %x R[%d] %x R[%d] %x imm %x ari %d", s[2].op, s[2].rd, R[s[2].rd], s[2].rt, R[s[2].rt], s[2].rs, R[s[2].rs], s[2].imm, ari_i);
              if(!drain) log_i++;
              break;

    case 0x7: ALU[s[2].rt] = R[s[2].rs] | s[2].imm;//ORI s[2].rt s[2].rs Imm
              goto logical;
    case 0x8: ALU[s[2].rd] = R[s[2].rs] & R[s[2].rt];//AND s[2].rd s[2].rs s[2].rt
              goto logical;
    case 0x9: ALU[s[2].rt] = R[s[2].rs] & s[2].imm;//ANDI s[2].rt s[2].rs Imm
              goto logical;
    case 0xA: ALU[s[2].rd] = R[s[2].rs] ^ R[s[2].rt];//XOR s[2].rd s[2].rs s[2].rt
              goto logical;
    case 0xB: ALU[s[2].rt] = R[s[2].rs] ^ s[2].imm;//XORI s[2].rt s[2].rs Imm
              goto logical;
    case 0x10: //PC = R[s[1].rs]*4;//JR s[2].rs
               if(!drain) control_i++;
               break;

     //HALT
     case 0x11:  printf("\nHALT\n");//HALT
                 if(!drain) control_i++;
                 functional_sim_print(s[1]);
                 exit(0); //exit to halt the execution of program
                 return s[1];

    default:  if(Debug > 1) printf("\nEX --");
  }
  R[0] = 0;
  return s[2];
}

struct s ME(){
  s[3] = s[2];
  int a;
  switch(s[3].op)
  {
    // memory access instructions
    case 0xD: updated[R[s[3].rs] + s[3].imm] = 1;
              mem[R[s[3].rs] + s[3].imm] = R[s[3].rt]; //STW s[3].rt s[3].rs Imm

              if(Debug > 2) printf("\nclk %d ME  mem[%d] %x\tSTW", clk, s[3].rt + s[3].imm, R[s[3].rt]);

              if(!drain) mem_i++;

              break;

   default:  if(Debug > 1) printf("\nME --");
  }
  return s[3];
}

struct s WB(){
  s[4] = s[3];
  switch(s[4].op)
  {
    //Control flow instructions
    case 0xC: ALU[s[4].rt] = mem[R[s[4].rs] + s[4].imm]; //LDW s[3].rt s[3].rs Imm

              if(Debug > 1) printf("\nME R[%d]  mem[%d] %x + %x\tLDW", s[4].rt, s[4].rs, mem[R[s[4].rs]+s[4].imm], s[4].imm);

              if(!drain) mem_i++;

              break;

       default: if(Debug > 1) printf("\nWB --");
      }
      for(int i=0; i<31; i++) R[i] = ALU[i];
  return s[4];
}
