program a1;
var k:integer;
    znak1,znak2:char;
    chislo:integer;
function make:integer;
var c:char;
begin read(c);
      if (c='+')or(c='-')or(c='=')
      then begin make:=chislo; znak2:=c end
      else if (c>='0') and (c<='9')
           then begin chislo:=chislo*10+ord(c)-ord('0') ; make:=make end
           else begin writeln('è¨¡®ç­ë© á¨¬¢®« ¢ ç¨á«¥ '); exit end
end;
function form:integer;
var x:char; sum:integer;
begin   chislo:=0;
        sum:=make;
        if znak2='='
        then if znak1='+'
             then form:=sum
             else form:=-sum
        else begin
                if znak1='+'
                then begin znak1:=znak2; form:=form+sum end
                else if znak1='-'
                     then begin znak1:=znak2; form:=form-sum end
             end

 end;
   begin   znak1:='+'; writeln(form) end.
