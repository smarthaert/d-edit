### Отличия Turbo-Pascal от Delphi ###
```
program DemoProject;

{$APPTYPE CONSOLE}

uses
  SysUtils;

// Пример демонстрирует различие между object и class
type
  Number = integer;
  // Объявление класса 
  MyClass = class // неявное наследование от TObject
    x,y : Number;
    constructor Create( ix : Number ); // Конструктор 
    destructor Free; // Деструктор 
    function MyMethod : Number; // Другой метод
  end;
  // Объявление типа данных object 
  MyObject = object // Расширенный record 
    x,y : Number;
    function MyMethod : Number;
  end;

constructor MyClass.Create; // Конструктор
begin
  x := ix;
  y := 0;
end;

destructor MyClass.Free; // Деструктор
begin
  writeln('Free');
end;

// Методы в object и class объявляются одинаково!
function MyClass.MyMethod : Number;
begin
  Result := x*y;
end;

function MyObject.MyMethod : Number;
begin
  Result := x*y;
end;

procedure SimulateClassesByPointers;
var Ap,Bp : ^MyObject; // 2 указателя на объект 
begin
  new(Ap); new(Bp);
  Bp := Ap;
  Ap.x := 20;
  writeln('A = ',Ap.x,' B = ',Bp.x); // A = 20 B = 20 
end;

var
  Ac,Bc : MyClass; // 2 переменные - экземпляры класса 
  Ao,Bo : MyObject; // 2 объекта
begin
  Ac := MyClass.Create(1);
  Bc := Ac;
  Ac.x := 3;
  writeln('A = ',Ac.x,' B = ',Bc.x); // A = 3 B = 3 
  Bc.x := 9;
  writeln('A = ',Ac.x,' B = ',Bc.x); // A = 9 B = 9 
  Bo := Ao;
  Ao.x := 3;
  writeln('A = ',Ao.x,' B = ',Bo.x); // A = 3 B = 0 
  Bo.x := 9;
  writeln('A = ',Ao.x,' B = ',Bo.x); // A = 3 B = 9 
  SimulateClassesByPointers;
  Ac.Free;
  readln;
end.
```


### Использование виртуальных функций ###
```
program VirtualDemo;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  Shape = class
    procedure Draw; virtual;
  end;
  Square = class(Shape)
    procedure Draw; override;
  end;
  Circle = class(Shape)
    procedure Draw; override;
  end;
  Text3D = class(Shape)
    procedure Draw; override;
  end;

procedure Shape.Draw;
begin
  writeln('Shape.Draw');
end;

procedure Square.Draw;
begin
  writeln('Square.Draw');
end;

procedure Circle.Draw;
begin
  writeln('Circle.Draw');
end;

procedure Text3D.Draw;
begin
  writeln('Text3D.Draw');
end;

var
  A : array [1..3] of Shape;
  i : integer;
begin
  A[1] := Square.Create;
  A[2] := Circle.Create;
  A[3] := Text3D.Create;
  for i := low(A) to high(A) do
    A[i].Draw;
  // Square.Draw, Circle.Draw, Text3D.Draw
  readln;
end.
```