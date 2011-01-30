Uses CRT,DOS;

{ ---=== Работа со списком ===--- }
 Type
   PItem = ^TItem;
   TItem = Record
     Name : String; { ФИО }
     Group : Word; { Номер группы }
     Show : Boolean; { Флаг показанности }
     Next : PItem;
     Case State:Char of { Положение }
      '1': { Студент }
       ( Sex : Char; { Пол }
         FamSt : String; { Семейное положение }
         Home : Word ); { Номер общежития }
      '2': { Выпускник }
       ( Mark : Real; { Средний балл }
         Born : Word; { Год рождения }
         Work : String ); { Место распределения }
   End;

 Const Root : PItem = nil;

 Function Choose( C1,C2:Char ):Char;
   Var Key:Char;
   Begin
     Repeat
       Key:=UpCase(ReadKey);
     Until ((Key=C1) Or (Key=C2));
     Choose:=Key;
   End;

 Function EnterNum( S:String ):Real;
   Var Buf:String; Num:Real; Error:Integer;
   Begin
     Repeat
       Write(S);
       Readln(Buf);
       Val(Buf,Num,Error);
       If Error<>0 then
         Begin
           TextColor(12);
           Writeln('Ошибка: Неверный формат числа !');
           TextColor(7);
         End;
     Until Error = 0;
     EnterNum:=Num;
   End;

 Procedure AddEl;
   Var Buf,Cur:PItem;
   Begin
     New(Buf);
     TextColor(15);
     Writeln('---=== Добавление студента/выпускника ===---');
     TextColor(7);
     With Buf^ do
       Begin
         Write('Введите ФИО: ');
         Readln(Name);
         Group:=Trunc(EnterNum('Введите номер группы: '));
         Write('Студент/Выпускник [1/2] ');
         State:=Choose('1','2');
         Case State of
           '1':
             Begin
               Writeln('<Студент>');
               Write('Пол [1-Мужчина/0-Женщина]: ');
               Sex:=Choose('1','0');
               Case Sex of
                '1': Writeln('<Мужчина>');
                '0': Writeln('<Женщина>');
               End;
               Write('Семейное положение: ');
               Readln(FamSt);
               Home:=Trunc(EnterNum('Номер общежития: '));
             End;
           '2':
             Begin
               Writeln('<Выпускник>');
               Mark:=EnterNum('Средний балл: ');
               Born:=Trunc(EnterNum('Год рождения: '));
               Write('Место распределения: ');
               Readln(Work);
             End;
         End;
         Next:=nil;
       End;
     If Root<>nil then
       Begin
         Cur:=Root;
         While Cur^.Next<>nil do
           Cur:=Cur^.Next;
         Cur^.Next:=Buf;
       End
     Else
       Root:=Buf;
   End;

 Procedure DelAllEl;
   Var Buf:PItem;
   Begin
     While Root<>nil do
       Begin
         Buf:=Root;
         Root:=Root^.Next;
         Dispose(Buf);
       End;
   End;

 Procedure Show1( Buf:PItem );
   Begin
     If Buf^.Show then Exit;
     Writeln('---===### Студент ###===---');
     With Buf^ do
       Begin
         Writeln('ФИО: ',Name);
         Writeln('Номер группы: ',Group);
         Write('Пол : ');
         Case Sex of
          '1': Writeln('<Мужчина>');
          '0': Writeln('<Женщина>');
         End;
         Writeln('Семейное положение: ',FamSt);
         Writeln('Номер общежития: ',Home);
         Show:=True;
       End;
   End;

 Procedure Show2( Buf:PItem );
   Begin
     If Buf^.Show then Exit;
     Writeln('---===### Выпускник ###===---');
     With Buf^ do
       Begin
         Writeln('ФИО: ',Name);
         Writeln('Номер группы: ',Group);
         Writeln('Средний балл: ',Mark);
         Writeln('Год рождения: ',Born);
         Writeln('Место распределения: ',Work);
         Show:=True;
       End;
   End;

 Procedure ClearShowFlag;
   Var Buf:PItem;
   Begin
     Buf:=Root;
     While Buf<>nil do
       Begin
         Buf^.Show:=False;
         Buf:=Buf^.Next;
       End;
   End;

 Function AllShow( State:Char ):Boolean;
   Var Buf:PItem; Flag:Boolean;
   Begin
     Flag:=True;
     Buf:=Root;
     While Buf<>nil do
       Begin
         If Buf^.State = State then
           Flag:=Flag And Buf^.Show;
         Buf:=Buf^.Next;
       End;
     AllShow:=Flag;
   End;

 Procedure ShowList;
   Var Buf:PItem;
   Begin
     Writeln('>>> Вывод общего списка на экран <<<');
     ClearShowFlag;
     Buf:=Root;
     While Buf<>nil do
       Begin
         Case Buf^.State of
           '1': Show1(Buf);
           '2': Show2(Buf);
         End;
         Buf:=Buf^.Next;
       End;
   End;

 Procedure ShowList1;
   Var Buf:PItem; Min:Integer;
   Begin
     Writeln('>>> Вывод списка "Студенты" на экран <<<');
     ClearShowFlag;
     While not AllShow('1') do
       Begin
        { Выяснение миниума }
         Min:=+10000;
         Buf:=Root;
         While Buf<>nil do
           Begin
             If ((Buf^.State = '1') And (Not Buf^.Show)) then
               If Buf^.Home < Min then
                 Min:=Buf^.Home;
             Buf:=Buf^.Next;
           End;
        { Вывод минимальных }
         Buf:=Root;
         While Buf<>nil do
           Begin
             If Buf^.State = '1' then
               If Buf^.Home = Min then
                 Show1(Buf);
             Buf:=Buf^.Next;
           End;
       End;
   End;

 Procedure ShowList2;
   Var Buf:PItem; Max:Real;
   Begin
     Writeln('>>> Вывод списка "Выпускники" на экран <<<');
     ClearShowFlag;
     While not AllShow('2') do
       Begin
        { Выяснение миниума }
         Max:=-10000;
         Buf:=Root;
         While Buf<>nil do
           Begin
             If ((Buf^.State = '2') And (Not Buf^.Show)) then
               If Buf^.Mark > Max then
                 Max:=Buf^.Home;
             Buf:=Buf^.Next;
           End;
        { Вывод минимальных }
         Buf:=Root;
         While Buf<>nil do
           Begin
             If Buf^.State = '2' then
               If Buf^.Home = Max then
                 Show2(Buf);
             Buf:=Buf^.Next;
           End;
       End;
   End;

Procedure AddList;
  Begin
    Repeat
      Writeln;
      AddEl;
      Write('Продолжить [1-Да/0-Нет] ');
    Until Choose('1','0')='0';
    Writeln;
  End;

Procedure LoadList;
  Var Buf,Cur:PItem; T:Text; I:Char;
  Begin
    Assign(T,'KURS.TXT');
    Reset(T);
    Readln(T,I);
    While I <> '0' do
      Begin
        New(Buf);
        Buf^.State:=I;
        Readln(T,Buf^.Name);
        Readln(T,Buf^.Group);
        With Buf^ do
          Case Buf^.State of
            '1':
              Begin
                Readln(T,Sex);
                Readln(T,FamSt);
                Readln(T,Home);
              End;
            '2':
              Begin
                Readln(T,Mark);
                Readln(T,Born);
                Readln(T,Work);
              End;
        End;
        Buf^.Next:=nil;
       { Работа с указателями }
        If Root<>nil then
          Begin
            Cur:=Root;
            While Cur^.Next<>nil do Cur:=Cur^.Next;
            Cur^.Next:=Buf;
          End
        Else
          Root:=Buf;
        Readln(T,I);
      End;
    Close(T);
  End;

Procedure SaveList;
  Var Buf:PItem; T:Text;
  Begin
    Assign(T,'KURS.TXT');
    Rewrite(T);
    Buf:=Root;
    While Buf<>nil do
      Begin
        Writeln(T,Buf^.State);
        Writeln(T,Buf^.Name);
        Writeln(T,Buf^.Group);
        With Buf^ do
          Case Buf^.State of
            '1':
              Begin
                Writeln(T,Sex);
                Writeln(T,FamSt);
                Writeln(T,Home);
              End;
            '2':
              Begin
                Writeln(T,Mark);
                Writeln(T,Born);
                Writeln(T,Work);
              End;
        End;
        Buf:=Buf^.Next;
      End;
    Writeln(T,0);
    Close(T);
  End;

Var Temp:Integer;
Begin
  Repeat
    If FSearch('KURS.TXT','')='' then SaveList;
    LoadList;
    TextColor(11);
    Writeln('0) Общий список');
    Writeln('1) Список студентов факультета (В порядке возрастания номера общежития)');
    Writeln('2) Список выпускников факультета (В порядке убывания среднего балла)');
    Writeln('3) Добавить в общий список');
    Writeln('4) Добавить в список из файла');
    Writeln('5) Записать список в файл');
    Writeln('6) Выйти');
    Repeat
      Write(' Ваш выбор: ');
      Readln(Temp);
    Until Temp in [0..6];
    TextColor(7);
    Case Temp of
      0: ShowList;
      1: ShowList1;
      2: ShowList2;
      3: AddList;
      4: LoadList;
      5: SaveList;
    End;
  Until Temp = 6;
End.