program ten_to_ten;
var chislo:integer;
function make:integer;
var c:char;
begin read(c);
      if c=' '
      then make:=chislo
      else if (c>='0') and (c<='9')
           then begin chislo:=chislo*10+ord(c)-ord('0') ; make:=make end
           else begin writeln('�訡��� ᨬ��� � �᫥ '); exit end
end;
Begin writeln('������ ����� ��� ��ॢ���, �����稢 �஡���� ');
      writeln(make)
End.