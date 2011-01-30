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
  // - ��������� ���� ��� ������ -
  AssignFile(T,fileName);
  SetTextBuf(T, Buf); // ��� ��������� ������
  Rewrite(T);
  // - ������ � ���� -
  writeln(T,'<?xml version="1.0" encoding="windows-1251"?>');
  TabLevel := 0;
  Mode := Outside;
  for i:=1 to Length(XML) do begin
    // �������� ����� ������� ������� � ����
    case XML[i] of
      '<': begin { ������ ���� }
        if XML[i+1]='/' then begin { ������ ������������ ���� "</" }
//          if Mode = Inside then need_NewLine := false;
          Mode := CloseTagInside;  { ���� � ��� ������ ������������ XML ���� => }
          dec( TabLevel ); { ���� ��������� ��������� ����� ��� ������� }
        end else begin { ������ ������������ ���� "<" }
          NewLine;
          Mode := OpenTagInside;
          Inc( TabLevel );
        end;
      end;
      '>': { ����� ���� }
        begin
          if XML[i-1]='/' then begin { "/>" - ����� "���������" ���� }
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

    { ��������� � ������ ������ }
//    if need_NewLine then begin
//      need_NewLine := false;
//    end;

    { - ����� ���������� ������� � ���� - }
    if mode = InsideString then // ���� ��� ������ => ������� ����� ������, �� ������� ��������, ��� ���
      // ����� ���� ����� ������
      write(T,XML[i])
    else // �� ���� ��� �� ������ => ������� ��� ��������� �������!
      if ord(XML[i])>=32 then write(T,XML[i]);
  end;
  CloseFile(T);
end;

end.
