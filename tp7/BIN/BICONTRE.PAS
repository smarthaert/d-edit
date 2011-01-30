unit bicontre;
{Выполнили студенты гр. 8362 Буков М.В., Белов В.А.}
Interface
         const
              nMax=9;
         type
             Vert=integer;
             plist=^alist;
             alist=record
                         v: vert;
                         next: plist;
             end;
             pstk=^astk;
             astk=record
                        u,v:vert;
                        t:pstk;
             end;
         var
             Adj: array [1..nMax] of plist; {список смежности графа}
             TAdj: array [1..nMax] of plist; {список для комп.св.}
             stk: pstk; {стек}
             iv,i:integer;
             numvert: array [1..nMax] of integer;
             low: array [1..nMax] of integer;
             nm:string;
{Функции для работы со стеком}
function Push(top:pstk;u,v:vert): pstk;
function Pop(top:pstk; var u,v:vert): pstk;
{Функции для работы с графом}
function SearchAdj(u,v:vert):boolean;
procedure ReadAdjList (f_in: string);
procedure SaveAdjList (Adj:array of plist; f_out: string);
procedure ShowAdjList(Adj: array of plist);
procedure Create;
procedure Add(var head:plist; val:vert);
procedure BICON(v,u:vert);
{----------------------------------}
Implementation
function SearchAdj(u,v:vert):boolean;
var p:plist;
begin
     SearchAdj:=false;
     p:=Adj[u];
     while p<>nil do begin
           if p^.v=v then SearchAdj:=true;
           p:=p^.next;
     end;
     p:=Adj[v];
     while p<>nil do begin
           if p^.v=u then SearchAdj:=true;
           p:=p^.next;
     end;
end;
{***}
procedure ShowAdjList(Adj: array of plist);
var curr: plist;
    i: integer;
begin
     Write('Graph: ');
     for i:=1 to nMax do begin
         curr:=Adj[i-1];
         while curr<>nil do begin
               if curr^.v>i then Write('(',i,',',curr^.v,'); ');
               curr:=curr^.next;
         end;
     end;
     writeln;
end;
{***}
function Push(top:pstk;u,v:vert): pstk;
var p:pstk;
begin
     new(p);
     p^.u:=u;
     p^.v:=v;
     p^.t:=top;
     push:=p;
end;
{***}
function Pop(top:pstk; var u,v:vert): pstk;
var p:pstk;
begin
     u:=top^.u;
     v:=top^.v;
     pop:=top^.t;
     dispose(top);
end;
{***}
procedure Create;
var i:integer;
begin
     for i:=1 to nMax do begin
     Adj[i]:=nil;
     TAdj[i]:=nil;
     end;
end;
{***}
procedure Add(var head:plist; val:vert);
var p,t:plist;
var er:boolean;
begin
     er:=false;
     new(p);
     p^.v:=val;
     p^.next:=nil;
     if head=nil then head:=p
     else begin
          t:=head;
          while t<>nil do begin
                if t^.v=val then er:=true;
                t:=t^.next;
          end;
          if not er then begin
             t:=head;
             while t^.next<>nil do t:=t^.next;
             t^.next:=p;
          end;
     end;
end;
{***}
procedure ReadAdjList(f_in: string);
          var f: text;
              vl,m,i,err: integer;
              s: string;
              Curr:alist;
begin
     assign(f,f_in);
     reset(f);
     Create;
     while not EOF(f) do begin
           readln(f,s);
           Val(s[1],i,err);
           for m:=3 to Length(s) do begin
               if s[m]<>',' then begin
                  Val(s[m],vl,err);
                  Add(Adj[i],vl);
                  Add(Adj[vl],i);
               end;
           end;
     end;
     close(f);
end;
{***}
procedure SaveAdjList (Adj:array of plist; f_out: string);
var curr: plist;
    i: integer;
    f:text;
begin
     Assign(f,f_out);
     Rewrite(f);
     for i:=1 to nMax do begin
         curr:=Adj[i-1];
         if curr<>nil then begin
            write(f,i,':');
            while curr<>nil do begin
               Write(f,curr^.v,',');
               curr:=curr^.next;
            end;
            writeln(f);
            end;
     end;
     Close(f);
end;
{***}
procedure BICON(v,u:vert);
var curr:plist;
    s,t:vert;

begin
     inc(iv);
     numvert[v]:=iv;
     low[v]:=numvert[v];
     curr:=Adj[v];
     while curr<>nil do begin
           if numvert[curr^.v]=0 then begin
                 stk:=Push(stk,v,curr^.v);
                 BICON(curr^.v,v);
              if low[curr^.v]<low[v] then low[v]:=low[curr^.v];
              if low[curr^.v]>=NumVert[v] then begin
                 Write('Block: ');
                 repeat
                       stk:=Pop(stk,s,t);
                       Write('(',s,',',t,'); ');
                       Add(TAdj[s],t);
                 until ((s=v) and (curr^.v=t));
                 nm:=Concat(nm,'1');
                 SaveAdjList(TAdj,Concat('OUT-',nm,'.txt'));
                 for i:=1 to nMax do TAdj[i]:=nil;
                 Writeln;
              end;
           end else
             if (numvert[curr^.v]<numvert[v]) and (u<>curr^.v) then begin
                 stk:=Push(stk,v,curr^.v);
                if numvert[curr^.v]<low[v] then low[v]:=numvert[curr^.v];
             end;
           curr:=curr^.next;
     end;
end;
{***}
begin
end.