#include <stdio.h>
int num1, num2;
char op;
char inp[64];

char *getnum(char *rdi, int *rsi) {
	printf("getnum called with rdi: %.64s", rdi);
	printf(" and rsi: %i\n", *rsi);
    int rax = 0;
    char sign = *rsi - '-';
	printf("sign: %i\n", sign);
    if(sign) {
        goto a;
    }
    char dl;
    while(1) {
        rdi++;
		printf("rdi incremented\n");
        a: dl = *rdi - '0';
		printf("rax: %i\n", rax);
		printf("rdi: %.64s\n", rdi);
		printf("dl: %c (%i)\n", dl, dl);
        if('0' > *rdi){
			printf("breaking from loop\n");
            break;
        }
        rax *= 10;
        rax += dl;
    }
	printf("final rax before sign check: %i\n", rax);
    if(!sign) {
        rax *= -1;
    }
	printf("final rax after sign check: %i\n", rax);
    *rsi = rax;
    return rdi;
}

int main() {
    fread(inp, 1, 64, stdin);
    char* x = inp;
	printf("inp: %.64s\n", inp);
    x = getnum(x, &num1);
	printf("num1: %d\n", num1);
	printf("from x: %.64s\n", x);
    op = *x;
	printf("op: %c\n", op);
	x++;
	x = getnum(x, &num2);
	printf("num2: %d\n", num2);
	switch (op) {
		case '+':
			num1 += num2;
			break;
		case '-':
			num1 -= num2;
			break;
		case '*':
			num1 *= num2;
			break;
		default:
			num1 /= num2;
			break;
	}
	printf("num1 result: %d\n", num1);
    return num1;
}
