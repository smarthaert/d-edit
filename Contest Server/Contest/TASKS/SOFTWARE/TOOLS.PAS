{ ษออออออออออออออออออออออออออออออออออออออออออออป }
{ บ  ---=== Super Contest System ver 1 ===---  บ }
{ บ      (c) Roman International Software      บ }
{ บ            Build 002 [18.11.99]            บ }
{ ศออออออออออออออออออออออออออออออออออออออออออออผ }
Unit Tools;

{$I-}

Interface

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ‘ ’ €  ’                        ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Const
  { ” ฉซ - ง ฏเฎแ ญ  เฅฃจแโเ ๆจ๎ }
   RegisterFile = 'REGISTER.TXT';
  { ” ฉซ - ฎโขฅโ แฅเขฅเ  ญ  ง ฏเฎแ }
   RegisterBackFile = 'REGBACK.TXT';
  { ” ฉซ - ชฎฌ ญค  ง ขฅเ่ฅญจ๏ เ กฎโ๋ }
   UnregisterFile = 'UNREG.TXT';
  { ” ฉซ - แโ โใแ แใค์จ }
   StatusFile = 'STATUS.TXT';
  { ” ฉซ - ง ค ญจฅ ฎโ แฅเขฅเ  }
   ServerFile = 'TASK.TXT';
  { ” ฉซ - ชฎฏจ๏ ฏเฎฃเ ฌฌ๋ คซ๏ โฅแโจเฎข ญจ๏ }
   SourceTaskFile = 'TESTPROG.TXT';
   WorkTaskFile = 'TESTPROG.EXE';
  { ” ฉซ - เฅงใซ์โ โ๋ โฅแโจเฎข ญจ๏ }
   ResultsFile = 'RESULTS.TXT';
  { เฅฌฅญญ๋ฉ ช โ ซฎฃ แใค์จ }
   TempDir = 'Temp';
  { ‘จแโฅฌญ ๏ ง คฅเฆช  }
   SystemDelay = 100;
  { ’ฅแโฎข ง  ฏฎซญฎแโ์๎ เฅ้ฅญญใ๎ ง ค ็ใ }
   BonusTests = 20;
  { “โจซจโ  ฏเฎขฅเชจ ญ  ญฅคฎฏใแโจฌ๋ฅ จญแโเใชๆจจ }
   CheckUtil = 'CHECK.EXE';
  { “โจซจโ  ง ฏใแช  ฏเฎฃเ ฌฌ๋ }
   ExecUtil = 'TIMER.EXE';

{ ---=== ใโจ ช ช โ ซฎฃ ฌ ===--- }
{ UsersDir - เจฅฌญ๋ฉ ช โ ซฎฃ ฏฎซ์งฎข โฅซฅฉ }
{ JudgesDir -  โ ซฎฃ ฎก้ฅญจ๏ แ ฏฎซ์งฎข โฅซ๏ฌจ }
{ WorkDir -  กฎ็จฉ ช โ ซฎฃ แจแโฅฌ๋ }
{ TasksDir -  โ ซฎฃ จแๅฎคญ๋ๅ ค ญญ๋ๅ }
{ InfoDir -  โ ซฎฃ จญไฎเฌ ๆจจ }
 Const UsersDir    : String = '\DENIS\CONTEST\USERS.!!!';
       JudgesDir   : String = '\DENIS\CONTEST\JUDGES.!!!';
       WorkDir     : String = '\DENIS\CONTEST\WORK.!!!';
       TasksDir    : String = '\DENIS\CONTEST\TASKS';
       InfoDir     : String = '\DENIS\CONTEST\INFO.!!!';
       SoftwareDir : String = '';

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                               €                          ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ่จกช  ===--- }
 Type
   TError = (NoError,CompilationError,WrongAnswer,TimeLimit,RuntimeError,
             IllegalInstructions);

{ ---=== ฅงใซ์โ โ ===--- }
 Var Result : TError;

{ ---=== ฎฌฅเ ฎ่จกชจ ===--- }
 Function ErrorNum( _Error_:TError ):Byte;

{ ---=== ่จกช  ฏฎ ญฎฌฅเใ ===--- }
 Function ErrorSrc( _Error_:Word ):TError;

{ ---=== ’ฅชแโ ฎ่จกชจ ===--- }
 Function ErrorText( _Error_:TError ):String;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ‘ ’                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฅเฅขฎค แโเฎชจ ข ็จแซฎ ===--- }
 Function StrNum( S:String ):LongInt;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ ===--- }
 Function NumStr( N:LongInt ):String;

{ ---=== ฎก ขซฅญจฅ แจฌขฎซฎข แง คจ ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ คฎฏฎซญฅญญใ๎ แจฌขฎซ ฌจ แฏเ ข  ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                           ” €                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฎฏจเฎข ญจฅ ไ ฉซ  ===--- }
 Procedure CopyFile( Sourse,Dest:String );

{ ---=== “ค ซฅญจฅ ไ ฉซ  ===--- }
 Procedure DelFile( FileName:String );

{ ---=== “ค ซฅญจฅ คฅเฅข  ช โ ซฎฃฎข ===--- }
 Procedure DelTree( DirName:String );

{ ---=== ‘เ ขญฅญจฅ ไ ฉซฎข ===--- }
 Procedure CompareFiles( FileName1,FileName2:String );

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                             €                             ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---===  เจแฎข โ์ เ ฌชใ ===--- }
 Procedure DrawBorder( X1,Y1,X2,Y2,Color:Byte );

Implementation

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                               €                          ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Uses CRT,DOS;

{ ---=== ฎฌฅเ ฎ่จกชจ ===--- }
 Function ErrorNum( _Error_:TError ):Byte;
   Begin
     Case _Error_ of
       NoError             : ErrorNum:=0;
       CompilationError    : ErrorNum:=1;
       WrongAnswer         : ErrorNum:=2;
       TimeLimit           : ErrorNum:=3;
       RuntimeError        : ErrorNum:=4;
       IllegalInstructions : ErrorNum:=5;
     End;
   End;

{ ---=== ่จกช  ฏฎ ญฎฌฅเใ ===--- }
 Function ErrorSrc( _Error_:Word ):TError;
   Begin
     Case _Error_ of
       0: ErrorSrc:=NoError;
       1: ErrorSrc:=CompilationError;
       2: ErrorSrc:=WrongAnswer;
       3: ErrorSrc:=TimeLimit;
       4: ErrorSrc:=RuntimeError;
       5: ErrorSrc:=IllegalInstructions;
     End;
   End;

{ ---=== ’ฅชแโ ฎ่จกชจ ===--- }
 Function ErrorText( _Error_:TError ):String;
   Begin
     Case _Error_ of
       NoError             : ErrorText:='่จกฎช ญฅ ฎกญ เใฆฅญฎ';
       CompilationError    : ErrorText:='่จกช  ชฎฌฏจซ๏ๆจจ';
       WrongAnswer         : ErrorText:='ฅฏเ ขจซ์ญ๋ฉ ฎโขฅโ';
       TimeLimit           : ErrorText:='เฅข๋่ฅญจฅ ฏฅเคฅซ  ขเฅฌฅญจ';
       RuntimeError        : ErrorText:='่จกช  จแฏฎซญฅญจ๏';
       IllegalInstructions : ErrorText:='ฅคฎฏใโจฌ ๏ จญแโเใชๆจ๏';
     End;
   End;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ‘ ’                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฅเฅขฎค แโเฎชจ ข ็จแซฎ ===--- }
 Function StrNum( S:String ):LongInt;
   Var Error:Integer; Temp:LongInt;
   Begin
     Val(S,Temp,Error);
     If Error <> 0 then
       StrNum:=MaxLongInt
     Else
       StrNum:=Temp;
   End;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ ===--- }
 Function NumStr( N:LongInt ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     NumStr:=Temp;
   End;

{ ---=== ฎก ขซฅญจฅ แจฌขฎซฎข แง คจ ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Temp:=S;
     While Length(Temp) < Digits do Temp:=Temp+Symbol;
     AddSym:=Temp;
   End;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ คฎฏฎซญฅญญใ๎ แจฌขฎซ ฌจ แฏเ ข  ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                           ” €                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฎฏจเฎข ญจฅ ไ ฉซ  ===--- }
 Procedure CopyFile( Sourse,Dest:String );
   Var SF,DF:Text; Str:String;
   Begin
     Assign(SF,Sourse);
     Assign(DF,Dest);
     Reset(SF);
     If IOResult<>0 then Exit;
     Rewrite(DF);
     If IOResult<>0 then Exit;
     Repeat
       Readln(SF,Str);
       Writeln(DF,Str);
     Until EOF(SF);
     Close(SF);
     Close(DF);
   End;

{ ---=== “ค ซฅญจฅ ไ ฉซ  ===--- }
 Procedure DelFile( FileName:String );
   Var F:File; Attr:Word;
   Begin
     Assign(F,FileName);
     Reset(F);
     If IOResult<>0 then Exit;
     GetFAttr(F,Attr);
     SetFAttr(F,(Attr And (VolumeID+Directory+Archive)));
     Erase(F);
   End;

{ ---=== “ค ซฅญจฅ คฅเฅข  ช โ ซฎฃฎข ===--- }
 Procedure _DelTree_( DirName:String );
   Var DirInfo:SearchRec; F:File; Attr:Word;
   Begin
     ChDir(DirName);
     If IOResult <> 0 then Exit;
     FindFirst('*.*',AnyFile,DirInfo);
     While DosError = 0 do
       Begin
         If ((DirInfo.Name <> '.') And
             (DirInfo.Name <> '..')) then
           Begin
             Assign(F,DirInfo.Name);
             GetFAttr(F,Attr);
             SetFAttr(F,(Attr And (VolumeID+Directory+Archive)));
             If (Attr And Directory)<>0 then
               _DelTree_(DirInfo.Name)
             Else
               Erase(F);
           End;
         FindNext(DirInfo);
       End;
     ChDir('..');
     RmDir(DirName);
   End;

 Procedure DelTree( DirName:String );
   Var CurDir:String;
   Begin
     GetDir(0,CurDir);
     _DelTree_(DirName);
     ChDir(CurDir);
   End;

{ ---=== ‘เ ขญฅญจฅ ไ ฉซฎข ===--- }
 Procedure CompareFiles( FileName1,FileName2:String );
   Var T1,T2:Text; Str1,Str2:String;
   Begin
     Assign(T1,FileName1); Reset(T1);
     If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
     Assign(T2,FileName2); Reset(T2);
     If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
     Repeat
       Readln(T1,Str1);
       If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
       Readln(T2,Str2);
       If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
       If Str1<>Str2 then Begin Result:=WrongAnswer; Exit; End;
     Until EOF(T1);
     Close(T1); Close(T2);
   End;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                              €                            ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---===  เจแฎข โ์ เ ฌชใ ===--- }
 Procedure DrawBorder( X1,Y1,X2,Y2,Color:Byte );
   Var I:Byte;
   Begin
     TextColor(Color);
     For I:=(X1+1) to (X2-1) do
       Begin
         GotoXY(I,Y1); Write('อ');
         GotoXY(I,Y2); Write('อ');
       End;
     For I:=(Y1+1) to (Y2)-1 do
       Begin
         GotoXY(X1,I); Write('บ');
         GotoXY(X2,I); Write('บ');
       End;
     GotoXY(X1,Y1); Write('ษ');
     GotoXY(X1,Y2); Write('ศ');
     GotoXY(X2,Y1); Write('ป');
     GotoXY(X2,Y2); Write('ผ');
   End;

End.