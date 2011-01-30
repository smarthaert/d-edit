{ Программа для написания Bat файла !Comp.bat, }
{ который будет компилировать все файлы с расширением PAS }
{ в данном каталоге. }
{ Для кооректной работы небходимо наличие в данном каталоге }
{ файла !bppath.txt содержащего путь к Borland Pascal }
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
  Writeln(T,'@ECHO OFF');
  Writeln(T,'Копилирование всех *.PAS файлов в данном каталоге');
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
