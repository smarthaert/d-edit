#include <string.h>
#include <stdlib.h>

#include "main.h"
#include "nmtbl.h"
#include "token.h"
#include "trnod.h"
#include "util.h"

extern int zzparse();

static void load_predefined() 
{ 
    b_ring::add_cur(nm_entry::add("integer", TKN_IDENT), 
				  symbol::s_type, 
				  &integer_type);
    b_ring::add_cur(nm_entry::add("real", TKN_IDENT), 
				  symbol::s_type, 
				  &real_type);
    b_ring::add_cur(nm_entry::add("boolean", TKN_IDENT), 
				  symbol::s_type, 
				  &bool_type);
    b_ring::add_cur(nm_entry::add("char", TKN_IDENT),
				  symbol::s_type, 
				  &char_type);
    b_ring::add_cur(nm_entry::add("text", TKN_IDENT), 
				  symbol::s_type, 
				  &text_type);
    b_ring::add_cur(nm_entry::add("zero_terminated_string", TKN_IDENT), 
				  symbol::s_type, 
				  &string_type);
    b_ring::add_cur(nm_entry::add("true", TKN_IDENT), 
				  symbol::s_const, 
				  &bool_type);
    b_ring::add_cur(nm_entry::add("false", TKN_IDENT), 
				  symbol::s_const, 
				  &bool_type);
    b_ring::add_cur(nm_entry::add("nil", TKN_IDENT), 
				  symbol::s_const, 
				  &void_type);
}

static void load_keywords() 
{ 
    for (int tag = 0; tag < TKN_LAST; tag ++ )  {
	if (token::token_cat[tag] == CAT_ID ||
	    token::token_cat[tag] == CAT_KWD) 
	{
	    nm_entry::add(token::token_name[tag], tag); 
	}
    }
}

#define MAX_NAME_LEN 1024

static void load_configuration(char* name) { 
    FILE* cfg = fopen(name, "r");
    if (cfg != NULL) { 
	char buf[MAX_NAME_LEN];

	while (fscanf(cfg, "%s", buf) == 1) { 
	    if (strcmp(buf, "#begin(reserved)") == 0) { 
		while (fscanf(cfg, "%s", buf) == 1 
		       && strcmp(buf, "#end(reserved)") != 0) 
		{
		    nm_entry::add(buf, TKN_RESERVED);
                }
	    } else if(strcmp(buf, "#begin(macro)") == 0) { 
		while (fscanf(cfg, "%s", buf) == 1 
		       && strcmp(buf, "#end(macro)") != 0) 
		{
		    nm_entry::add(buf, TKN_IDENT)->flags |= nm_entry::macro;
		}
	    } else if(strcmp(buf, "#begin(library)") == 0) { 
		while (fscanf(cfg, "%s", buf) == 1 
		       && strcmp(buf, "#end(library)") != 0) 
		{
		    b_ring::global_b_ring.add(nm_entry::add(buf, TKN_IDENT),
					  symbol::s_dummy, 
					  NULL);
		}
	    } else if(strcmp(buf, "#begin(rename)") == 0) { 
		while (fscanf(cfg, "%s", buf) == 1 
		       && strcmp(buf, "#end(rename)") != 0) 
		{
		    nm_entry* nm_old = nm_entry::add(buf, TKN_IDENT);
		    fscanf(cfg, "%s", buf);
		    nm_entry* nm_new = nm_entry::add(buf, TKN_IDENT);
		    rename_item::add(nm_new, nm_old);
		}
	    }
	}
	fclose(cfg);
    } else { 
	fprintf(stderr, "Can't open configuration file '%s'\n", 
		name);
    }
}


char *i_path;
char *input_file;
char *output_file;
char *output_suf;
char *prog_path;
bool  output_not_existed_hdr;
bool  no_array_assign_operator;
bool  language_c;
bool  compile_system_library;
bool  pio_init;
bool  use_call_graph;
bool  short_set; 
bool  unsigned_comparison;
bool  small_enum; 
bool  nological;

FILE *call_graph_file;

static void scan_opt (int argc, char **argv) {
    static struct opt_str {
	bool *flag;
	char **value;
	char *str;
        char *defval; 
	char *comment;
    } opt[] = {

//      Add command options to this table:

	{ NULL, &i_path, "-I", ".", 
	  "Include path (colon separated directory list)" },
	{ NULL, &input_file, "-in", NULL, 
	  "Input pascal file" },
	{ NULL, &output_file, "-out", NULL, 
	  "Output C/C++ file" },
	{ NULL, &output_suf, "-suf", ".cxx",
	  "Output C/C++ file suffix" },
	{ &language_c, NULL, "-c", NULL,
	  "Translate into ANSI C" },
	{ &no_array_assign_operator, NULL, "-assign", NULL,
	  "Do not use assignment operators for array" },
	{ &use_call_graph, NULL, "-analyze", NULL,
	  "Analyze call graph to find non-recursive functions" },
	{ &short_set, NULL, "-intset", NULL,
	  "Use integer types for short sets of enumerations" },
	{ &pio_init, NULL, "-init", NULL,
	  "Call pio_initialize() function from main()" },
	{ &small_enum, NULL, "-smallenum", NULL,
	  "Use for enumerated types as small bytes as possible" },
	{ &unsigned_comparison, NULL, "-unsigned", NULL,
	  "Generate correct code for sign/unsigned comparisons" },
	{ &output_not_existed_hdr, NULL, "-h", NULL,
	  "Output only not existed header files" },
	{ &nological, NULL, "-nological", NULL,
	  "Use | and & instead of || and && for boolean operations" },

    };
    for (unsigned j = 0; j < (sizeof(opt)/sizeof(opt_str)); j++) {
	if (opt[j].value != NULL) { 
 	    *opt[j].value = opt[j].defval;
        }
	if (opt[j].flag != NULL) { 
	    *(opt[j].flag) = FALSE; // Switch off flags
        }
    }
    for (int i = 1; i < argc; i++) { // Skipping program name
	bool found = FALSE;
	for (unsigned j = 0; j < (sizeof(opt)/sizeof(opt_str)); j++) {
	    if (strcmp (opt[j].str, argv[i]) == 0) { 
		if (opt[j].flag != NULL) { 
	            *(opt[j].flag) = TRUE;
                } 
		if (opt[j].value != NULL) { 
		    i++; 
		    if (i >= argc) {
			fprintf(stderr, "Value for option '%s' is not specified\n", opt[j].str);
			goto Help;
		    }
		    *opt[j].value = argv[i];
		}
		found = TRUE;
		break;
	    }
	}
	if (!found) { 
 	  Help:
	    fprintf (stderr, "Pascal to C++ converter\n"
			     "Available options are:\n");

	    for (unsigned j = 0; j < (sizeof(opt)/sizeof(opt_str)); j++ ) {
		if (opt[j].defval != NULL) { 
		    char buf[256];
		    sprintf(buf, "%s [%s]", opt[j].str, opt[j].defval);
		    fprintf(stderr, "\t%-16s", buf); 
 		} else { 
		    fprintf(stderr, "\t%-16s", opt[j].str); 
		}
	   	fprintf(stderr, "%s\n", opt[j].comment); 
	    }
	    exit (1);
	}
    }
#ifdef __unix__
    char* p = strrchr(argv[0], '/');
    prog_path = (p != NULL) ? dprintf("%.*s", p + 1 - argv[0], argv[0]) : ""; 
#else
    char* p = strrchr(argv[0], '\\');
    prog_path = (p != NULL) ? dprintf("%.*s", p + 1 - argv[0], argv[0]) : ""; 
#endif
}

int main(int argc, char* argv[]) 
{ 
    scan_opt (argc, argv);

    if (input_file == NULL) { 
	fputs("Input file was not specified\n", stderr);
        exit(1); 
    } 
    if (output_file == NULL) { 
	char* ext = strrchr(input_file, '.');
        int file_name_len = ext ? ext - input_file : strlen(input_file); 
	if (language_c) output_suf = ".c";
	output_file = dprintf("%.*s%s", file_name_len, input_file, output_suf);  
    } 
    load_predefined(); 
    load_keywords();
    load_configuration(dprintf("%s%s", prog_path, CONFIG_FILE));

    if (use_call_graph) { 
	call_graph_file = fopen(CALL_GRAPH_FILE, "a");
	FILE* f = fopen(RECURSIVE_PROC_FILE, "r");
	if (f != NULL) { 
	    char name[256];
	    while (fscanf(f, "%s", name) == 1) { 
		nm_entry::add(name, TKN_IDENT)->flags |= nm_entry::recursive;
	    }
	    fclose(f);
	}
    }

    compile_system_library = TRUE;
    token::input(dprintf("%s%s", prog_path, "ptoc.pas")); 
    zzparse(); 

    compile_system_library = FALSE;
    token::reset();
    token::input(input_file); 
    zzparse(); 

    token::output(output_file);

    if (call_graph_file) { 
	fclose(call_graph_file);
    }
    return 0; 
}


