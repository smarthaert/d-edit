{ Turbo Pascal - ����⨥ 3. ����� - ��ॢ�� 楫��� �᫠ � 
  ������� ��⥬� ��᫥��� � �뢮� �� ��࠭ }
uses CRT;

var
  N : integer;
  Result,S1 : string;
  Answer : Char;
begin
  ClrScr; { ClearScreen }
  repeat
    write('N = '); readln(N);
    Result := '';
    while N > 0 do begin
      { writeln(N mod 2);} { ���⮪ �� ������� �� 2 }
      str(N mod 2,S1);
      Result := S1 + Result;
      N := N div 2; { ������� �� 2 ��楫� }
      { writeln('N ᥩ�� ',N);}
    end;
    writeln('N in binary = ',Result);
    write('Retry(y/n)? ');
    repeat
      Answer := Upcase(ReadKey);
    until (Answer = 'Y') or (Answer = 'N');
    writeln(Answer);
  until Answer = 'N';
  writeln('Enter for exit');
  readln;
end.