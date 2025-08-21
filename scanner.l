/****************************
Nikhil Kottoli
Mohnish 
Pal Patel
 ****************************/

%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

FILE *out;

char* xstrdup(const char* s){
    if(!s) return NULL;
    size_t n=strlen(s)+1; char* p=malloc(n); if(p) memcpy(p,s,n); return p;
}
char* trim(char* s){
    if(!s) return s;
    size_t n=strlen(s),i=0; while(i<n && isspace(s[i])) i++;
    size_t j=n; while(j>i && isspace(s[j-1])) j--;
    memmove(s,s+i,j-i); s[j-i]='\0'; return s;
}

typedef struct Symbol{
    char* name; char* type; char* dimensions; int frequency;
    char* return_type; char* param_lists; int is_function;
    struct Symbol* next;
}Symbol;

#define SYM_HASH_SIZE 211
Symbol* symtab[SYM_HASH_SIZE];

unsigned long djb2(const char* str){
    unsigned long hash=5381; int c;
    while((c=*str++)) hash=((hash<<5)+hash)+c;
    return hash;
}
Symbol* sym_lookup(const char* name){
    unsigned long h=djb2(name)%SYM_HASH_SIZE;
    Symbol* s=symtab[h];
    while(s){if(!strcmp(s->name,name)) return s; s=s->next;}
    return NULL;
}
Symbol* sym_insert(const char* name){
    unsigned long h=djb2(name)%SYM_HASH_SIZE;
    Symbol* s=calloc(1,sizeof(Symbol));
    s->name=xstrdup(name); s->next=symtab[h]; symtab[h]=s;
    return s;
}
Symbol* sym_touch(const char* name){
    Symbol* s=sym_lookup(name);
    if(!s) s=sym_insert(name);
    s->frequency++; return s;
}
void sym_set_type(Symbol* s,const char* type){
    if(s){free(s->type); s->type=xstrdup(type);}
}
void sym_set_return(Symbol* s,const char* r){
    if(s){free(s->return_type); s->return_type=xstrdup(r);}
}
void sym_append_dims(Symbol* s,const char* dims){
    if(!s||!dims) return;
    size_t old=s->dimensions?strlen(s->dimensions):0,add=strlen(dims);
    char* p=malloc(old+add+1);
    if(p){if(old) memcpy(p,s->dimensions,old); memcpy(p+old,dims,add); p[old+add]='\0'; free(s->dimensions); s->dimensions=p;}
}
void sym_append_params(Symbol* s,const char* params){
    if(!s||!params) return;
    const char* sep=s->param_lists?" ; ":"";
    size_t old=s->param_lists?strlen(s->param_lists):0,add=strlen(sep)+strlen(params);
    char* p=malloc(old+add+1);
    if(p){if(old) memcpy(p,s->param_lists,old); memcpy(p+old,sep,strlen(sep)); memcpy(p+old+strlen(sep),params,strlen(params)); p[old+add]='\0'; free(s->param_lists); s->param_lists=p;}
}

typedef struct Constant{
    char* var_name; int line; char* value; char* type;
}Constant;

Constant* consts=NULL; size_t nconsts=0,capconsts=0;

void const_add(const char* var,int line,const char* val,const char* type){
    if(nconsts==capconsts){capconsts=capconsts?capconsts*2:64; consts=realloc(consts,capconsts*sizeof(Constant));}
    consts[nconsts].var_name=xstrdup(var?var:"-"); consts[nconsts].line=line;
    consts[nconsts].value=xstrdup(val?val:""); consts[nconsts].type=xstrdup(type?type:"");
    nconsts++;
}

int in_declaration=0; char last_type[256]={0}; char last_ident[256]={0};
int last_was_ident=0; int array_capture_for_ident=0;

void start_declaration(const char* t){
    in_declaration=1; last_type[0]=0; if(t) strncat(last_type,t,sizeof(last_type)-1);
}
void add_type_token(const char* t){
    if(last_type[0]) strncat(last_type," ",sizeof(last_type)-1);
    strncat(last_type,t,sizeof(last_type)-1);
}
void end_declaration(){in_declaration=0; last_type[0]=0;}

int paren_depth=0; int capturing_args=0; char* arg_buffer=NULL;
size_t arg_cap=0,arg_len=0; Symbol* current_func_sym=NULL;

void args_begin(Symbol* s){
    capturing_args=1; paren_depth=1; arg_len=0;
    if(!arg_buffer){arg_cap=256; arg_buffer=malloc(arg_cap);}
    current_func_sym=s;
}
void args_push_char(int c){
    if(!capturing_args) return;
    if(arg_len+2>arg_cap){arg_cap*=2; arg_buffer=realloc(arg_buffer,arg_cap);}
    arg_buffer[arg_len++]=(char)c; arg_buffer[arg_len]=0;
}
void args_end(){
    if(capturing_args&&current_func_sym){
        if(arg_len&&arg_buffer[arg_len-1]==')') arg_buffer[arg_len-1]=0;
        char* s=xstrdup(arg_buffer); trim(s);
        sym_append_params(current_func_sym,s); free(s);
    }
    capturing_args=0; paren_depth=0; arg_len=0; current_func_sym=NULL;
}

void print_token(const char* kind,const char* lexeme){
    fprintf(out,"[line %d] %-12s : %s\n",yylineno,kind,lexeme);
}

const char* classify_int(const char* s){
    if(!s) return "int";
    size_t len=strlen(s);
    if(len>2&&s[0]=='0'&&(s[1]=='x'||s[1]=='X')) return "hex";
    if(len>2&&s[0]=='0'&&(s[1]=='b'||s[1]=='B')) return "bin";
    if(s[0]=='0'&&len>1) return "oct";
    return "int";
}

%}

%x COMMENT STRING CHARLIT FUNCARGS

DIGIT [0-9]
LETTER [A-Za-z_]
ID {LETTER}[A-Za-z0-9_]*
WS [ \t\r]+
HEX 0[xX][0-9A-Fa-f]+
BIN 0[bB][01]+
OCT 0[0-7]+
INTSUFFIX ([uU][lL]?|[lL][uU]?|[uU][lL][lL]|[lL][lL][uU]?)
EXP ([eE][+-]?{DIGIT}+)
FLOAT ({DIGIT}+\.{DIGIT}*({EXP})?|\.{DIGIT}+({EXP})?|{DIGIT}+{EXP})
FLOATSUF [fFlL]?
ESC (\\[abfnrtv\\'"?]|\\x[0-9A-Fa-f]+|\\[0-7]{1,3})

%%

^[ \t]*\#[^\n\\]*(\\\n[^\n\\]*)* {
    print_token("PREPROC",yytext);
    char* tmp=xstrdup(yytext); char* p=tmp;
    while(*p==' '||*p=='\t') p++;
    if(*p=='#') p++;
    while(*p==' ') p++;
    if(!strncmp(p,"define",6)&&isspace(p[6])){
        p+=6; while(*p==' ') p++;
        char namebuf[256]={0}; int i=0;
        while(*p&&(isalnum(*p)||*p=='_')){if(i<255) namebuf[i++]=*p; p++;}
        namebuf[i]=0;
        while(*p==' '||*p=='\t') p++;
        char* val=trim(p);
        if(val&&namebuf[0]) const_add(namebuf,yylineno,val,"macro");
    }
    free(tmp);
}

{WS} { }
\n { }

"//".* { }

"/*" { BEGIN(COMMENT); int depth=1;
    while(depth>0){
        int c1=input();
        if(c1==EOF){fprintf(out,"[line %d] ERROR: Unterminated comment\n",yylineno); break;}
        if(c1=='/'){
            int c2=input();
            if(c2=='*') depth++;
            else if(c2!=EOF) unput(c2);
        }else if(c1=='*'){
            int c2=input();
            if(c2=='/') depth--;
            else if(c2!=EOF) unput(c2);
        }
    }
    BEGIN(INITIAL);
}

\" { BEGIN(STRING); yymore(); }
<STRING>[^"\\\n]|{ESC} { yymore(); }
<STRING>\" { print_token("STRING",yytext); const_add("-",yylineno,yytext,"string"); BEGIN(INITIAL); }
<STRING>\\\n { yymore(); }
<STRING>\n { fprintf(out,"[line %d] ERROR: Unterminated string\n",yylineno-1); BEGIN(INITIAL); }
<STRING>. { yymore(); }

\' { BEGIN(CHARLIT); yymore(); }
<CHARLIT>[^'\\\n]|{ESC} { yymore(); }
<CHARLIT>\' { print_token("CHAR",yytext); const_add("-",yylineno,yytext,"char"); BEGIN(INITIAL); }
<CHARLIT>\n { fprintf(out,"[line %d] ERROR: Unterminated char\n",yylineno-1); BEGIN(INITIAL); }
<CHARLIT>. { yymore(); }

"auto"|"break"|"case"|"const"|"continue"|"default"|"do"|"else"|"enum"|"extern"|"for"|"goto"|"if"|"register"|"return"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"volatile"|"while" {
    print_token("KEYWORD",yytext); last_was_ident=0;
}

"void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned" {
    print_token("TYPE",yytext);
    if(!in_declaration) start_declaration(yytext);
    else add_type_token(yytext);
    last_was_ident=0;
}

{ID} {
    print_token("IDENT",yytext);
    Symbol* s=sym_touch(yytext);
    strncpy(last_ident,yytext,sizeof(last_ident)-1);
    last_was_ident=1; array_capture_for_ident=1;
    if(in_declaration&&!s->type) sym_set_type(s,last_type);
}

{HEX}{INTSUFFIX}? { print_token("NUMBER",yytext); const_add("-",yylineno,yytext,"hex"); last_was_ident=0; }
{BIN}{INTSUFFIX}? { print_token("NUMBER",yytext); const_add("-",yylineno,yytext,"bin"); last_was_ident=0; }
{OCT}{INTSUFFIX}? { print_token("NUMBER",yytext); const_add("-",yylineno,yytext,"oct"); last_was_ident=0; }
{DIGIT}+{INTSUFFIX}? { print_token("NUMBER",yytext); const_add("-",yylineno,yytext,classify_int(yytext)); last_was_ident=0; }
{FLOAT}{FLOATSUF}? { print_token("NUMBER",yytext); const_add("-",yylineno,yytext,"float"); last_was_ident=0; }

"(" {
    print_token("PUNCT",yytext);
    if(last_was_ident){
        Symbol* s=sym_lookup(last_ident);
        if(!s) s=sym_touch(last_ident);
        if(in_declaration){
            s->is_function=1;
            if(last_type[0]) sym_set_return(s,last_type);
        }
        args_begin(s); BEGIN(FUNCARGS);
    }
    last_was_ident=0;
}
<FUNCARGS>[^()\n]+ { for(int i=0;i<yyleng;i++) args_push_char(yytext[i]); }
<FUNCARGS>"(" { args_push_char('('); paren_depth++; }
<FUNCARGS>")" { args_push_char(')'); paren_depth--; if(!paren_depth){ args_end(); BEGIN(INITIAL); } }
<FUNCARGS>\n { args_push_char('\n'); }

")" { print_token("PUNCT",yytext); last_was_ident=0; }
"["{WS}*{DIGIT}+{WS}*"]" {
    print_token("PUNCT",yytext);
    if(array_capture_for_ident){
        Symbol* s=sym_lookup(last_ident);
        if(s) sym_append_dims(s,yytext);
    }
    last_was_ident=0;
}
"["|"]" { print_token("PUNCT",yytext); last_was_ident=0; }

";" { print_token("PUNCT",yytext); array_capture_for_ident=0; if(in_declaration) end_declaration(); last_was_ident=0; }
"," { print_token("PUNCT",yytext); last_was_ident=0; }
"{" { print_token("PUNCT",yytext); if(in_declaration) end_declaration(); last_was_ident=0; }
"}" { print_token("PUNCT",yytext); last_was_ident=0; }
"."|"->" { print_token("OP",yytext); last_was_ident=0; }
"++"|"--"|"+="|"-="|"*="|"/="|"%="|"&="|"^="|"|="|"=="|"!="|"<="|">="|"<<"|">>"|"&&"|"||"|"+"|"-"|"*"|"/"|"%"|"<"|">"|"="|"!"|"~"|"&"|"^"|"|"|"?"|":" {
    print_token("OP",yytext); last_was_ident=0;
}

. { fprintf(out,"[line %d] ERROR: Invalid token '%s'\n",yylineno,yytext); }

<<EOF>> {
    fprintf(out,"```\n\n## Symbol Table\n\n| %-15s | %-12s | %-12s | %-9s | %-12s | %-35s |\n", "Name", "Type", "Dimensions", "Frequency", "Return Type", "Parameters Lists in Function call");
    fprintf(out,"|%s|%s|%s|%s|%s|%s|\n", "-----------------", "--------------", "--------------", "-----------", "--------------", "-------------------------------------");
    for(int i=0;i<SYM_HASH_SIZE;i++){
        for(Symbol* s=symtab[i];s;s=s->next){
            char name_buf[16], type_buf[13], dims_buf[13], ret_buf[13], params_buf[36];
            
            // Truncate and pad strings to fit column widths
            snprintf(name_buf, sizeof(name_buf), "%-15s", s->name ? s->name : "-");
            snprintf(type_buf, sizeof(type_buf), "%-12s", s->type ? s->type : "-");
            snprintf(dims_buf, sizeof(dims_buf), "%-12s", s->dimensions ? s->dimensions : "-");
            snprintf(ret_buf, sizeof(ret_buf), "%-12s", s->return_type ? s->return_type : (s->is_function ? "unknown" : "-"));
            snprintf(params_buf, sizeof(params_buf), "%-35s", s->param_lists ? s->param_lists : "-");
            
            fprintf(out,"| %s | %s | %s | %-9d | %s | %s |\n",
                name_buf, type_buf, dims_buf, s->frequency, ret_buf, params_buf
            );
        }
    }
    fprintf(out,"\n## Constant Table\n\n| %-15s | %-11s | %-20s | %-8s |\n", "Variable Name", "Line Number", "Value", "Type");
    fprintf(out,"|%s|%s|%s|%s|\n", "-----------------", "-------------", "----------------------", "----------");
    for(size_t i=0;i<nconsts;i++){
        char var_buf[16], val_buf[21], type_buf[9];
        
        snprintf(var_buf, sizeof(var_buf), "%-15s", consts[i].var_name ? consts[i].var_name : "-");
        snprintf(val_buf, sizeof(val_buf), "%-20s", consts[i].value ? consts[i].value : "");
        snprintf(type_buf, sizeof(type_buf), "%-8s", consts[i].type ? consts[i].type : "");
        
        fprintf(out,"| %s | %-11d | %s | %s |\n",
            var_buf, consts[i].line, val_buf, type_buf
        );
    }
    return 0;
}

%%

int main(){
    out=fopen("output.md","w");
    if(!out){perror("output.md"); return 1;}
    fprintf(out,"# Lexical Analysis Output\n\n## Recognized Tokens and Errors\n\n```\n");
    yyin=fopen("input.c","r");
    if(!yyin){perror("input.c"); fclose(out); return 1;}
    yylex();
    fclose(yyin); fclose(out);
    return 0;
}