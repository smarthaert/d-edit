{ >>> Симулятор пользователей для программы Contest Server <<< }
Uses CRT;
{$I-}
Var Dir,SubDir:String; I,Number:Byte; C,LastTask:Char; T:Text;
Begin
  Writeln('>>> Симулятор пользователей для программы Contest Server <<<');
  Write('Каталог пользователей : ');
  Readln(Dir);
  Write('Число пользователей : ');
  Readln(Number);
  Write('Имя последней задачи : ');
  Readln(LastTask);
  Writeln('* Для выхода нажмите любую клавишу *');
  Repeat
    For I:=1 to Number do
      Begin
        Str(I,SubDir);
        While Length(SubDir) < 2 do SubDir:='0'+SubDir;
        SubDir:=Dir+'\'+SubDir;
        For C:='A' to LastTask do
          Begin
            Assign(T,SubDir+'\'+C+'.PAS');
            Rewrite(T);
            If IOResult <> 0 then Continue;
            Writeln(T,'!TEST!');
            Close(T);
          End;
      End;
  Until KeyPressed;
End.