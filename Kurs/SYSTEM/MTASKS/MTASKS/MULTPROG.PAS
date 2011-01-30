{*********************************}
{*      Демонстрация работы      *}
{*  многопроцессорного монитора  *}
{*         VSTasks v 1.01        *}
{*   (c) VVSsoft Group, 1993     *}
{*********************************}

{$S-,I-}
Uses VSTasks, Crt;

Const
  ExitProg : boolean = False;

Var
  Ch : char;

procedure InputChar; far;
begin
 Writeln('Процесс 1!!!');
 repeat
  If KeyPressed then Ch:=ReadKey
   else SwithTasks;
 until ExitProg;
 HaltCurrentTask; { для версии 1.0 обязательно, для 1.01 ненужен }
end;

procedure OutChar; far;
begin
 Writeln('Процесс 2!!!');
 repeat
  Case Ch of
   #32..#255 : begin
               Write(Ch);
               Ch:=#0;
              end;
   #27 : ExitProg:=True;
   else SwithTasks;
  end;
 until ExitProg;
end;

begin
 RegisterTask(@InputChar,1024);
 RegisterTask(@OutChar,1024);
 StartTasks;
 Writeln;
 Writeln('Работа закончена');
end.

{http://www.warsh.com - Библиотека программиста - http://bp.da.ru}
{Более 100 исходников, более гигабайта русской документации, не верите?}
{Зайдите, посмотрите! Удачной компиляции!}
