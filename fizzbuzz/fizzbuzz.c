#include <stdio.h>

typedef unsigned int uint;

int main(int argc, char* argv[]) {
    for(uint i = 0; i <= 100; i++) {
        uint is_div_3 = i % 3;
        uint is_div_5 = i % 5;

        if((is_div_3 != 0 && is_div_5 != 0)) { 
            printf("%d", i); 
        } else {
            if(is_div_3 == 0) { fputs("fizz", stdout); }
            if(is_div_5 == 0) { fputs("buzz", stdout); }
        }

        puts("");
    }
}