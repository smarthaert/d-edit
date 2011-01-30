program a1;
var k:integer;
function form:integer;
var x,y:char;p:integer;
begin
      if k=1
      then begin read(x);
             if x in ['0'..'9']
             then begin  k:=2; form:=ord(x)-ord('0')+form end
             else if x='='
                  then begin form:=0; k:=2 end
                  else begin writeln('error:znak'); form:=10000 end
           end
       else begin read(y);
                 if y<>'='
                 then begin read(x);
                            if not( x in ['0'..'9'])
                            then begin writeln('error:chislo');form:=10000 end
                            else begin if y='-'
                                       then p:=-ord(x)+ord('0')
                                       else if y='+'
                                            then p:=ord(x)-ord('0')
                                            else begin writeln('error:znak');
                                                       form:=10000
                                                 end;
                                        form:=p+form
                                  end
                         end
                  else form:=0

              end
 end;
 begin k:=1; writeln(form) end.
