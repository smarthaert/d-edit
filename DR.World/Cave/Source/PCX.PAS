UNIT  pcx;

INTERFACE

uses crt,graph,dos;

TYPE pcximage=^BYTE;

VAR old_key_isr:pointer;
  PROCEDURE viewpcxfile(filename:string);
  PROCEDURE loadpcxfile(filename:string; VAR pcxm:pcximage);
  PROCEDURE init256graph;
  PROCEDURE errors(code:byte);
  Procedure check_file(name:string);
  Procedure check_mem(VAR names:pcximage; amount:longint);

IMPLEMENTATION

VAR pcxim:pcximage;
 thof,thseg,seger,offer:word;
 pcxfile:file;

(*-------------- Procedure Errors -------------------------------------*)



PROCEDURE errors(code:byte);
BEGIN
  textmode(3);
  clrscr;
  setintvec($09, Old_Key_Isr);
  writeln('!!! A Runtime Error Has Occured !!!');
  Case code OF
  1:writeln('Error Code 1: Not Enough Memory, Try Using A Boot Disk !!!!');
  2:writeln('Error Code 2: File Not Found, Try Re-installing Game !!!!');
  END;
  writeln('Press Any Key To End.');
  REPEAT UNTIL keypressed;
  Halt(0);
END;

(*---------------------- Procedure check_file --------------------------*)

Procedure check_file(name:string);

VAR test:file;

BEGIN
  {$I-}
  assign(test,name);
  reset(test);
  IF ioresult<>0 THEN
  BEGIN
    {$I+}
    errors(2);
  END
  ELSE close(test);
  {$I+}
END;

(*----------------- Procedure Check_Mem -------------------------------*)


Procedure check_mem(VAR names:pcximage; amount:longint);
BEGIN
  IF memavail<amount THEN errors(1);
  getmem(names,amount);
END;


PROCEDURE init256graph;

BEGIN
 ASM
    push bp
    mov bp,sp
    mov al,13h
    mov ah,0
    int 10h
    pop bp
  END
END;

PROCEDURE set256palette(filename:string);

VAR count:INTEGER;
    red,green,blue:BYTE;
    pcxer:file of byte;

BEGIN
  assign(pcxer,filename);
  reset(pcxer);
  seek(pcxer,filesize(pcxer)-(256*3));
  FOR count:=0 to 255 DO
  BEGIN
    read(pcxer,red,green,blue);
    port[$3c7]:=count-1;
    port[$3c9]:=(red SHR 2);
    port[$3c9]:=(green SHR 2);
    port[$3c9]:=(blue SHR 2);
  END;
 close(pcxer);
END;

PROCEDURE decode_line(line:INTEGER);

VAR runcount,data:BYTE;
    count,bytecount:INTEGER;

BEGIN
  bytecount:=0;
  WHILE bytecount<320 DO
  BEGIN
  data:=mem[thseg:thof];
  thof:=thof+1;
    IF data>192 THEN
    BEGIN
      runcount:=data AND $3f;
       data:=mem[thseg:thof];
      thof:=thof+1;
      FOR count:=1 to runcount DO
      BEGIN
        mem[seger:offer+(line*320)+bytecount]:=data;
        bytecount:=bytecount+1
      END;
    END
    ELSE
      BEGIN
          mem[seger:offer+(line*320)+bytecount]:=data;
        bytecount:=bytecount+1
      END;
  END;
END;


PROCEDURE show_file;

VAR count2:INTEGER;
    joe:byte;

BEGIN
  FOR count2:=0 to 199 DO
  bEGIN
  decode_line(count2);
  END;
END;


PROCEDURE viewpcxfile(filename:string);

VAR count_me:WORD;

BEGIN
  check_file(filename);
  assign(pcxfile,filename);
  reset(pcxfile);
  check_mem(pcxim,filesize(pcxfile));
  thseg:=seg(pcxim^);
  thof:=ofs(pcxim^)+128;
  seger:=$a000;
  offer:=$0000;
  blockread(pcxfile,pcxim^,filesize(pcxfile));
  set256palette(filename);
  show_file;
  freemem(pcxim,filesize(pcxfile));
  close(pcxfile);
END;


PROCEDURE loadpcxfile(filename:string; VAR pcxm:pcximage);

VAR count_me:WORD;

BEGIN
  check_file(filename);
  assign(pcxfile,filename);
  reset(pcxfile);
  check_mem(pcxim,filesize(pcxfile));
  seger:=seg(pcxm^);
  offer:=ofs(pcxm^);
  thseg:=seg(pcxim^);
  thof:=ofs(pcxim^)+128;
  blockread(pcxfile,pcxim^,filesize(pcxfile));
  set256palette(filename);
  show_file;
  close(pcxfile);
END;

BEGIN
getintvec($09,old_key_isr);
END.