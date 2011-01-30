uses CRT;

function F( S : string ):Boolean;
var
  Word : string;
  P,i : integer;
  WordP : boolean;
begin
  while S<>'' do begin
    P := Pos(' ',S);
    if P = 0 then begin
      Word := S;
      S := '';
    end else begin
      Word := Copy(S,1,P-1);
      Delete(S,1,P);
    end;
    WordP := true;
    for i:=1 to Length(Word) do
      if Word[i] <> Word[Length(Word)-i+1] then begin
        WordP:= false;
        break;
      end;
    if WordP then begin
      F := true;
      exit;
    end;
  end;
  F := false;
end;

procedure Test( TestStr : string );
begin
  writeln('"',TestStr,'" => ',F(TestStr));
end;

begin
  ClrScr;
  Test('ono');
  Test('ono prishlo');
  Test('Kontrprimer');
  Test('mama mila ramy');
  Test('ama ama ama');
  Test('Kuda ono ushlo?');
  Test('auda ushlu?');
  Test('test tset');
end.