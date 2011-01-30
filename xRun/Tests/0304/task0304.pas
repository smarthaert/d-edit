{$ASSERTIONS ON}

Unit task0304;

interface

{ Проверка скобочной последовательности на правильность }
function isCorrect( S:String ):boolean;

implementation

Uses SysUtils;

{ Проверка скобочной последовательности на правильность }
function isCorrect( S:String ):boolean;
var Cur,i : Integer;  // Текущее количество открывающих скобок - кол-во закрывающих
begin
  Cur := 0;
  for i:=1 to Length(S) do begin
    case S[i] of
      '(': inc(Cur);
      ')': dec(Cur);
    end;
    if Cur < 0 then begin
      Result := false;
      exit;
    end;
  end;
  Result := (Cur=0);
end;

begin

end.