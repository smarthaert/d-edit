Uses TPString,TPCrt,TPCmd,TPWindow,TPMenu,TPPick;

{ --- Описание типов данных --- }
type
    TInf = record
       NGroup : LongInt;
          Fam : String;
         Name : String;
        BYear : LongInt;
       SummaS : LongInt;
       SrBall : Real;
       MRaspr : String;
          end;
    TFRec = record
       Adr : Word;
       Inf : TInf;
           end;
    TFile=file of TFRec;

{ --- Имя файла с которым мы работаем --- }
Const FileName : String = 'Notebook.dat';

{ --- Запись присутствует --- }
Const ItemExist = $FFFF;

{ --- Возможные команды --- }
Const
  cmFileWatch  = 1;
  cmSearchStud = 2;
  cmAddStud    = 3;
  cmDelStud    = 4;
  cmSummaStip  = 5;
  cmExit       = 6;

{ --- Файл базы данных --- }
Var  F : TFile;

{ --- Инициализация меню Turbo Professional --- }
procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($0E, $2E, $03, $1E, $0B, $0E, $19, $78);
  Frame1 : FrameArray = '╔╚╗╝═║';

begin
  ClrScr;
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(4,3,1,Horizontal,Frame1,Color1,'(C) 9331 International');
    MenuMode(False, True, False);
    MenuWidth(69);
    MenuItem('Работа со списком',3,1,1,'Работа с базой данных студентов');
    SubMenu(7,5,1,Vertical,Frame1,Color1,'');
      MenuMode(False, True, False);
      MenuItem('Просмотр списка',1,1,cmFileWatch,'Просмотр списка студентов');
      MenuItem('Добавить студента',2,1,cmAddStud,'Добавление студента в базу данных');
      MenuItem('Удалить студента',3,1,cmDelStud,'Удаление студента из базы данных');
      MenuItem('Поиск студента',4,1,cmSearchStud,'Поиск студента в базе данных по фамилии');
      MenuItem('Стипендия',5,1,cmSummaStip,'Подсчет суммы стипендии по группам');
      PopSublevel;
    MenuItem('Выход',52,1,cmExit,'Выход в Операционную Систему');
    PopSublevel;

  ResetMenu(M);
end;

{ --- Ввод целого числа --- }
Procedure EnterInteger( Str:String; Var N:LongInt );
  Var Error:Integer; S:String;
  Begin
    Repeat
      Write(Str);
      Readln(S);
      Val(S,N,Error);
      If Error<>0 then Writeln('Ошибка: Неправильный формат числа');
    Until Error = 0;
  End;

{ --- Ввод действительного числа --- }
Procedure EnterReal( Str:String; Var N:Real );
  Var Error:Integer; S:String;
  Begin
    Repeat
      Write(Str);
      Readln(S);
      Val(S,N,Error);
      If Error<>0 then Writeln('Ошибка: Неправильный формат числа');
    Until Error = 0;
  End;

{ --- Открываем файл --- }
procedure FOpen;
Var R:TFRec;
begin
 Assign(F,FileName);
{$I-}
 Reset(F); { Если файл есть => Открываем его }
{$I+}
 if IoResult<>0 then { А если его нет => Создаем новый пустой }
  begin
   Rewrite(F);
   R.Adr:=0;
   Write(F,R);
  end;
end;

{ --- Чтение из файла --- }
Procedure ReadRec( Pos:Word; Var R:TFRec );
  Begin
    Seek(F,Pos);
    Read(F,R);
  End;

{ --- Запись в файл --- }
Procedure WriteRec( Pos:Word; Var R:TFRec );
  Begin
    Seek(F,Pos);
    Write(F,R);
  End;

{ --- Вставка элемента на свободные места --- }
Procedure InsFRec( Inf:TInf );
var Deleted,NextDeleted:Word; R:TFRec;
begin
 ReadRec(0,R);
{ Если у нас нет удаленных записей }
 if R.Adr = 0 then
  begin
   R.Inf := Inf;
   R.Adr := ItemExist;
   WriteRec(FileSize(F),R);
  end
{ Если у нас есть удаленные записи }
 else
  begin
   Deleted := R.Adr;
   ReadRec(Deleted,R);
   NextDeleted := R.Adr;
   R.Inf := Inf;
   R.Adr := ItemExist;
   WriteRec(Deleted,R);
   R.Adr := NextDeleted;
   WriteRec(0,R);
  end;
end;

{ --- Добавление студента --- }
Procedure AddStud;
Var Pole:TInf; Window:WindowPtr; S:String;
Begin
 MakeWindow(Window,1,3,60,18,true,true,false,$1E,$1f,$1e,' Данные по студенту ');
 Repeat
  EraseTopWindow;
  DisplayWindow(Window);
  GoToXY(1,3);
  EnterInteger('Группа: ',Pole.NGroup);
  Write('Фамилия: '); ReadLn(Pole.Fam);
  Write('Имя: '); ReadLn(Pole.Name);
  EnterInteger('Год рождения: ',Pole.BYear);
  EnterInteger('Сумма стипендии: ',Pole.SummaS);
  EnterReal('Средний балл: ',Pole.SrBall);
  Write('Место распределения: '); Readln(Pole.MRaspr);
  InsFRec(Pole);
  Writeln; Writeln('Студент добавлен !');
  Writeln; Writeln('< Enter - продолжение  Другая клавиша - Меню >');
 Until ReadKey <> #13;
 KillWindow(Window);
End;

{ --- Вывод окна с информацией о студенте --- }
Procedure StudShow( Var Window:Pointer; R:TInf );
 Begin
  MakeWindow(Window,40,3,80,12,true,true,false,$1E,$1f,$1e,' Данные по студенту ');
  DisplayWindow(Window);
  With R do
   Begin
    Writeln('Фамилия:             ',Fam);
    Writeln('Имя:                 ',Name);
    Writeln('Год рождения:        ',BYear);
    Writeln('Группа:              ',NGroup);
    Writeln('Сумма стипендии:     ',SummaS);
    Writeln('Средний балл:        ',SrBall:0:3);
    Write  ('Место распределения: ',MRaspr);
   End;
 End;

{ --- Поиск студента по фамилии --- }
Function Search_Student( Fam:String ):LongInt;
  Var R:TFRec;
  Begin
    Search_Student := 0;
    Seek(F,1);
    While Not EOF(F) do
     Begin
       Read(F,R);
       If ((R.Adr = ItemExist) And (R.Inf.Fam = Fam)) then
         Begin
           Search_Student := FilePos(F)-1;
           Break;
         End;
     End;
  End;

{ --- Поиск студента по фамилии --- }
Procedure SearchStud;
var Str : String;
    Window,Window2 : Pointer;
    R : TFRec;
    T : LongInt;
begin
 MakeWindow(Window,1,3,39,18,true,true,false,$1E,$1f,$1e,
   ' Поиск студента по фамилии ');
 EraseTopWindow;
 DisplayWindow(Window);
 Writeln('Введите фамилию студента: '); Readln(Str);
 T := Search_Student(Str);
 If T = 0 then
  Writeln('Данных по этому студенту нет ')
 Else
  Begin
   ReadRec(T,R);
   StudShow(Window2,R.Inf);
  End;
 ActivateTiledWindow(Window);
 Writeln; Writeln('<Нажмите клавишу для продолжения>');
 ReadKey;
 If T<>0 then KillWindow(Window2);
 KillWindow (Window);
end;

{ --- Сортировка файла по среднему баллу --- }
Procedure Sortirovka;
Var
 I,J,D:integer;
 A,B:TFRec;
Begin
 D := FileSize(F)-1;
 for I:=1 to (D-1) do
   for J:=(I+1) to D do
    begin
     ReadRec(I,A);
     ReadRec(J,B);
     if ((A.Inf.SrBall < B.Inf.SrBall) And
         (A.Adr = ItemExist) And (B.Adr = ItemExist)) then
      Begin
       WriteRec(J,A);
       WriteRec(I,B);
      End;
    end;
End;

{ --- Число студентов в списке --- }
Function Stud_Num:LongInt;
  Var Counter:LongInt; R:TFRec;
  Begin
    Counter := 0;
    Seek(F,0);
    While Not EOF(F) do
      Begin
        Read(F,R);
        If R.Adr = ItemExist then Inc(Counter);
      End;
    Stud_Num := Counter;
  End;

{ --- Студент номер N --- }
Procedure Stud_Get( Var StudRec:TFRec; N:LongInt );
  Var Counter:LongInt; R:TFRec;
  Begin
    Counter := 0;
    Seek(F,0);
    While Not EOF(F) do
      Begin
        Read(F,R);
        If R.Adr = ItemExist then Inc(Counter);
        If Counter = N then Break;
      End;
    StudRec := R;
  End;

{ --- Функция, возвращающая по номеру запись --- }
Function StrFunc( N:Integer ):String; Far;
  Var R:TFRec; C:LongInt;
  Begin
    Stud_Get(R,N);
    StrFunc := Pad(Long2Str(R.Inf.NGroup),6) + '║ ' + R.Inf.Fam;
  End;

{ --- Выбранный студент --- }
Var Selected : Word;
    About_Window : WindowPtr;

Procedure Show_Information; Far;
  Var R:TFRec; Temp:WindowPtr;
  Begin
    Temp := CurrentWindow;
    KillTiledWindow(About_Window);
    Stud_Get(R,Selected);
    StudShow(About_Window,R.Inf);
    ActivateTiledWindow(Temp);
  End;

Procedure FileWatch;
  Var Palette:PickColorArray;
  Begin
    Palette[WindowAttr] := $07;
    Palette[FrameAttr]  := $07;
    Palette[HeaderAttr] := $0F;
    Palette[SelectAttr] := $70;
    Palette[AltNormal]  := $0F;
    Palette[AltHigh]    := $0F;
    If Stud_Num = 0 then Exit;
    PickUserPtr := Addr(Show_Information);
    Repeat
      PickWindow(Addr(StrFunc),Stud_Num,1,1,40,20,True,Palette,
        'Просмотр списка студентов',Selected);
    Until PickCmdNum = PKSExit;
    KillTiledWindow(About_Window);
  End;

{ --- Удаление студента --- }
Procedure DelStud;
  Var UdalStud:String; Window:WindowPtr; T:LongInt; R1,R2:TFRec;
  Begin
    MakeWindow(Window,1,3,60,18,true,true,false,$1E,$1f,$1e,' Удаление ');
    DisplayWindow(Window);
    GoToXY(1,3);
    Write('Введите фамилию студента: '); Readln(UdalStud);
    T := Search_Student(UdalStud);
    If T<>0 then
      Begin
        ReadRec(0,R1);
        ReadRec(T,R2);
        R2.Adr := R1.Adr;
        R1.Adr := T;
        WriteRec(0,R1);
        WriteRec(T,R2);
        Writeln('Студент успешно удален !');
      End
    Else
      Writeln('Ошибка: Данных по этому студенту нет !');
    Writeln('<Нажмите клавишу для продолжения>');
    ReadKey;
    KillWindow(Window);
  End;

{ --- Cумма стипендии --- }
Procedure SummaStip;
  Procedure Out( S:String );
    Begin
      If WhereY = 20 then
        Begin
          Write('<Нажмите клавишу для продолжения>');
          ReadKey;
          ClrScr;
        End;
      Writeln(S);
    End;
  Var Exclude,Min:Integer; Window:WindowPtr; R:TFRec; Sum,AllSum:LongInt;
  Begin
    Exclude := -1;
    MakeWindow(Window,1,3,60,24,true,true,false,$1E,$1f,$1e,' Сумма стипендии ');
    DisplayWindow(Window);
    AllSum := 0;
    Repeat
      Min := MaxInt;
     { Выяснение номера минимальной группы }
      Seek(F,0);
      While Not EOF(F) do
        Begin
          Read(F,R);
          If ((R.Adr = ItemExist) And
              (R.Inf.NGroup > Exclude) And
              (R.Inf.NGroup < Min)) then
            Min := R.Inf.NGroup;
        End;
      Exclude := Min;
     { Вывод суммы на экран }
      Seek(F,0);
      Sum := 0;
      If Min < MaxInt then Out('---=== Группа '+Long2Str(Min)+' ===---');
      While Not EOF(F) do
        Begin
          Read(F,R);
          If ((R.Adr = ItemExist) And
              (R.Inf.NGroup = Min)) then
            With R.Inf do
              Begin
                Out(Pad(Fam,17)+Pad(Name,10)+Long2Str(SummaS));
                AllSum := AllSum + SummaS;
                Sum := Sum + SummaS;
                Min := R.Inf.NGroup;
              End;
        End;
      If Min < MaxInt then Out('Сумма по группе '+Long2Str(Min)+': '
                               +Long2Str(Sum));
    Until Min = MaxInt;
    Out('---=== По всем группам ===---');
    Out('Итоговая сумма: '+Long2Str(AllSum));
    ReadKey;
    KillWindow(Window);
  End;

{ --- Основная программа --- }
var
  M : Menu;
  Key : MenuKey;
  Ch : Char;
begin
  TextColor(7);
  TextBackGround(0);
  Repeat
    ClrScr;
    InitMenu(M);
    Key := MenuChoice(M, Ch);
    EraseMenu(M, False);
   { Открываем файл }
    FOpen;
   { Делаем нужную операцию }
    Case Key of
      cmFileWatch  : FileWatch;
      cmSearchStud : SearchStud;
      cmAddStud    : AddStud;
      cmDelStud    : DelStud;
      cmSummaStip  : SummaStip;
    end;
   { Закрываем файл }
    Close(F);
   { Пока не будет команды выхода }
  Until Key = cmExit;
end.
