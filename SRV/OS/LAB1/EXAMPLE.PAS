Program Example;
Uses Corout;
Var
   proc1,
   proc2,
   proc3 : descptr;
{-----------------------------------------------------}
Procedure P1;
Begin
     while true do begin
          writeln('proc1');
          Transfer(proc1,proc2);
     end {while};
End {P1};
{-----------------------------------------------------}
Procedure P2;
Begin
     while true do begin
          writeln('proc2');
          Transfer(proc2,proc3);
     end {while};
End {P2};
{-----------------------------------------------------}
Procedure P3;
Var
     i : integer;
Begin
     i := 0;
     while true do begin
          inc(i);
          writeln('proc3');
          if i = 5 then Transfer(proc3,main);
          Transfer(proc3,proc1);
     end {while};
End {P3};
{-----------------------------------------------------}
Begin
     NewProcess(@p1,proc1);
     NewProcess(@p2,proc2);
     NewProcess(@p3,proc3);
     Transfer(main,proc1);
End {Example}.


