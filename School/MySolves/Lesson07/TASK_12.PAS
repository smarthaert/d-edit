program identif;
type lit=set of 'a'..'z';
     cif=set of '0'..'9';
var k:integer;li:lit; ci:cif;
function id:boolean;
var x:char;
Begin li:=['a'..'z']; ci:=['0'..'9'];
      read(x);
      if k=1
      then if x in li
           then begin k:=k+1; id:=id end
           else id:=false
      else if (x in li) or (x in ci)
           then id:=id
           else id:=x=' '
End;
BEGIN k:=1; writeln(id)END.