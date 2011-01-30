Program Example;
Uses Corout, CRT;
type
  ScreenOut = array [1..25,1..80,1..2] of byte;
Var
   proc1,
   proc2,
   proc3 : descptr;
   chrout: screenout absolute $B800:0;
   i: integer;
   MemTest,
   BeforMemSize,
   AfterMemSize: LongInt;
   f: boolean;
   p: pointer;
   pr1,
   pr2,
   pr3: arptr;
{-----------------------------------------------------}
Procedure StrOut(str: string);
Var
   j: integer;
Begin
     for j:=1 to Length(str) Do
       chrout[i,j,1]:=ord(str[j]);
     Inc(i);
     Delay(20000);
     if i>3 Then begin i:=1; ClrScr; Delay(20000);end; {if}
End;
{-----------------------------------------------------}
{-----------------------------------------------------}
Procedure P1;
Var
     chr : char;
Begin
     chr := #0;
     while true do begin
	  StrOut('proc1');
	  if KeyPressed Then
	    begin
	      chr:=ReadKey;
	    end;
	  if chr = #27 then Transfer(proc1,main);
	  Transfer(proc1,proc2);
     end {while};
End {P1};
{-----------------------------------------------------}
Procedure P2;
Var
     chr : char;
Begin
     chr := #0;
     while true do begin
	  StrOut('proc2');
	  if KeyPressed Then
	    begin
	      chr:=ReadKey;
	    end;
	  if chr = #27 then Transfer(proc2,main);
	  Transfer(proc2,proc3);
     end {while};
End {P2};
{-----------------------------------------------------}
Procedure P3;
Var
     chr : char;
Begin
     chr := #0;
     while true do begin
	  StrOut('proc3');
	  if KeyPressed Then
	    begin
	      chr:=ReadKey;
	    end;
	  if chr = #27 then Transfer(proc3,main);
	  Transfer(proc3,proc1);
     end {while};
End {P3};
{-----------------------------------------------------}
Begin
     ClrScr;
     i:=1;
     BeforMemSize:= MaxAvail;
     NewProcess(@p1,proc1);
     NewProcess(@p2,proc2);
     NewProcess(@p3,proc3);
     Transfer(main,proc1);

     Dispose(proc1^.addrAR);
     Dispose(proc2^.addrAR);
     Dispose(proc3^.addrAR);

     Dispose(proc1^.addrProc);
     Dispose(proc2^.addrProc);
     Dispose(proc3^.addrProc);

     AfterMemSize:= MaxAvail;
     MemTest:=BeforMemSize-AfterMemSize;
     ClrScr;
     WriteLn(BeforMemSize);
     WriteLn(AfterMemSize);
     WriteLn('Lost memory: ',MemTest);
     readln;
End {Example}.









