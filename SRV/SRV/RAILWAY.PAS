Program RailWay;
{Монитор без всяких приоритетов. Недостаток - бесконечное ожидание.}
Uses Crt, MultiObj;
Type
        Monitor = Object
            Nwlr,                     {число ждущих слева направо}
            Nwrl,                     {число ждущих справа налево}
            Nmlr,                     {число идущих слева направо}
            Nmrl      : Word;         {число идущих справа налево}
            L_R_List,                 {список ждущих слева направо}
            R_L_List  :  List;        {список ждущих справа налево}
            Procedure Init;           {инициализация монитора}
            Procedure Enter_L_R;      {вход на ед. путь левого}
            Procedure Enter_R_L;      {вход на ед. путь правого}
            Procedure Exit_L_R;       {выход с ед. пути левого}
            Procedure Exit_R_l;       {выход с ед. пути правого}
        End;
{=========================================================================}
Procedure Monitor.Init;
Begin
            Nwlr  :=  0;
            Nwrl  :=  0;
            Nmlr  :=  0;
            Nmrl  :=  0;
            L_R_List.Init;
            R_L_List.Init;
End;
{------------------------------------------------}
Procedure Monitor.Enter_L_R;
Begin
     DI;
     If Nmrl > 0 Then Begin
     {если есть правые на ед. пути, то встаем в очередь левых}
           Inc(Nwlr);
           GoToXY(26,11);
           Write(Nwlr);
           Prev := Cur;
           L_R_List.Incl(Prev);
           Cur := ListReady.GetBeg;
           ListReady.Remove(Cur);
           Transfer(Prev,Cur);
           DI;
     End;
     Inc(Nmlr);
     EI;
End;
{------------------------------------------------}
Procedure Monitor.Enter_R_L;
Begin
     DI;
     If Nmlr > 0 Then Begin
     {если есть левые на ед. пути, то встаем в очередь правых}
           Inc(Nwrl);
           GoToXY(59,13);
           Write(Nwrl);
           Prev := Cur;
           R_L_List.Incl(Prev);
           Cur := ListReady.GetBeg;
           ListReady.Remove(Cur);
           Transfer(Prev,Cur);
           DI;
     End;
     Inc(Nmrl);
     EI;
End;
{------------------------------------------------}
Procedure Monitor.Exit_L_R;
Var
     E          :  ElmPtr;
     Na         :  Word;
Begin
     DI;
     Dec(Nmlr);
     If Nmlr = 0 Then Begin
     {если последний левый вышел с ед. пути, активизируем всех правых}
        Na := 0;
        While Nwrl > 0 Do Begin
                  Dec(Nwrl);
                  GoToXY(59,13);
                  Write(Nwrl,' ');
                  E := R_L_List.GetBeg;
                  R_L_List.Remove(E);
                  If Na = 0 Then
                  {первого правого пишем в очередь готовых}
                           ListReady.Incl(E)
                       Else Begin
                  {остальных правых пишем в очередь задержанных на время}
                  {с задержкой, увеличивающейся на 10 с каждым новым}
                  {процессом; это сделано для наглядности изображения}
                           ListDelayT.Incl(E);
                           E^.SetTact(Tick + 10*Na);
                       End;
                   Inc(Na);
        End;
        End;
     EI;
End;
{------------------------------------------------}
Procedure Monitor.Exit_R_L;
Var
     E          :  ElmPtr;
     Na         :  Word;
Begin
     DI;
     Dec(Nmrl);
     If Nmrl = 0 Then Begin
     {если последний правый вышел с ед. пути, активизируем всех левых}
        Na := 0;
        While Nwlr > 0 Do Begin
                  Dec(Nwlr);
                  GoToXY(26,11);
                  Write(Nwlr,' ');
                  E := L_R_List.GetBeg;
                  L_R_List.Remove(E);
                  If Na = 0 Then
                  {первого левого пишем в очередь готовых}
                           ListReady.Incl(E)
                       Else Begin
                  {остальных левых пишем в очередь задержанных на время}
                  {с задержкой, увеличивающейся на 10 с каждым новым}
                  {процессом; это сделано для наглядности изображения}
                           ListDelayT.Incl(E);
                           E^.SetTact(Tick + 10*Na);
                       End;
                  Inc(Na);
        End;
     End;
     EI;
End;
{=========================================================================}
Var
        Proc1,
        Proc2,
        Proc3     :  ProcPtr;
        {Дескрипторами пользоваться нельзя!}
        Only_Way  :  Monitor;
        Flag_L_R,
        Flag_R_L  :  Boolean;
{=========================================================================}
Procedure WriteLock(X : word; Y : word; S : char);
Begin
DI;
         GoToXY(X,Y);
         Write(S);
EI;
End {WriteLock};
{=========================================================================}
Procedure Init_Way;
Var
   K : Word;
Begin
     GoToXY( 1, 6);
     Write('═══════════════════════╗                '+
           '                ╔═══════════════════════');
     For K := 1 To 5 Do Begin
         GoToXY(24,K+ 6);
         Write('║                                ║');
     End {For};
     GoToXY(24,12);
     Write('╠════════════════════════════════╣');
     For K := 1 To 5 Do Begin
         GoToXY(24,K+12);
         Write('║                                ║');
     End {For};
     GoToXY( 1,18);
     Write('═══════════════════════╝                '+
           '                ╚═══════════════════════');
End {Init_Way};
{=========================================================================}
Procedure L_R_Train;
Var
     K : Word;
     S : Char;
Begin
          WriteLock(1,6,'L');
          ListReady.MoveSelf(ListDelayT,3);
          Flag_L_R := True;
     For K := 1 To 23 Do Begin
          WriteLock(K,6,'═');
          WriteLock(K+1,6,'L');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};
     For K := 1 To 5 Do Begin
          If K = 1 Then S := '╗' Else S := '║';
          WriteLock(24,K+5,S);
          WriteLock(24,K+6,'L');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};

          Only_Way.Enter_L_R;

          WriteLock(24,11,'║');
          WriteLock(24,12,'L');
          ListReady.MoveSelf(ListDelayT,3);
     For K := 1 To 33 Do Begin
          If K = 1 Then S := '╠' Else  S := '═';
          WriteLock(K+23,12,S);
          WriteLock(K+24,12,'L');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};
          WriteLock(57,12,'╣');
          WriteLock(57,11,'L');
          ListReady.MoveSelf(ListDelayT,3);

          Only_Way.Exit_L_R;

     For K := 5 DownTo 1 Do Begin
          WriteLock(57,K+6,'║');
          WriteLock(57,K+5,'L');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};

     For K := 1 To 23 Do Begin
          If K = 1 Then S := '╔' Else S := '═';
          WriteLock(K+56,6,S);
          WriteLock(K+57,6,'L');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};
          WriteLock(80,6,'═');
          ListReady.MoveSelf(ListKill,0);
End {L_R_Train};
{=========================================================================}
Procedure R_L_Train;
Var
     K : Word;
     S : Char;
Begin
          WriteLock(80,18,'R');
          ListReady.MoveSelf(ListDelayT,3);
          Flag_R_L := True;
     For K := 80 DownTo 58 Do Begin
          WriteLock(K,18,'═');
          WriteLock(K-1,18,'R');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};
     For K := 5 DownTo 1 Do Begin
          If K = 5 Then S := '╚' Else  S := '║';
          WriteLock(57,K+13,S);
          WriteLock(57,K+12,'R');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};

          Only_Way.Enter_R_L;

          WriteLock(57,13,'║');
          WriteLock(57,12,'R');
          ListReady.MoveSelf(ListDelayT,3);
     For K := 33 DownTo 1 Do Begin
          If K = 33 Then S := '╣' Else  S := '═';
          WriteLock(K+24,12,S);
          WriteLock(K+23,12,'R');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};
          WriteLock(24,12,'╠');
          WriteLock(24,13,'R');
          ListReady.MoveSelf(ListDelayT,3);

          Only_Way.Exit_R_L;

     For K := 1 To 5 Do Begin
          WriteLock(24,K+12,'║');
          WriteLock(24,K+13,'R');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};

     For K := 24 DownTo 2 Do Begin
          If K = 24 Then S := '╝' Else S := '═';
          WriteLock(K,18,S);
          WriteLock(K-1,18,'R');
          ListReady.MoveSelf(ListDelayT,3);
     End {For};
          WriteLock(1,18,'═');
          ListReady.MoveSelf(ListKill,0);
End {R_L_Train};
{=========================================================================}
Procedure  Key;
Var
   K : Boolean;
   C : Char;
Begin
While True Do begin
           DI;
           K := KeyPressed;
           EI;
      If  K  Then  Begin
                 DI;
                 C  :=   Readkey;
                 EI;
                 Case C Of
             Char(27) : ListReady.Stop;
             'L','l'  : If Flag_L_R Then Begin
                            ListReady.Add(@L_R_Train,0,proc1);
                            Flag_L_R := False;
                        End;
             'R','r'  : If Flag_R_L Then Begin
                            ListReady.Add(@R_L_Train,0,proc2);
                            Flag_R_L := False;
                        End;
                 Else
                 End;
      End  {If};
End {While};
End {Key};
{=========================================================================}
Begin
     Flag_L_R := True;
     Flag_R_L := True;
     ClrScr;
     Only_Way.Init;
     Init_Way;
     ListReady.Add(@Key,0,proc3);
     ListReady.Start;
     ClrScr;
End {RailWay}.




