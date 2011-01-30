Uses Dos;

Var DirInfo:SearchRec;
    T:Text; Path:String;
Begin
  Assign(T,'!bppath.txt'); 
  Reset(T);
  Readln(T,Path);
  Close(T);
  Assign(T,'!COMP.BAT');
  Rewrite(T);
  Writeln(T,'PATH ',Path);
  FindFirst('*.PAS',Archive,DirInfo);
  While DosError = 0 do
    Begin
      Writeln(DirInfo.Name);
      Writeln(T,'BPC ',DirInfo.Name);
      FindNext(DirInfo);
    End;
  Close(T);
End.
