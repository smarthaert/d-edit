
Unit PolyUnit;

Interface

Uses CoefUnit, TPCRT, TPPick, TPString, TPWindow;

{ ************* }
{ * Степень X * }
{ ************* }
Type
  PXStep = ^TXStep;
  TXStep = Record
    Coef     : PDigit;
    Step     : Word;
    NextStep : PXStep;
  End;

{ --- Сообщение об ошибке --- }
Procedure ErrorMessage( Message : String );
{ --- Устанавливание коэфиициента перед степенью X --- }
Procedure MakeXStep( Var Root : PXStep; CoefStr : String; Step : Word );
{ --- Уничтожение полинома --- }
Procedure DelPol( Var Root : PXStep );
{ --- Количество степеней --- }
Function NumXStep( Var Root : PXStep ) : Integer;
{ --- Удаление определенного элемента --- }
Procedure DelXStep( Var Root : PXStep; N : Word );
{ --- Элемент с нужным номером --- }
Function GetXStep( Var Root : PXStep; N : Word ) : PXStep;
{ --- Элемент с нужной степенью X --- }
Function Get_X_Step( Var Root : PXStep; N : Word ) : PDigit;
{ --- Сортировка полинома --- }
Procedure SortPolynom( Var Root : PXStep );
{ --- Редактирование полинома --- }
Procedure PolynomEdit( Header : String; Var Poly : PXStep ); Far;
{ --- Вывод полинома --- }
Procedure PolynomShow( Header : String; Var Poly : PXStep ); Far;


Implementation

{ --- Сообщение об ошибке --- }
Procedure ErrorMessage( Message : String );
  Var Window : WindowPtr;
  Begin
    MakeWindow(Window, 18, 10, 62, 14, True, True, False, $07, $07, $0F,
               ' Ошибка ');
    DisplayWindow(Window);
    Writeln(Message);
    WriteLn;
    Write('         < Нажмите любую клавишу >');
    Sound(2500); Delay(2500); NoSound;
    ReadKey;
    KillWindow(Window);
  End;

{ --- Устанавливание коэфиициента перед степенью X --- }
Procedure MakeXStep( Var Root : PXStep; CoefStr : String; Step : Word );
  Var NewEl : PXStep;
  Begin
    New(NewEl);
    MakeCoef(NewEl^.Coef, CoefStr);
    NewEl^.Step     := Step;
    NewEl^.NextStep := Root;
    Root            := NewEl;
  End;

{ --- Уничтожение полинома --- }
Procedure DelPol( Var Root : PXStep );
  Var Buf : PXStep;
  Begin
    While Root <> nil do
      Begin
        Buf := Root;
        Root := Root^.NextStep;
        DelCoef(Buf^.Coef);
        Dispose(Buf);
      End;
  End;

{ --- Количество степеней --- }
Function NumXStep( Var Root:PXStep ):Integer;
  Var Count:Integer; Cur:PXStep;
  Begin
    Count := 0;
    Cur := Root;
    While Cur<>nil do
      Begin
        Inc(Count);
        Cur := Cur^.NextStep;
      End;
    NumXStep := Count;
  End;

{ --- Удаление определенного элемента --- }
Procedure DelXStep( Var Root : PXStep; N : Word );
  Var Count : Integer; Cur, Buf : PXStep;
  Begin
    Count := 0;
    Cur := Root;
    Buf := nil;
    While Cur <> nil do
      Begin
        Inc(Count);
        If Count = N then
          Begin
            If Buf <> nil then
              Buf^.NextStep := Cur^.NextStep
            Else
              Root := Cur^.NextStep;
            Dispose(Cur);
            Exit;
          End;
        Buf := Cur;
        Cur := Cur^.NextStep;
      End;
  End;

{ --- Элемент с нужным номером --- }
Function GetXStep( Var Root : PXStep; N : Word ) : PXStep;
  Var Count:Integer; Cur:PXStep;
  Begin
    Count := 0;
    Cur := Root;
    While Cur <> nil do
      Begin
        Inc(Count);
        If Count = N then GetXStep := Cur;
        Cur := Cur^.NextStep;
      End;
  End;

{ --- Элемент с нужной степенью X --- }
Function Get_X_Step( Var Root : PXStep; N : Word ) : PDigit;
  Var Cur : PXStep;
  Begin
    Get_X_Step := nil;
    Cur := Root;
    While Cur <> nil do
      Begin
        If Cur^.Step = N then Get_X_Step := Cur^.Coef;
        Cur := Cur^.NextStep;
      End;
  End;

{ --- Сравнение числа с 0 --- }
Function Sravn_0( D:PDigit ):Boolean;
  Var D2:PDigit;
  Begin
    MakeCoef(D2,'0');
    Sravn_0 := (Sravn(D,D2) = 0);
  End;

{ --- Сортировка полинома --- }
Procedure SortPolynom( Var Root : PXStep );
  Var New_, C1, C2, Buf, NE : PXStep; D : PDigit; I:Integer;
  Begin
    New_ := nil; { Изначально список пустой }
    C1 := Root;
    While C1 <> nil do
      Begin
       { Копируем степень X из исходного списка в Buf }
        New(Buf);
        MakeCoef( Buf^.Coef, ShowCoef(C1^.Coef));
        Buf^.Step := C1^.Step;
       { Если список не пустой и степень Buf <= степени 1-ого коэф }
        If ((New_ <> nil) And (Buf^.Step <= New_^.Step)) then
          Begin
            C2 := New_;
            While C2^.NextStep <> nil do
              Begin
                NE := C2^.NextStep;
                If Buf^.Step > NE^.Step then Break;
                C2 := NE;
              End;
            If Buf^.Step = C2^.Step then
              Begin
                D := AddCoef(Buf^.Coef, C2^.Coef);
                DelCoef(C2^.Coef);
                C2^.Coef := D;
              End
            Else
              If Not Sravn_0(Buf^.Coef) then
                Begin
                  Buf^.NextStep := C2^.NextStep;
                  C2^.NextStep := Buf;
                End;
          End
       { Если список новый или степень Buf > степень первого элемента }
        Else
          If Not Sravn_0(Buf^.Coef) then
            Begin
              Buf^.NextStep := New_;
              New_ := Buf;
            End;
        C1 := C1^.NextStep;
      End;
    DelPol(Root);
    Root := New_;
  End;

Var CurPoly : PXStep;

Function StringFunc( N : Integer ) : String; Far;
  Var Count : Integer; Cur : PXStep;
  Begin
    StringFunc := ' '+Pad('Степень', 20)+'│ '+Pad('Коэффициент', 20);
    Count := 0;
    Cur := CurPoly;
    While Cur <> nil do
      Begin
        Inc(Count);
        If Count = (N - 1) then
          StringFunc := ' '+Pad(Long2Str(Cur^.Step), 20)+
                        '│ '+Pad(ShowCoef(Cur^.Coef), 20);
        Cur := Cur^.NextStep;
      End;
  End;

{ --- Редактирование полинома --- }
Procedure PolynomEdit( Header : String; Var Poly : PXStep );
  Var Choice : Word; Palette : PickColorArray; StrCoef, S : String;
      A : PXStep; Window : WindowPtr; Error : Integer; Step : LongInt;
      I,J : Byte;
  Begin
   { Заполнение палитры }
    Palette[WindowAttr] := $0B; {Color for normal unselected items}
    Palette[FrameAttr]  := $07; {Color for window frame}
    Palette[HeaderAttr] := $0F; {Color for window header}
    Palette[SelectAttr] := $0F; {Color for normal selected item}
    Palette[AltNormal]  := $07; {Color for alternate unselected items}
    Palette[AltHigh]    := $07; {Color for alternate selected item}
   { Пока не нажата ESC }
    Repeat
      CurPoly := Poly;
      PickWindow(Addr(StringFunc), NumXStep(Poly)+1, 1, 8, 79, 22, True,
        Palette, Header, Choice);
     { При нажатии Enter }
      If PickCmdNum = PKSSelect then
        Begin
         { Сhoice - Номер выбранной записи }
          If Choice <> 1 then
            Begin
              A := GetXStep(Poly, Choice - 1);
              S:=(' Редактирование '+ShowCoef(A^.Coef)+' * X^'+Long2Str(A^.Step)+' ');
              DelXStep(Poly, Choice - 1);
            End
          Else
            S:='';
          MakeWindow(Window, 10, 8, 70, 18, True, True, False, $07, $07, $0F,
                     ' '+S+' ');
          DisplayWindow(Window);
         { Ввод степени и проверка на корректность ввода }
          Repeat
            Write('Введите степень X: '); Readln(S);
            Val( S, Step, Error );
            If (Error <> 0) or (Step < 0) or (Step> 65535) then
              ErrorMessage('        Неправильный формат числа !');
          Until (Error = 0) and (Step >= 0) and (Step <= 65535 );
         { Ввод коэффициента и проверка на корректность ввода }
          Repeat
            Write('Введите коэффициент: '); Readln(S); Error := 0;
           { Проверка символов }
            If Not (S[1] in ['-','+','.','0'..'9']) then Error := 1;
            For I := 2 to Length(S) do
              If Not (S[I] in ['.','0'..'9']) then Error := 1;
           { Проверка на количество точек }
            J:=0; For I := 1 to Length(S) do If S[I]='.' then Inc(J);
            If J > 1 then Error := 1;
           { Выдача сообщения об ошибке }
            If Error <> 0 then
              ErrorMessage('        Неправильный формат числа !');
          Until Error = 0;
         { Заносим обратно в список }
          MakeXStep(Poly, S, Step);
          KillWindow(Window);
        End;
   { PickCmdNum - Команда из PickWindow PKSExit - Выход по ESC }
    Until PickCmdNum = PKSExit;
  End;

{ --- Вывод полинома --- }
Procedure PolynomShow( Header : String; Var Poly : PXStep );
  Var Choice : Word; Palette : PickColorArray;
  Begin
    Palette[WindowAttr] := $0B; {Color for normal unselected items}
    Palette[FrameAttr]  := $07; {Color for window frame}
    Palette[HeaderAttr] := $0F; {Color for window header}
    Palette[SelectAttr] := $0F; {Color for normal selected item}
    Palette[AltNormal]  := $07; {Color for alternate unselected items}
    Palette[AltHigh]    := $07; {Color for alternate selected item}
    Repeat
      CurPoly := Poly;
      PickWindow(Addr(StringFunc), NumXStep(Poly)+1, 1, 8, 79, 22, True,
        Palette, Header, Choice);
    Until PickCmdNum = PKSExit;
  End;

End.