Program DV_TO_TEN;
var chislo:integer;
function perevod:integer;
var c:char;
Begin read(c);
      if c=' '
      then perevod:=chislo
      else if c='0'
           then begin chislo:=chislo*2; perevod:=perevod end
           else if c='1'
                then begin chislo:=chislo*2+1; perevod:=perevod end
                else begin writeln('Ошибочный символ'); exit end
End;
BEGIN writeln('Введите двоичное число, закончив его пробелом ');
      writeln('Вы ввели число: ',perevod)
END.

