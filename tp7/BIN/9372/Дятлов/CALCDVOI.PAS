program calc;
uses crt;
const
 N=10;

type M= array [-1..N] of byte;

 var
  M0, M1, M2, M3, M5, Mb, Ms, Me: M;
  y: byte;
  W: char;
  Dlina1, Dlina2, KtoBol: integer;

procedure M00(var M0: M);
 var
 i: integer;
 begin
 For i:=-1 to N do
 M0[i]:=0;
 end;

procedure Compare(var M1, M2, Mb, Ms, Me: M; var KtoBol: integer);
var
 i: integer;
 F, F2: boolean;

Begin
 F:=True;
 i:=0;
 while (F=True) and (i<=N)  Do
 Begin
  If M1[i]>M2[i] then
   begin
    Mb:=M1;
    Ms:=M2;
    F:=False;
    KtoBol:=1;
   end;
  i:=i+1;
  end;

   If F=true then
   BEGIN
    F2:=True;
    i:=0;
   while (F2=True) and (i<=N) Do
   Begin
    if M1[i]<>M2[i] then
       F2:=False;
    i:=i+1;
    end;


   If F2=True then
    begin
     Me:=M1;
     Me:=M2;
     KtoBol:=3;
    end else
     begin
     Mb:=M2;
     Ms:=M1;
     KtoBol:=2;
     end;
    END;
End;


procedure Vvivod(Mm: M);
 var
  i: integer;
 begin

 if Mm[-1]=1 then
 write('-');
 For i:=0 to N do
   write(Mm[i]);
   readln ;
End;

procedure sloj(Mm1, Mm2: M; var Mm: M);
 var
 i:integer;
 R:byte;
  begin
  R:=0;
  For i:=0 to N do
  Mm[i]:=0;
   for i:=N downto 1 do
   begin
   If (Mm1[i]=0) and (Mm2[i]=0) then
   begin
    Mm[i]:=R;
    R:=0;
   end;
   if (Mm1[i] <> Mm2[i]) and (R=0) then
   Mm[i]:=1
   else
   if (Mm1[i] <> Mm2[i]) and (R=1) then
   begin
   Mm[i]:=0;
   R:=1;
   end;

   if (Mm1[i]=1) and (Mm2[i]=1) and (R=0) then
   begin
    Mm[i]:=0;
    R:=1;
   end else

   if (Mm1[i]=1) and (Mm2[i]=1) and (R=1) then
   begin
    Mm[i]:=1;
    R:=1;
   end;

 end;

   Mm[0]:=R;

  end;

procedure sloj1;
 BEGIN
  If ((M1[-1]=1) and (M2[-1]=1)) then
  begin
   sloj(M1, M2, M3);
   M3[-1]:=1;
  end;

  If ((M1[-1]=0) and (M2[-1]=0)) then
   begin
    sloj(M1, M2, M3);
    M3[-1]:=0;
   end;
     {+ u -  poka net sluchaya}
   END;



procedure vich(Mm1, Mm2: M; var Mm: M);
 var
 i:integer;
 R:byte;
  begin
  Mm1:=Mb;
  Mm2:=Ms;
  R:=0;
  For i:=0 to N do
  Mm[i]:=0;
   for i:=N downto 1 do
   begin
   If (Mm1[i]=0) and (Mm2[i]=0) and (R=0) then
    Mm[i]:=0
   else
    if (Mm1[i]=0) and (Mm2[i]=0) and (R=1) then
     begin
      Mm[i]:=1;
      R:=1;
     end;


   if (Mm1[i]=1) and (Mm2[i]=0) and (R=0) then
    Mm[i]:=1
   else
    if (Mm1[i]=1) and (Mm2[i]=0) and (R=1) then
     begin
      Mm[i]:=0;
      R:=0;
     end;

   if (Mm1[i]=0) and (Mm2[i]=1) and (R=0) then
    begin
     Mm[i]:=1;
     R:=1;
    end
   else
    if (Mm1[i]=0) and (Mm2[i]=1) and (R=1) then
     begin
      Mm[i]:=0;
     end;

   if (Mm1[i]=1) and (Mm2[i]=1) and (R=0) then
   begin
    Mm[i]:=0;
    R:=0;
   end else

   if (Mm1[i]=1) and (Mm2[i]=1) and (R=1) then
   begin
    Mm[i]:=1;
    R:=1;
   end;

 end;

   Mm[0]:=R;

   If KtoBol=2 then
   Mm[-1]:=1;

  { For i:=0 to N do
   write(Mm[i]);
   readln ;    }
  end;


  procedure Ymnoj(M1, M2: M; var M5: M);
   var
   M3, M4: M; {array [1..N*2] of byte;}
   i, j, k, kk:integer;
   begin
    M00(M3);
    M00(M4);
    If M2[N]=1 then M3:=M1;

    For i:=(N-1) downto (dlina2) do
    begin

    For j:=(N) downto (dlina1) do
    begin



    M4[j]:=M1[j]*M2[i];
    end;
     for kk:=1 to (N-i) do
       For k:=1 to N do
        M4[k]:=M4[k+1];
     M4[N]:=0;
     sloj(M3, M4, M5);
     M3:=M5;
    end;
      end;

  procedure exit1;
  begin
  writeln('exit');
  readln;
  end;

 procedure VVod(var mM1: M; var kkk: integer);
  var
  y, x,Q: char;
   k,b,i, c: integer;
  kluch: boolean;
  begin
   writeln;
   Writeln('VVod slogaemih');
   For i:=1 to N do
   begin
   mM1[i]:=0;
   end;
   i:=1;
   kluch:= False;
   repeat
     x:=readkey;

    If (kluch=false) and  (x='-') then
     begin
      write(x);
      mM1[-1]:=1;
      x:=readkey;
      Kluch:=True;
     end;
      Kluch:=True;

    if ord(x)<>13 then
     begin
     if (x='0') or (x='1')  then
      begin
       repeat
       val(x,b,k) ;
       If k<>0 then
        begin
         {writeln('Povtori VVod');}
         x:=readkey;
        end;
       until k=0;
       mM1[i]:=b;
       write(x);

       i:=i+1;
       kkk:=i-1;
       end else begin
                 { textcolor(red+blink);
                  writeln('Povtori VVod');
                  NormVideo;}
                end;
      end;
      until (i>N) or (ord(x)=13);
     c:=N;
     If kkk<N then
     begin
      For i:=kkk downto 1 do
        begin
         Mm1[c]:= Mm1[i];
         Mm1[i]:=0;
         c:= c-1;
        end;
      end;


   {Vvivod(mM1);}
  {  For i:=1 to N do
    write(mM1[i]);
    writeln;
    writeln('Press Enter');
    repeat
     Q:=readkey;

    until ord(Q)=13}

 end;




 procedure Menu;
  begin

   VVod(M1, Dlina1);
   Vvod(M2, Dlina2);
   Compare(M1, M2, Mb, Ms, Me, KtoBol);
   clrscr;
   writeln('1 - slojenie');
   writeln('2 - vichitanie');
   writeln('0 - exit');
   readln(y);
    case y of
     1: begin
         sloj1;
         Vvivod(M3);
         end;
     2: begin
        vich(M1, M2, M3);
        Vvivod(M3);
        end;

     3: begin
        Ymnoj(M1, M2, M5);
        Vvivod(M5);
        end;
     end;
  end;

  begin
   repeat
    Menu
   until y=0;

  end.