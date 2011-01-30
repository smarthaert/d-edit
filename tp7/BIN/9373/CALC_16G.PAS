program HexCalculator;
uses crt, tpcrt, DLARINT1;
type
    TArr = array [0..20] of byte;
    TRec = record
            Z:boolean;
            C:TArr;
            L:byte;
          end;
const
    p=16;

procedure Null(var A:TRec);                 {obnylenie}
   var i:byte;
    begin
     for i := 0 to 20 do
       A.C[i]:= 0;
       A.L:=0;
       A.Z:=true;
    end;

function sravnenie(A,B:TRec):boolean;             {sravnenie  A>B ?}
    var L,i:byte;
        R:boolean;
    begin
       L:=A.L;
       if A.L<B.L then L:= B.L;
         for i:= 0 to L-1 do
         if A.C[i]>=B.C[i] then R:=true
           else R:=false;
           sravnenie:=R;
    end;

function ReadHex(var T: TRec; S: string;x,y:byte):boolean;
    var I,n:byte;
        Err:boolean;
    begin
      I:=0;
      n:=0;
      Err:=false;
      T.L:= Length(S);
      if S[1] = '-' then
        begin
          T.Z:= false;
          T.L:=T.L-1;
          n:=1;
        end;
      while (I<T.L) and (I<20) do
        begin
          case S[T.L-I+n] of
            '0'..'9': T.C[I] := Ord(S[T.L-I+n]) - Ord ('0');
            'A'..'F': T.C[I] := Ord(S[T.L-I+n]) - Ord ('A')+10;
            'a'..'f': T.C[I] := Ord(S[T.L-I+n]) - Ord ('a')+10;
          else Err:= true;
        end;
       Inc(I);
    end;
if Err then begin
  gotoxy(x,y);
  write('Error input!');
  Null(T);
  end;
ReadHex:= not Err;
end;

procedure WriteHex(var T:TRec);
var
I: byte;
 begin
 if T.L>0 then begin
  if T.Z=false then write ('-');
  for I:= T.L-1 downto 0 do
    case T.C[I] of
     0..9: write(Chr(T.C[I]+Ord('0')));
     10..15: write(Chr(T.C[I]+Ord('A')-10));
    end;
  end;
 end;

procedure HexPlus(A,B:TRec; var R:TRec);     {summa}
var M,I,S:byte;
begin
if A.L <= B.L then R.L:= B.L
 else R.L:= A.L;
S:=0;
for I:= 0 to R.L do         {+}
 begin
  M:=A.C[I]+B.C[I]+S;
  if M> p-1 then
   begin
    R.C[I]:= M-p;
    S:=1;
   end
  else begin
    R.C[I]:=M;
    S:=0;
   end;
end;
if S=1 then begin
 R.C[I+1]:= S;
 S:= 0;
 Inc(R.L);
 end;
end;

procedure HexMinus(A,B:TRec; var R:TRec);        {vichitanie}
var I,S:byte;
M: integer;
Buf:TRec;
begin
if A.L<=B.L then R.L:= B.L
 else R.L:= A.L;
if not sravnenie(A,B) then
begin
Buf:=A;
A:=B;
B:=Buf;
R.Z:=false;
end;
S:=0;
for I:= 0 to R.L-1 do
begin
 M:=A.C[I]-B.C[I]-S;
   if M<0 then begin
     R.C[I]:= M+p;
     S:=1;
    end
   else begin
     R.C[I]:= M;
     S:=0;
    end;
 end;
 I:= R.L-1;
 while (R.C[I]=0) and (I>0) do
  begin
   Dec(R.L);
   Dec(I);
  end;
end;

procedure HexMult (A,B: TRec; var C: TRec);    {ymnozhenie}
var
i,j,M,N,R,S,S1:byte;
begin
if not(A.Z = B.Z) then
 C.Z:= false;
 if A.L<=B.L then C.L:= B.L
 else C.L:= A.L;
S:=0;
S1:=0;
 for i:=0 to B.L-1 do
  begin
  j:=0;
    while (j<A.L) or (S<>0) do
      begin
       if j>=A.L then
        if S<>0 then Inc(C.L);
        R:= B.C[i]*A.C[j]+S;
        M:= R mod p;
        S:= R div p;
        N:= C.C[i+j]+M+S1;
        if N > p-1 then
          begin
            C.C[i+j]:= N mod p;
            S1:=N div p;
          end
        else
          begin
            C.C[i+j]:= N;
            S1:=0;
          end;
        if S1<>0 then
         begin
          C.C[i+j+1]:= S1;
          if (i+j+1)>C.L then
          Inc(C.L);
          S1:=0;
         end;
       Inc(j);
      end;
  end;
end;

procedure HexDel(A,B:TRec; var C,O:TRec);          {delenie}
var
n,i,j:byte;
Sdv,M,C1,O1:TRec;
begin
if not(A.Z = B.Z) then
 C.Z:= false;
Null(C1);
Null(Sdv);
O:=A;
if A.L>B.L then
 n:=A.L-B.L
else
 n:=0;
  for i:= n downto 0 do
   begin
      Null(Sdv);
      Null(M);
      Sdv.C[i]:=1;
      Sdv.L:=i+1;
      for j:= B.L-1 downto 0 do
        M.C[j+i]:=B.C[j];
      while sravnenie(O,M) do
        begin
          O1:=O;
          HexMinus(O1,M,O);
          C1:=C;
          HexPlus(C1,Sdv,C);
      end;
   end;
end;

procedure HexPlusZn(A,B:TRec;var C:TRec);
begin
 case A.Z = B.Z of
  true: case A.Z of
         true: HexPlus(A,B,C);
         false:begin
                 HexPlus(A,B,C);
                 C.Z:=false;
               end;
        end;
  false: case A.Z of
          true: HexMinus(A,B,C);
          false:HexMinus(B,A,C);
         end;
 end;
end;

procedure HexMinusZn(A,B:TRec; var C:TRec);
begin
 case A.Z = B.Z of
  true: case A.Z of
         true: HexMinus(A,B,C);
         false:HexPlus(B,A,C);
        end;
  false: case A.Z of
          true: HexPlus(A,B,C);
          false:begin
                  HexPlus(A,B,C);
                  C.Z:=false;
                end;
         end;
 end;
end;

procedure Gr;
  var
  x,y:byte;
  begin
    textcolor (15);
    textbackground (1);
    clrscr;
    Fastwrite ('===Hex Calculator===       made by Leontev Alexey 9373',2,20, $0F);

    Fastwrite ('Please ENTER First value:', 4,3, white);
    FastFill (20,' ', 5,1, 1);
    FastWrite ('0',6,1,white);

    Fastwrite ('Choose operation:+,-,*,/', 9,3, white);
    FastFill (1,' ', 10,1, 1);
    FastWrite ('+',10,1,white);

    Fastwrite ('Please ENTER Second value:', 13,3,white);
    FastFill (20,' ', 14,1, 1);
    FastWrite ('0',14,1,white);

    FastWrite('Podscet',18,4,yellow);

    Fastwrite ('Result', 21,4, white);
    FastFill (40,' ', 22,1, 1);
    FastWrite ('0',22,1,white);
    Textbackground(0);
    textcolor(14);
    x:=1;
    y:=6;
    gotoxy(x,y);
  end;

var
   A,B,O,C:TRec;
   I,S,x,y: byte;
   M:integer;
   k,D:char;
   SA,SB:string;
begin
   Null(A);
   Null(B);
   Null(C);
   Null(O);
    Gr;
     y:=6;
     x:=1;
     D:='+';
      repeat
       k:= readkey;
        case k of
         #9: begin
          if y=18 then
             y:=6
          else
             y:=y+4;
             gotoxy(x,y);
           end;
#13: case y of
        6:ReadHex(A,SA,1,6);
       14:ReadHex(B,SB,1,14);
{SB+}  18:begin
           if ReadHex(A,SA,1,6) and ReadHex(B,SB,1,14) then
{$B-}      case D of
             '+': HexPlusZn(A,B,C);
             '-': HexMinusZn(A,B,C);
             '*': HexMult(A,B,C);
             '/': HexDel(A,B,C,O);
           end;
           gotoxy(1,22);
           WriteHex(C);
           if D= '/' then begin
               Fastwrite ('ostatok', 23,1, white);
               gotoxy(1,24);
               WriteHex(O);
             end;
          end;
     end;
#8: case y of
    6: begin
        Delete(SA,Length(SA)-1,1);
        gotoxy(1+Length(SA),6);
        write(' ');
       end;
    14: begin
         Delete(SB,Length(SB)-1,1);
         gotoxy(1+Length(SA),14);
         write(' ');
       end;
    end;
else
  begin
    case y of
     6:  begin
          write(k);
          readln(SA);
          SA:=k+SA;
          gotoxy(1,6);
         end;
     10: begin
           if k in ['+','-','*','/'] then begin
             D:= k;
             FastWrite (k,10,1,white);
           end;
         end;
     14: begin
          write(k);
          readln(SB);
          SB:=k+SB;
         end;
    end;
  end;
end;
until k in [#27,#29,'y','Y'];
end.