
/*  A Bison parser, made from parser.y with Bison version GNU Bison version 1.24
  */

#define YYBISON 1  /* Identify Bison output.  */

#define yyparse zzparse
#define yylex zzlex
#define yyerror zzerror
#define yylval zzlval
#define yychar zzchar
#define yydebug zzdebug
#define yynerrs zznerrs
#define	ARRAY	258
#define	BEGIN	259
#define	CASE	260
#define	CONST	261
#define	DO	262
#define	DOTS	263
#define	ELSE	264
#define	END	265
#define	FIL	266
#define	FOR	267
#define	FUNCTION	268
#define	GOTO	269
#define	IDENT	270
#define	ICONST	271
#define	IF	272
#define	LABEL	273
#define	LET	274
#define	LOOPHOLE	275
#define	OF	276
#define	ORIGIN	277
#define	OTHERWISE	278
#define	PACKED	279
#define	PROCEDURE	280
#define	PROGRAM	281
#define	RCONST	282
#define	READ	283
#define	RECORD	284
#define	REPEAT	285
#define	RETURN	286
#define	SET	287
#define	SCONST	288
#define	THEN	289
#define	TO	290
#define	TYPE	291
#define	UNTIL	292
#define	VAR	293
#define	WHILE	294
#define	WITH	295
#define	WRITE	296
#define	EQ	297
#define	NE	298
#define	LT	299
#define	LE	300
#define	GT	301
#define	GE	302
#define	IN	303
#define	PLUS	304
#define	MINUS	305
#define	OR	306
#define	MOD	307
#define	DIV	308
#define	DIVR	309
#define	MUL	310
#define	AND	311
#define	UPLUS	312
#define	UMINUS	313
#define	NOT	314

#line 1 "parser.y"


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

#include "nmtbl.h"
#include "token.h"
#include "trnod.h"
#include "util.h"

static int zzcnv_table[] = {
#define DEF_TOKEN(mnem, cat, cls, yacc) yacc,
#include "token.dpp"
};


void zzerror(char* text) 
{
    error(curr_token, "syntax error: %s", text); 
}


#line 27 "parser.y"
typedef union {
    token                *tok;

    token_list           *toks; 

    node                 *n_node;
    tpd_node             *n_tpd;
    block_node           *n_block; 
    stmt_node            *n_stmt; 
    decl_node            *n_decl; 
    expr_node            *n_expr; 
    expr_group_node      *n_grp; 

    write_param_node     *n_wrtp; 
    write_list_node      *n_wrls; 
    case_node            *n_case; 
    set_item_node        *n_item; 

    const_def_node       *n_cdef; 
    type_def_node        *n_tdef; 
    var_decl_node        *n_vdcl; 

    param_list_node      *n_plist; 
    idx_node             *n_idx; 

    field_list_node      *n_fldls;
    variant_part_node    *n_varp;
    selector_node        *n_sel; 
    variant_node         *n_vari;
    compound_node        *n_comp;
   
    import_list_node     *n_imp; 
} YYSTYPE;

#ifndef YYLTYPE
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;

#define YYLTYPE yyltype
#endif

#include <stdio.h>

#ifndef __cplusplus
#ifndef __STDC__
#define const
#endif
#endif



#define	YYFINAL		342
#define	YYFLAG		-32768
#define	YYNTBASE	69

#define YYTRANSLATE(x) ((unsigned)(x) <= 314 ? yytranslate[x] : 138)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,    46,
    47,     2,     2,    43,     2,    42,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,    44,    45,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
    48,     2,    49,    50,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     1,     2,     3,     4,     5,
     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
    16,    17,    18,    19,    20,    21,    22,    23,    24,    25,
    26,    27,    28,    29,    30,    31,    32,    33,    34,    35,
    36,    37,    38,    39,    40,    41,    51,    52,    53,    54,
    55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
    65,    66,    67,    68
};

#if YYDEBUG != 0
static const short yyprhs[] = {     0,
     0,     2,     4,     6,     9,    16,    18,    24,    25,    29,
    33,    35,    38,    39,    42,    44,    46,    48,    50,    52,
    54,    55,    59,    62,    68,    73,    80,    89,    94,    99,
   102,   105,   107,   109,   114,   118,   120,   124,   126,   130,
   131,   133,   134,   138,   140,   144,   149,   150,   152,   156,
   160,   162,   166,   170,   174,   178,   182,   186,   190,   194,
   198,   202,   206,   210,   214,   218,   222,   224,   227,   230,
   233,   235,   239,   244,   248,   251,   256,   263,   265,   267,
   269,   273,   275,   276,   278,   282,   284,   288,   290,   294,
   296,   300,   302,   303,   307,   309,   313,   315,   319,   325,
   329,   331,   335,   338,   339,   343,   347,   350,   351,   355,
   359,   362,   363,   365,   369,   373,   379,   383,   389,   396,
   405,   412,   421,   427,   428,   432,   434,   438,   441,   443,
   445,   449,   451,   453,   455,   457,   459,   461,   463,   465,
   467,   469,   471,   479,   487,   495,   499,   503,   506,   511,
   516,   521,   522,   524,   526,   530,   536,   538,   542,   544,
   548,   551,   553,   555,   560,   564,   566,   568,   571,   575
};

static const short yyrhs[] = {    70,
     0,    71,     0,    72,     0,    75,    42,     0,    26,    15,
    73,    45,    75,    42,     0,    76,     0,    26,    15,    73,
    45,    76,     0,     0,    46,    74,    47,     0,    15,    43,
    74,     0,    15,     0,    76,    79,     0,     0,    77,    76,
     0,    98,     0,   100,     0,   103,     0,   106,     0,   111,
     0,   110,     0,     0,    88,    19,    86,     0,    14,    16,
     0,     5,    86,    21,    83,    10,     0,    17,    86,    34,
    78,     0,    17,    86,    34,    78,     9,    78,     0,    12,
    15,    19,    86,    35,    86,     7,    78,     0,    39,    86,
     7,    78,     0,    30,    80,    37,    86,     0,    41,    82,
     0,    28,    81,     0,    88,     0,    31,     0,    40,    92,
     7,    78,     0,    16,    44,    78,     0,    79,     0,     4,
    80,    10,     0,    78,     0,    78,    45,    80,     0,     0,
    95,     0,     0,    46,    96,    47,     0,    84,     0,    84,
    23,    78,     0,    84,    23,    78,    45,     0,     0,    85,
     0,    85,    45,    84,     0,    92,    44,    78,     0,    87,
     0,    86,    58,    86,     0,    86,    59,    86,     0,    86,
    61,    86,     0,    86,    64,    86,     0,    86,    62,    86,
     0,    86,    63,    86,     0,    86,    65,    86,     0,    86,
    60,    86,     0,    86,    55,    86,     0,    86,    53,    86,
     0,    86,    54,    86,     0,    86,    56,    86,     0,    86,
    51,    86,     0,    86,    52,    86,     0,    86,    57,    86,
     0,    88,     0,    58,    87,     0,    59,    87,     0,    68,
    87,     0,    89,     0,    46,    92,    47,     0,    88,    46,
    93,    47,     0,    88,    42,    15,     0,    88,    50,     0,
    88,    48,    92,    49,     0,    20,    46,   117,    43,    86,
    47,     0,    16,     0,    27,     0,    33,     0,    48,    90,
    49,     0,    15,     0,     0,    91,     0,    91,    43,    90,
     0,    86,     0,    86,     8,    86,     0,    86,     0,    86,
    43,    92,     0,    94,     0,    94,    43,    93,     0,    86,
     0,     0,    46,    92,    47,     0,    97,     0,    97,    43,
    96,     0,    86,     0,    86,    44,    86,     0,    86,    44,
    86,    44,    86,     0,    18,    99,    45,     0,    16,     0,
    16,    43,    99,     0,     6,   101,     0,     0,   102,    45,
   101,     0,    15,    51,    86,     0,    36,   104,     0,     0,
   105,    45,   104,     0,    15,    51,   117,     0,    38,   107,
     0,     0,   108,     0,   108,    45,   107,     0,    74,    44,
   117,     0,    15,    22,    86,    44,   118,     0,    25,    15,
   112,     0,    13,    15,   112,    44,   117,     0,    25,    15,
   112,    45,    15,    45,     0,    13,    15,   112,    44,   117,
    45,    15,    45,     0,    25,    15,   112,    45,    75,    45,
     0,    13,    15,   112,    44,   117,    45,    75,    45,     0,
    13,    15,    45,    75,    45,     0,     0,    46,   113,    47,
     0,   114,     0,   114,    45,   113,     0,    38,   115,     0,
   115,     0,   109,     0,    74,    44,   116,     0,   118,     0,
   120,     0,   118,     0,   119,     0,   125,     0,   124,     0,
   126,     0,   123,     0,   121,     0,   122,     0,    15,     0,
   127,     3,    48,   130,    49,    21,   117,     0,   127,     3,
    48,   128,    49,    21,   118,     0,   127,     3,    48,   128,
    49,    21,   120,     0,    46,    74,    47,     0,    86,     8,
    86,     0,    50,   117,     0,   127,    32,    21,   117,     0,
   127,    29,   132,    10,     0,   127,    11,    21,   117,     0,
     0,    24,     0,   129,     0,   129,    45,   128,     0,    15,
     8,    15,    44,   117,     0,   131,     0,   131,    43,   130,
     0,   118,     0,    86,     8,    86,     0,   133,   134,     0,
   133,     0,   107,     0,     5,   135,    21,   136,     0,    15,
    44,   117,     0,   117,     0,   137,     0,   137,    45,     0,
   137,    45,   136,     0,    92,    44,    46,   132,    47,     0
};

#endif

#if YYDEBUG != 0
static const short yyrline[] = { 0,
   224,   229,   229,   231,   232,   237,   238,   244,   245,   247,
   248,   250,   255,   256,   258,   258,   258,   258,   259,   259,
   288,   289,   290,   291,   292,   293,   295,   297,   298,   299,
   300,   301,   302,   303,   304,   305,   307,   309,   309,   310,
   310,   312,   313,   315,   316,   327,   339,   340,   341,   343,
   367,   368,   369,   370,   371,   372,   373,   375,   376,   378,
   379,   380,   381,   382,   383,   384,   386,   387,   389,   391,
   394,   395,   396,   397,   398,   399,   400,   402,   403,   404,
   405,   406,   408,   409,   410,   412,   413,   415,   415,   417,
   418,   420,   420,   423,   426,   426,   428,   429,   430,   472,
   475,   476,   478,   481,   482,   484,   486,   489,   490,   492,
   494,   497,   498,   499,   501,   502,   505,   508,   512,   515,
   518,   521,   523,   526,   527,   529,   530,   532,   533,   533,
   535,   537,   537,   543,   543,   543,   543,   543,   544,   544,
   544,   546,   548,   551,   553,   556,   558,   561,   563,   565,
   568,   570,   570,   572,   573,   575,   578,   578,   581,   582,
   585,   588,   591,   593,   598,   599,   602,   603,   604,   606
};

static const char * const yytname[] = {   "$","error","$undefined.","ARRAY",
"BEGIN","CASE","CONST","DO","DOTS","ELSE","END","FIL","FOR","FUNCTION","GOTO",
"IDENT","ICONST","IF","LABEL","LET","LOOPHOLE","OF","ORIGIN","OTHERWISE","PACKED",
"PROCEDURE","PROGRAM","RCONST","READ","RECORD","REPEAT","RETURN","SET","SCONST",
"THEN","TO","TYPE","UNTIL","VAR","WHILE","WITH","WRITE","'.'","','","':'","';'",
"'('","')'","'['","']'","'^'","EQ","NE","LT","LE","GT","GE","IN","PLUS","MINUS",
"OR","MOD","DIV","DIVR","MUL","AND","UPLUS","UMINUS","NOT","translation","input_file",
"program","module","prog_param_list","ident_list","block","decl_part_list","decl_part",
"statement","compoundst","sequence","actual_params","write_params","case_list",
"case_items","case_item","expr","simple_expr","primary","constant","set_elem_list",
"set_elem","expr_list","act_param_list","act_param","expr_group","write_list",
"write_param","label_decl_part","label_list","const_def_part","const_def_list",
"const_def","type_def_part","type_def_list","type_def","var_decl_part","var_decl_list",
"var_decl","proc_decl","proc_fwd_decl","proc_def","formal_params","formal_param_list",
"formal_param","param_decl","param_type","type","simple_type","array_type","conformant_array_type",
"enum_type","range_type","pointer_type","set_type","record_type","file_type",
"packed","conformant_indices","conformant_index","indices","index_spec","field_list",
"fixed_part","variant_part","selector","variant_list","variant",""
};
#endif

static const short yyr1[] = {     0,
    69,    70,    70,    71,    71,    72,    72,    73,    73,    74,
    74,    75,    76,    76,    77,    77,    77,    77,    77,    77,
    78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
    78,    78,    78,    78,    78,    78,    79,    80,    80,    81,
    81,    82,    82,    83,    83,    83,    84,    84,    84,    85,
    86,    86,    86,    86,    86,    86,    86,    86,    86,    86,
    86,    86,    86,    86,    86,    86,    87,    87,    87,    87,
    88,    88,    88,    88,    88,    88,    88,    89,    89,    89,
    89,    89,    90,    90,    90,    91,    91,    92,    92,    93,
    93,    94,    94,    95,    96,    96,    97,    97,    97,    98,
    99,    99,   100,   101,   101,   102,   103,   104,   104,   105,
   106,   107,   107,   107,   108,   108,   109,   109,   110,   110,
   111,   111,   111,   112,   112,   113,   113,   114,   114,   114,
   115,   116,   116,   117,   117,   117,   117,   117,   117,   117,
   117,   118,   119,   120,   120,   121,   122,   123,   124,   125,
   126,   127,   127,   128,   128,   129,   130,   130,   131,   131,
   132,   132,   133,   134,   135,   135,   136,   136,   136,   137
};

static const short yyr2[] = {     0,
     1,     1,     1,     2,     6,     1,     5,     0,     3,     3,
     1,     2,     0,     2,     1,     1,     1,     1,     1,     1,
     0,     3,     2,     5,     4,     6,     8,     4,     4,     2,
     2,     1,     1,     4,     3,     1,     3,     1,     3,     0,
     1,     0,     3,     1,     3,     4,     0,     1,     3,     3,
     1,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,     3,     3,     3,     3,     3,     1,     2,     2,     2,
     1,     3,     4,     3,     2,     4,     6,     1,     1,     1,
     3,     1,     0,     1,     3,     1,     3,     1,     3,     1,
     3,     1,     0,     3,     1,     3,     1,     3,     5,     3,
     1,     3,     2,     0,     3,     3,     2,     0,     3,     3,
     2,     0,     1,     3,     3,     5,     3,     5,     6,     8,
     6,     8,     5,     0,     3,     1,     3,     2,     1,     1,
     3,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     7,     7,     7,     3,     3,     2,     4,     4,
     4,     0,     1,     1,     3,     5,     1,     3,     1,     3,
     2,     1,     1,     4,     3,     1,     1,     2,     3,     5
};

static const short yydefact[] = {    13,
   104,     0,     0,     0,     0,   108,   112,     1,     2,     3,
     0,     6,    13,    15,    16,    17,    18,    20,    19,     0,
   103,     0,   124,   101,     0,   124,     8,     0,   107,     0,
    11,     0,   111,   113,     4,    21,    12,    14,     0,   104,
    13,     0,     0,     0,   100,     0,     0,     0,   152,   108,
     0,     0,   152,   112,     0,     0,     0,    82,    78,     0,
     0,    79,    40,    21,    33,    80,     0,     0,    42,     0,
    83,    38,    36,     0,    32,    71,    78,     0,     0,     0,
   106,    51,    67,   105,     0,     0,     0,    11,     0,     0,
     0,   130,     0,   126,   129,   152,   102,    13,     0,    13,
    82,   153,     0,   152,     0,   110,   134,   135,   140,   141,
   139,   137,   136,   138,     0,   109,     0,    10,   115,   114,
     0,     0,    23,    21,     0,   152,     0,    31,    41,     0,
     0,    88,     0,     0,    30,     0,    86,     0,    84,    21,
    37,     0,     0,    93,     0,    75,    68,    69,    70,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,   123,   124,   124,   128,   152,   125,
     0,     0,     0,     0,     9,     0,     7,    82,     0,   148,
     0,     0,     0,   112,     0,     0,    47,     0,    35,    21,
     0,     0,     0,    21,     0,    21,    97,     0,    95,    72,
     0,    81,    83,    39,    22,    74,    92,     0,    90,     0,
    64,    65,    61,    62,    60,    63,    66,    52,    53,    59,
    54,    56,    57,    55,    58,     0,   117,   142,   131,   132,
   133,     0,   127,    13,   119,   121,     5,   146,   147,     0,
   152,   163,     0,   162,   152,   116,     0,    44,    48,     0,
     0,    25,     0,    94,    29,    28,    89,    34,     0,    43,
     0,    87,    85,    73,    93,    76,   152,     0,     0,     0,
     0,   159,     0,   157,   151,   150,   152,   161,   149,    24,
    21,    47,    21,     0,    21,     0,    98,    96,    91,   118,
     0,   120,   122,     0,     0,     0,    82,   166,     0,    45,
    49,    50,     0,    26,    77,     0,     0,     0,   154,   160,
   152,   158,   152,     0,    46,    21,    99,     0,     0,     0,
   143,   165,     0,   164,   167,    27,     0,   152,   155,     0,
   168,   152,   144,   145,   112,   169,   156,     0,   170,     0,
     0,     0
};

static const short yydefgoto[] = {   340,
     8,     9,    10,    48,    32,    11,    86,    13,    72,    73,
    74,   128,   135,   247,   248,   249,   105,    82,    83,    76,
   138,   139,   136,   208,   209,   129,   198,   199,    14,    25,
    15,    21,    22,    16,    29,    30,    17,   242,    34,    92,
    18,    19,    43,    93,    94,    95,   229,   106,   107,   108,
   231,   109,   110,   111,   112,   113,   114,   115,   308,   309,
   273,   274,   243,   244,   278,   299,   324,   325
};

static const short yypact[] = {    29,
     0,    19,    21,    33,    36,    44,    46,-32768,-32768,-32768,
    30,    73,    32,-32768,-32768,-32768,-32768,-32768,-32768,    40,
-32768,    34,   -23,    35,    49,    51,    53,    56,-32768,    57,
    -2,    60,-32768,    63,-32768,   517,-32768,-32768,   120,     0,
    32,    11,    66,    21,-32768,    83,    86,    88,   366,    44,
   120,    86,   366,    46,   120,   123,   125,-32768,    95,   120,
    97,-32768,   100,   517,-32768,-32768,   120,   120,   104,   120,
   120,   106,-32768,   142,    39,-32768,-32768,   120,   120,   120,
   546,-32768,    50,-32768,   110,    73,   143,   114,   145,    86,
   128,-32768,   129,   130,-32768,   366,-32768,   167,   134,    32,
   481,-32768,   416,   366,   257,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,    14,-32768,   583,-32768,-32768,-32768,
   515,   158,-32768,   517,   530,   366,   120,-32768,-32768,   147,
   176,   296,   179,   120,-32768,   140,   273,   141,   151,   517,
-32768,   120,   180,   120,   120,-32768,-32768,-32768,-32768,   120,
   120,   120,   120,   120,   120,   120,   120,   120,   120,   120,
   120,   120,   120,   120,-32768,    51,    51,-32768,    15,-32768,
    11,   146,   152,   153,-32768,   157,    73,    28,   169,-32768,
   120,   156,   196,    46,   197,   185,   120,   120,-32768,   517,
   181,   172,   120,   517,   120,   517,   605,   195,   201,-32768,
   120,-32768,   120,-32768,   546,-32768,   546,   199,   204,   174,
   148,   148,   148,   148,   148,   148,   148,   225,   225,   225,
-32768,-32768,-32768,-32768,-32768,   207,-32768,-32768,-32768,-32768,
-32768,   245,-32768,   404,-32768,-32768,-32768,-32768,   546,   430,
   366,-32768,   246,   253,   366,-32768,   250,   239,   218,   220,
   561,   259,   120,-32768,   546,-32768,-32768,-32768,   120,-32768,
   120,   546,-32768,-32768,   120,-32768,   366,   221,   226,   227,
   315,-32768,   217,   230,-32768,-32768,   380,-32768,-32768,-32768,
   517,   120,   517,   120,   517,   646,   627,-32768,-32768,-32768,
   261,-32768,-32768,   120,   256,   430,    42,-32768,   258,   229,
-32768,-32768,   242,-32768,-32768,   120,   270,   233,   238,   546,
   366,-32768,   366,   120,-32768,   517,   546,   269,   319,   261,
-32768,-32768,   247,-32768,   297,-32768,   299,    15,-32768,   295,
   120,   366,-32768,-32768,    46,-32768,-32768,   298,-32768,   344,
   346,-32768
};

static const short yypgoto[] = {-32768,
-32768,-32768,-32768,-32768,   -34,   -38,    27,-32768,  -114,    -3,
   -50,-32768,-32768,-32768,    80,-32768,   -39,    52,   -31,-32768,
   160,-32768,   -61,    99,-32768,-32768,   122,-32768,-32768,   321,
-32768,   345,-32768,-32768,   334,-32768,-32768,    -1,-32768,-32768,
-32768,-32768,   -22,   216,-32768,   301,-32768,   -52,  -167,-32768,
    61,-32768,-32768,-32768,-32768,-32768,-32768,  -158,    68,-32768,
    96,-32768,    59,-32768,-32768,-32768,    67,-32768
};


#define	YYLAST		711


static const short yytable[] = {    81,
   119,   230,    85,    46,    75,    33,   133,    91,    37,   189,
   232,   117,    99,   130,    20,   121,   182,   118,   246,    51,
   125,    41,    42,    87,   183,    88,    12,   131,   132,   228,
   132,   137,    75,    23,     1,    89,    24,     1,   102,    38,
    52,     2,   184,   172,     2,   185,     3,    26,    90,     3,
    27,   180,   120,     4,     5,    91,     4,   142,    28,   174,
    31,   176,  -142,   132,     6,   192,     7,     6,   179,     7,
    52,    35,   272,   191,   -11,   252,    36,    44,    40,   256,
   143,   258,    37,   210,   144,   313,   145,   132,   146,   204,
    39,   143,    75,    45,   197,   144,    42,   145,    47,   146,
    88,    50,   205,    53,   207,   132,    49,    54,    75,    96,
   211,   212,   213,   214,   215,   216,   217,   218,   219,   220,
   221,   222,   223,   224,   225,   250,   177,    98,   272,   147,
   148,   149,   100,   257,    58,    77,    91,   122,   124,    61,
   123,   239,   126,   226,   227,   127,    62,   132,   251,   134,
   140,   141,    66,   255,   165,   132,    52,   166,    75,   167,
   333,   262,    75,   137,    75,    70,   300,    71,   302,   232,
   304,   169,     1,    37,   171,   170,   188,    78,    79,     2,
   175,   173,   194,   193,     3,   196,   200,    80,   275,   202,
   234,     4,   279,   203,   206,   270,   235,   236,   237,   228,
   271,   326,     6,   240,     7,   157,   158,   159,   160,   161,
   162,   163,   164,   286,   290,   238,   241,   245,   254,   287,
   250,   197,   266,   253,   298,   207,   150,   151,   152,   153,
   154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
   164,   260,   132,   261,   303,   264,   265,   268,   316,    75,
   267,    75,   323,    75,   310,   276,   271,   277,   321,   280,
   322,   281,   282,   283,   181,   295,   317,   285,   291,   323,
   292,   293,   296,   315,   132,   307,   311,   318,   314,   337,
   201,   319,   320,   327,    75,   160,   161,   162,   163,   164,
   330,   132,   150,   151,   152,   153,   154,   155,   156,   157,
   158,   159,   160,   161,   162,   163,   164,   150,   151,   152,
   153,   154,   155,   156,   157,   158,   159,   160,   161,   162,
   163,   164,   294,   150,   151,   152,   153,   154,   155,   156,
   157,   158,   159,   160,   161,   162,   163,   164,   195,   328,
   335,   331,   332,   341,   339,   342,   150,   151,   152,   153,
   154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
   164,   301,   263,   289,    97,   150,   151,   152,   153,   154,
   155,   156,   157,   158,   159,   160,   161,   162,   163,   164,
   101,    77,   288,   116,    84,    61,   233,   329,   334,   102,
   168,   312,    62,   338,   297,    77,     0,   336,    66,    61,
     0,     0,     0,   102,     0,     0,    62,     0,     0,     1,
     0,   103,    66,    71,     0,   104,     2,     0,   269,     0,
     0,     3,     0,    78,    79,   103,     0,    71,     4,   104,
   178,    77,     0,    80,     0,    61,     0,    78,    79,     6,
     0,     7,    62,     0,   101,    77,     0,    80,    66,    61,
     0,     0,     0,     0,     0,     0,    62,     0,     0,     0,
     0,    70,    66,    71,     0,     0,     0,     0,     0,     0,
     0,     0,     0,    78,    79,    70,     0,    71,     0,     0,
  -142,     0,     0,    80,  -142,  -142,  -142,    78,    79,     0,
  -142,     0,     0,  -142,     0,     0,     0,    80,  -142,     0,
     0,  -142,     0,     0,     0,  -142,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,  -142,     0,  -142,     0,
    36,    55,     0,  -142,     0,  -142,     0,  -142,    56,  -142,
    57,    58,    59,    60,     0,   187,    61,     0,     0,     0,
     0,     0,     0,    62,    63,     0,    64,    65,     0,    66,
     0,     0,     0,     0,     0,    67,    68,    69,     0,     0,
     0,     0,    70,   190,    71,   150,   151,   152,   153,   154,
   155,   156,   157,   158,   159,   160,   161,   162,   163,   164,
   150,   151,   152,   153,   154,   155,   156,   157,   158,   159,
   160,   161,   162,   163,   164,   284,   150,   151,   152,   153,
   154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
   164,   150,   151,   152,   153,   154,   155,   156,   157,   158,
   159,   160,   161,   162,   163,   164,   186,     0,     0,     0,
     0,     0,     0,   150,   151,   152,   153,   154,   155,   156,
   157,   158,   159,   160,   161,   162,   163,   164,   259,     0,
     0,     0,     0,     0,     0,   150,   151,   152,   153,   154,
   155,   156,   157,   158,   159,   160,   161,   162,   163,   164,
   306,     0,     0,     0,     0,     0,     0,   150,   151,   152,
   153,   154,   155,   156,   157,   158,   159,   160,   161,   162,
   163,   164,   305,     0,     0,     0,   150,   151,   152,   153,
   154,   155,   156,   157,   158,   159,   160,   161,   162,   163,
   164
};

static const short yycheck[] = {    39,
    53,   169,    41,    26,    36,     7,    68,    42,    12,   124,
   169,    51,    47,    64,    15,    55,     3,    52,   186,    22,
    60,    45,    46,    13,    11,    15,     0,    67,    68,    15,
    70,    71,    64,    15,     6,    25,    16,     6,    24,    13,
    43,    13,    29,    96,    13,    32,    18,    15,    38,    18,
    15,   104,    54,    25,    26,    90,    25,    19,    15,    98,
    15,   100,    21,   103,    36,   127,    38,    36,   103,    38,
    43,    42,   240,   126,    47,   190,     4,    43,    45,   194,
    42,   196,    86,   145,    46,    44,    48,   127,    50,   140,
    51,    42,   124,    45,   134,    46,    46,    48,    46,    50,
    15,    45,   142,    44,   144,   145,    51,    45,   140,    44,
   150,   151,   152,   153,   154,   155,   156,   157,   158,   159,
   160,   161,   162,   163,   164,   187,   100,    45,   296,    78,
    79,    80,    45,   195,    15,    16,   171,    15,    44,    20,
    16,   181,    46,   166,   167,    46,    27,   187,   188,    46,
    45,    10,    33,   193,    45,   195,    43,    15,   190,    15,
   328,   201,   194,   203,   196,    46,   281,    48,   283,   328,
   285,    44,     6,   177,    45,    47,    19,    58,    59,    13,
    47,    15,     7,    37,    18,     7,    47,    68,   241,    49,
    45,    25,   245,    43,    15,   234,    45,    45,    42,    15,
   240,   316,    36,    48,    38,    58,    59,    60,    61,    62,
    63,    64,    65,   253,   267,    47,    21,    21,    47,   259,
   282,   261,    49,    43,   277,   265,    51,    52,    53,    54,
    55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
    65,    47,   282,    43,   284,    47,    43,     3,     7,   281,
    44,   283,   314,   285,   294,    10,   296,     5,   311,    10,
   313,    23,    45,    44,     8,    49,   306,     9,    48,   331,
    45,    45,    43,    45,   314,    15,    21,     8,    21,   332,
     8,    49,    45,    15,   316,    61,    62,    63,    64,    65,
    44,   331,    51,    52,    53,    54,    55,    56,    57,    58,
    59,    60,    61,    62,    63,    64,    65,    51,    52,    53,
    54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
    64,    65,     8,    51,    52,    53,    54,    55,    56,    57,
    58,    59,    60,    61,    62,    63,    64,    65,    43,    21,
    46,    45,    44,     0,    47,     0,    51,    52,    53,    54,
    55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
    65,   282,   203,   265,    44,    51,    52,    53,    54,    55,
    56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
    15,    16,   261,    50,    40,    20,   171,   320,   328,    24,
    90,   296,    27,   335,    15,    16,    -1,   331,    33,    20,
    -1,    -1,    -1,    24,    -1,    -1,    27,    -1,    -1,     6,
    -1,    46,    33,    48,    -1,    50,    13,    -1,    15,    -1,
    -1,    18,    -1,    58,    59,    46,    -1,    48,    25,    50,
    15,    16,    -1,    68,    -1,    20,    -1,    58,    59,    36,
    -1,    38,    27,    -1,    15,    16,    -1,    68,    33,    20,
    -1,    -1,    -1,    -1,    -1,    -1,    27,    -1,    -1,    -1,
    -1,    46,    33,    48,    -1,    -1,    -1,    -1,    -1,    -1,
    -1,    -1,    -1,    58,    59,    46,    -1,    48,    -1,    -1,
     0,    -1,    -1,    68,     4,     5,     6,    58,    59,    -1,
    10,    -1,    -1,    13,    -1,    -1,    -1,    68,    18,    -1,
    -1,    21,    -1,    -1,    -1,    25,    -1,    -1,    -1,    -1,
    -1,    -1,    -1,    -1,    -1,    -1,    36,    -1,    38,    -1,
     4,     5,    -1,    43,    -1,    45,    -1,    47,    12,    49,
    14,    15,    16,    17,    -1,    21,    20,    -1,    -1,    -1,
    -1,    -1,    -1,    27,    28,    -1,    30,    31,    -1,    33,
    -1,    -1,    -1,    -1,    -1,    39,    40,    41,    -1,    -1,
    -1,    -1,    46,    34,    48,    51,    52,    53,    54,    55,
    56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
    51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
    61,    62,    63,    64,    65,    35,    51,    52,    53,    54,
    55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
    65,    51,    52,    53,    54,    55,    56,    57,    58,    59,
    60,    61,    62,    63,    64,    65,    44,    -1,    -1,    -1,
    -1,    -1,    -1,    51,    52,    53,    54,    55,    56,    57,
    58,    59,    60,    61,    62,    63,    64,    65,    44,    -1,
    -1,    -1,    -1,    -1,    -1,    51,    52,    53,    54,    55,
    56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
    44,    -1,    -1,    -1,    -1,    -1,    -1,    51,    52,    53,
    54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
    64,    65,    47,    -1,    -1,    -1,    51,    52,    53,    54,
    55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
    65
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "/usr/local/share/bison.simple"

/* Skeleton output parser for bison,
   Copyright (C) 1984, 1989, 1990 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

#ifndef alloca
#ifdef __GNUC__
#define alloca __builtin_alloca
#else /* not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__) || defined (__sparc) || defined (__sgi)
#include <alloca.h>
#else /* not sparc */
#if defined (MSDOS) && !defined (__TURBOC__)
#include <malloc.h>
#else /* not MSDOS, or __TURBOC__ */
#if defined(_AIX)
#include <malloc.h>
 #pragma alloca
#else /* not MSDOS, __TURBOC__, or _AIX */
#ifdef __hpux
#ifdef __cplusplus
extern "C" {
void *alloca (unsigned int);
};
#else /* not __cplusplus */
void *alloca ();
#endif /* not __cplusplus */
#endif /* __hpux */
#endif /* not _AIX */
#endif /* not MSDOS, or __TURBOC__ */
#endif /* not sparc.  */
#endif /* not GNU C.  */
#endif /* alloca not defined.  */

/* This is the parser code that is written into each bison parser
  when the %semantic_parser declaration is not specified in the grammar.
  It was written by Richard Stallman by simplifying the hairy parser
  used when %semantic_parser is specified.  */

/* Note: there must be only one dollar sign in this file.
   It is replaced by the list of actions, each action
   as one case of the switch.  */

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	return(0)
#define YYABORT 	return(1)
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call yyerror.
   This remains here temporarily to ease the
   transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(token, value) \
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    { yychar = (token), yylval = (value);			\
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { yyerror ("syntax error: cannot back up"); YYERROR; }	\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

#ifndef YYPURE
#define YYLEX		yylex()
#endif

#ifdef YYPURE
#ifdef YYLSP_NEEDED
#ifdef YYLEX_PARAM
#define YYLEX		yylex(&yylval, &yylloc, YYLEX_PARAM)
#else
#define YYLEX		yylex(&yylval, &yylloc)
#endif
#else /* not YYLSP_NEEDED */
#ifdef YYLEX_PARAM
#define YYLEX		yylex(&yylval, YYLEX_PARAM)
#else
#define YYLEX		yylex(&yylval)
#endif
#endif /* not YYLSP_NEEDED */
#endif

/* If nonreentrant, generate the variables here */

#ifndef YYPURE

int	yychar;			/*  the lookahead symbol		*/
YYSTYPE	yylval;			/*  the semantic value of the		*/
				/*  lookahead symbol			*/

#ifdef YYLSP_NEEDED
YYLTYPE yylloc;			/*  location data for the lookahead	*/
				/*  symbol				*/
#endif

int yynerrs;			/*  number of parse errors so far       */
#endif  /* not YYPURE */

#if YYDEBUG != 0
int yydebug;			/*  nonzero means print parse trace	*/
/* Since this is uninitialized, it does not stop multiple parsers
   from coexisting.  */
#endif

/*  YYINITDEPTH indicates the initial size of the parser's stacks	*/

#ifndef	YYINITDEPTH
#define YYINITDEPTH 200
#endif

/*  YYMAXDEPTH is the maximum size the stacks can grow to
    (effective only if the built-in stack extension method is used).  */

#if YYMAXDEPTH == 0
#undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
#define YYMAXDEPTH 10000
#endif

/* Prevent warning if -Wstrict-prototypes.  */
#ifdef __GNUC__
int yyparse (void);
#endif

#if __GNUC__ > 1		/* GNU C and GNU C++ define this.  */
#define __yy_memcpy(FROM,TO,COUNT)	__builtin_memcpy(TO,FROM,COUNT)
#else				/* not GNU C or C++ */
#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_memcpy (from, to, count)
     char *from;
     char *to;
     int count;
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#else /* __cplusplus */

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_memcpy (char *from, char *to, int count)
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif
#endif

#line 192 "/usr/local/share/bison.simple"

/* The user can define YYPARSE_PARAM as the name of an argument to be passed
   into yyparse.  The argument should have type void *.
   It should actually point to an object.
   Grammar actions can access the variable by casting it
   to the proper pointer type.  */

#ifdef YYPARSE_PARAM
#define YYPARSE_PARAM_DECL void *YYPARSE_PARAM;
#else
#define YYPARSE_PARAM
#define YYPARSE_PARAM_DECL
#endif

int
yyparse(YYPARSE_PARAM)
     YYPARSE_PARAM_DECL
{
  register int yystate;
  register int yyn;
  register short *yyssp;
  register YYSTYPE *yyvsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int yychar1 = 0;		/*  lookahead token as an internal (translated) token number */

  short	yyssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE yyvsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *yyss = yyssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *yyvs = yyvsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;

#define YYPOPSTACK   (yyvsp--, yyssp--, yylsp--)
#else
#define YYPOPSTACK   (yyvsp--, yyssp--)
#endif

  int yystacksize = YYINITDEPTH;

#ifdef YYPURE
  int yychar;
  YYSTYPE yylval;
  int yynerrs;
#ifdef YYLSP_NEEDED
  YYLTYPE yylloc;
#endif
#endif

  YYSTYPE yyval;		/*  the variable used to return		*/
				/*  semantic values from the action	*/
				/*  routines				*/

  int yylen;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Starting parse\n");
#endif

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss - 1;
  yyvsp = yyvs;
#ifdef YYLSP_NEEDED
  yylsp = yyls;
#endif

/* Push a new state, which is found in  yystate  .  */
/* In all cases, when you get here, the value and location stacks
   have just been pushed. so pushing a state here evens the stacks.  */
yynewstate:

  *++yyssp = yystate;

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Give user a chance to reallocate the stack */
      /* Use copies of these so that the &'s don't force the real ones into memory. */
      YYSTYPE *yyvs1 = yyvs;
      short *yyss1 = yyss;
#ifdef YYLSP_NEEDED
      YYLTYPE *yyls1 = yyls;
#endif

      /* Get the current used size of the three stacks, in elements.  */
      int size = yyssp - yyss + 1;

#ifdef yyoverflow
      /* Each stack pointer address is followed by the size of
	 the data in use in that stack, in bytes.  */
#ifdef YYLSP_NEEDED
      /* This used to be a conditional around just the two extra args,
	 but that might be undefined if yyoverflow is a macro.  */
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
		 &yyls1, size * sizeof (*yylsp),
		 &yystacksize);
#else
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
		 &yystacksize);
#endif

      yyss = yyss1; yyvs = yyvs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	{
	  yyerror("parser stack overflow");
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
      yyss = (short *) alloca (yystacksize * sizeof (*yyssp));
      __yy_memcpy ((char *)yyss1, (char *)yyss, size * sizeof (*yyssp));
      yyvs = (YYSTYPE *) alloca (yystacksize * sizeof (*yyvsp));
      __yy_memcpy ((char *)yyvs1, (char *)yyvs, size * sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) alloca (yystacksize * sizeof (*yylsp));
      __yy_memcpy ((char *)yyls1, (char *)yyls, size * sizeof (*yylsp));
#endif
#endif /* no yyoverflow */

      yyssp = yyss + size - 1;
      yyvsp = yyvs + size - 1;
#ifdef YYLSP_NEEDED
      yylsp = yyls + size - 1;
#endif

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Stack size increased to %d\n", yystacksize);
#endif

      if (yyssp >= yyss + yystacksize - 1)
	YYABORT;
    }

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Entering state %d\n", yystate);
#endif

  goto yybackup;
 yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Reading a token: ");
#endif
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Now at end of input.\n");
#endif
    }
  else
    {
      yychar1 = YYTRANSLATE(yychar);

#if YYDEBUG != 0
      if (yydebug)
	{
	  fprintf (stderr, "Next token is %d (%s", yychar, yytname[yychar1]);
	  /* Give the individual parser a way to print the precise meaning
	     of a token, for further debugging info.  */
#ifdef YYPRINT
	  YYPRINT (stderr, yychar, yylval);
#endif
	  fprintf (stderr, ")\n");
	}
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting token %d (%s), ", yychar, yytname[yychar1]);
#endif

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  /* count tokens shifted since error; after three, turn off error status.  */
  if (yyerrstatus) yyerrstatus--;

  yystate = yyn;
  goto yynewstate;

/* Do the default action for the current state.  */
yydefault:

  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;

/* Do a reduction.  yyn is the number of a rule to reduce with.  */
yyreduce:
  yylen = yyr2[yyn];
  if (yylen > 0)
    yyval = yyvsp[1-yylen]; /* implement default value of the action */

#if YYDEBUG != 0
  if (yydebug)
    {
      int i;

      fprintf (stderr, "Reducing via rule %d (line %d), ",
	       yyn, yyrline[yyn]);

      /* Print the symbols being reduced, and their result.  */
      for (i = yyprhs[yyn]; yyrhs[i] > 0; i++)
	fprintf (stderr, "%s ", yytname[yyrhs[i]]);
      fprintf (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif


  switch (yyn) {

case 1:
#line 224 "parser.y"
{ 
    yyvsp[0].n_node->attrib(ctx_program); 
    yyvsp[0].n_node->translate(ctx_program); 
;
    break;}
case 4:
#line 231 "parser.y"
{ yyval.n_node = new program_node(NULL, NULL, NULL, NULL, yyvsp[-1].n_block, yyvsp[0].tok); ;
    break;}
case 5:
#line 233 "parser.y"
{ 
    yyval.n_node = new program_node(yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_imp, yyvsp[-2].tok, yyvsp[-1].n_block, yyvsp[0].tok);
;
    break;}
case 6:
#line 237 "parser.y"
{ yyval.n_node = new module_node(NULL, NULL, NULL, NULL, yyvsp[0].n_decl); ;
    break;}
case 7:
#line 239 "parser.y"
{ 
    yyval.n_node = new module_node(yyvsp[-4].tok, yyvsp[-3].tok, yyvsp[-2].n_imp, yyvsp[-1].tok, yyvsp[0].n_decl);
;
    break;}
case 8:
#line 244 "parser.y"
{ yyval.n_imp = NULL; ;
    break;}
case 9:
#line 245 "parser.y"
{ yyval.n_imp = new import_list_node(yyvsp[-2].tok, yyvsp[-1].toks, yyvsp[0].tok); ;
    break;}
case 10:
#line 247 "parser.y"
{ yyval.toks = new token_list(yyvsp[-2].tok, yyvsp[0].toks); ;
    break;}
case 11:
#line 248 "parser.y"
{ yyval.toks = new token_list(yyvsp[0].tok); ;
    break;}
case 12:
#line 251 "parser.y"
{
    yyval.n_block = new block_node(yyvsp[-1].n_decl, yyvsp[0].n_comp);
;
    break;}
case 13:
#line 255 "parser.y"
{ yyval.n_decl = NULL; ;
    break;}
case 14:
#line 256 "parser.y"
{ yyvsp[-1].n_decl->next = yyvsp[0].n_decl; yyval.n_decl = yyvsp[-1].n_decl; ;
    break;}
case 21:
#line 288 "parser.y"
{ yyval.n_stmt = new empty_node(curr_token->prev_relevant()); ;
    break;}
case 22:
#line 289 "parser.y"
{ yyval.n_stmt = new assign_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 23:
#line 290 "parser.y"
{ yyval.n_stmt = new goto_node(yyvsp[-1].tok, yyvsp[0].tok); ;
    break;}
case 24:
#line 291 "parser.y"
{ yyval.n_stmt = new switch_node(yyvsp[-4].tok, yyvsp[-3].n_expr, yyvsp[-2].tok, yyvsp[-1].n_case, yyvsp[0].tok); ;
    break;}
case 25:
#line 292 "parser.y"
{ yyval.n_stmt = new if_node(yyvsp[-3].tok, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 26:
#line 294 "parser.y"
{ yyval.n_stmt = new if_node(yyvsp[-5].tok, yyvsp[-4].n_expr, yyvsp[-3].tok, yyvsp[-2].n_stmt, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 27:
#line 296 "parser.y"
{ yyval.n_stmt = new for_node(yyvsp[-7].tok, yyvsp[-6].tok, yyvsp[-5].tok, yyvsp[-4].n_expr, yyvsp[-3].tok, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 28:
#line 297 "parser.y"
{ yyval.n_stmt = new while_node(yyvsp[-3].tok, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 29:
#line 298 "parser.y"
{ yyval.n_stmt = new repeat_node(yyvsp[-3].tok, yyvsp[-2].n_stmt, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 30:
#line 299 "parser.y"
{ yyval.n_stmt = new write_node(yyvsp[-1].tok, yyvsp[0].n_wrls); ;
    break;}
case 31:
#line 300 "parser.y"
{ yyval.n_stmt = new read_node(yyvsp[-1].tok, yyvsp[0].n_grp); ;
    break;}
case 32:
#line 301 "parser.y"
{ yyval.n_stmt = new pcall_node(yyvsp[0].n_expr); ;
    break;}
case 33:
#line 302 "parser.y"
{ yyval.n_stmt = new return_node(yyvsp[0].tok); ;
    break;}
case 34:
#line 303 "parser.y"
{ yyval.n_stmt = new with_node(yyvsp[-3].tok, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 35:
#line 304 "parser.y"
{ yyval.n_stmt = new label_node(yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 36:
#line 305 "parser.y"
{ yyval.n_stmt = yyvsp[0].n_comp; ;
    break;}
case 37:
#line 307 "parser.y"
{ yyval.n_comp = new compound_node(yyvsp[-2].tok, yyvsp[-1].n_stmt, yyvsp[0].tok); ;
    break;}
case 39:
#line 309 "parser.y"
{ yyvsp[-2].n_stmt->next = yyvsp[0].n_stmt; yyval.n_stmt = yyvsp[-2].n_stmt; ;
    break;}
case 40:
#line 310 "parser.y"
{ yyval.n_grp = NULL; ;
    break;}
case 41:
#line 310 "parser.y"
{ yyval.n_grp = yyvsp[0].n_grp; ;
    break;}
case 42:
#line 312 "parser.y"
{ yyval.n_wrls = NULL; ;
    break;}
case 43:
#line 313 "parser.y"
{ yyval.n_wrls = new write_list_node(yyvsp[-2].tok, yyvsp[-1].n_wrtp, yyvsp[0].tok); ;
    break;}
case 45:
#line 317 "parser.y"
{ 
	     if (yyvsp[-2].n_case != NULL) { 
	         case_node** cpp;
	         for(cpp = &yyvsp[-2].n_case->next; *cpp != NULL; cpp = &(*cpp)->next);
	         *cpp = new case_node(NULL, yyvsp[-1].tok, yyvsp[0].n_stmt);
		 yyval.n_case = yyvsp[-2].n_case;
             } else { 		 
	         yyval.n_case = new case_node(NULL, yyvsp[-1].tok, yyvsp[0].n_stmt);
             }
	   ;
    break;}
case 46:
#line 328 "parser.y"
{ 
	     if (yyvsp[-3].n_case != NULL) { 
	         case_node** cpp;
	         for(cpp = &yyvsp[-3].n_case->next; *cpp != NULL; cpp = &(*cpp)->next);
	         *cpp = new case_node(NULL, yyvsp[-2].tok, yyvsp[-1].n_stmt);
		 yyval.n_case = yyvsp[-3].n_case;
             } else { 		 
	         yyval.n_case = new case_node(NULL, yyvsp[-2].tok, yyvsp[-1].n_stmt);
             }
	   ;
    break;}
case 47:
#line 339 "parser.y"
{ yyval.n_case = NULL; ;
    break;}
case 49:
#line 341 "parser.y"
{ yyvsp[-2].n_case->next = yyvsp[0].n_case; yyval.n_case = yyvsp[-2].n_case; ;
    break;}
case 50:
#line 343 "parser.y"
{ yyval.n_case = new case_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_stmt); ;
    break;}
case 52:
#line 368 "parser.y"
{ yyval.n_expr = new op_node(tn_add, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 53:
#line 369 "parser.y"
{ yyval.n_expr = new op_node(tn_sub, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 54:
#line 370 "parser.y"
{ yyval.n_expr = new op_node(tn_mod, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 55:
#line 371 "parser.y"
{ yyval.n_expr = new op_node(tn_mul, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 56:
#line 372 "parser.y"
{ yyval.n_expr = new op_node(tn_div, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 57:
#line 373 "parser.y"
{ yyval.n_expr = new op_node(tn_divr, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 58:
#line 375 "parser.y"
{ yyval.n_expr = new op_node(tn_and, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 59:
#line 376 "parser.y"
{ yyval.n_expr = new op_node(tn_or, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 60:
#line 378 "parser.y"
{ yyval.n_expr = new op_node(tn_gt, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 61:
#line 379 "parser.y"
{ yyval.n_expr = new op_node(tn_lt, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 62:
#line 380 "parser.y"
{ yyval.n_expr = new op_node(tn_le, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 63:
#line 381 "parser.y"
{ yyval.n_expr = new op_node(tn_ge, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 64:
#line 382 "parser.y"
{ yyval.n_expr = new op_node(tn_eq, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 65:
#line 383 "parser.y"
{ yyval.n_expr = new op_node(tn_ne, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 66:
#line 384 "parser.y"
{ yyval.n_expr = new op_node(tn_in, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 68:
#line 387 "parser.y"
{
     yyval.n_expr = new op_node(tn_plus, NULL, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 69:
#line 390 "parser.y"
{ yyval.n_expr = new op_node(tn_minus, NULL, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 70:
#line 392 "parser.y"
{ yyval.n_expr = new op_node(tn_not, NULL, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 72:
#line 395 "parser.y"
{ yyval.n_expr = new expr_group_node(yyvsp[-2].tok, yyvsp[-1].n_expr, yyvsp[0].tok); ;
    break;}
case 73:
#line 396 "parser.y"
{ yyval.n_expr = new fcall_node(yyvsp[-3].n_expr, yyvsp[-2].tok, yyvsp[-1].n_expr, yyvsp[0].tok); ;
    break;}
case 74:
#line 397 "parser.y"
{ yyval.n_expr = new access_expr_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].tok); ;
    break;}
case 75:
#line 398 "parser.y"
{ yyval.n_expr = new deref_expr_node(yyvsp[-1].n_expr, yyvsp[0].tok); ;
    break;}
case 76:
#line 399 "parser.y"
{ yyval.n_expr = new idx_expr_node(yyvsp[-3].n_expr, yyvsp[-2].tok, yyvsp[-1].n_expr, yyvsp[0].tok); ;
    break;}
case 77:
#line 400 "parser.y"
{ yyval.n_expr = new loophole_node(yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_tpd, yyvsp[-2].tok, yyvsp[-1].n_expr, yyvsp[0].tok); ;
    break;}
case 78:
#line 402 "parser.y"
{ yyval.n_expr = new integer_node(yyvsp[0].tok); ;
    break;}
case 79:
#line 403 "parser.y"
{ yyval.n_expr = new real_node(yyvsp[0].tok); ;
    break;}
case 80:
#line 404 "parser.y"
{ yyval.n_expr = new string_node(yyvsp[0].tok); ;
    break;}
case 81:
#line 405 "parser.y"
{ yyval.n_expr = new set_node(yyvsp[-2].tok, yyvsp[-1].n_item, yyvsp[0].tok); ;
    break;}
case 82:
#line 406 "parser.y"
{ yyval.n_expr = new atom_expr_node(yyvsp[0].tok); ;
    break;}
case 83:
#line 408 "parser.y"
{ yyval.n_item = NULL; ;
    break;}
case 85:
#line 410 "parser.y"
{ yyvsp[-2].n_item->next = yyvsp[0].n_item; yyval.n_item = yyvsp[-2].n_item; ;
    break;}
case 86:
#line 412 "parser.y"
{ yyval.n_item = new set_elem_node(yyvsp[0].n_expr); ;
    break;}
case 87:
#line 413 "parser.y"
{ yyval.n_item = new set_range_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 89:
#line 415 "parser.y"
{ yyvsp[-2].n_expr->next = yyvsp[0].n_expr; yyval.n_expr = yyvsp[-2].n_expr; ;
    break;}
case 91:
#line 418 "parser.y"
{ yyvsp[-2].n_expr->next = yyvsp[0].n_expr; yyval.n_expr = yyvsp[-2].n_expr; ;
    break;}
case 93:
#line 420 "parser.y"
{ yyval.n_expr = new skipped_node(curr_token->prev_relevant()); ;
    break;}
case 94:
#line 423 "parser.y"
{ yyval.n_grp = new expr_group_node(yyvsp[-2].tok, yyvsp[-1].n_expr, yyvsp[0].tok); ;
    break;}
case 96:
#line 426 "parser.y"
{ yyvsp[-2].n_wrtp->next = yyvsp[0].n_wrtp; yyval.n_wrtp = yyvsp[-2].n_wrtp; ;
    break;}
case 97:
#line 428 "parser.y"
{ yyval.n_wrtp = new write_param_node(yyvsp[0].n_expr); ;
    break;}
case 98:
#line 429 "parser.y"
{ yyval.n_wrtp = new write_param_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 99:
#line 430 "parser.y"
{ yyval.n_wrtp = new write_param_node(yyvsp[-4].n_expr, yyvsp[-3].tok, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 100:
#line 473 "parser.y"
{ yyval.n_decl = new label_decl_part_node(yyvsp[-2].tok, yyvsp[-1].toks, yyvsp[0].tok); ;
    break;}
case 101:
#line 475 "parser.y"
{ yyval.toks = new token_list(yyvsp[0].tok); ;
    break;}
case 102:
#line 476 "parser.y"
{ yyval.toks = new token_list(yyvsp[-2].tok, yyvsp[0].toks); ;
    break;}
case 103:
#line 479 "parser.y"
{ yyval.n_decl = new const_def_part_node(yyvsp[-1].tok, yyvsp[0].n_cdef); ;
    break;}
case 104:
#line 481 "parser.y"
{ yyval.n_cdef = NULL; ;
    break;}
case 105:
#line 482 "parser.y"
{ yyvsp[-2].n_cdef->next = yyvsp[0].n_cdef; yyval.n_cdef = yyvsp[-2].n_cdef; ;
    break;}
case 106:
#line 484 "parser.y"
{ yyval.n_cdef = new const_def_node(yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 107:
#line 487 "parser.y"
{ yyval.n_decl = new type_def_part_node(yyvsp[-1].tok, yyvsp[0].n_tdef); ;
    break;}
case 108:
#line 489 "parser.y"
{ yyval.n_tdef = NULL; ;
    break;}
case 109:
#line 490 "parser.y"
{ yyvsp[-2].n_tdef->next = yyvsp[0].n_tdef; yyval.n_tdef = yyvsp[-2].n_tdef; ;
    break;}
case 110:
#line 492 "parser.y"
{ yyval.n_tdef = new type_def_node(yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 111:
#line 495 "parser.y"
{ yyval.n_decl = new var_decl_part_node(yyvsp[-1].tok, yyvsp[0].n_vdcl); ;
    break;}
case 112:
#line 497 "parser.y"
{ yyval.n_vdcl = NULL; ;
    break;}
case 114:
#line 499 "parser.y"
{ yyvsp[-2].n_vdcl->next = yyvsp[0].n_vdcl; yyval.n_vdcl = yyvsp[-2].n_vdcl; ;
    break;}
case 115:
#line 501 "parser.y"
{ yyval.n_vdcl = new var_decl_node(yyvsp[-2].toks, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 116:
#line 503 "parser.y"
{ yyval.n_vdcl = (var_decl_node*)new var_origin_decl_node(yyvsp[-4].tok, yyvsp[-3].tok, yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 117:
#line 507 "parser.y"
{ yyval.n_decl = new proc_decl_node(yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_plist); ;
    break;}
case 118:
#line 509 "parser.y"
{ yyval.n_decl = new proc_decl_node(yyvsp[-4].tok, yyvsp[-3].tok, yyvsp[-2].n_plist, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 119:
#line 514 "parser.y"
{ yyval.n_decl = new proc_fwd_decl_node(yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_plist, NULL, NULL, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].tok); ;
    break;}
case 120:
#line 516 "parser.y"
{ yyval.n_decl = new proc_fwd_decl_node(yyvsp[-7].tok, yyvsp[-6].tok, yyvsp[-5].n_plist, yyvsp[-4].tok, yyvsp[-3].n_tpd, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].tok); ;
    break;}
case 121:
#line 520 "parser.y"
{ yyval.n_decl = new proc_def_node(yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_plist, NULL, NULL, yyvsp[-2].tok, yyvsp[-1].n_block, yyvsp[0].tok); ;
    break;}
case 122:
#line 522 "parser.y"
{ yyval.n_decl = new proc_def_node(yyvsp[-7].tok, yyvsp[-6].tok, yyvsp[-5].n_plist, yyvsp[-4].tok, yyvsp[-3].n_tpd, yyvsp[-2].tok, yyvsp[-1].n_block, yyvsp[0].tok); ;
    break;}
case 123:
#line 524 "parser.y"
{ yyval.n_decl = new proc_def_node(yyvsp[-4].tok, yyvsp[-3].tok, NULL, NULL, NULL, yyvsp[-2].tok, yyvsp[-1].n_block, yyvsp[0].tok); ;
    break;}
case 124:
#line 526 "parser.y"
{ yyval.n_plist = NULL; ;
    break;}
case 125:
#line 527 "parser.y"
{ yyval.n_plist = new param_list_node(yyvsp[-2].tok, yyvsp[-1].n_decl, yyvsp[0].tok); ;
    break;}
case 127:
#line 530 "parser.y"
{ yyvsp[-2].n_decl->next = yyvsp[0].n_decl; yyval.n_decl = yyvsp[-2].n_decl; ;
    break;}
case 128:
#line 532 "parser.y"
{ yyval.n_decl = new var_decl_part_node(yyvsp[-1].tok, yyvsp[0].n_vdcl); ;
    break;}
case 129:
#line 533 "parser.y"
{ yyval.n_decl = yyvsp[0].n_vdcl; ;
    break;}
case 131:
#line 535 "parser.y"
{ yyval.n_vdcl = new var_decl_node(yyvsp[-2].toks, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 142:
#line 546 "parser.y"
{ yyval.n_tpd = new simple_tpd_node(yyvsp[0].tok); ;
    break;}
case 143:
#line 549 "parser.y"
{ yyval.n_tpd = new array_tpd_node(yyvsp[-6].tok, yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_idx, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 144:
#line 552 "parser.y"
{ yyval.n_tpd = new array_tpd_node(yyvsp[-6].tok, yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_idx, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 145:
#line 554 "parser.y"
{ yyval.n_tpd = new array_tpd_node(yyvsp[-6].tok, yyvsp[-5].tok, yyvsp[-4].tok, yyvsp[-3].n_idx, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 146:
#line 556 "parser.y"
{ yyval.n_tpd = new enum_tpd_node(yyvsp[-2].tok, yyvsp[-1].toks, yyvsp[0].tok); ;
    break;}
case 147:
#line 559 "parser.y"
{ yyval.n_tpd = new range_tpd_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 148:
#line 561 "parser.y"
{ yyval.n_tpd = new ptr_tpd_node(yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 149:
#line 563 "parser.y"
{ yyval.n_tpd = new set_tpd_node(yyvsp[-3].tok, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 150:
#line 566 "parser.y"
{ yyval.n_tpd = new record_tpd_node(yyvsp[-3].tok, yyvsp[-2].tok, yyvsp[-1].n_fldls, yyvsp[0].tok); ;
    break;}
case 151:
#line 568 "parser.y"
{ yyval.n_tpd = new file_tpd_node(yyvsp[-3].tok, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 152:
#line 570 "parser.y"
{ yyval.tok = NULL; ;
    break;}
case 155:
#line 573 "parser.y"
{ yyvsp[-2].n_idx->next = yyvsp[0].n_idx; yyval.n_idx = yyvsp[-2].n_idx; ;
    break;}
case 156:
#line 576 "parser.y"
{ yyval.n_idx = new conformant_index_node(yyvsp[-4].tok, yyvsp[-3].tok, yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 158:
#line 579 "parser.y"
{ yyvsp[-2].n_idx->next = yyvsp[0].n_idx; yyval.n_idx = yyvsp[-2].n_idx; ;
    break;}
case 159:
#line 581 "parser.y"
{ yyval.n_idx = new type_index_node(yyvsp[0].n_tpd); ;
    break;}
case 160:
#line 582 "parser.y"
{ yyval.n_idx = new range_index_node(yyvsp[-2].n_expr, yyvsp[-1].tok, yyvsp[0].n_expr); ;
    break;}
case 161:
#line 587 "parser.y"
{ yyval.n_fldls = new field_list_node(yyvsp[-1].n_vdcl, yyvsp[0].n_varp); ;
    break;}
case 162:
#line 589 "parser.y"
{ yyval.n_fldls = new field_list_node(yyvsp[0].n_vdcl); ;
    break;}
case 164:
#line 594 "parser.y"
{ 
    yyval.n_varp = new variant_part_node(yyvsp[-3].tok, yyvsp[-2].n_sel, yyvsp[-1].tok, yyvsp[0].n_vari); 
;
    break;}
case 165:
#line 598 "parser.y"
{ yyval.n_sel = new selector_node(yyvsp[-2].tok, yyvsp[-1].tok, yyvsp[0].n_tpd); ;
    break;}
case 166:
#line 599 "parser.y"
{ yyval.n_sel = new selector_node(NULL, NULL, yyvsp[0].n_tpd); ;
    break;}
case 168:
#line 603 "parser.y"
{ yyval.n_vari = yyvsp[-1].n_vari; ;
    break;}
case 169:
#line 604 "parser.y"
{ yyvsp[-2].n_vari->next = yyvsp[0].n_vari; yyval.n_vari = yyvsp[-2].n_vari; ;
    break;}
case 170:
#line 607 "parser.y"
{ 
    yyval.n_vari = new variant_node(yyvsp[-4].n_expr, yyvsp[-3].tok, yyvsp[-2].tok, yyvsp[-1].n_fldls, yyvsp[0].tok); 
;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 487 "/usr/local/share/bison.simple"

  yyvsp -= yylen;
  yyssp -= yylen;
#ifdef YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;

#ifdef YYLSP_NEEDED
  yylsp++;
  if (yylen == 0)
    {
      yylsp->first_line = yylloc.first_line;
      yylsp->first_column = yylloc.first_column;
      yylsp->last_line = (yylsp-1)->last_line;
      yylsp->last_column = (yylsp-1)->last_column;
      yylsp->text = 0;
    }
  else
    {
      yylsp->last_line = (yylsp+yylen-1)->last_line;
      yylsp->last_column = (yylsp+yylen-1)->last_column;
    }
#endif

  /* Now "shift" the result of the reduction.
     Determine what state that goes to,
     based on the state we popped back to
     and the rule number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;

yyerrlab:   /* here on detecting error */

  if (! yyerrstatus)
    /* If not already recovering from an error, report this error.  */
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  int size = 0;
	  char *msg;
	  int x, count;

	  count = 0;
	  /* Start X at -yyn if nec to avoid negative indexes in yycheck.  */
	  for (x = (yyn < 0 ? -yyn : 0);
	       x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (yycheck[x + yyn] == x)
	      size += strlen(yytname[x]) + 15, count++;
	  msg = (char *) malloc(size + 15);
	  if (msg != 0)
	    {
	      strcpy(msg, "parse error");

	      if (count < 5)
		{
		  count = 0;
		  for (x = (yyn < 0 ? -yyn : 0);
		       x < (sizeof(yytname) / sizeof(char *)); x++)
		    if (yycheck[x + yyn] == x)
		      {
			strcat(msg, count == 0 ? ", expecting `" : " or `");
			strcat(msg, yytname[x]);
			strcat(msg, "'");
			count++;
		      }
		}
	      yyerror(msg);
	      free(msg);
	    }
	  else
	    yyerror ("parse error; also virtual memory exceeded");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror("parse error");
    }

  goto yyerrlab1;
yyerrlab1:   /* here on error raised explicitly by an action */

  if (yyerrstatus == 3)
    {
      /* if just tried and failed to reuse lookahead token after an error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Discarding token %d (%s).\n", yychar, yytname[yychar1]);
#endif

      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token
     after shifting the error token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;

yyerrdefault:  /* current state does not do anything special for the error token. */

#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */
  yyn = yydefact[yystate];  /* If its default is to accept any token, ok.  Otherwise pop it.*/
  if (yyn) goto yydefault;
#endif

yyerrpop:   /* pop the current state because it cannot handle the error token */

  if (yyssp == yyss) YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#ifdef YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "Error: state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

yyerrhandle:

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting error token, ");
#endif

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  yystate = yyn;
  goto yynewstate;
}
#line 611 "parser.y"


int zzlex() { 
    curr_token = curr_token ? curr_token->next_relevant() 
	                    : token::first_relevant(); 
    zzlval.tok = curr_token;
    return zzcnv_table[curr_token->tag];
}


