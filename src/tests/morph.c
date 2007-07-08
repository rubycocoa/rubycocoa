/*
 *  Copyright (c) 2007 Satoshi Nakagawa
 */

#include <mach/machine.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/sysctl.h>
#include <errno.h>

cpu_type_t set_exec_affinity(cpu_type_t new_cputype);

int main(int argc, char** argv)
{
  int pid, status;
  const char* cputype;
  
  if (argc < 3) {
    fprintf(stderr, "Usage: morph (i386|ppc) command [args]\n");
    exit(1);
  }
  
  cputype = argv[1];
  if (strcmp(cputype, "ppc") == 0) {
    set_exec_affinity(CPU_TYPE_POWERPC);
  } else if (strcmp(cputype, "i386") == 0) {
    set_exec_affinity(CPU_TYPE_I386);
  } else {
    fprintf(stderr, "Unknown CPU type: %s\n", cputype);
    exit(1);
  }

  pid = fork();
  if (pid < 0) {
    fprintf(stderr, "fork failed\n");
    exit(1);
  }
  
  if (pid == 0) {
    argv += 2;
    if (execvp(argv[0], argv) < 0) {
      fprintf(stderr, "execvp failed: %s\n", strerror(errno));
      exit(1);
    }
    return 0;
  } else {
    if (wait(&status) < 0) {
      fprintf(stderr, "wait failed\n");
      exit(1);
    }
    return status;
  }
}

cpu_type_t set_exec_affinity(cpu_type_t new_cputype)
{
  cpu_type_t ret;
  cpu_type_t* newp = 0;
  size_t size = sizeof(cpu_type_t);
  
  if (new_cputype != 0) newp = &new_cputype;
  if (sysctlbyname("sysctl.proc_exec_affinity", &ret, &size, newp, newp ? size : 0) == -1) {
    fprintf(stderr, "sysctlbyname failed: %s\n", strerror(errno));
    return -1;
  }
  return ret;
}
