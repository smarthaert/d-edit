{
From: root@cct.bishkek.su (Youriev Leonid)
Organization: CCT Ltd.
Date: Wed, 29 Dec 93 12:40:04 GMT
Subject: Еще один вариант разделения времени

Hello All !

   Я тут прочел письмо Владимира Конова (прошу прошенья, отчество он не указал)
о его библиотечке "мягкого" разделения времени, и решил подкинуть свою похожую.
Убедился на собственном опыте - такая штука очень многое позволяет.  Для
заинтересовавшихся ниже DEMO и исходники, а также немного пояснений т. к. в
тексте коментариев нет (есть у меня такой грешок).

C наилучшими пожеланиями.
        Юрьев Леонид Валерьевич
        wyk@imfiko.bishkek.su (может сменится, тогда пишите в relcom.*.pascal)
--------------------------------------------------------------------------
>    Все похоже на UNIX-fork
   if fork (StackSize, BackTraceStackFrameCount) then
      begin
         "сын"
         _; переключение
         killSELF; закрываем
      end
   else
      begin
         "отец"
         _; переключение
      end

>    fork делает:
       - AllocMem (StackSize) под стек "сына"
       - затем копирует BackTraceStackFrameCount кадров стека
         из стека "отца" в стек "сына" т.е. дублирует цепочку вызовов и
         параметров/локальных_переменных

>    процедура выполняющая переключение "_;" в зависимости от DEFINE в
     Version.PAS статовится либо INT 0/$CD/$00 (с сохранением divide by zero)
     либо INT3/$CC (красиво воюет с отладчиками) либо CALL FAR.


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}
program DEMO;

uses    Dark, Crt;

type
   TScreen = array [0..124] of array [0..79] of record C : Char; A : Byte end;
var
    Screen  : TScreen absolute $B800:0000;
    Save    : TScreen;

procedure X;
var
    I : Integer;
    Y : Integer;
    C : Char;
    N : Integer;
begin
    I := 0;
    N := -1;
    C := '0';
    for I := 0 to 79 do
        begin
        if fork (2000, 1) then
            repeat {тело процесса - сына}
                for Y := 1 to Hi (WindMax) - 1 do
                    begin
                        _; {переключение}
                        if N >= 0 then Screen [N, I].C := Save [N, I].C;
                        N := Y;
                        Screen [Y, I].C := C;
                        if Y = random (Y + 5) then
                            begin
                                Y := 0;
                                Inc (C);
                            end;
                    end;
            until FALSE;
            _;
        end;
end;

var
    C   : Char;
begin
   InitDark;
   _;
   clrscr;
   gotoxy (1, 3);
   Writeln ('            Демонстрация разделения времени.');
   Writeln ('  Каждая падающая буква - самостоятельная "нить" задачи.');
   Writeln ('Итого: сейчас работает 80 фоновых процессов,');
   Writeln ('       а основной - следит за клавиатурой и делает Delay (20).');
   Writeln ('Enter - для окончания. vyk@kot.bishkek.su');
   Writeln ('');
   Writeln (' Start  Stop   Length Name               Class');
   Writeln ('');
   Writeln (' 00000H 0062AH 0062BH t                  CODE');
   Writeln (' 00630H 00C4EH 0061FH Crt                CODE');
   Writeln (' 00C50H 00E20H 001D1H Dark               CODE');
   Writeln (' 00E30H 00F25H 000F6H Memory             CODE');
   Writeln (' 00F30H 01C8EH 00D5FH System             CODE');
   Writeln (' 01C90H 06D7BH 050ECH DATA               DATA');
   Writeln (' 06D80H 0AD7FH 04000H STACK              STACK');
   Writeln (' 0AD80H 0AD80H 00000H HEAP               HEAP');

   gotoxy (1, 1);
   Save := Screen;
   X;
   repeat
       _; { Переключение }
       Delay (20);
       if KeyPressed then
           begin
               C := ReadKey;
               if C = #0 then
                   C := ReadKey
               else
                   Write (C);
            end
       else
           C := #0;
   until C = #13;
   Screen := Save;
end.

{http://www.warsh.com - Библиотека программиста - http://bp.da.ru}
{Более 100 исходников, более гигабайта русской документации, не верите?}
{Зайдите, посмотрите! Удачной компиляции!}
