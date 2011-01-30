%{

#include "token.h"
#include "util.h"

#ifdef __unix__
#include <unistd.h>
#else
#include <io.h>
#endif

#define yywrap() 1
#define YY_SKIP_YYWRAP 1

// Some static data definition

static char *file_name;                  
static int line, pos;    // Token position
extern char *i_path;

struct scan_state { 
    int             pos;
    int             line;
    char*           file_name;
    char*           search_path; 
    FILE*           input;
    YY_BUFFER_STATE buffer; 
};

#define MAX_INCLUDE_DEPTH 64   // Include stack depth

class scan_ctx { 
  protected: 
    scan_state      stack[ MAX_INCLUDE_DEPTH ];
    int             sp;

  public:
    void push();
    void attach(char* name, FILE* in);
    void pop(); 
    bool empty() { return sp == 0; }
    bool find(char* name) ; 
    scan_ctx() { sp = 0; }
};
    
static scan_ctx scanner; 

void scanner_input(char *file) 
{
    FILE* f = fopen (file, "r");
	
    if (f == NULL) { 
	error("can't open input source file: %s", file); 
    }
    scanner.attach(file, f);
}



// Hints for macro functionality (inherited from rtl2c)
static nm_entry *nm = NULL;	       // Token name
static char *text   = NULL;            // Token text if != NULL

#undef  ECHO
#define ECHO 

// Token generator function

int tkn (int tag) {
   curr_token = new token(text ? text : strdup(yytext),
			  tag, line, pos, nm);
   nm = NULL; text = NULL;
   for (char *c = yytext; *c != 0; c++) {
       if (*c == '\n') { line++; pos = 0; }
       else if (*c == '\t') { pos += TAB_WIDTH - (pos % TAB_WIDTH); }
       else pos++;
   }
   curr_token->fname = file_name; 
   return 1;
}



// Include file name processing

static char *include_name (char *src) {
    char *t;
    char *name = new char[strlen(src)+8]; 
    char *dst = name;
    if (strchr(src, '\n') != NULL) { 
        line += 1;
        pos = 0;
    }
    while (*src == '\'' || isspace(*src)) src++;        // Skip leading '[ ]
    if ((t = strchr (src, '[')) != NULL) {
#if 0
        int gid, uid, n;
        if (sscanf(t, "[%d,%d]%n", &gid, &uid, &n) == 2) { 
            dst += sprintf(dst, "../%03d%03d/", gid, uid);
	    src = t + n;
        } 
	else 
#endif
	{ 
	    if ((t = strrchr(src, ']')) != NULL) { 
	        src = t+1;
            }
        }
    }	   
    bool suffix = FALSE;
    while(*src && !isspace(*src) && *src != ';' && *src != '\'' && *src!='\n')
    {
        if (*src == '.') suffix = TRUE;
	*dst++ = tolower(*src++); 
    } 
    *dst = 0;
    if (!suffix) strcpy(dst, ".pas");
 
    if (scanner.find(name)) {
	error(line, pos, file_name, "file %s already included !\n", name); 
    }
    return name; 
}

static int yyinput(void);

inline int yyinput_file() { 
    int ch = yyinput(); 
    if (ch == '\n') { line++; pos = 0; }
    else if (ch == '\t') { pos += TAB_WIDTH - (pos % TAB_WIDTH); }
    else pos++;
    return ch;
}     

static int process_comments() { 
    static int cmt_buf_len = 256;
    static char* cmt_buf = new char[cmt_buf_len];
    int c, pc = 0;
    char *p = cmt_buf;
    char cmt_start = *yytext;
    *p++ = '/';
    *p++ = '*';

    curr_token = new token(NULL, TKN_CMNT, line, pos);

    pos += strlen(yytext);

    while( (c = yyinput_file()) != EOF ) {  
	if (c == '*' && cmt_start == '{') continue;
        cmt_start = 0;
        if (c == '/' && pc == '*') c = ' ';  
	if (p == cmt_buf + cmt_buf_len) {
	    cmt_buf = (char*)realloc(cmt_buf, 2*cmt_buf_len);
	    p = cmt_buf + cmt_buf_len;
	    cmt_buf_len *= 2;
	}
	if (c == '}' || (c == ')' && pc == '*')) { 
	    size_t len = p - cmt_buf;
	    text = new char[len + 3];
	    memcpy(text, cmt_buf, len);      
            if (pc != '*') text[len++] = '*';
	    text[len++] = '/';
	    text[len] = '\0';
	    curr_token->in_text = curr_token->out_text = text;
	    text = NULL;
	    return 1;
	} 
	*p++ = pc = c;
    }
    error(line, pos, file_name, "EOF in comment !\n");
    return -1;
}

%}

ID           [_\$A-Z][_\$A-Z0-9]*

DIGIT        [0-9]
BINDIGIT     [0-1]
OCTDIGIT     [0-7]
HEXDIGIT     [0-9A-F]

SIGN         [+-]?
EXPONENT     E{SIGN}{DIGIT}+

REAL         {DIGIT}+\.{DIGIT}+{EXPONENT}?|{DIGIT}+{EXPONENT}         

ROOT         {DIGIT}\#|{DIGIT}{DIGIT}\#

INTEGER      {DIGIT}+|{ROOT}{HEXDIGIT}+|{DIGIT}+B


/* the "incl" state is used for picking up the name
 * of an include file
 */
%x incl

%%

\%include     BEGIN(incl);


<incl>[ \t\n]* {  /* eat the whitespace */
    char* p = yytext; 
    while(*p != '\0') { 
	if (*p++ == '\n') line += 1; 
    } 
}
<incl>[^\;\n]+\;* { 
                  /* got the include file name */
    BEGIN(INITIAL);     // To leave include state
    
    char *fname = include_name (yytext);
    char *xname;
    FILE *in = NULL;
    char *try_dir, *next_dir;
    int dir_length;
    
    for (try_dir = i_path; try_dir != NULL; try_dir = next_dir) {
	if ((next_dir = strchr (try_dir, ':')) != NULL ) {
	    dir_length = next_dir - try_dir;
	    next_dir++; 
	} else {
	    dir_length = strlen (try_dir);
	}
	xname = dprintf ("%.*s/%s", dir_length, try_dir, fname);
	if ((in = fopen(xname, "r")) != NULL) {
	    scanner.push();
	    scanner.attach(xname, in);
	    curr_token = new token(xname, TKN_PUSH_FILE);
	    curr_token->out_text = fname; 
	    return 1;
	}
    }
    warning(line, pos, file_name, "can't include file %s", fname);
    curr_token = new token(dprintf("/*#include \"%s\"*/", fname),
	                   TKN_CMNT, line, pos);
    return 1;
}
<incl>.  { 
    error(line, pos, file_name, "unrecognized tocken: %s\n",
		yytext); 
}


<<EOF>>      {
    if (scanner.empty()) { 
	return -1;  // MAGIC ! (< 0 means end of files)
    } else {
	scanner.pop();
	curr_token =  new token((char*)NULL, TKN_POP_FILE);
	return 1;
    }
}

"(*"        { return process_comments(); }
"{"         { return process_comments(); }

"("         { return tkn(TKN_LPAR); }
")"         { return tkn(TKN_RPAR); }
"(."        { text = "["; return tkn(TKN_LBR);  }
".)"        { text = "]"; return tkn(TKN_RBR);  }
"["         { return tkn(TKN_LBR);  }
"]"         { return tkn(TKN_RBR);  }
"*"         { return tkn(TKN_MUL);  }
"+"         { return tkn(TKN_PLUS); }
"-"         { return tkn(TKN_MINUS);}
","         { return tkn(TKN_COMMA);}
"."         { return tkn(TKN_DOT);  }
".."        { return tkn(TKN_DOTS); }
"/"         { return tkn(TKN_DIVR);  }
"@"         { return tkn(TKN_HEAP); }
"^"         { return tkn(TKN_HEAP); }
":="        { return tkn(TKN_LET);  }
":"         { return tkn(TKN_COLON);}
";"         { return tkn(TKN_SEMICOLON); }
"<="        { return tkn(TKN_LE);  }
">="        { return tkn(TKN_GE);  }
"<"         { return tkn(TKN_LT);  }
">"         { return tkn(TKN_GT);  }
"="         { return tkn(TKN_EQ);  }
"<>"        { return tkn(TKN_NE);  }


{REAL}       { return tkn(TKN_RCONST); }
{INTEGER}    { return tkn(TKN_ICONST);  } 

{ID}         { 
	       char *p = yytext; 
	       while (*p) { *p = tolower(*p); p += 1; }

               nm = nm_entry::add(yytext, TKN_IDENT); 
	       int tag = nm->tag;

	       if (tag == TKN_RESERVED) { 
	           text = dprintf("%s_", yytext);      
		   nm = nm_entry::add(text, TKN_IDENT); 
		   tag = TKN_IDENT;
               }
	       return tkn(tag);
             }  


\'([^\']|\'\')*\' { return tkn(TKN_SCONST); }  

[ \t\f]+     { return tkn(TKN_SPACE); }   

[\n]         { return tkn(TKN_LN); } 

.            { 
                error(line, pos, file_name, "unrecognized tocken: %s\n",
		      yytext); 
             }
  
%%

void scan_ctx::push() { 
    assert(sp < MAX_INCLUDE_DEPTH);
    stack[sp].file_name = file_name;
    stack[sp].buffer = YY_CURRENT_BUFFER;
    stack[sp].search_path = i_path;
    stack[sp].pos = pos;
    stack[sp].line = line;
    stack[sp].input = yyin;
    sp += 1;
}


void scan_ctx::attach(char* name, FILE* in) { 
    pos = 0;
    line = 1;
    file_name = name;
    yyin = in;
    char* base_name = strrchr(name, '/');
    if (base_name != NULL) { 
	i_path = dprintf("%.*s:%s", base_name-name, name, i_path);
    }
    yy_switch_to_buffer(yy_create_buffer(yyin, YY_BUF_SIZE));
}

void scan_ctx::pop() { 
    assert(sp > 0);
    sp -= 1;
    pos = stack[sp].pos;
    line = stack[sp].line;
    file_name = stack[sp].file_name;
    yyin = stack[sp].input;
    i_path = stack[sp].search_path;
    yy_switch_to_buffer(stack[sp].buffer);
}

bool scan_ctx::find(char* name) { 
    for (int i = 0; i < sp; i ++ ) { 
	if (strcmp(stack[i].file_name, name) == 0) { 
	    return TRUE;
	}
    }
    return FALSE;
}

