{ Простейщий пример Объектно-Ориентированного программирования }
type
  Square = object
    Side : Real;
    constructor Init( const _Side:Real );
    function Area : Real; { Получить площадь квадрата }
    procedure SetArea( const _Area:Real );
    destructor Done;
  end;

constructor Square.Init;
begin
  writeln('Создаём квадрат со стороной: ',_Side:0:2);
  Side := _Side;
end;

function Square.Area : Real;
begin
  Area := Side*Side;
end;

procedure Square.SetArea;
begin
  writeln('Задаём площадь равной: ',_Area:0:2);
  Side := sqrt(_Area);
end;

destructor Square.Done;
begin
  writeln('Уничтожаем объект');
end;

var A : ^Square;
begin
  new( A, Init(2) );
  writeln('Площадь квадрата: ',A^.Area:0:2);
  A^.SetArea(9);
  writeln('Строна квадрата: ',A^.Side:0:2);
  dispose( A, Done );
end.