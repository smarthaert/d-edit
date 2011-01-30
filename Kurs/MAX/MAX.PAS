{ Поиспользуем Turbo Professional на полную катушку ;) }
uses
  TPString,
  TPCrt,
  TPCmd,
  TPWindow,
  TPMenu,
  TPEdit;

{ ////////////////////////////////////////////////////////////////// }
{ //           С П И С О К  Н И Ж Н Е Г О  У Р О В Н Я            // }
{ ////////////////////////////////////////////////////////////////// }

{ ---=== Описание типа список ===--- }
 Type
   PNumList = ^TNumList;
   TNumList = Record
     Data : Float;
     Next : PNumList;
   End;

{ ---=== Добавление нового элемента в начало списка ===--- }
 Procedure NumListAddBeg( Var Root:PNumList; Data:Float );
   Var Current : PNumList;
   Begin
     New(Current);
     Current^.Data := Data;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== Добавление N элементов (нулевых) ===--- }
 Procedure NumListCreate( Var Root:PNumList; N:Word );
   Var Counter : Word;
   Begin
     Root := nil;
     For Counter := 1 to N do
       NumListAddBeg( Root, 0 );
   End;

{ ---=== Удаление всего списка ===--- }
 Procedure NumListDelAll( Var Root:PNumList );
   Var Buffer : PNumList;
   Begin
    { Пока в списке остались элементы }
     While Root <> nil do
       Begin
        { Удаляем первый элемент }
         Buffer := Root;
         Root := Root^.Next;
         Dispose(Buffer);
       End;
   End;

{ ---=== Возвращает элемент с номером N ===--- }
 Function NumListGet( Var Root:PNumList; N:Integer ):PNumList;
   Var Current:PNumList; Counter:Integer;
   Begin
     Current := Root;
     Counter := 0;
    { - Ищем нужный нам элемент - }
     While Current <> nil do
       Begin
         Inc(Counter);
        { - И удаляем его ... - }
         If Counter = N then
           Begin
             NumListGet := Current;
             Exit; { Больше нам делать нечего ;) }
           End;
         Current := Current^.Next;
       End;
   End;

{ ////////////////////////////////////////////////////////////////// }
{ //           С П И С О К  Н И Ж Н Е Г О  У Р О В Н Я            // }
{ ////////////////////////////////////////////////////////////////// }

{ ---=== Описание типа список строк ===--- }
 Type
   PNumTable = ^TNumTable;
   TNumTable = Record
     Data : PNumList;
     Next : PNumTable;
   End;

{ ---=== Добавление нового элемента в начало списка (нулевой строки) ===--- }
 Procedure TableAddBeg( Var Root:PNumTable; M:LongInt );
   Var Current : PNumTable;
   Begin
     New(Current);
     NumListCreate( Current^.Data, M );
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== Создание нулевой матрицы N*M ===--- }
 Procedure TableCreate( Var Root:PNumTable; N,M:Word );
   Var Counter : Word;
   Begin
     Root := nil;
     For Counter := 1 to N do
       TableAddBeg( Root, M );
   End;

{ ---=== Удаление матрицы ===--- }
 Procedure TableDelAll( Var Root:PNumTable );
   Var Buffer : PNumTable;
   Begin
    { Пока в списке остались элементы }
     While Root <> nil do
       Begin
        { Удаляем первый элемент }
         Buffer := Root;
         Root := Root^.Next;
         Dispose(Buffer);
       End;
   End;

{ ---=== Возвращает элемент с номером N,M ===--- }
 Function Get( Var Root:PNumTable; N,M:Integer ):PNumList;
   Var Current:PNumTable; Counter:Integer;
   Begin
     Current := Root;
     Counter := 0;
    { - Ищем нужный нам элемент - }
     While Current <> nil do
       Begin
         Inc(Counter);
        { - И удаляем его ... - }
         If Counter = N then
           Begin
             Get := NumListGet( Current^.Data, M );
             Exit; { Больше нам делать нечего ;) }
           End;
         Current := Current^.Next;
       End;
   End;

{ ////////////////////////////////////////////////////////////////// }
{ //             Р А Б О Т А   С  М А Т Р И Ц Е Й                 // }
{ ////////////////////////////////////////////////////////////////// }

 Type
   TMatrix = Record
     N,M  : Integer;
     Root : PNumTable;
   End;

 Procedure Matrix_Delete( Var Matrix:TMatrix );
   Begin
     TableDelAll( Matrix.Root );
   End;

 Procedure Matrix_Create( Var Matrix:TMatrix; N,M:Integer );
   Begin
     TableDelAll( Matrix.Root );
     Matrix.N := N;
     Matrix.M := M;
     TableCreate( Matrix.Root, N, M );
   End;

 Procedure Matrix_New( Var Matrix:TMatrix );
   Begin
     Matrix.N := 1;
     Matrix.M := 1;
     TableCreate( Matrix.Root, 1, 1 );
   End;

{ ////////////////////////////////////////////////////////////////// }
{ //         И Н Т Е Р Ф Е Й С Н Ы Е  П Р О Ц Е Д У Р Ы           // }
{ ////////////////////////////////////////////////////////////////// }

 Procedure CreateWindow( Var Window:WindowPtr; Header:String; Row,Col:Word );
   Begin
     MakeWindow( Window, 41-(Col div 2),12-(Row div 2),
                         41+(Col div 2),12+(Row div 2),
                         True,True,True,$07,$07,$07,
       ' '+Header+' ');
     DisplayWindow( Window );
   End;

 Procedure Error_Message( Message:String );
   Var Window:WindowPtr;
   Begin
     CreateWindow(Window,'Ошибка !',4,60);
     Write(Center(Message,60));
     Write(Center('<<< Нажмите любую клавишу для продолжения >>>',60));
     ReadKey;
     KillWindow(Window);
   End;

 Function Read_Int( Var T:Text; Var I:Integer ):Boolean;
   Begin
    {$I-}
     Read_Int := False;
     Read( T, I );
     If IOResult<>0 then
       Begin
         Error_Message('Ошибка чтения из файла !');
         Close(T);
         Read_Int := True;
       End;
    {$I+}
   End;

 Function Read_Real( Var T:Text; Var R:Float ):Boolean;
   Begin
    {$I-}
     Read_Real := False;
     Read( T, R );
     If IOResult<>0 then
       Begin
         Error_Message('Ошибка чтения из файла !');
         Close(T);
         Read_Real := True;
       End;
    {$I+}
   End;

 Procedure Matrix_Load( FileName:String; Var Matrix:TMatrix );
   Var T:Text; N,M,I,J:Integer;
   Begin
     Assign(T,FileName);
    {$I-}
     Reset(T);
     If IOResult<>0 then
       Begin Error_Message('Не могу открыть файл '+FileName); Exit; End;
     If Read_Int( T, N ) then Exit;
     If Read_Int( T, M ) then Exit;
     Matrix_Create( Matrix, N, M );
     For I:=1 to N do
       For J:=1 to M do
         If Read_Real( T, Get(Matrix.Root,I,J)^.Data ) then Exit;
    {$I+}
     Close(T);
   End;

 Procedure Matrix_Save( FileName:String; Var Matrix:TMatrix );
   Var T:Text; I,J:Integer;
   Begin
     Assign(T,FileName);
    {$I-}
     Rewrite(T);
     If IOResult<>0 then
       Begin Error_Message('Не могу открыть файл '+FileName); Exit; End;
     Writeln( T, Matrix.N, ' ', Matrix.M );
     For I:=1 to Matrix.N do
       Begin
         For J:=1 to Matrix.M do
           Write( T, Get(Matrix.Root,I,J)^.Data:10:6 );
         Writeln( T );
       End;
    {$I+}
     Close(T);
   End;

{ ---=== Создание новой матрицы ===--- }
 Procedure CreateTable( Header:String; Var Matrix:TMatrix );
   Var N,M:Integer; Window:WindowPtr; Escaped:Boolean;
   Begin
     CreateWindow( Window, Header, 4, 60 );
     N:=1; M:=1;
     ReadInteger('Количество строк: ',
       11,12,5,$0F,$0F,1,10000,Escaped,N);
     If Not Escaped then
       Begin
         ReadInteger('Количество столбцов: ',
           12,12,5,$0F,$0F,1,10000,Escaped,M);
         If Not Escaped then Matrix_Create(Matrix,N,M);
       End;
     KillWindow( Window );
   End;

 Const EditI = 19; EditJ = 6;

{ ---=== Редактирование матрицы ===--- }
 Procedure EditTable( Header:String; Var Matrix:TMatrix; CanEdit:Boolean );
   Var CurI,CurJ,I,J,CI,CJ,FrI,FrJ:Integer;
       Window:WindowPtr; Escaped:Boolean; Key:Char;
   Begin
     CreateWindow( Window, Header, 22, 78 );
     CurI:=1; CurJ:=1; FrI:=1; FrJ:=1;
     Repeat
       For I:=0 to 19 do
         For J:=0 to 6 do
           Begin
             CI:=FrI+I; CJ:=FrJ+J;
             If ((CI <= Matrix.N) And (CJ <= Matrix.M)) then
               Begin
                 If ((CI = CurI) And (CJ = CurJ)) then
                   TextAttr := $70 Else TextAttr := $07;
                 GotoXY(J*10+1,I+1);
                 Write(Copy(Real2Str(Get(Matrix.Root,CI,CJ)^.Data,10,10),1,9));
               End;
           End;
       TextAttr := $07;
       Key := ReadKey;
       If Key = #00 then
         Case ReadKey of
           #72: Dec(CurI); { Up }
           #75: Dec(CurJ); { Left }
           #77: Inc(CurJ); { Right }
           #80: Inc(CurI); { Down }
         End;
       If CurI < 1 then CurI:=Matrix.N;
       If CurI > Matrix.N then CurI:=1;
       If CurJ < 1 then CurJ:=Matrix.M;
       If CurJ > Matrix.M then CurJ:=1;
       If CurI < FrI then FrI:=CurI;
       If CurJ < FrJ then FrJ:=CurJ;
       If CurI > (FrI+EditI) then FrI:=CurI-EditI;
       If CurJ > (FrJ+EditJ) then FrJ:=CurJ-EditJ;
       If ((Key = #13) And CanEdit) then
         ReadReal('',2+CurI-FrI,3+10*(CurJ-FrJ),10,$0F,$0F,7,-1E30,+1E30,
           Escaped,Get(Matrix.Root,CurI,CurJ)^.Data);
     Until Key = #27;
     KillWindow( Window );
   End;

{ ---=== Загрузка матрицы ===--- }
 Procedure LoadTable( Header:String; Var Matrix:TMatrix );
   Var FileName:String; Window:WindowPtr; Escaped:Boolean;
   Begin
     CreateWindow( Window, Header, 4, 60 );
     FileName := 'MATRIX.TXT';
     ReadString('Имя файла: ',
       11,12,12,$0F,$0F,$0F,Escaped,FileName);
     If Not Escaped then Matrix_Load( FileName, Matrix );
     KillWindow( Window );
   End;

{ ---=== Сохранение матрицы ===--- }
 Procedure SaveTable( Header:String; Var Matrix:TMatrix );
   Var FileName:String; Window:WindowPtr; Escaped:Boolean;
   Begin
     CreateWindow( Window, Header, 4, 60 );
     FileName := 'MATRIX.TXT';
     ReadString('Имя файла: ',
       11,12,12,$0F,$0F,$0F,Escaped,FileName);
     If Not Escaped then Matrix_Save( FileName, Matrix );
     KillWindow( Window );
   End;

{ ---=== Сложение матриц ===--- }
 Procedure AddMatrix( Header:String; Var M1,M2:TMatrix );
   Var I,J:Integer; M3:TMatrix;
   Begin
     If ((M1.N = M2.N) And (M1.M = M2.M)) then
       Begin
         Matrix_New(M3);
         Matrix_Create(M3,M1.N,M1.M);
         For I:=1 to M3.N do
           For J:=1 to M3.N do
             Get(M3.Root,I,J)^.Data :=
               Get(M1.Root,I,J)^.Data + Get(M2.Root,I,J)^.Data;
         EditTable(Header,M3,False);
       End
     Else
       Error_Message('Матрицы должны быть одинаковых размеров !');
     Matrix_Delete(M3);
   End;

{ ---=== Вычитание матриц ===--- }
 Procedure SubMatrix( Header:String; Var M1,M2:TMatrix );
   Var I,J:Integer; M3:TMatrix;
   Begin
     If ((M1.N = M2.N) And (M1.M = M2.M)) then
       Begin
         Matrix_New(M3);
         Matrix_Create(M3,M1.N,M1.M);
         For I:=1 to M3.N do
           For J:=1 to M3.N do
             Get(M3.Root,I,J)^.Data :=
               Get(M1.Root,I,J)^.Data - Get(M2.Root,I,J)^.Data;
         EditTable(Header,M3,False);
       End
     Else
       Error_Message('Матрицы должны быть одинаковых размеров !');
     Matrix_Delete(M3);
   End;

{ ---=== Умножение матриц ===--- }
 Procedure MulMatrix( Header:String; Var M1,M2:TMatrix );
   Var I,J,K:Integer; M3:TMatrix;
   Begin
     If M1.M = M2.N then
       Begin
         Matrix_New(M3);
         Matrix_Create(M3,M1.N,M2.M);
         For I:=1 to M3.N do
           For J:=1 to M3.M do
             Begin
               Get(M3.Root,I,J)^.Data := 0;
               For K:=1 to M1.M do
                 Get(M3.Root,I,J)^.Data := Get(M3.Root,I,J)^.Data +
                   Get(M1.Root,I,K)^.Data * Get(M2.Root,K,J)^.Data;
             End;
         EditTable(Header,M3,False);
       End
     Else
       Error_Message('Кол-во столбцов A должно быть равно числу строк B !');
     Matrix_Delete(M3);
   End;

{ ////////////////////////////////////////////////////////////////// }
{ //                  Г Л А В Н О Е   М Е Н Ю                     // }
{ ////////////////////////////////////////////////////////////////// }

{ ---=== Главное меню ===--- }
procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($0E, $2E, $03, $1E, $0B, $0E, $19, $78);
  Frame1 : FrameArray = '╔╚╗╝═║';

begin
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(1,2,1,Horizontal,Frame1,Color1,'');
    MenuItem('Матрица A',2,1,1,'Работа с матрицей A');
    SubMenu(3,4,1,Vertical,Frame1,Color1,'');
      MenuItem('Новая',1,1,11,'Создание новой матрицы');
      MenuItem('Редактирование',2,1,12,'Редактирование матрицы');
      MenuItem('Загрузка',3,1,13,'Загрузка матрицы из текстового файла');
      MenuItem('Запись',4,1,14,'Запись матрицы в текстовой файл');
      PopSublevel;
    MenuItem('Матрица B',13,1,2,'Работа с матрицей B');
    SubMenu(14,4,1,Vertical,Frame1,Color1,'');
      MenuItem('Новая',1,1,21,'Создание новой матрицы');
      MenuItem('Редактирование',2,1,22,'Редактирование матрицы');
      MenuItem('Загрузка',3,1,23,'Загрузка матрицы из текстового файла');
      MenuItem('Запись',4,1,24,'Запись матрицы в текстовой файл');
      PopSublevel;
    MenuItem('Действия над матрицами',24,1,7,'Действия над матрицами');
    SubMenu(25,4,1,Vertical,Frame1,Color1,'');
      MenuItem('Сложение матриц (A+B)',1,1,31,'Сложение матриц (Они должны быть одинакового размера)');
      MenuItem('Вычитание матриц (A-B)',2,1,32,'Вычитание матриц (Они должны быть одинакового размера)');
      MenuItem('Умножение матриц (A*B)',3,1,33,'Умножение матриц (Кол-во столбцов в A = Кол-во строк в B)');
      MenuItem('Квадрат A (A^2)',4,1,34,'Возведение в квадрат A (A - Должна быть квадратной матрицей)');
      MenuItem('Квадрат B (B^2)',5,1,35,'Возведение в квадрат B (B - Должна быть квадратной матрицей)');
      PopSublevel;
    MenuItem('Выход',48,1,40,'Выход в операционную систему');
    PopSublevel;

  ResetMenu(M);
end;

{ ---=== Основная Программа ===--- }
var
  M : Menu;
  Ch : Char;
  Key : MenuKey;
  M1,M2 : TMatrix;

begin
  Matrix_New(M1);
  Matrix_New(M2);
  ClrScr;
  InitMenu(M);
  Repeat
    Key := MenuChoice(M, Ch);
    EraseMenu(M, False);
    Case Key of
      11: CreateTable('Создание матрицы A',M1);
      12: EditTable('Редактирование матрицы A',M1,True);
      13: LoadTable('Загрузка матрицы A',M1);
      14: SaveTable('Запись матрицы A',M1);
      21: CreateTable('Создание матрицы B',M2);
      22: EditTable('Редактирование матрицы B',M2,True);
      23: LoadTable('Загрузка матрицы B',M2);
      24: SaveTable('Запись матрицы B',M2);
      31: AddMatrix('Сложение матриц (A+B)',M1,M2);
      32: SubMatrix('Вычитание матриц (A-B)',M1,M2);
      33: MulMatrix('Умножение матриц (A*B)',M1,M2);
      34: MulMatrix('Квадрат A (A^2)',M1,M1);
      35: MulMatrix('Квадрат B (B^2)',M2,M2);
    End;
  Until Key = 40;
  Matrix_Delete(M1);
  Matrix_Delete(M2);
end.
