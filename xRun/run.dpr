{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P-,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
program run;
uses
  SysUtils,
  Windows,
  JudgeExec in 'JudgeExec.pas',
  TestSysUtil in 'TestSysUtil.pas',
  MemoryLimit in 'MemoryLimit.pas',
  runlog in 'runlog.pas',
  TestSysTime in 'TestSysTime.pas',
  TestSysReadCfg in 'TestSysReadCfg.pas';

const NAME='myRUN';

var WaitOnExit:boolean=false;


function testescape:boolean;
var current:INPUT_RECORD;
    q:cardinal;
begin
  while WaitForSingleObject (GetStdHandle (STD_INPUT_HANDLE), 0)=WAIT_OBJECT_0 do begin
    if not ReadConsoleInput (GetStdHandle (STD_INPUT_HANDLE), current, 1, q) then begin
      result:=false; exit;
    end;
    if (q=1) and (current.eventtype=KEY_EVENT) and 
       (current.Event.KeyEvent.bKeyDown) and
       (current.Event.KeyEvent.wRepeatCount>0) and
       (current.Event.KeyEvent.AsciiChar=#27) then begin result:=true; exit end;
  end;
  result:=false;
end;

procedure myhalt (code:integer);
var current:INPUT_RECORD;
    q:cardinal;
begin
  while WaitForSingleObject (GetStdHandle (STD_INPUT_HANDLE), 0)=WAIT_OBJECT_0 do
    ReadConsoleInput (GetStdHandle (STD_INPUT_HANDLE), current, 1, q);
  if WaitOnExit then begin
    repeat
      WaitForSingleObject (GetStdHandle (STD_INPUT_HANDLE), INFINITE);
      if not ReadConsoleInput (GetStdHandle (STD_INPUT_HANDLE), current, 1, q) then break;
      if (q<>0) and (current.eventtype=KEY_EVENT) then break;
    until false;
  end;
  halt (code);
end;


function getbvar (curcfg:PCfgContext; const name : string; default : boolean) : boolean;
var V : PCfgObject; S : String;
begin
  Result := default;
  V := CurCfg.evalvar (name);
  if (V = nil) or (V.gettype = _NULL_) or
    ((V.gettype = _LIST_) and (V.tolist.len = 0)) then
    begin DelCfgObj(V); exit end;
  if V.gettype <> _STRING_ then
    writeln (format (#7#13#10'Variable "%s" in %s should be of boolean type',
                                                [name, CurCfg.Origin]));
  S := UpperCase (trim (V.tostr.getstr));
  V.destroy;
  if (S = 'TRUE') or (S = 'YES') then Result := true;
  if (S = 'FALSE') or (S = 'NO') then Result := false
end;


function getvar (curcfg:PCfgContext; const name, default : string) : string;
var V : PCfgObject;
begin
  Result := default;
  V := CurCfg.evalvar (name);
  if (V = nil) or (V.gettype = _NULL_) or
    ((V.gettype = _LIST_) and (V.tolist.len = 0)) then
    begin DelCfgObj(V); exit end;
  if V.gettype <> _STRING_ then begin
    writeln (format (#7#13#10'Variable "%s" should be of string type', [name]));
    myhalt (1);
  end;
  Result := V.tostr.getstr;
  DelCfgObj (V);
  if Result = '' then Result := default
end;


function getivar (curcfg:PCfgContext; const name : string; default : integer) : integer;
var V : PCfgObject;
begin
  Result := default;
  V := CurCfg.evalvar (name);
  if (V = nil) or (V.gettype = _NULL_) or
    ((V.gettype = _LIST_) and (V.tolist.len = 0)) then
    begin DelCfgObj(V); exit end;
  if V.gettype <> _STRING_ then begin
    Writeln (format (#7#13#10'Variable "%s" in %s should be an integer',
                                                [name, CurCfg.Origin]));
    myhalt (1);
  end;
  Result := V.tostr.getint;
  DelCfgObj (V);
  if Result = INVALID_NUM then begin
    Writeln (format (#7#13#10'Variable "%s" in %s should be an integer',
                                                [name, CurCfg.Origin]));
    myhalt (1);
  end;
end;


var TaskCfgName:string='task.cfg';
    InputFile:string='input.txt';
    OutputFile:string='output.txt';
    ProgramName:string='solution';
    CheckerFile:string='check.exe';
    SourceExtension:string='dpr';
    CompilerCommand:string='dcc32.exe -cc';
    CompileAlways:boolean=false;
    CompileSolution:boolean=true;
    CopyTestFiles:boolean=true;
    CheckResult:boolean=false;
    ResultExtension:string='u';
    AnswerExtension:string='a';
    Options:string='';
    TaskDirectory:string='';
    _MemoryLimit:integer=0;
    _TimeLimit:integer=0;

var CheckerOutputPreviouslyDisplayed:boolean=false;

function TryTest (const UsedInputFile:string; var TimeUsed, MaxMemoryUsed:int64):boolean;
var CurrentPath, CurrentInputFile, CurrentOutputFile:string;
    ResultCode:cardinal;
    res:cardinal;
    outhdl:cardinal;
    UtilityOutput:string;
    tstr:string;
begin
  CheckerOutputPreviouslyDisplayed:=false;
  Result:=false; TimeUsed:=0; MaxMemoryUsed:=0;
  if InputFile='con' then CurrentInputFile:='~input~.tmp'
                     else CurrentInputFile:=InputFile;
  if CopyTestFiles and (CurrentInputFile<>TaskDirectory+UsedInputFile) then begin
    if not FCopy (TaskDirectory+UsedInputFile, CurrentInputFile, true) then begin
      logstring ('Unable to copy input file %s for test %s', [InputFile, UsedInputFile]);
      exit;
    end;
  end;
  GetDir (0, CurrentPath);
  Res:=ExecuteContestantProgram (ProgramName, CurrentPath, InputFile, OutputFile,
             EXEC_FLAG_NEW_CONSOLE, _TimeLimit, _MemoryLimit,
             TimeUsed, MaxMemoryUsed, ResultCode);
  case Res of
    EXEC_FAIL:tstr:='Failed To Execute';
    EXEC_ABORT:tstr:='Execution Aborted???';
    EXEC_SV:tstr:='Security Violation???';
    EXEC_RT:tstr:=format ('Runtime Error (%d)', [ResultCode]);
    EXEC_ML:tstr:='Memory Limit';
    EXEC_TL:tstr:='Time Limit';
    EXEC_OK:tstr:='Программа благополучно завершилась';
    else tstr:='Unknown Judge Response';
  end;
  writeonlylog (tstr);
  writeln (tstr, ' (', round (timeused/10000), ' ms)');
  if Res<>EXEC_OK then exit;
  if OutputFile='con' then CurrentOutputFile:='out.tmp' else CurrentOutputFile:=OutputFile;
  if Res=EXEC_OK then begin
    if (ResultExtension<>'') and CopyTestFiles then
      if not FCopy (CurrentOutputFile, UsedInputFile+'.'+ResultExtension, true) then
        logstring ('Unable to copy output file %s for test %s', [OutputFile, UsedInputFile]);
    if CheckResult then begin
      Res:=ExecuteChecker (TaskDirectory+CheckerFile, CurrentPath,
                           TaskDirectory+UsedInputFile, CurrentOutputFile,
                           TaskDirectory+UsedInputFile+'.'+AnswerExtension,
                           '~check~.tmp',
                           EXEC_FLAG_UTILITY or EXEC_FLAG_NEW_PROCESS_GROUP,
                           outhdl);
      CloseHandle (outhdl);
      if not FileToString ('~check~.tmp',
                           1048576, false, UtilityOutput) then
        UtilityOutput:='';
      case Res of
        EXEC_OK:writelog ('Результат: Правильный ответ!');
        EXEC_WA:writelog ('Результат: Неправильный ответ!');
        EXEC_JE:writelog ('Результат: _ОШИБКА_ЖЮРИ_ Проверьте настройки и запустите заново!');
        EXEC_PE:writelog ('Результат: Неправильный формат ввода/вывода');
        EXEC_ABORT:writelog ('Checker aborted???');
        else writelog ('ERROR: Не могу найти файл чекера! Check.exe должен быть в каталоге задачи!');
      end;
      if Res<>EXEC_OK then writeonlylog ('Комментарии:'#13#10+UtilityOutput);
      CheckerOutputPreviouslyDisplayed:=true;
      Extended_Delete ('~check~.tmp');
      Result:=Res=EXEC_OK;
    end else Result:=true;
  end;
end;

var ExitOnFail:boolean=false;
    TestName:string='';

type keyfunction=function (const value:string; where:pointer):boolean;
     pboolean=^boolean;

type keyrec=record
  name:string;
  firstfunction:keyfunction;
  secondfunction:keyfunction;
  where:pointer;
end;

function nulfunction (const value:string; where:pointer):boolean;
begin
  Result:=true;
end;


function keyboolean (const value:string; where:pointer):boolean;
begin
  Result:=true;
  if value='' then pboolean (where)^:=true else
  case upcase (value[1]) of
    '1', 'Y', '+', 'T':pboolean (where)^:=true;
    '0', 'N', '-', 'F':pboolean (where)^:=false;
    else Result:=false;
  end;
end;


function keystring (const value:string; where:pointer):boolean;
begin
  Result:=true; pstring (where)^:=value;
end;


function keyinteger (const value:string; where:pointer):boolean;
var tmp:integer;
begin
  val (value, pinteger (where)^, tmp);
  Result:=tmp=0;
end;


function displayhelp (const value:string; where:pointer):boolean;
begin
  write   (#13#10+NAME+#13#10#13#10+
           'Generic switch format: /<swname>=<value>'#13#10+
           'For boolean switches single /<swname> also allowed setting value to be true'#13#10+
           'For string switches single /<swname> sets value to be empty'#13#10+
           'Here is the list of allowed command line parameters:'#13#10#13#10+
           '/? or /help - displays this help'#13#10+
           '/answerextension or /a - change answer file extension'#13#10+
           '/checker or /v         - change name of the checking program'#13#10+
           '/checkresult or /y     - check the answer whether it is correct or no'#13#10+
           '/copytestfiles or /f   - if false - runs only on single test specified by /i'#13#10+
           '/compiler or /b        - name and options for solution compiler'#13#10+
           '/compilesolution or /q - solution recompilation allowed if source is newer'#13#10+
           '/compilealways or /g   - if true and /q enabled - unconditional compile'#13#10+
           '/config or @<cfgname>  - the name of configuration file to read'#13#10+
           '/exitonfail or /e      - finish testing after first wrong test'#13#10+
           '/inputfile or /i       - name of the input file'#13#10+
           '/outputfile or /o      - name of the output file'#13#10+
           '/resultextension or /r - the name of result extension, if empty - no result'#13#10+
           '/solution or /p        - name of the solution'#13#10+
           '/sourceextension or /x - extension of the source file'#13#10+
           '/memorylimit or /m     - memory limit for this task (<=512-mb else kb, 0=inf)'#13#10+
           '/timelimit or /z       - time limit for this task (<=60-sec else ms, 0=inf)'#13#10+
           '/testname or /n        - the name of the single test to run, if empty - run all'#13#10+
           '/directory or /d       - directory for tests, answers and checker'#13#10+
           '/waitonexit or /w      - wait on exit'#13#10+
           '/logfile or /l         - the name of the run.log file, if empty - do not log'#13#10#13#10+
           'The defaults are: /a=a/v=check.exe/y- "/b=dcc32.exe -cc" /w-/q @task.cfg/e-'#13#10+
           '                  /i=input.txt/m=0/o=output.txt/r=u/p=solution/x=dpr/z=0/n'#13#10+
           '                  /l=run.log/d/w-/f'#13#10#13#10+
           'First five parameters without switches are recognized in order /p /i /o /r /n'#7);
  myhalt (1);
  Result:=boolean (2);
end;

var secondpass:boolean=false;
    passedcount:integer=0;

const allkeys:array [1..34] of keyrec=
(
(name:#0; firstfunction:nulfunction; secondfunction:nulfunction; where:nil),
(name:'?'; firstfunction:displayhelp; secondfunction:nulfunction; where:nil),
(name:'answerextension'; firstfunction:nulfunction; secondfunction:keystring; where:@answerextension),
(name:'b'; firstfunction:nulfunction; secondfunction:keystring; where:@compilercommand),
(name:'checker'; firstfunction:nulfunction; secondfunction:keystring; where:@checkerfile),
(name:'checkresult'; firstfunction:nulfunction; secondfunction:keyboolean; where:@checkresult),
(name:'compilealways'; firstfunction:nulfunction; secondfunction:keyboolean; where:@compilealways),
(name:'compiler'; firstfunction:nulfunction; secondfunction:keystring; where:@compilercommand),
(name:'compilesolution'; firstfunction:nulfunction; secondfunction:keyboolean; where:@compilesolution),
(name:'config'; firstfunction:keystring; secondfunction:nulfunction; where:@taskcfgname),
(name:'copytestfiles'; firstfunction:nulfunction; secondfunction:keyboolean; where:@copytestfiles),
(name:'directory'; firstfunction:nulfunction;secondfunction:keystring;where:@taskdirectory),
(name:'exitonfail'; firstfunction:nulfunction; secondfunction:keyboolean; where:@exitonfail),
(name:'f'; firstfunction:nulfunction; secondfunction:keyboolean; where:@copytestfiles),
(name:'g'; firstfunction:nulfunction; secondfunction:keyboolean; where:@compilealways),
(name:'help'; firstfunction:displayhelp; secondfunction:nulfunction; where:nil),
(name:'inputfile'; firstfunction:nulfunction; secondfunction:keystring; where:@inputfile),
(name:'logfile'; firstfunction:nulfunction; secondfunction:keystring; where:@runlogname),
(name:'memorylimit'; firstfunction:nulfunction; secondfunction:keyinteger; where:@_memorylimit),
(name:'n'; firstfunction:nulfunction; secondfunction:keystring; where:@testname),
(name:'outputfile'; firstfunction:nulfunction; secondfunction:keystring; where:@outputfile),
(name:'p'; firstfunction:nulfunction; secondfunction:keystring; where:@programname),
(name:'q'; firstfunction:nulfunction; secondfunction:keyboolean; where:@compilesolution),
(name:'resultextension'; firstfunction:nulfunction; secondfunction:keystring; where:@resultextension),
(name:'solution'; firstfunction:nulfunction; secondfunction:keystring; where:@programname),
(name:'sourceextension'; firstfunction:nulfunction; secondfunction:keystring; where:@sourceextension),
(name:'testname'; firstfunction:nulfunction; secondfunction:keystring; where:@testname),
(name:'timelimit'; firstfunction:nulfunction; secondfunction:keyinteger; where:@_timelimit),
(name:'v'; firstfunction:nulfunction; secondfunction:keystring; where:@checkerfile),
(name:'w'; firstfunction:keyboolean;  secondfunction:keyboolean; where:@waitonexit),
(name:'x'; firstfunction:nulfunction; secondfunction:keystring; where:@sourceextension),
(name:'y'; firstfunction:nulfunction; secondfunction:keyboolean; where:@checkresult),
(name:'z'; firstfunction:nulfunction; secondfunction:keyinteger; where:@_timelimit),
(name:#255; firstfunction:nulfunction; secondfunction:nulfunction; where:nil)
);


procedure handlekey (const s:string);
var i, k, t:integer;
    name, value:string;
begin
  t:=pos ('=', s); if t=0 then t:=length (s)+1;
  if (t>length (s)) and (s<>'') and (s[length (s)] in ['+', '-']) then begin
    name:=copy (s, 2, length (s)-2); value:=s[length (s)];
  end else begin
    name:=copy (s, 2, t-2); value:=copy (s, t+1, length (s));
  end;
  k:=-1; name:=lowercase (name);
  for i:=low (allkeys)+1 to high (allkeys)-1 do
    if (copy (allkeys[i].name, 1, length (name))=name) then begin
      if (copy (allkeys[i-1].name, 1, length (name))=name) or
         (copy (allkeys[i+1].name, 1, length (name))=name) then begin
        writeln (#7#13#10'Ambiguous key specified: /', name, #13#10#7);
        myhalt (1);
      end;
      k:=i; break;
    end;
  if k<0 then begin
    writeln (#7#13#10'Unknown key specified: /', name, #13#10#7);
    myhalt (1);
  end;
  if secondpass then allkeys[k].secondfunction (value, allkeys[k].where)
                else allkeys[k].firstfunction (value, allkeys[k].where);
end;


procedure namefunction (const s:string);
begin
  if s<>'' then begin
    if s[1]='@' then TaskCfgName:=copy (s, 2, length (s)) else
    if secondpass then begin
      inc (passedcount);
      case passedcount of
        1:programname:=s;
        2:inputfile:=s;
        3:outputfile:=s;
        4:resultextension:=s;
        5:testname:=s
        else begin
          writeln (#7#13#10'Too many parameters in command line'#13#10#7);
          myhalt (1);
        end;
      end;
    end;
  end;
end;


procedure parsekeys (const s:string);
var p, z:integer;
begin
  if s[1]<>'/' then begin
    p:=pos ('/', s); if p=0 then p:=length (s)+1;
    namefunction (trim (copy (s, 1, p-1)));
  end else p:=1;
  while p<=length (s) do begin
    z:=pos ('/', copy (s, p+1, length (s)));
    if z=0 then z:=length (s)-p+1;
    handlekey (trim (copy (s, p, z)));
    inc (p, z);
  end;
end;


procedure parseall;
var i:integer;
begin
  passedcount:=0;
  if options<>'' then parsekeys (options);
  for i:=1 to paramcount do parsekeys (paramstr (i));
  secondpass:=true;
end;


var MainCfg:PCfgContext;
    count, i:integer;
    s, ModuleName, CurrentPath, UtilityOutput:string;
    CurTimeUsed, CurMemoryUsed, MaxTimeUsed, MaxMemoryUsed:int64;
    tmp:boolean;
    CompRes, ResCode:cardinal;
    sourcemod, modulemod:int64;
    OutputHandle:THandle;


   sr : TSearchRec;
   TaskID,SolutionCfgFileName : String;
   T : TextFile;
begin
  {chdir ('f:\testarea\compos_2');}
  for i:=low (allkeys) to high (allkeys)-1 do
    if allkeys[i].name>=allkeys[i+1].name then
      runerror (239);
  for i:=low (allkeys) to high (allkeys) do
    if allkeys[i].name<>lowercase (allkeys[i].name) then runerror (239);
  parseall;
  JudgeExecExternalLog:=OnlyLogString;
  if FileExists (TaskCfgName) then begin
    MainCfg:=ReadConfig (TaskCfgName);
    InputFile:=getvar (MainCfg, 'InputFile', 'in.txt');
    OutputFile:=getvar (MainCfg, 'OutputFile', 'out.txt');
    _MemoryLimit:=getivar (MainCfg, 'MemoryLimit', 0);
    _TimeLimit:=getivar (MainCfg, 'TimeLimit', 0);
    ProgramName:=getvar (MainCfg, 'ProgramName', 'solution');
    AnswerExtension:=getvar (MainCfg, 'AnswerExtension', 'a');
    ResultExtension:=getvar (MainCfg, 'ResultExtension', 'u');
    SourceExtension:=getvar (MainCfg, 'SourceExtension', 'dpr');
    CompilerCommand:=getvar (MainCfg, 'Compiler', 'dcc32.exe -cc');
    CompileSolution:=getbvar (MainCfg, 'CompileSolution', true);
    CompileAlways:=getbvar (MainCfg, 'CompileAlways', false);
    CheckerFile:=getvar (MainCfg, 'Checker', 'check.exe');
    CheckResult:=getbvar (MainCfg, 'CheckResult', true);
    CopyTestFiles:=getbvar (MainCfg, 'CopyTestFiles', true);
    ExitOnFail:=getbvar (MainCfg, 'ExitOnFail', false);
    Options:=getvar (MainCfg, 'Options', '');
    TestName:=getvar (MainCfg, 'TestName', '');
    RunLogName:=getvar (MainCfg, 'LogName', 'run.txt');
    TaskDirectory:=getvar (MainCfg, 'TaskDirectory', '');
    WaitOnExit:=getbvar (MainCfg, 'WaitOnExit', false);
  end else
  if TaskCfgName<>'task.cfg' then begin
    writeln (#7#13#10'Unable to find configuration file ', TaskCfgName, #13#10#7);
    myhalt (2);
  end;

  CheckResult:=true;
  RunLogName := 'run.txt';
  // Удаляем старый лог-файл
  DeleteFile(PChar(RunLogName));

  WriteLogEmpty;
  WriteOnlyLog ('Subj: Проверка работ в Заочной Школе Современного Программирования');
  WriteLogEmpty;
  WriteOnlyLog ('Здравствуйте, !');
  WriteLogEmpty;
  WriteOnlyLog ('Ваша работа проверена! (Занятие )');
  WriteLogEmpty;
  WriteOnlyLog ('Оценка: _Отлично,Хорошо,Зачёт_');
  WriteLogEmpty;
  WriteOnlyLog ('Результаты ручной проверки:');
  WriteLogEmpty;
  WriteOnlyLog (' Задача ?.? - Комментарии проверяющего');
  WriteLogEmpty;
  WriteOnlyLog ('Результат работы автоматической тестирующей системы:');
  WriteLogEmpty;

  if FindFirst('USERS\*.*',faAnyFile,sr) = 0 then begin
    repeat
      if (sr.Attr and faDirectory) = 0 then begin
      CompileSolution := true;
      SourceExtension := StrLower(PChar(ExtractFileExt(sr.Name)));
      Delete(SourceExtension,1,1); // Удаляем точку вначале
      if SourceExtension = 'pas' then
        CompilerCommand := 'dcc32.exe -cc'
      else if SourceExtension = 'dpr' then CompilerCommand := 'dcc32.exe -cc'
      else if SourceExtension = 'exe' then begin
        CompilerCommand := '';
        CompileSolution := false;
      end else continue;
      //
      TaskID := Copy(sr.Name,1,4);
      ProgramName     := 'USERS\'+TaskID;
      TaskDirectory := 'TESTS\'+TaskID+'\';
      InputFile:= 'in.txt';
      OutputFile:= 'out.txt';
      CheckerFile:= 'check.exe';
      WriteOnlyLog ('--=== Тестирование:  ID задачи - '+TaskID+' ===--');
      WriteOnlyLog ('Найден файл: '+sr.Name);
      // Ищем файл настроек для данного решения
      SolutionCfgFileName := 'USERS\'+TaskID+'.cfg';
      if FileExists(SolutionCfgFileName) then begin
        AssignFile(T,SolutionCfgFileName); Reset(T);
        Readln(T,InputFile);
        Readln(T,OutputFile);
        if ((Length(InputFile)=0) or (Length(OutputFile)=0)) then begin
          writeln('В файле: "'+SolutionCfgFileName+'" должны быть две строки.');
          writeln('Первая - имя входного файла для данного решения. Консоль = con.');
          writeln('Вторая - имя выходного файла для данного решения. Консоль = con.');
          myHalt(2);
        end else begin
          WriteOnlyLog ('Входной файл: '+InputFile+'   Выходной файл: '+OutputFile);
        end;
        CloseFile(T);
      end;
      WriteLogEmpty;

  {---------------------------}

  parseall;

  if TaskDirectory<>'' then TaskDirectory:=IncludeTrailingPathDelimiter (TaskDirectory);

  if _TimeLimit<=60 then _TimeLimit:=_TimeLimit*1000;
  if _MemoryLimit<=512 then _MemoryLimit:=_MemoryLimit*1024;

  if _TimeLimit<=0 then _TimeLimit:=1000;
  if _MemoryLimit<=0 then _MemoryLimit:=100000000;

  SetThreadPriority (GetCurrentThread, THREAD_PRIORITY_HIGHEST);

  if CompileSolution then begin
    ModuleName:=copy (ProgramName, 1, length (ProgramName)-length (ExtractFileExt (ProgramName)));
    sourcemod:=FTime (ModuleName+'.'+SourceExtension);
    modulemod:=FTime (ModuleName+'.exe');
    if sourcemod=0 then begin
      if modulemod=0 then begin logstring ('Unable to find source file %s - terminating',
                                           [ModuleName+'.'+SourceExtension]);
                                myhalt (1);
                          end;
    end else begin
      if CompileAlways or (modulemod=0) or (sourcemod>modulemod) then begin
        Extended_Delete (ModuleName+'.exe');
        GetDir (0, CurrentPath);
        CompRes:=ExecuteCompiler (CompilerCommand, CurrentPath, '',
                                  ModuleName+'.'+SourceExtension,
                                  EXEC_FLAG_UTILITY or EXEC_FLAG_NEW_CONSOLE,
                                  ResCode, OutputHandle);

        case CompRes of
          EXEC_ABORT:begin writelog ('Compilation aborted???'); myhalt (1) end;
          EXEC_FAIL:begin writelog ('Unable to invoke compiler'); myhalt (1) end;
          EXEC_OK: begin
            modulemod:=FTime (ModuleName+'.exe');
            if (not FileExists (ModuleName+'.exe')) or (modulemod<sourcemod) then begin
              writelog ('Compilation Error');
              UtilityOutput:=ProcessUtilityOutput (OutputHandle);
              writeln (UtilityOutput);
              writeonlylog('Compiler output:'+#13#10+UtilityOutput);
              myhalt (1);
            end else begin
              writelog ('Executable file successfully recompiled');
              UtilityOutput:=ProcessUtilityOutput (OutputHandle);
              writeonlylog('Compiler output:'+#13#10+UtilityOutput);
            end;
          end;
          else begin
            writelog ('Unknown result code returned during compilation'); myhalt (1)
          end;
        end;

      end;
    end;
  end;

  if not copytestfiles then TestName:=InputFile;

  if TestName='' then begin
    MaxTimeUsed:=0;
    MaxMemoryUsed:=0;
    LogString ('Тестирование %s, in=%s, out=%s, ext=%s, tl=%d, ml=%d',
               [programname, inputfile, outputfile, resultextension, _timelimit,
               _memorylimit]);
    count:=0;
    for i:=0 to 99 do begin
      str (i, s); if i<10 then s:='0'+s;
      if FileExists (TaskDirectory+s) then begin
        if testescape then begin
          WriteLog ('*** ESCAPE PRESSED ON KEYBOARD - EXECUTION ABORTED ***');
          break;
        end;
        if not CheckerOutputPreviouslyDisplayed then WriteLogEmpty;
        OnlyLogString ('Запуск на тесте %s', [s]);
        write (format ('Запуск на тесте %s - ', [s]));
        tmp:=TryTest (s, CurTimeUsed, CurMemoryUsed);
        if CurTimeUsed>MaxTimeUsed then MaxTimeUsed:=CurTimeUsed;
        if CurMemoryUsed>MaxMemoryUsed then MaxMemoryUsed:=CurMemoryUsed;
        inc (count);
        if not tmp and ExitOnFail then break;
      end;
    end;
    if count=0 then Writelog ('Тесты не найдены') else begin
      if not CheckerOutputPreviouslyDisplayed then WriteLogEmpty;
      WriteLogEmpty;
      LogString ('Максимальное время работы для всех тестов: %.5f ms', [MaxTimeUsed/10000]);
      LogString ('Максимальное использование памяти для всех тестов: %u Kb', [MaxMemoryUsed div 1024]);
    end;
  end else begin
    LogString ('Тестирование %s, in=%s, out=%s, ext=%s, tl=%d, ml=%d on %s',
               [programname, inputfile, outputfile, resultextension, _timelimit,
               _memorylimit, TestName]);
    TryTest (TestName, MaxTimeUsed, MaxMemoryUsed);
    WriteLogEmpty;
    LogString ('Время работы: %.5f ms', [MaxTimeUsed/10000]);
    LogString ('Максимальное использование памяти: %u Kb', [MaxMemoryUsed div 1024]);
  end;

  WriteLogEmpty;

  {---------------------------------------}
    end;
    until FindNext(sr) <> 0;
    sysutils.FindClose(sr);

  end;

  if FindFirst('*.u',faAnyFile,sr) = 0 then begin
    repeat
      DeleteFile(PChar(sr.Name));
    until FindNext(sr) <> 0;
    sysutils.FindClose(sr);
  end;
  DeleteFile(PChar(InputFile));
  DeleteFile(PChar(OutputFile));

  myhalt (0);
end.