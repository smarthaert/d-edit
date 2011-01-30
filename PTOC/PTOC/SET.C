#include "ptoc.h"

set setof(int param1,...) {  
    set s = {{0}};
    SetElemType elem = param1;
    boolean interval = false;
    int param = param1;
    va_list ap;
    unsigned i;
    
    va_start(ap, param1);
    
    while (param != eos) {

	if (interval) {
	    unsigned low  = (SetElemType)elem;
	    unsigned high = (SetElemType)param;
	    unsigned lowindex  = low / BITS_PER_WORD;
	    unsigned highindex = high / BITS_PER_WORD;
    
	    if(lowindex == highindex) {
		s.setarray[lowindex] |= ((1L << (high-low+1)) - 1) 
		    << (low % BITS_PER_WORD); 
	    } else {
		s.setarray[lowindex] |=  ALL_BITS_SET << (low % BITS_PER_WORD);
		
		for(i = lowindex+1; i < highindex; i++)
		    s.setarray[i] = ALL_BITS_SET;
		
		s.setarray[highindex] = (1L << ((high+1) % BITS_PER_WORD)) - 1;
	    }    
	    interval = false;
	    elem = param; 
	}  else if(param == INTERVAL_MARKER) { 
	    interval = true;
	} else { /* single value */
	    elem = param; 
	    s.setarray[(unsigned)elem / BITS_PER_WORD] 
		|= 1L << ((unsigned)elem % BITS_PER_WORD); 
	}
	param = va_arg(ap, int);         
    }
    va_end(ap);
    return s;
}

set join(set a, set b) { 
    set c;
    unsigned i;

    for(i = 0; i < SET_LENGTH; i++)
        c.setarray[i] = a.setarray[i] | b.setarray[i];
    return c;
}

set difference(set a, set b) {
    set c;
    unsigned i;

    for (i = 0; i < SET_LENGTH; i++)
        c.setarray[i] = a.setarray[i] & ~b.setarray[i];
    return c;      
}

set intersect(set a, set b) { 
    set c;
    unsigned i;

    for (i = 0; i < SET_LENGTH; i++)
        c.setarray[i] = a.setarray[i] & b.setarray[i];
    return c;
}

boolean equivalent(set a, set b) { 
    unsigned i;

    for (i = 0; i < SET_LENGTH; i++)
         if (a.setarray[i] != b.setarray[i]) return false;
    return true;
}

boolean subset(set a, set b) { 
    unsigned i;

    for (i = 0; i < SET_LENGTH; i++)
         if (a.setarray[i] & ~b.setarray[i]) return false;
    return true;
}

boolean inset(SetElemType elem, set s) { 
    return (s.setarray[(unsigned)elem / BITS_PER_WORD] & 
                    (1L << ((unsigned)elem % BITS_PER_WORD))) != 0;
}

