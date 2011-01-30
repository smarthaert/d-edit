Program Example;
Uses Corout, CRT, DOS;
type
  ScreenOut = array [1..25,1..80,1..2] of byte;
Var
   p_last,
   p_next,
   proc1,
   proc2 : descptr;
   chrout: screenout absolute $B800:0;
   i: integer;
   MemTest,
   BeforMemSize,
   AfterMemSize: LongInt;
   mvecInt: pointer;
   flag: boolean;
{-----------------------------------------------------}
Procedure StrOut(str: string);
Var
   j: integer;
Begin
     for j:=1 to Length(str) Do
       chrout[i,j,1]:=ord(str[j]);
     Inc(i);
     Delay(20000);
     if i>2 Then begin i:=1; ClrScr; Delay(20000);end; {if}
End;
{-----------------------------------------------------}
Procedure ClrInt; Assembler;
Asm
  Cli;
End;
{-----------------------------------------------------}
Procedure SetInt; Assembler;
Asm
  Sti;
End;
{-----------------------------------------------------}
Procedure P1;
Var
     chr : char;
Begin
     SetInt;
     chr := #0;
     while true do begin
	  StrOut('proc1 proc1 proc1 proc1 proc1 proc1');
	  if KeyPressed Then
	    begin
	      chr:=ReadKey;
	    end;
	  if chr = #27 then begin ClrInt; Transfer(proc1,main); end;
     end {while};
End {P1};
{-----------------------------------------------------}
Procedure P2;
Var
     chr : char;
Begin
     SetInt;
     chr := #0;
     while true do begin
	  StrOut('proc2 proc2 proc2 proc2 proc2 proc2');
	  if KeyPressed Then
	    begin
	      chr:=ReadKey;
	    end;
	  if chr = #27 then begin ClrInt; Transfer(proc2,main); end;
     end {while};
End {P2};
{-----------------------------------------------------}
Procedure IntOk; assembler;
asm
mov  al, 20h
out  20h,al
end;

Procedure Handler; interrupt;
Begin
 ClrInt;
 IntOk;
 If flag = true then
   begin
    p_last:=proc1;
    p_next:=proc2;
    flag:= false;
   end
  else
   begin
    p_last:=proc2;
    p_next:=proc1;
    flag:= true;
   end;
 Transfer(p_last,p_next);

End;
{-----------------------------------------------------}
Begin
     flag:= true;
     ClrScr;
     i:=1;
     BeforMemSize:= MaxAvail;

     NewProcess(@p1,proc1);
     NewProcess(@p2,proc2);

     ClrInt;
     GetIntVec(08,mvecint);
     SetIntVec(08,Addr(Handler));
     Transfer(main,proc1);

     Dispose(proc1^.addrAR);
     Dispose(proc2^.addrAR);

     Dispose(proc1^.addrProc);
     Dispose(proc2^.addrProc);

     AfterMemSize:= MaxAvail;
     MemTest:=BeforMemSize-AfterMemSize;
     ClrScr;
     WriteLn(BeforMemSize);
     WriteLn(AfterMemSize);
     WriteLn('Lost memory: ',MemTest);
     SetIntVec(08,mvecint);
     readln;
End {Example}.









