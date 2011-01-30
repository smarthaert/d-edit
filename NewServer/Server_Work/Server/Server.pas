Unit Server;

Interface

Uses  Windows, Classes, FmxUtils, SysUtils, Base, Qdialogs, monitor_XML;

Type

  TCode = (_OK, _WA, _TL, _RE, _CE, _PE, _DQ, _UE);
  TAns = Record
    _Code : TCode;
    User_Id, Problem_Id, Test_Num : Integer;
    QueueName : String;
  End;

  TCollector = Class(TThread)  // Thread1 : по-нашему
  Protected
     _Message, DataFile : TStrings;
    Procedure Execute; Override;
  Public
    Procedure Kill;
  End;

  TCompiler = Class(TThread)
  Private
    Data, TSubmit : TStrings;
    UsersAnswers, Lang : String;
  Protected
    Procedure Execute; Override;
    Function  FreeTester(Tester_Id : Longint) : Boolean;
    Procedure ReadAnswer(ID : Longint);
    Function  EndTest(Line : String): Boolean;
    Procedure Return(Code : TAns);
    Function Decod(Cod : TAns) :String;
    Procedure SetSmallPrioritet;
    Procedure SetBigPrioritet;
  Public
    Procedure Kill;
  End;

  TAnswer = Class(TThread)
  Private
  Protected
    procedure Execute; Override;
    Function Decod(Cod : String): TCode;
    Function Cod(Cod : TAns) :String;
    Procedure SetSmallPrioritet;
    Procedure SetBigPrioritet;
    Procedure AddRecToMonitor(Rec : TAns);
    Function GetMin(_Time : TDateTime): Longint;
    Procedure BeginSortMonitor(_User_Base_ID : Longint);
    Procedure MoveUsers(A,B : Longint);
  Public
    UserTemp : TStrings;
    Procedure Kill;
  End;
// --------------------------  Процедуры -----------------------------------

//Procedure Return(Code : Tans);
// --------------------------  Переменные ----------------------------------
Var Collector  : TCollector;
    Compiler   : Tcompiler;
    Answer     : TAnswer;
    A : Tstrings;
    Contest_Start : TDateTime; 
Implementation

uses Xml_Server, XMLIntf;

Procedure TCollector.Execute;
Var Tek_User: Integer;
   FileName : String;
   SubmitTime : TDateTime;
Begin
  _Message := TStringList.Create;
  DataFile := TStringList.Create;
  Priority := tpIdle; // ставим относительный низкий приоритет
  While True do
    Begin
       For Tek_User :=0 to Config.USERS.Count-1 do
         Begin
           _Message.Text := AcceptMessage(Tek_User);
           If _Message.Text = '' then Continue;
           DataFile.Add(IntToStr(Config.USERS.USER[Tek_User].ID));
           DataFile.Add(_Message.Strings[_Message.Count-3]);
           DataFile.Add(_Message.Strings[_Message.Count-2]);
           DataFile.Add(LoadQueueNumber+_Message.Strings[_Message.Count-1]);
           FileName := Config.Paths.Queue+'\'+LoadQueueNumber+_Message.Strings[_Message.Count-1];
           _Message.Delete(_Message.Count-1); //
           _Message.Delete(_Message.Count-1); //  Удаление трех последних строчек в файле
           _Message.Delete(_Message.Count-1); //
           _Message.SaveToFile(FileName);
           DataFile.SaveToFile(Config.Paths.Queue+'\'+LoadQueueNumber+'.sub');
           _Message.Clear;
           SubmitTime:= Time;
           _Message.Add(TimeToStr(SubmitTime));
           _Message.SaveToFile(ChangeFileExt(FileName,'.tim'));
           Inc(Tek_Queue);
           SaveQueueNumber;
           _Message.Clear;
           DataFile.Clear;
         End;
    End;
End;

Procedure TCompiler.Execute;
Var Submit : TSearchRec;
    FileName : String;
    Check_Compiller, i : Longint;
    Next_Test, Test_Problem, Tek_Tester : Longint;
    Res  : TAns;
    User_ID, Problem_ID : Integer;
Begin
  Data := TStringList.Create;
  TSubmit := TStringList.Create;
  While True Do
    Begin
      If FindFirst(Config.Paths.Queue+'\*.sub',$3F,Submit) <> 0 then
        Begin
          SetSmallPrioritet; // Пока не нашли в очереди Submit-а имеем низкий приоритет
          Continue;
        End;
      Try
        SetBigPrioritet; // Ура, нашли Submit Поставили высокий приоритет и ...
        Data.LoadFromFile(Config.Paths.Queue+'\'+Submit.Name);  // загружаем параметры Submit-а (*.sub)
        User_Id:=StrToInt(Data.Strings[0]);  // Запоминаем User_ID
        Problem_Id:=StrToInt(Data.Strings[1]); // Запоминаем Problem_ID
        FileName := Data.Strings[Data.Count-1];
        // Начинаем компилировть прогу, предварительно орпеделив компилятор
        For Check_Compiller:=0 to Config.COMPILERS.Count-1 do
          Begin
            If (ExtractFileExt(FileName)='.'+Config.COMPILERS.Compilator[Check_Compiller].FileExt) and
               (Data.Strings[Data.Count-2] = Config.COMPILERS.Compilator[Check_Compiller].Name) Then
                   Begin
                      Lang := Config.COMPILERS.Compilator[Check_Compiller].Name;
                        // Запускаем компилятор
                      SetSmallPrioritet;
                      Run(Config.COMPILERS.Compilator[Check_Compiller].Program_,
                          {Config.PATHS.Queue}'', Config.COMPILERS[Check_Compiller].CmdLine+' '+
                                 Config.PATHS.Queue+'\'+FileName,'3');
                      SetBigPrioritet;
                      Break;          
                   End;
        // обрабатываем результат поиска компилятора, если все плохо, сообщаем.
        IF Check_Compiller = Config.COMPILERS.Count-1 then
                 MessageDlg('Компилятор: '+ Data.Strings[Data.Count-2] + ' не найден',MtError, [mbOK],0);
          End;
        // изменяем расширение FileName
        FileName := ChangeFileExt(FileName, '.exe');
        If Not FileExists(Config.PATHS.Queue+'\'+FileName) then
          Begin
             //MessageDlg('Прога не компильнулась!',MtError, [mbOK],0);
             // Понятно файл не компильнулся и мы ругаясь на User-a
             // за то, что потратили время, возвращаем ему _CE
             Res._Code:=_CE;
             Res.User_Id := User_Id;
             Res.Problem_Id :=Problem_ID;
             Res.Test_Num:=0;
             Res.QueueName := FileName;
             Return(Res);
             Data.Clear;
          End;
        // Выясняем номер Problem в базе зняе её ID
        For Check_Compiller:=0 to Config.PROBLEMS.Count-1 do
          If Config.PROBLEMS.PROBLEM[Check_Compiller].ID=StrToInt(Data.Strings[1]) then
                     Test_Problem:=Check_Compiller;
        // Начинаем процесс тестирования на N-ом количестве тестеров
        // начинаем с первого теста, заполняя строку UsersAnswers ответами на каждый тест
        // пока тестируем по всем тестам не смотря даже на то, что User может завалиться и на первом.
        Next_Test:=1;
        UsersAnswers:='';
        SetLength(UsersAnswers,Config.PROBLEMS.PROBLEM[Test_Problem].Tests);
        For i:=1 to Length(UsersAnswers) do UsersAnswers[i]:=' ';
        // Сделали пометки о том что не на все тесты мы еще получили ответы
        While True do
          Begin
            SetSmallPrioritet;
            If EndTest(UsersAnswers) then Break;
            For Tek_Tester:=0 to Config.TESTERS.Count-1 do
              Begin
                If FreeTester(Tek_Tester) then
                  Begin
                     TSubmit.Clear;
                     IF FileExists(Config.PATHS.Queue+'\'+FileName) then
                            CopyFile(Config.PATHS.Queue+'\'+FileName,
                                     Config.TESTERS.TESTER[Tek_Tester].Queue+'\'+FileName);
                     TSubmit.Add(IntToStr(Config.PROBLEMS.PROBLEM[Test_Problem].Id));
                     TSubmit.Add(IntToStr(Next_Test));
                     TSubmit.Add(Config.TESTERS.TESTER[Tek_Tester].Queue+'\'+FileName);
                     TSubmit.SaveToFile(Config.TESTERS.TESTER[Tek_Tester].Path+'\Submit.msg');
                     Inc(Next_Test);
                     // Залили тестеру exe файл, и Submit.msg по которому он знает
                     // номер задачи, номер теста, имя exe  файла.
                  End;
                ReadAnswer(Tek_Tester);
                // проверили есть ли какой-нибудь ответ, если есть, то загрузили
                // его и освободили тестер удалив Answer.msg
              End;
          End;
        SetBigPrioritet;
        // дойдя до сюда мы поняли, что все тесты м прошли и получили  на них ответты
        // к тому же мы их всех записали в UsersAnswers
        For i:=1 to Length(UsersAnswers) Do
          IF UsersAnswers[i]= #0 then Continue Else Break;
        IF i>=Length(UsersAnswers) then
          Begin  // Задача решена
             Res._Code:=_OK;
             Res.User_Id := User_Id;
             Res.Problem_Id :=Problem_ID;
             Res.Test_Num:=0;
             Res.QueueName := FileName;
             Return(Res);
          End
        else   // User слажался и загрузил нас выяснять каким образом!!!!
          Begin
             // Выбираем код ошибки
             Case StrToInt(UsersAnswers[i]) of
               1: Res._Code := _CE;
               2: Res._Code := _WA;
               3: Res._Code := _TL;
               4: Res._Code := _PE;
               5: Res._Code := _RE;
               6: Res._Code := _DQ;
             Else Res._Code := _UE;
             End;
             IF _TimeLimit then Res._Code := _TL;
             Res.User_Id:= User_Id;
             Res.Problem_Id:=Problem_ID;
             Res.QueueName := FileName;
             Res.Test_Num := i;
             Return(Res);
          End;
      Finally
        Data.Clear;
        TSubmit.Clear;
      End;
    End;
End;
{ ---------------- Процедури убивания каждого потока -----------------------}
Procedure TCollector.Kill;
Begin
  _Message.Free;
  DataFile.Free;
  FreeOnTerminate:=True;
  While not Terminated do Terminate;
End;

Procedure TCompiler.Kill;
Begin
  Data.Free;
  TSubmit.Free;
  FreeOnTerminate:=True;
  While not Terminated do Terminate;
End;

Procedure TAnswer.Kill;
Begin
  UserTemp.Free;
  FreeOnTerminate:=True;
  While not Terminated do Terminate;
End;

{-------------------------  }


Function TCompiler.FreeTester(Tester_Id : Longint) : Boolean;
//  Функция орпеделяет готовность тестера к очередному запросу
Begin
  If (FileExists(Config.TESTERS.TESTER[Tester_Id].Path+'\'+'Submit.msg')) or
      (FileExists(Config.TESTERS.TESTER[Tester_Id].Path+'\'+'Answer.msg')) then
    Result:=False else Result:=True;
End;

Procedure TCompiler.ReadAnswer(ID: Longint);
// Читает ответ тестера и записывает его в UsersAnswers
Var Temp : Tstrings;
    Answer : String;
Begin
  IF FileExists(Config.TESTERS.TESTER[ID].Path+'\Answer.msg') then
    Begin
      Temp :=TStringList.Create;
      Temp.LoadFromFile(Config.TESTERS.TESTER[ID].Path+'\Answer.msg');
      Answer := Temp.Strings[2];
      UsersAnswers[StrToInt(Temp.Strings[1])]:=Answer[2];
      Temp.Free;
      DeleteFile(Config.TESTERS.TESTER[ID].Path+'\Answer.msg');
    End;
End;

Function TCompiler.Decod(Cod : TAns) :String;
Begin
  Case Cod._Code Of
    _OK : Result:='_OK';
    _WA : Result:='_WA';
    _TL : Result:='_TL';
    _RE : Result:='_RE';
    _CE : Result:='_CE';
    _PE : Result:='_PE';
    _DQ : Result:='_DQ';
    _UE : Result:='_UE';
  End;
End;

Procedure TCompiler.Return(Code : TAns);
// Процедура передает третьему потоку код ответа
Var {Mov_Arhive : TSearchRec;}
    Ans : TStrings;
Begin
  Code.QueueName := ChangeFileExt(Code.QueueName, '.ans');
  Ans := TStringList.Create;
  Ans.Add(IntToStr(Code.User_Id));
  Ans.Add(IntToStr(Code.Problem_Id));
  Ans.Add(IntToStr(Code.Test_Num));
  Ans.Add(DeCod(Code));
  Ans.Add(Lang);
  Ans.SaveToFile(Config.PATHS.Queue+'\'+Code.QueueName);
  Ans.Free;
  DeleteFile(Config.PATHS.Queue+'\'+ChangeFileExt(Code.QueueName, '.sub'));
  DeleteFile(Config.PATHS.Queue+'\'+ChangeFileExt(Code.QueueName, '.exe'));  
End;


Function  TCompiler.EndTest(Line : String): Boolean;
// Функция определяет степень завершенности тестирования
// User - а
Var _Pr : Longint;
Begin
  For _pr:=1 to Length(Line) do
    If  Line[_pr]=' ' then
      Begin
        Result:=False;
        Exit;
      End;
  Result:=True;
End;

Procedure TCompiler.SetSmallPrioritet;
Begin
  SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
  Priority := tpIdle;
End;

Procedure TCompiler.SetBigPrioritet;
Begin
  SetPriorityClass(GetCurrentProcess,  HIGH_PRIORITY_CLASS);
  Priority := tpHighest;
End;

Function TAnswer.Decod(Cod : String): TCode;
Begin
  If Cod = '_OK' then Result:= _OK else
  If Cod = '_WA' then Result:= _WA else
  If Cod = '_TL' then Result:= _TL else
  If Cod = '_RE' then Result:= _RE else
  If Cod = '_CE' then Result:= _CE else
  If Cod = '_DQ' then Result:= _DQ else
  Result := _UE;
End;

Function TAnswer.Cod(Cod : TAns) :String;
Begin
  Case Cod._Code Of
    _OK : Result:='Accepted';
    _WA : Result:='Wrong Answer';
    _TL : Result:='Time limit exceeded';
    _RE : Result:='Runtime error';
    _CE : Result:='Compilation error';
    _PE : Result:='Presentation error';
    _DQ : Result:='Disqualificate';
    _UE : Result:='Undefined error';
  End;
End;

Procedure TAnswer.Execute;
Var Mov_Arhive : TSearchRec;
    User_Ans : TAns;

Begin
  UserTemp := TStringList.Create;
  UserTemp.Clear;
  While True Do
   Begin
     SetSmallPrioritet;
     While Not (FindFirst(Config.PATHS.QUEUE+'\*.ans',$3F,Mov_Arhive) = 0) do;
        SetBigPrioritet;
       {   Мы получили ответ от 2 потока в формате *.ans поэтому добавляем
    в Архив исходник проги и *.ans}
        UserTemp.LoadFromFile(Config.PATHS.QUEUE+'\'+Mov_Arhive.Name);
        User_Ans._Code:=Decod(UserTemp.Strings[3]);
        User_Ans.User_Id := StrToInt(Usertemp.Strings[0]);
        User_Ans.Problem_Id := StrToInt(Usertemp.Strings[1]);
        User_Ans.Test_Num := StrToInt(Usertemp.Strings[2]);
        DeleteFile(Config.PATHS.QUEUE+'\'+Mov_Arhive.Name);
        UserTemp.Clear;
        UserTemp.Add('Результаты тестирования:');
        UserTemp.Add('User_Name : '+Config.USERS.USER[User_Ans.User_ID-1].Name);
        UserTemp.Add('User_ID : ' + IntToStr(User_Ans.User_Id));
        UserTemp.Add('Problem Name : ' + Config.PROBLEMS[User_Ans.Problem_ID-1].Name);
        UserTemp.Add('Problem ID : ' + IntToStr(User_Ans.Problem_ID));
        UserTemp.Add('Ответ Системы : ' + Cod(User_Ans));
        IF User_Ans._Code<>_OK then
                UserTemp.Add('Номер теста : '+ IntToStr(User_Ans.Test_Num));
        UserTemp.SaveToFile(Config.PATHS.QUEUE+'\'+Mov_Arhive.Name);
        If FindFirst(Config.PATHS.QUEUE+'\'+ChangeFileExt(Mov_Arhive.Name,'.*'),$3F,Mov_Arhive) = 0 then
                begin
                        repeat
                                CopyFile(Config.PATHS.Queue+'\'+Mov_Arhive.Name,
                                         Config.PATHS.Arhive+'\'+Mov_Arhive.Name);
                                DeleteFile(Config.PATHS.Queue+'\'+Mov_Arhive.Name);
                        until FindNext(Mov_Arhive) <> 0;
                        FindClose(Mov_Arhive);
                end;
        {  В Архив все переписали и сгенерили красивый ансвер}
        SendUserMessage(Config.USERS.USER[User_Ans.User_ID-1].Dir_Path,UserTemp);
        {Теперь начинаем генирить монитор}
        // загрузили текущее состояние монитора
        User_Ans.QueueName := ChangeFileExt(Mov_Arhive.Name,'.tim');
        AddRecToMonitor(User_Ans);
   End;
End;

Procedure TAnswer.AddRecToMonitor(Rec : TAns);
(*
  TCode = (_OK, _WA, _TL, _RE, _CE, _PE, _DQ, _UE);
  TAns = Record
    _Code : TCode;
    User_Id, Problem_Id, Test_Num : Integer;
    QueueName : String;
  End;
 *)
 Var i, User_in_Base, Problem_In_Base : Longint;
     User_Name : WideString;
     TimeFile : TStrings;
Begin
  // исчем юзера в базе
  For i:=0 to Config.USERS.Count-1 do
    If Rec.User_Id = Config.USERS.USER[i].ID then
      User_Name := Config.USERS.USER[i].Name;
  For i:=0 to XMonitor.USERS.Count-1 do
    If User_Name = XMonitor.USERS.USER[i].Data.U_Name then
      User_In_Base:=i;
  // Орпеделили номер юзера по базе
  For i:=0 to XMonitor.USERS.USER[User_in_Base].Submits.Count - 1 do
    If Rec.Problem_Id = XMonitor.USERS.USER[User_in_Base].Submits.Submit[i].ID then
      Problem_In_Base := i;
  // Начинаем писать данные в юзера
  If Rec._Code = _Ok then
    Begin
     IF XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits = 0 then
           XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].NUM_Submits:='+' else
             XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].NUM_Submits:='+' +
               IntToStr(XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits);
//   XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits :=
//       XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits+1;
     XMonitor.USERS.USER[User_in_Base].Data.Solved := XMonitor.USERS.USER[User_in_Base].Data.Solved + 1;
     End;
  If Rec._Code <> _Ok then
     Begin
       XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits :=
          XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits+1;
       XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].NUM_Submits:='-'+
            IntToStr(XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits);
     End;
  TimeFile := TStringList.Create;
  TimeFile.LoadFromFile(Config.PATHS.Arhive+'\'+Rec.QueueName);
  Tek_Time := StrToTime(TimeFile.Strings[0]);
  XMonitor.USERS.USER[User_in_Base].Data.Time := XMonitor.USERS.USER[User_in_Base].Data.Time+
       GetMIN(Contest_Start-Tek_Time)+
       20*XMonitor.USERS.USER[User_in_Base].Submits.Submit[Problem_In_Base].Kol_Submits;
  BeginSortMonitor(User_in_Base);
  TimeFile.Clear;
  TimeFile.Text := XMonitor.XML;
  TimeFile.SaveToFile('Monitor.xml'); // Сохранили изменения в мониторе
End;

Function TAnswer.GetMin(_Time : TDateTime) : Integer;
Var S, Tmp :String;
    I, j, Hour, Min, Sec : Longint;
Begin
  S:= TimeToStr(_Time);
  i:=1;
  While S[i]<>':' do Inc(i);
  For j:=1 to i-1 do tmp:= tmp+ s[j];
  Hour:=StrToInt(Tmp);Inc(I);Tmp:='';
  While S[i]<>':' do Inc(i);
  For j:=j+1 to i-1 do tmp:= tmp+ s[j];
  Min := StrToInt(Tmp);Inc(i);Tmp:='';
  For j:=j+1 to Length(S) do tmp:= tmp+ s[j];
  Sec := StrToInt(Tmp);
  Result:=Hour*60+Min;
End;

Procedure TAnswer.BeginSortMonitor(_User_Base_ID : Longint);
Var i_,j : Longint;
Begin
  For i_:=0 to XMonitor.USERS.Count - 1 do
    For j:=0 to XMonitor.USERS.Count - 2  do
      Begin
        If XMonitor.USERS.USER[j].Data.Solved < XMonitor.USERS.USER[j+1].Data.Solved then
            MoveUsers(j,j+1);
        If XMonitor.USERS.USER[j].Data.Solved = XMonitor.USERS.USER[j+1].Data.Solved Then
          Begin
            IF XMonitor.USERS.USER[j].Data.Time > XMonitor.USERS.USER[j+1].Data.Time Then
                  MoveUsers(j,j+1);
            If XMonitor.USERS.USER[j].Data.Time = XMonitor.USERS.USER[j+1].Data.Time Then
               IF XMonitor.USERS.USER[j].Data.U_Name > XMonitor.USERS.USER[j+1].Data.U_Name then
                  MoveUsers(j,j+1);
          End;
      End;
  XMonitor.USERS.USER[0].Data.Rank := 1;
  For i_:=1 to XMonitor.USERS.Count - 1 do
    Begin
      XMonitor.USERS.USER[i_].Data.Rank := i_+1;
      IF (XMonitor.USERS.USER[i_].Data.Solved = XMonitor.USERS.USER[i_-1].Data.Solved) And
         (XMonitor.USERS.USER[i_].Data.Time = XMonitor.USERS.USER[i_-1].Data.Time) then
          XMonitor.USERS.USER[i_].Data.Rank := XMonitor.USERS.USER[i_-1].Data.Rank;
    End;
End;

Procedure TAnswer.MoveUsers(A,B : Longint);
Var Temp: IXMLUSERTypes;
    i : Longint;
Begin
  Temp:= XMonitor.USERS.USER[A];

  XMonitor.USERS.USER[A].Data.U_Name := XMonitor.USERS.USER[B].Data.U_Name;
  XMonitor.USERS.USER[A].Data.Rank := XMonitor.USERS.USER[B].Data.Rank;
  XMonitor.USERS.USER[A].Data.Time := XMonitor.USERS.USER[B].Data.Time;
  XMonitor.USERS.USER[A].Data.Solved := XMonitor.USERS.USER[B].Data.Solved;
  For i:=0 to XMonitor.USERS.USER[A].Submits.Count - 1 do
    Begin
      XMonitor.USERS.USER[A].Submits.Submit[i].ID:=XMonitor.USERS.USER[B].Submits.Submit[i].ID;
      XMonitor.USERS.USER[A].Submits.Submit[i].NUM_Submits:=XMonitor.USERS.USER[B].Submits.Submit[i].NUM_Submits;
      XMonitor.USERS.USER[A].Submits.Submit[i].Kol_Submits:=XMonitor.USERS.USER[B].Submits.Submit[i].Kol_Submits;
      XMonitor.USERS.USER[A].Submits.Submit[i].Solve_Time:=XMonitor.USERS.USER[B].Submits.Submit[i].Solve_Time;
      XMonitor.USERS.USER[A].Submits.Submit[i].Balls:=XMonitor.USERS.USER[B].Submits.Submit[i].Balls;
    End;
    
  XMonitor.USERS.USER[B].Data.U_Name := Temp.Data.U_Name;
  XMonitor.USERS.USER[B].Data.Rank := Temp.Data.Rank;
  XMonitor.USERS.USER[B].Data.Time := Temp.Data.Time;
  XMonitor.USERS.USER[B].Data.Solved := Temp.Data.Solved;
  For i:=0 to XMonitor.USERS.USER[B].Submits.Count - 1 do
    Begin
      XMonitor.USERS.USER[B].Submits.Submit[i].ID:=Temp.Submits.Submit[i].ID;
      XMonitor.USERS.USER[B].Submits.Submit[i].NUM_Submits:=Temp.Submits.Submit[i].NUM_Submits;
      XMonitor.USERS.USER[B].Submits.Submit[i].Kol_Submits:=Temp.Submits.Submit[i].Kol_Submits;
      XMonitor.USERS.USER[B].Submits.Submit[i].Solve_Time:=Temp.Submits.Submit[i].Solve_Time;
      XMonitor.USERS.USER[B].Submits.Submit[i].Balls:=Temp.Submits.Submit[i].Balls;
    End;
End;

Procedure TAnswer.SetSmallPrioritet;
Begin
  SetPriorityClass(GetCurrentProcess, IDLE_PRIORITY_CLASS);
  Priority := tpIdle;
End;

Procedure TAnswer.SetBigPrioritet;
Begin
  SetPriorityClass(GetCurrentProcess,  HIGH_PRIORITY_CLASS);
  Priority := tpHighest;
End;

end.
