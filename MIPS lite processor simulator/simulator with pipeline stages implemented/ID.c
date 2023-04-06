#include <stdio.h>
#include <math.h>
#include <string.h>
#define ARRAY_SIZE  9
int ID(char buf[ARRAY_SIZE]);

int ID(char hex[ARRAY_SIZE]){
    long long decimal = 0, base = 1;
    int i = 0, value;
    printf("Input hex: %s[4][3][2]", hex);
    for(i = strlen(hex); i >= 0; i--)
    {
        if(hex[i] >= '0' && hex[i] <= '9')
        {
            decimal += (hex[i] - 48) * base;
            base *= 16;
        }
        else if(hex[i] >= 'A' && hex[i] <= 'F')
        {
            decimal += (hex[i] - 55) * base;
            base *= 16;
        }
        else if(hex[i] >= 'a' && hex[i] <= 'f')
        {
            decimal += (hex[i] - 87) * base;
            base *= 16;
        }
    }
    printf("\nHex = %s[4][3][2]\n\nDec = %lld\n", hex, hex, decimal);
    return 0;
}
int main()
{
    char buf[ARRAY_SIZE] = {"FfFfFfFf"};
    ID(buf);
    return 0;
}
