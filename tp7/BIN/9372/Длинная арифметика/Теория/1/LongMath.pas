
 {
   Модуль для работы с длинными числами. 2004
    Автор: Азат

    редактировал: Romtek
 }

unit LongMath;
                                  interface

type
  real = extended;

  TComplex = record     {Тип с комплексным числом}
    Re,Im:Real;
  end;

procedure Complex_Add(x,y:TComplex; var z:TComplex);
 {Складывает комплексные числа}

procedure Complex_Sub(x,y:TComplex; var z:TComplex);
 {Вычисляет частное комплексных чисел}

procedure Complex_Mul(x,y:TComplex; var z:TComplex);
 {Умножение (коплексных)}

procedure Complex_Div(x,y:TComplex; var z:TComplex);
 {Деление (комплексных)}


const
  MaxDig = 1000; {кол-во элементов массива}
  osn = 10000;   {основание}

type
  TLong = array[0..MaxDig] of integer; {тип с длинным числом}

function  More(const a,b: TLong; Shift:integer):byte;
 {Сравнение чисел со сдвигом. Редко используется.
  Использовался только при написании модуля}

procedure Long_Read(var f:text; var a:TLong);
 {Чтение длинного числа}

procedure Long_Write(var f:text; const a:TLong);
 {Вывод длинного числа}

procedure Long_Add(a,b:TLong; var c:TLong);
 {Сложение длинных чисел}

procedure Long_Mul(a,b:TLong; var c:TLong);
 {умножение длинных чисел}

procedure Long_Mul_Longint(const k:longint; const A:TLong; var c:TLong);
 {умножает длинное число на число типа longint}

function  Long_Above(const a,b:TLong):boolean;
 {Возвращает True, если a>b}

function  Long_Less(const a,b:TLong):boolean;
 {Возвращает true, если a<b}

function  Long_Equal(const a,b:TLong):boolean;
 {Возвращает true, если a=b}

{---------------------------------------------------------------}

procedure XChange(var a,b:integer);
 {Заменяет значения переменных а и b}

function  Min(a,b:integer):integer;
 {Возвращает меньшее число из а и b}

function  Max(a,b:integer):integer;
 {Возвращает большее число из a и b}

{---------------------------------------------------------------}
{---------------------------------------------------------------}
                                implementation

{---------------------------------------------------------------}
procedure Complex_Add(x,y:TComplex; var z:TComplex); {z = x+y}
begin
  z.Im := x.Im + y.Im;
  z.Re := x.Re + y.Re;
end;

{---------------------------------------------------------------}
procedure Complex_Sub(x,y:TComplex; var z:TComplex); {z = x-y}
begin
  z.Im := x.Im - y.Im;
  z.Re := x.Re - y.Re;
end;

{---------------------------------------------------------------}
procedure Complex_Mul(x,y:TComplex; var z:TComplex); {z = x*y}
begin
  z.Re := x.Re * y.Re + x.Im * y.Im;
  z.Im := x.Re * y.Im + x.Im * y.Re;
end;

{---------------------------------------------------------------}
procedure Complex_Div(x,y:TComplex; var z:TComplex); {z = x/y}
var
  zz:Real;
begin
  zz := Sqr(y.Re) + Sqr(y.Im);
  z.Re := (x.Re * y.Re + x.Im * y.Im)/zz;
  z.Im := (x.Re * y.Im + x.Im * y.Re)/zz;
end;

{---------------------------------------------------------------}

{---------------------------------------------------------------}
function  More(const a,b: TLong; Shift:integer):byte;
var
  i:integer;
begin
  if a[0] > (b[0]+Shift) then more := 0
  else
    if a[0]<(b[0]+Shift) then more := 1
    else
      begin
        i := a[0];
        while (i>Shift) and (a[i]=b[i-Shift]) do
          dec(i);
        if i = Shift then
          begin
            more := 0;
            for i := 1 to Shift do
              if a[i] > 0 then exit;
            more := 2;
          end
        else
          more := byte(a[i]<b[i-Shift]);
      end;
end;

{---------------------------------------------------------------}
procedure Long_Read(var f:text; var a:TLong);
var
  ch:char;
  i:integer;
begin
  FillChar(a,Sizeof(A),0);
  repeat
    Read(f,ch);
  until ch in ['0'..'9'];
  while ch in ['0'..'9'] do
    begin
      for i := a[0] downto 1 do
        begin
          a[i+1] := a[i+1]+(Longint(a[i])*10) div osn;
          a[i]   := (Longint(a[i])*10) mod osn;
        end;
      a[1] := a[1]+Ord(ch)-ord('0');
      if a[a[0]+1]>0 then inc(a[0]);
      Read(f,ch)
    end
end;

{---------------------------------------------------------------}
procedure Long_Write(var f:text; const a:TLong);
var
  ls,s:string;
  i:integer;
begin
  Str(Osn div 10,ls);
  Write(f,A[A[0]]);
  for i := a[0]-1 downto 1 do
    begin
      Str(a[i],s);
      while Length(s)<Length(ls) do s := '0'+s;
      Write(f,s);
    end;
  WriteLn
end;

{---------------------------------------------------------------}
procedure Long_Add(a,b:TLong; var c:TLong);   {c = a+b}
var
  i,k:integer;
begin
  fillchar(c,SizeOF(c),0);
  if a[0]>b[0] then k := a[0] else k := b[0];
  for i := 1 to k do
    begin
      c[i+1] := (c[i]+a[i]+b[i]) div osn;
      c[i]   := (c[i]+a[i]+b[i]) mod osn;
    end;
  if c[k+1]=0 then c[0] := k else c[0] := k+1;
end;

{---------------------------------------------------------------}
procedure Long_Mul(a,b:TLong; var c:TLong); {c = a*b}
var
  i,j:word;
  dv:Longint;
begin
  FillChar(c,SizeOF(c),0);
  for i := 1 to a[0] do
    for j := 1 to b[0] do
      begin
        dv := Longint(a[i])*b[j] + c[i+j-1];
        inc(c[i+j], dv div osn);
        c[i+j-1] := dv mod osn;
      end;
  c[0] := a[0]+b[0];
  while (c[0]>1) and (c[c[0]] = 0) do dec(c[0]);
end;

{---------------------------------------------------------------}
procedure Long_Mul_Longint(const k:longint; const A:TLong; var c:TLong); {c = k*a}
var
  i:integer;
begin
  fillChar(c,SizeOf(C),0);
  if k = 0 then inc(c[0])
  else
    begin
      for i := 1 to a[0] do
        begin
          c[i+1] := (LongInt(a[i])*k+c[i]) div osn;
          c[i] := (LongInt(a[i])*k+c[i]) mod osn;
        end;
      if c[a[0]+1]>0 then c[0] := a[0]+1
      else c[0] := a[0];
    end;
end;

{---------------------------------------------------------------}
function Long_Above(const a,b:TLong):boolean;
var
  q:boolean;
  i:integer;
begin
  if a[0]<b[0] then
    begin
      Long_Above := false;
      exit;
    end;
  if a[0]>b[0] then
    begin
      Long_Above := true;
      exit;
    end;
  if a[0] = b[0] then
    begin
      for i := a[0] downto 1 do
        if a[i] < b[i] then begin q := false; break; end
        else q := true;
    end;
  Long_Above := q;
end;
{---------------------------------------------------------------}
function Long_Less(const a,b:TLong):boolean;
var
  q:boolean;
  i:integer;
begin
  if a[0]>b[0] then
    begin
      Long_Less := false;
      exit;
    end;
  if a[0]<b[0] then
    begin
      Long_Less := true;
      exit;
    end;
  if a[0] = b[0] then
    begin
      for i := a[0] downto 1 do
        if a[i] > b[i] then begin q := false; break; end
        else q := true;
    end;
  Long_Less := q;
end;
{---------------------------------------------------------------}
function  Long_Equal(const a,b:TLong):boolean;
var
  q:boolean;
  i:integer;
begin
  if a[0] = b[0] then
    for i := 1 to a[0] do
      if a[i] <> b[i] then begin q := false; break; end
      else q := true
  else q := false;
  Long_Equal := q;
end;

{---------------------------------------------------------------}

{---------------------------------------------------------------}
procedure XChange(var a,b:integer);
var temp: integer;
begin
     temp := a;
     a := b;
     b := temp;
end;

{---------------------------------------------------------------}
function  Min(a,b:integer):integer;
begin
     if a > b then
        Min := b
     else
        Min := a;
end;

{---------------------------------------------------------------}
function  Max(a,b:integer):integer;
begin
     if b > a then
        Max := b
     else
        Max := a;
end;

end.
