{ ╔╤════════════════════════════════════════════════════════════════════╤╗ }
{ ║│        Модуль для работы с целыми и рациональными числами          │║ }
{ ║│                        (c) 19.05.2000                              │║ }
{ ╚╧════════════════════════════════════════════════════════════════════╧╝ }
Unit RN_Unit;

Interface

{ ---=== Описание типов ===--- }
 Type
  { Список цифр числа (Корень списка - младший разряд) }
   PDigit = ^TDigit;
   TDigit = Record
     Data : ShortInt;
     Next : PDigit;
   End;
  { Знак целого числа }
   TSignum = (Plus,Minus);
  { Описание типа целое число }
   TNumber = Record
     Signum : TSignum; { Знак }
     Data   : PDigit;  { Список цифр }
   End;
  { Описание типа рациональное число }
   TRational = Record
     Up,Down : TNumber;
   End;

{ >>> Работа с целыми числами <<< }
{ ---=== Установка значения целого числа ===--- }
 Procedure Set_Number( Var Number:TNumber; Str:String );
{ ---=== Удаление целого числа из памяти ===--- }
 Procedure Del_Number( Var Number:TNumber );
{ ---=== Вывод целого числа в строку ===--- }
 Function Show_Number( Var Number:TNumber ):String;
{ ---=== Сравнение целых чисел (по модулю) ===--- }
 Function ModEQU_Number( Var N1,N2:TNumber ):ShortInt;
{ ---=== Сравнение целых чисел ===--- }
 Function EQU_Number( Var N1,N2:TNumber ):ShortInt;
{ ---=== Сложение целых чисел ===--- }
 Procedure nAdd( Var N1,N2,Res:TNumber );
{ ---=== Вычитание целых чисел ===--- }
 Procedure nSub( Var N1,N2,Res:TNumber );
{ ---=== Умножение целых чисел ===--- }
 Procedure nMul( Var N1,N2,Res:TNumber );
{ ---=== Деление с остатком целых чисел ===--- }
 Procedure nDiv( Var N1,_N2_,Res,Num:TNumber );
{ ---=== Наибольший общий делитель двух целых чисел ===--- }
 Procedure NOD( Var N1,N2,Res:TNumber );
{ >>> Работа с рациональными числами <<< }
{ ---=== Установка значения рационального числа ===--- }
 Procedure Set_Rational( Var R:TRational; UpStr,DownStr:String );
{ ---=== Удаление рационального числа из памяти ===--- }
 Procedure Del_Rational( Var R:TRational );
{ ---=== Вывод рационального числа на экран ===--- }
 Function Show_Rational( Var R:TRational ):String;
{ ---=== Сокращение рационального числа ===--- }
 Procedure Simple_Rational( Var R:TRational );
{ ---=== Сложение рациональных чисел ===--- }
 Procedure rAdd( Var N1,N2,Res:TRational );
{ ---=== Вычитание рациональных чисел ===--- }
 Procedure rSub( Var N1,N2,Res:TRational );
{ ---=== Умножение рациональных чисел ===--- }
 Procedure rMul( Var N1,N2,Res:TRational );
{ ---=== Деление рациональных чисел ===--- }
 Procedure rDiv( Var N1,N2,Res:TRational );

{ ---=== Ошибка деления на 0 ===--- }
 Const Div_Error : Boolean = False;
{ ---=== Вычисление выражения ===--- }
 Procedure Calc( S:String; Var Res:TRational );

Implementation

{ ---=== Добавление нового элемента в начало списка ---===}
 Procedure DigitAddBeg( Var Root:PDigit; Data:ShortInt );
   Var Current : PDigit;
   Begin
     New(Current);
     Current^.Data := Data;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== Добавление нового элемента в конец списка ---===}
 Procedure DigitAddEnd( Var Root:PDigit; Data:ShortInt );
   Var Current,Buffer : PDigit;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Data := Data;
     Buffer^.Next := nil;
    { - Присоединение элемента к существующему списку - }
     If Root <> nil then
       Begin
         Current := Root;
         While Current^.Next <> nil do Current := Current^.Next;
         Current^.Next := Buffer;
       End
     Else
       Root := Buffer;
     End;

{ ---=== Добавление нового элемента после элемента с номером N ---===}
 Procedure DigitAdd( Var Root:PDigit; N:Integer; Data:ShortInt );
   Var Current,Buffer : PDigit; Counter : Word;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Data := Data;
    { - Присоединение элемента к существующему списку - }
     Current := Root;
     Counter := 0;
     If N <> 0 then
       While Current <> nil do
         Begin
           Inc(Counter);
           If Counter = N then
             Begin
               Buffer^.Next := Current^.Next;
               Current^.Next := Buffer;
               Break; { Больше нам делать нечего ;) }
             End;
           Current := Current^.Next;
         End
     Else
       Begin
         Buffer^.Next := Root;
         Root := Buffer;
       End;
   End;

{ ---=== Просмотр всего списка (поэлементно) ---===}
 Procedure DigitShow( Var Root:PDigit );
   Var Current : PDigit;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по обработке элемента списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление элемента с номером N ---===}
 Procedure DigitDel( Var Root:PDigit; N:Integer );
   Var Current,Buffer:PDigit; Counter:Integer;
   Begin
     Current := Root;
     Buffer := nil;
     Counter := 0;
    { - Ищем нужный нам элемент - }
     While Current <> nil do
       Begin
         Inc(Counter);
        { - И удаляем его ... - }
         If Counter = N then
           Begin
             If Buffer = nil then
               Root:=Current^.Next
             Else
               Buffer^.Next:=Current^.Next;
             Dispose(Current);
             Break; { Больше нам делать нечего ;) }
           End;
         Buffer := Current;
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление всего списка ---===}
 Procedure DigitDelAll( Var Root:PDigit );
   Var Buffer : PDigit;
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

{ ---=== Подсчет количества элементов списка ===--- }
 Function DigitNum( Var Root:PDigit ):Word;
   Var Current : PDigit; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     DigitNum := Counter;
   End;

{ ---=== Значение элемента с номером N ===--- }
 Function DigitGet( Var Root:PDigit; N:Integer ):ShortInt;
   Var Current:PDigit; Counter:Integer;
   Begin
     DigitGet := 0;
     Current  := Root;
     Counter  := 0;
    { - Ищем нужный нам элемент - }
     While Current <> nil do
       Begin
         Inc(Counter);
        { - И возвращаем его ... - }
         If Counter = N then
           Begin
             DigitGet := Current^.Data;
             Break; { Больше нам делать нечего ;) }
           End;
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление лишних нулей впереди ===--- }
 Procedure Del0( Var D:PDigit );
   Begin
     While ((DigitGet(D,DigitNum(D)) = 0) And (DigitNum(D)>1)) do
       DigitDel(D,DigitNum(D));
   End;

{ ---=== Установка значения целого числа ===--- }
 Procedure Set_Number( Var Number:TNumber; Str:String );
   Var I:Byte;
   Begin
    { По умолчанию у нас все числа будут иметь знак '+' }
     Number.Signum := Plus;
    { А если на первой позиции стоит '-' => Минус }
     If Str[1]='-' then Number.Signum := Minus;
    { А теперь пробежимся по строке и заполним список знаков }
     Number.Data := nil; { Первоначально список у нас пустой }
     For I:=1 to Length(Str) do
       If Str[I] in ['0'..'9'] then { Проверка никогда не повредит ! }
         DigitAddBeg(Number.Data,Ord(Str[I])-Ord('0'));
     Del0(Number.Data);
   End;

{ ---=== Удаление целого числа из памяти ===--- }
 Procedure Del_Number( Var Number:TNumber );
   Begin
     DigitDelAll(Number.Data);
   End;

{ ---=== Вывод целого числа на экран ===--- }
 Function Show_Number( Var Number:TNumber ):String;
   Var I:Word; S:String;
   Begin
     S:='';
    { Если число отрицательное => Выводим '-' }
     If Number.Signum = Minus then S:='-';
    { Выводим число поэлементно на экран }
     For I:=DigitNum(Number.Data) downto 1 do
       S:=S+Chr(DigitGet(Number.Data,I)+Ord('0'));
    Show_Number := S;
   End;

{ ---=== Сравнение целых чисел ===--- }
 Function ModEQU_Number( Var N1,N2:TNumber ):ShortInt;
   Var L1,L2,I:Word;
   Begin
     ModEQU_Number := 0;
     L1 := DigitNum(N1.Data);
     L2 := DigitNum(N2.Data);
     If L1 > L2 then Begin ModEQU_Number :=  1; Exit; End;
     If L1 < L2 then Begin ModEQU_Number := -1; Exit; End;
     I := L1; { I = L1 = L2 (Число знаков в числах одинаково) }
    { Находи первый отличающийся знак (Начиная со старшего) }
     While ((DigitGet(N1.Data,I)=DigitGet(N2.Data,I)) And (I > 0)) do Dec(I);
    { Если мы нашли отличающийся знак в позиции I }
     If I > 0 then
       If DigitGet(N1.Data,I) > DigitGet(N2.Data,I) then
         ModEQU_Number := 1 Else ModEQU_Number := -1;
   End;

{ ---=== Сравнение с 0 ===--- }
 Function EQU_0( Var N:TNumber ):Boolean;
   Var NT:TNumber;
   Begin
     Set_Number(NT,'0');
     EQU_0 := (ModEQU_Number(NT,N) = 0);
     Del_Number(NT);
   End;

{ ---=== Сравнение целых чисел ===--- }
 Function EQU_Number( Var N1,N2:TNumber ):ShortInt;
   Begin
    { Если числа разного знака }
     If N1.Signum <> N2.Signum then
       Begin
        { Если оба числа нули разного знака }
         If (EQU_0(N1) And EQU_0(N2)) then
           Begin EQU_Number := 0; Exit; End;
        { А если не выполнился преведущий пункт }
         If N1.Signum = Plus then
           EQU_Number := +1
         Else
           EQU_Number := -1;
         Exit;
       End;
    { А если они одного (N1.Signum = N2.Signum) }
     If N1.Signum = Plus then
       EQU_Number := ModEQU_Number(N1,N2)
     Else
       EQU_Number := - ModEQU_Number(N1,N2);
   End;

{ ---=== Сложение/Вычитание модулей D1 >= D2 ===--- }
 Function AddSub( D1,D2:PDigit; K:ShortInt ):PDigit;
   Var Res:PDigit; Max,I:Word; T,_Add_:ShortInt;
   Begin
    { Max - Максимальное количество знаков в числах }
     Max := DigitNum(D1);
     If DigitNum(D2) > Max then Max := DigitNum(D2);
    { Цикл сложения }
     Res := nil; { Результирующий список сначала пустой }
     _Add_ := 0; { Переноса тоже сначала нет ;о) }
     For I := 1 to (Max+1) do
       Begin
         T := DigitGet(D1,I) + K * DigitGet(D2,I) + _Add_;
         If T > 0 then _Add_ := T div 10 Else _Add_ := (T-9) div 10;
         T := (T + 100) mod 10;
         DigitAddEnd(Res,T);
       End;
     AddSub := Res;
   End;

{ ---=== Сложение целых чисел ===--- }
 Procedure nAdd( Var N1,N2,Res:TNumber );
   Var T:ShortInt;
   Begin
    { Если они одного знака }
     If N1.Signum = N2.Signum then
       Begin
         Res.Signum := N1.Signum;
         Res.Data := AddSub(N1.Data,N2.Data,1);
         Del0(Res.Data);
         Exit;
       End;
    { Если они разных знаков }
     T := ModEQU_Number(N1,N2);
     If T = +1 then
       Begin
         Res.Signum := N1.Signum;
         Res.Data   := AddSub(N1.Data,N2.Data,-1)
       End
     Else
       Begin
         Res.Signum := N2.Signum;
         Res.Data := AddSub(N2.Data,N1.Data,-1);
       End;
     Del0(Res.Data);
   End;

{ ---=== Вычитание целых чисел ===--- }
 Procedure nSub( Var N1,N2,Res:TNumber );
   Var T:ShortInt;
   Begin
    { Если они разных знаков }
     If N1.Signum <> N2.Signum then
       Begin
         Res.Signum := N1.Signum;
         Res.Data := AddSub(N1.Data,N2.Data,1);
         Del0(Res.Data);
         Exit;
       End;
    { Если они одного знака }
     T := ModEQU_Number(N1,N2);
     If T = +1 then
       Begin
         Res.Signum := N1.Signum;
         Res.Data   := AddSub(N1.Data,N2.Data,-1)
       End
     Else
       Begin
         Res.Signum := N2.Signum;
         Res.Data := AddSub(N2.Data,N1.Data,-1);
       End;
     Del0(Res.Data);
   End;

{ ---=== Умножение целых чисел ===--- }
 Procedure nMul( Var N1,N2,Res:TNumber ); {*}
   Var I,J:Word; T:ShortInt; NRes,DSum:PDigit; TN:TNumber;
   Begin
     Set_Number(Res,'0');
    { Выясняем знак результата }
     If N1.Signum = N2.Signum then
       Res.Signum := Plus
     Else
       Res.Signum := Minus;
    { Вычисляем значение результата }
    { Цикл по цифрам второго числа }
     For I := 1 to DigitNum(N2.Data) do
       Begin
        { Берем цифру на который умножаем }
         T := DigitGet(N2.Data,I);
        { Умножаем на очередную цифру }
         Set_Number(TN,'0');
         DSum := AddSub(TN.Data,N1.Data,T);
         Del_Number(TN);
        { Сдвигаем }
         For J := 1 to (I-1) do DigitAddBeg(DSum,0);
        { Добавляем к существующей сумме }
         NRes := AddSub(Res.Data,DSum,1);
         DigitDelAll(Res.Data);
         DigitDelAll(DSum);
         Res.Data := NRes;
       End;
     Del0(Res.Data);
   End;

 Procedure CopyNumbers( Var N1,N2:TNumber );
   Var I:Word;
   Begin
     N2.Signum := N1.Signum;
     N2.Data   := nil;
     For I := DigitNum(N1.Data) downto 1 do
       DigitAddBeg(N2.Data,DigitGet(N1.Data,I));
   End;

{ ---=== Деление с остатком целых чисел ===--- }
 Procedure nDiv( Var N1,_N2_,Res,Num:TNumber );
   Var I,J:Word; T:ShortInt; TN,Temp,N2,TN1,TN2,TN3:TNumber;
   Begin
     CopyNumbers(N1,Num);
     CopyNumbers(_N2_,N2);
     N2.Signum  := Plus;
     Num.Signum := Plus;
     Set_Number(Res,'0');
    { Выясняем знак результата }
     If N1.Signum = _N2_.Signum then
       Res.Signum := Plus
     Else
       Res.Signum := Minus;
    { Бежим по циклу смещений }
     For I := (DigitNum(N1.Data)-1) downto 0 do
       Begin
        { Writeln('Работаем со смещением ',I); }
        { Копируем делитель в новую переменную }
         CopyNumbers(N2,TN);
        { Сдвигаем делитель на I разрядов влево }
         For J := 1 to I do DigitAddBeg(TN.Data,0);
        { Write('Делитель после сдвига: '); Show_Number(TN); }
        { Находим текущую цифру }
         T:=-1; { Пусть сначала текущий знак будет -1 }
         Set_Number(TN2,'0'); Set_Number(TN3,'0');
         Repeat
           Inc(T);
           Del_Number(TN3);
           CopyNumbers(TN2,TN3);
           If T < 10 then
             Set_Number(TN1,Chr(T+Ord('0')))
           Else
             Set_Number(TN1,'10');
           nMul(TN,TN1,TN2);
          { Write('Умножаем на ',T,': '); Show_Number(TN2); }
         Until ModEQU_Number(TN2,Num) = 1;
         Dec(T);
        { Вычитаем из остатка }
         nSub(Num,TN3,Temp);
         Del_Number(Num);
         Num := Temp;
         Del_Number(TN3);
        { Write('Остаток: '); Show_Number(Num); }
        { Дописываем знак к результату }
         DigitAddBeg(Res.Data,T);
        { Write('Частное: '); Show_Number(Res); }
         Del_Number(TN2);
       End;
     Num.Signum := N1.Signum;
     Del0(Num.Data);
     Del0(Res.Data);
   End;

{ ---=== Наибольший общий делитель двух целых чисел ===--- }
 Procedure NOD( Var N1,N2,Res:TNumber );
   Var T1,T2,T3,Temp:TNumber;
   Begin
     CopyNumbers(N1,T1); T1.Signum := Plus;
     CopyNumbers(N2,T2); T2.Signum := Plus;
     Repeat
       Case ModEQU_Number(T1,T2) of
        +1,0: Begin nDiv(T1,T2,T3,Temp); Del_Number(T1); T1:=Temp; End;
        -1  : Begin nDiv(T2,T1,T3,Temp); Del_Number(T2); T2:=Temp; End;
       End;
       Del_Number(T3);
     Until (EQU_0(T1) Or EQU_0(T2));
     If EQU_0(T1) then
       CopyNumbers(T2,Res)
     Else
       CopyNumbers(T1,Res);
     Del_Number(T1);
     Del_Number(T2);
   End;

{ >>> Работа с рациональными числами <<< }
{ ---=== Установка значения рационального числа ===--- }
 Procedure Set_Rational( Var R:TRational; UpStr,DownStr:String ); {*}
   Begin
     Set_Number( R.Up,   UpStr   );
     Set_Number( R.Down, DownStr );
   End;

{ ---=== Удаление рационального числа из памяти ===--- }
 Procedure Del_Rational( Var R:TRational ); {*}
   Begin
     Del_Number( R.Up   );
     Del_Number( R.Down );
   End;

{ ---=== Вывод рационального числа на экран ===--- }
 Function Show_Rational( Var R:TRational ):String;
   Begin
     Show_Rational := (Show_Number( R.Up ) + '/' + Show_Number( R.Down ));
   End;

{ ---=== Сокращение рационального числа ===--- }
 Procedure Simple_Rational( Var R:TRational );
   Var T1,T2,T3:TNumber;
   Begin
    { Сокращение знаков }
     If R.Down.Signum = Minus then
       Begin
         R.Down.Signum := Plus;
         Case R.Up.Signum of
           Plus:  R.Up.Signum   := Minus;
           Minus: R.Up.Signum   := Plus;
         End;
       End;
    { Сокращение чисел }
     NOD(R.Up,R.Down,T1);
    { Writeln('Сокращение дроби'); }
    { Show_Rational(R); }
     nDiv( R.Up,   T1, T2, T3 ); R.Up   := T2;
     nDiv( R.Down, T1, T2, T3 ); R.Down := T2;
   End;

{ ---=== Сложение рациональных чисел ===--- }
 Procedure rAdd( Var N1,N2,Res:TRational );
   Var R1,R2:TNumber;
   Begin
     nMul(N1.Up,N2.Down,R1);
    { Write('1> '); Show_Number(R1); }
     nMul(N2.Up,N1.Down,R2);
    { Write('1> '); Show_Number(R2); }
     nAdd(R1,R2,Res.Up);
     nMul(N1.Down,N2.Down,Res.Down);
    { Show_Rational(Res);}
     Simple_Rational(Res);
   End;

{ ---=== Вычитание рациональных чисел ===--- }
 Procedure rSub( Var N1,N2,Res:TRational );
   Var R1,R2:TNumber;
   Begin
     nMul(N1.Up,N2.Down,R1);
     nMul(N2.Up,N1.Down,R2);
     nSub(R1,R2,Res.Up);
     nMul(N1.Down,N2.Down,Res.Down);
     Simple_Rational(Res);
   End;

{ ---=== Умножение рациональных чисел ===--- }
 Procedure rMul( Var N1,N2,Res:TRational );
   Begin
     nMul(N1.Up,N2.Up,Res.Up);
     nMul(N1.Down,N2.Down,Res.Down);
     Simple_Rational(Res);
   End;

{ ---=== Деление рациональных чисел ===--- }
 Procedure rDiv( Var N1,N2,Res:TRational );
   Begin
     nMul(N1.Up,N2.Down,Res.Up);
     nMul(N1.Down,N2.Up,Res.Down);
     Simple_Rational(Res);
   End;

Function _Pos_( C:Char; S:String ):Byte;
  Var I,Counter:Word;
  Begin
    _Pos_:=0;
    Counter:=0;
    For I:=1 to Length(S) do
      Begin
        If ((S[I]=C) And (Counter=0)) then
          Begin
            _Pos_:=I;
            Break;
          End;
        If S[I]='(' then Inc(Counter);
        If S[I]=')' then Dec(Counter);
      End;
  End;

{ ---=== Вычисление выражения ===--- }
 Procedure Calc( S:String; Var Res:TRational );
   Var C,LC,Counter:Word; T:String; R1,R2,R3:TRational;
   Begin
     If S = '' then
       Begin
         Set_Rational(Res,'0','1');
         Exit;
       End;
    { + - }
     If (_Pos_('+',S)+_Pos_('-',S))<>0 then
       Begin
         T:=S;
         If ((T[1]<>'-') And (T[1]<>'+')) then T:='+'+T;
         Set_Rational(R1,'0','1');
         C:=2;
         LC:=1;
         Counter:=0;
         Repeat
           If T[C] = '(' then Inc(Counter);
           If T[C] = ')' then Dec(Counter);
           If Counter = 0 then
             If ((T[C] = '+') Or (T[C] = '-') Or (C > Length(T))) then
               Begin
                 Calc( Copy(T,LC+1,C-LC-1) ,R2);
                 Case T[LC] of
                   '+': rAdd(R1,R2,R3);
                   '-': rSub(R1,R2,R3);
                 End;
                 Del_Rational(R1);
                 R1 := R3;
                 LC := C;
               End;
           Inc(C);
         Until (C>(Length(T)+1));
         Res := R1;
         Del_Rational(R2);
         Exit;
       End;
    { * }
     C:=_Pos_('*',S);
     If C > 0 then
       Begin
         Calc( Copy(S,1,C-1), R1 );
         Calc( Copy(S,C+1,Length(S)-C), R2 );
         rMul(R1,R2,Res);
         Del_Rational(R1);
         Del_Rational(R2);
         Exit;
       End;
    { / }
     C:=_Pos_('/',S);
     If C > 0 then
       Begin
         Calc(Copy(S,C+1,Length(S)-C),R1);
         Calc(Copy(S,1,C-1),R2);
         If EQU_0(R1.Up) then
           Begin
             Div_Error := True;
             Exit;
           End;
         rDiv(R2,R1,Res);
         Del_Rational(R1);
         Del_Rational(R2);
         Exit;
       End;
    { () }
     If ((S[1]='(') And (S[Length(S)]=')')) then
       Begin
         Calc(Copy(S,2,Length(S)-2),Res);
         Exit;
       End;
    { Num }
     Set_Rational(Res,S,'1');
   End;

End.