#include <stdio.h>

int main () {
   char str1[20], str2[30];

   printf("Enter name: ");
   scanf("%19s", str1);

   printf("Enter your website name: ");
   scanf("%29s", str2);

   printf("\n\nEntered Name: %s\n", str1);
   printf("Entered Website:%s", str2);

   return(0);
}
