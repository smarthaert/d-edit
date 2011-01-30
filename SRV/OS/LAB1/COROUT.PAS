Unit Corout;
Interface
Type
    arptr    = ^artype;
    artype   = array[0..999] of word; {под стек - 1000 слов}

    descptr  = ^procdesc;
    procdesc = record
                     ssreg,
                     spreg  : word;
               end;

Procedure Transfer(OldProc,NewProc:descptr);

Procedure NewProcess(body:pointer; Var proc:descptr);

Var
     main : descptr;
{--------------------------------------------------------------------------}
Implementation
Procedure NewProcess(body : pointer; Var proc : descptr);
Var
     ar : arptr;
Begin
     New(proc);
     New(ar);
     with proc^ do begin
          ssreg := seg(ar^);
          spreg := ofs(ar^) + 1998 - 14;
          memw[ssreg:spreg+2] := ofs(body^);
          memw[ssreg:spreg+4] := seg(body^);
     end {with};
End {NewProcess};
{-----------------------------------------------------}
Procedure Transfer(OldProc, NewProc : descptr);
Assembler;
Asm                    {компилятор после Call Transfer
                        подставляет push bp; mov bp,sp}
   les di,oldproc
   mov es:[di],ss      {oldproc.ssreg := ss;}
   mov es:[di+2],sp    {oldproc.spreg := sp; адрес возврата в sp+2}
   les di,newproc
   mov ss,es:[di]      {ss := newproc.ssreg;}
   mov sp,es:[di+2]    {sp := newproc.spreg;}
   pop bp      {выталкивание bp выводит стек на адрес возврата}
   ret 8
       {затолкнули 8 байтов - 4 слова - значения oldproc и newproc}
End {Transfer};
{-----------------------------------------------------}
Begin
     New(main);
End {Corout}.


