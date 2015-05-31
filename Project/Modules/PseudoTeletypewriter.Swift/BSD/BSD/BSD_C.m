//
//  BSD_C.c
//  pty1
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

#include "BSD_C.h"

#include <stdio.h>
#include <stdlib.h>

pid_t
Eonil____BSD_C_fork() {
	return	fork();
}



//void
//test1() {
//	char*	args[3]		=	{"/usr/bin/printf", "AAA", NULL};
//	char*	env[1]		=	{NULL};
//	execve("/usr/bin/printf", args, env);
//}
