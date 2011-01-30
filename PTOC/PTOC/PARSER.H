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


extern YYSTYPE zzlval;
