program mssp;
        uses crt;
        type rec=record
                       name:string[30];
                       rost:integer;
                       nxt:integer;
                  end;
      
        var     A:array [1..5] of rec;
         pr,i,j,k,n,tmp,hd:integer; s:rec;
        begin
             clrscr;
             i:=1;
             while i<6 do
                   begin
                        writeln('������ ���');
                        readln(A[i].name);
                        writeln('������ ���');

                       readln(A[i].rost);
                        a[i].nxt:=-1;
                        inc(i);
                   end;
                   writeln('---------------');
             for i:=1 to 4 do
                 for k:=1 to 5-i do
                     begin
                          if a[k].name>a[k+1].name then
                             begin
                             s:=a[k];
                             a[k]:=a[k+1];
                             a[k+1]:=s;
                             end;
                      end;
              for i:=1 to 5 do
                  begin
                  writeln(i,'. ���:',a[i].name);
                  writeln('   ����', a[i].rost);
                  end;
              readkey;
              pr:=0;



         for i:=1 to 4 do
             begin
                  n:=0;
                  for j:=1 to 5 do
                      if (a[j].nxt=-1) and (a[j].rost>n) then
                         tmp:=j;
                   a[tmp].nxt:=0;
                   if i=1 then
                      begin
                          hd:=tmp;
                          pr:=tmp;
                          end;
                   if i>1 then a[pr].nxt:=tmp;
                            pr:=tmp;
                   if i=5 then a[tmp].nxt:=-2;



              end;

              i:=hd;
              while a[i].nxt>-2 do
                  begin
                  writeln(i,'. ���:',a[i].name);
                  writeln('   ����', a[i].rost);
                  i:=a[i].nxt;
                  end;
                  writeln(i,'. ���:',a[i].name);
                  writeln('   ����', a[i].rost);
              readkey;
              readkey;






        end.

