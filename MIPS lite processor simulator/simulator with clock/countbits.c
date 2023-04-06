#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(){
    long long  count = 1;
    int i=0;
    while(count != 0){
        printf("%d  %llu\n", i, count);
        count = count << 1;
        i++;
    }
}
