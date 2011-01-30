
// -*- C++ -*-
// Binding rings (lists actually)
#ifndef __BRING_H__
#define __BRING_H__

#include "main.h"

class b_ring;
class tpexpr;

// Element of binding contour: variable, type or label
class symbol : public heap_object {
  public:
    symbol	*next;
    nm_entry 	*in_name;
    nm_entry    *out_name;        
    char        *path;     // path to component in structure    
    b_ring	*ring;
    enum {
      s_var,    // variable
      s_ref,    // reference 
      s_const,  // constant
      s_type,   // type
      s_proc,   // procedure
      s_label,  // label   
      s_dummy   // dummy symbol, used only to preserve name in namespace 
    };
    int		tag;

    enum {
        f_used 		= 0x01, // 
	f_defined	= 0x02, // 
        f_parameter     = 0x04, // variable is procedure or function parameter 
	f_exported      = 0x08, // variable is accessed by nexted function
	f_static        = 0x10, // variable is static
	f_syslib        = 0x20, // symbol from system library        
	f_const         = 0x40  // integer constant is stored in "value"
    };
    int	        flags;
    int         value;  
    tpexpr	*type;

    void translate(token* t);
};

// Binding contour
class b_ring {
  public:
    b_ring(int scope);

    b_ring	*outer;
    symbol	*syms;
    symbol      *with; // WITH variable for RECORD ring  

    // Kinds of binding contours
    enum {
	block, record, proc, global
    };

    int    scope;

    static b_ring global_b_ring;
    static b_ring *curr_b_ring;

    static void push(b_ring* r) {
	r->outer = curr_b_ring;
	curr_b_ring = r;
    }

    static void pop() {
        curr_b_ring = curr_b_ring->outer;
    }

    symbol* search(nm_entry* nm);
    symbol* add(nm_entry* name, int tag, tpexpr* type);

    static symbol* search_cur(nm_entry* nm) { return curr_b_ring->search(nm); }
    static symbol* add_cur(nm_entry* name, int tag, tpexpr* type)
      { return curr_b_ring->add(name, tag, type); }

    void make_unique(symbol* s);
    void make_vars_static(); 
};

class rename_item { 
  protected:
    static rename_item* list;

    rename_item* next; 
    nm_entry*    nm_old;
    nm_entry*    nm_new;
    
  public:
    static void add(nm_entry *nm_new, nm_entry *nm_old) {
	rename_item* item = new rename_item;
	item->nm_new = nm_new;
	item->nm_old = nm_old;
	item->next = list;
	list = item;
    }
    static nm_entry* rename(nm_entry* name) { 
	for (rename_item *item = list; item != NULL; item = item->next) { 
	    if (item->nm_old == name) return item->nm_new;
	}
	return name;
    }
};

#endif
