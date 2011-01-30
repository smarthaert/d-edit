Program A;
function form:integer;
var y,x:char;
begin read(x);
   if x='='
   then form:=0
   else
      if x in ['0'..'9']
      then begin read(y);
                 if y='+'
                 then form:=ord(x)-ord('0')+form
                 else if y='='
                      then form:=ord(x)-ord('0')
                      else begin write('error');
                                 form:=10000
                           end
          end
       else begin write('error'); form:=10000
            end
end;
  BEGIN write(form) END.