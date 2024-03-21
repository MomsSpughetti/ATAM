unsigned int what_to_do(unsigned char magic) {
	/* This is not the greatest function in the world, no.
	   This is just a tribute. */
	return magic;
}
#include "stdio.h"
	//	ASM functions
extern void my_ili_handler(void);
extern long test_imul();
extern long test_xor();
extern long test_mov();
extern long test_push();

int main(){
    printf("code: %lx\n", test_imul()); // imul r2r opcode : 0x0faf
	printf("code: %lx\n", test_xor()); // xor r2r opcode : 0x31
	printf("code: %lx\n", test_mov()); // mov r2r opcode : 0x89
	printf("code: %lx\n", test_push()); // push %rbp opcode : 0x55
	return 0;
}