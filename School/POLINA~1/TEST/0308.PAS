var fin, fout: text;
    s:string;
    f1, f2, i: integer;
begin
  assign(fin, 'in.txt');
  reset(fin);
  assign(fout, 'out.txt');
  rewrite(fout);
  f1:=1;
  f2:=1;
  while not eof(fin) do
    begin
      readln(fin, s);
      for i:=1 to length(s) do
        if s[i] in ['A'..'Z']
          then begin
                 s[i]:= chr((ord(s[i]) - ord('A') + f1) mod 26 + ord('A'));
                 f2:=(f1+f2) mod 26;
                 f1:=(f2-f1) mod 26;
               end;
      writeln(fout, s);
    end;
  close(fin);
  close(fout);
end.