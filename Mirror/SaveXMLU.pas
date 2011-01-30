unit SaveXMLU;

interface

procedure SaveXML( fileName:String; XML:WideString );

implementation

procedure SaveXML( fileName:String; XML:WideString );
var
  T : TextFile;
  i,j : Integer;
  TabLevel : Integer;
  mode : (Outside,InsideString,OpenTagInside,CloseTagInside);
  Buf : array [1..100000] of Char;  { buffer }

procedure NewLine;
var j : Integer;
begin
  writeln(T);
  for j:=1 to TabLevel*2 do write(T,' ');
end;

begin
  // - Открываем файл для записи -
  AssignFile(T,fileName);
  SetTextBuf(T, Buf); // Для ускорения записи
  Rewrite(T);
  // - Запись в файл -
  writeln(T,'<?xml version="1.0" encoding="windows-1251"?>');
  TabLevel := 0;
  Mode := Outside;
  for i:=1 to Length(XML) do begin
    // Действия перед выводом символа в файл
    case XML[i] of
      '<': begin { Начало тега }
        if XML[i+1]='/' then begin { Начало закрывающего тега "</" }
//          if Mode = Inside then need_NewLine := false;
          Mode := CloseTagInside;  { Если у нас начало закрывающего XML тега => }
          dec( TabLevel ); { надо уменьшить табуляцию перед его выводом }
        end else begin { Начало открывающего тега "<" }
          NewLine;
          Mode := OpenTagInside;
          Inc( TabLevel );
        end;
      end;
      '>': { Конец тега }
        begin
          if XML[i-1]='/' then begin { "/>" - конец "свёрнутого" тега }
            Dec( TabLevel );
            mode := OutSide;
          end else
            case mode of
              CloseTagInside: mode := OutSide;
              OpenTagInside: begin
                j:=i+1;
                while XML[j]<>'<' do inc(j);
                if XML[j+1]='/' then mode := InsideString else mode := Outside;
              end;
            end;
        end;
    end;

    { Табуляция в начале строки }
//    if need_NewLine then begin
//      need_NewLine := false;
//    end;

    { - Вывод очередного символа в файл - }
    if mode = InsideString then // Если это данные => выводим любой символ, не обращая внимания, что там
      // может быть любая ерунда
      write(T,XML[i])
    else // Но если это не данные => удаляем все системные символы!
      if ord(XML[i])>=32 then write(T,XML[i]);
  end;
  CloseFile(T);
end;

end.
