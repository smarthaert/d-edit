{$APPTYPE CONSOLE}

Uses SysUtils,Task0304;

{ Генерация правильной скобочной последовательности }
function Gen : String;
var numBr : Integer;
begin
  Result := '';
  numBr:=0; { Текущее количество открывающих - количество закрывающих }
  repeat
    if numBr = 0 then begin
      Result := Result + '('; inc(numBr);
    end else begin
      { Выбор случайной скобки }
      case Random(2) of
        0: begin
          Result := Result + '(';
          inc(numBr);
         end;
        1: begin
          Result := Result + ')';
          dec(numBr);
         end;
      end;
    end;
  until numBr = 0;
end;


Type
  TIntArray = Array of Integer;

{ Генерация последовательности чисел по скобочной последовательности }
function toNumbers( S:String ):TIntArray;
var
  Stack : TIntArray;
  SP,Ans,i : Integer;
begin
  assert( Length(S) mod 2 = 0 ); // Длина строки должна быть всегда чётной
  assert( isCorrect(S) ); // И вообще она должна быть корректной
  // -----------------------------------------
  SetLength(Result,Length(S) div 2);
  SetLength(Stack,Length(S) div 2); // Максимальная глубина стека такая же :)
  SP := -1;
  Ans := Length(Result);
  for i:=Length(S) downto 1 do
    case S[i] of
      ')': begin { Добавляем закрывающую скобку в стек }
          inc(SP);
          Stack[SP] := i;
        end;
      '(': begin { Извлекаем результат }
          dec(Ans);
          Result[Ans] := Stack[SP] - i - 1;
          dec(SP);
        end;
    end;
end;

procedure SaveStringToFile( FileName:String; Data:String );
var T : TextFile;
begin
  AssignFile(T,FileName);
  Rewrite(T);
  Writeln(T,Data);
  CloseFile(T);
end;

procedure SaveIntArrayToFile( FileName:String; Data:TIntArray );
var T : TextFile;
  i : Integer;
begin
  AssignFile(T,FileName);
  Rewrite(T);
  Writeln(T,Length(Data));
  for i:=0 to Length(Data)-1 do
    Writeln(T,Data[i]);
  CloseFile(T);
end;

{ Проверка, есть ли уже такая строка }
var
  T : array [1..100] of String;
  TN : Integer = 0;

procedure Add( S:String );
begin
  inc(TN);
  T[TN] := S;
end;

function Exists( S:String ):boolean;
var i : Integer;
begin
  Result := false;
  for i:=1 to TN do
    if T[i]=S then begin
      Result := true;
      exit;
    end;
end;

var
  X,Y : TIntArray;
  i : Integer;
  S : String;
  ch : Char;
begin
  assert(isCorrect('(())'));
  assert(not isCorrect('(())('));
  {}
  S := '()(()(()()))'; Add(S);
  SetLength(X,6);
  X[0]:=0; X[1]:=8; X[2]:=0; X[3]:=4; X[4]:=0; X[5]:=0;
  Y := toNumbers(S);
  assert( Length(Y) = Length(X) );
  for i:=0 to Length(Y)-1 do assert( X[i]=Y[i] );
  SaveStringToFile('01.a',S);
  SaveIntArrayToFile('01',toNumbers(S));
  {}
  S := '(()(((()))()()))'; Add(S);
  SetLength(X,8);
  X[0]:=14; X[1]:=0; X[2]:=10; X[3]:=4; X[4]:=2; X[5]:=0; X[6]:=0; X[7]:=0;
  Y := toNumbers(S);
  assert( Length(Y) = Length(X) );
  for i:=0 to Length(Y)-1 do assert( X[i]=Y[i] );
  SaveStringToFile('02.a',S);
  SaveIntArrayToFile('02',toNumbers(S));
  {}
  S := '(())'; Add(S);
  SetLength(X,2);
  X[0]:=2; X[1]:=0;
  Y := toNumbers(S);
  assert( Length(Y) = Length(X) );
  for i:=0 to Length(Y)-1 do
    assert( X[i]=Y[i] );
  SaveStringToFile('03.a',S);
  SaveIntArrayToFile('03',toNumbers(S));
  {}
  RandSeed := 239;
  for ch:='4' to '9' do begin
    repeat
      S := Gen;
    until not Exists(S);  
    Add(S);
    SaveStringToFile('0'+ch+'.a',S);
    SaveIntArrayToFile('0'+ch,toNumbers(S));
  end;
end.
