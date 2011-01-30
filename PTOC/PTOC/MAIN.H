#ifndef __MAIN_H__
#define __MAIN_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <ctype.h>

#define items(a) (sizeof(a) / sizeof(*(a)))

#define bool int
#ifndef TRUE
  #define TRUE 1
  #define FALSE 0
#endif


// Some declarations 

extern bool language_c; 
extern bool no_array_assign_operator;
extern bool compile_system_library; 
extern bool small_enum;
extern bool unsigned_comparison; 
extern bool nological;

#define CALL_GRAPH_FILE     "call.grp"
#define RECURSIVE_PROC_FILE "recur.prc"
#define CONFIG_FILE         "ptoc.cfg"

extern bool  use_call_graph;
extern bool  pio_init;
extern bool  short_set; 
extern FILE* call_graph_file;
bool is_recursive_proc(const char* name); 

void scanner_input(char *file); 

class memory_allocator { 
  private:
    size_t   free;
    char*    ptr;
  public:
    void* alloc(size_t size) { 
	const int alloc_quant = 8;
	const int alloc_block = 1024*1024;
	
	size = (size + alloc_quant - 1) & ~(alloc_quant - 1);
	if (size > free) { 
	    free = (alloc_block < size) ? size : alloc_block; 
	    ptr = (char*)malloc(free);
	}
	free -= size;
	void* t = (void*)ptr;
	ptr += size;
	return t; 
    }
    memory_allocator() { free = 0; }
};

extern memory_allocator heap;

class heap_object { 
  public: 
    void* operator new(size_t size) { return heap.alloc(size); }
}; 

#endif

