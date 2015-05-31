//
//  main.c
//  Sample1
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

#include <stdio.h>
#include <unistd.h>

void func1() {
	int a = 0;
	char const b[] = "Hello!";
	printf("func1...%i...%s\n", a, b);
}

int main(int argc, const char * argv[]) {
	func1();
	
	int a = 0;
	char* b = "BCD";
	
	// insert code here...
	printf("Print1\n");
	
	a	=	1123;
	b	=	"GJD";
	
	printf("Print2\n");
	sleep(1);
	printf("Print3\n");
    return 0;
}
