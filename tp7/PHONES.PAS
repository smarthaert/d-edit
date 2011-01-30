{ Turbo Pascal - Занятие 4. Сортировка строк }
function UpCaseStr( S:string ):string;
var
  Result : string;
  i : integer;
begin
  Result := S;
  for i:=1 to Length(Result) do
    Result[i] := UpCase(Result[i]);
  UpCaseStr := Result;
end;

const MaxSize = 200;
var
  Names : array [1..MaxSize] of string;
  Temp : string;
  i,j,N : integer;
begin
  { Ввод исходных данных }
  Writeln('Пожалуйста, вводите имена.');
  Writeln('Пустая строка для окончания ввода.');
  N := 0;
  repeat
    N := N + 1;
    write('Имя: '); readln(Names[N]);
  until Names[N] = '';
  { Сортировка }
  for i:=1 to N do
    for j:=i+1 to N do
      if UpCaseStr(Names[i]) > UpCaseStr(Names[j]) then begin
        Temp := Names[i];
        Names[i] := Names[j];
        Names[j] := Temp;
      end;
  { Вывод }
  for i:=1 to N do
    Writeln( Names[i] );
end.