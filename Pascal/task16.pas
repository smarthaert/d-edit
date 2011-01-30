{ 16. Написать, в которую передаются массив из 128 STRING,
  содержащий строки из слов. Вернуть массив, содержащий
  количество повторений каждой из строчных (маленьких)
  латинских букв }

const Num = 8; { 128 }

type
  Arr = array [1..Num] of String;
  CountLetters = array ['a'..'z'] of integer;

{ A - массив строк (входные данные)
  CL - массив счётчиков букв }
procedure Count( A:Arr; var CL:CountLetters );
var
  i,j : integer;
  C : char;
begin
  { Обнуляем массив счётчиков букв }
  for C := 'a' to 'z' do
    CL[C] := 0;
  { Пробегаем в цикле по всем строкам массива }
  for i:=1 to Num do
    for j:=1 to Length(A[i]) do
      if A[i,j] in ['a'..'z'] then
        Inc( CL[A[i,j]] ); { CL[A[i,j]] := CL[A[i,j]] + 1; }
end;

procedure ShowArray( A : Arr );
var i : integer;
begin
  for i:=1 to Num do
    writeln(A[i]);
  writeln;
end;

const
  ExampleData : Arr = (
    'William Shakespeare (baptised 26 April 1564 - died 23',
    ' April 1616)[a] was an English poet and playwright,',
    'widely regarded as the greatest writer in the English',
    'language and the world''s preeminent dramatist. He is',
    ' often called England''s national poet and the "Bard of Avon".',
    ' His surviving works, including some collaborations, consist',
    ' of 38 plays, 154 sonnets, two long narrative poems,',
    ' and several other poems.');

var
  Res : CountLetters;
  C : Char;
begin
  ShowArray(ExampleData);
  Count(ExampleData,Res);
  for C:='a' to 'z' do
    write(C,' ',Res[C]:3,'   ');
end.
