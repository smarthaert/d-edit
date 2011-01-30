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
  { ‘จแโฅฌญ ๏ ง คฅเฆช  }
   SystemDelay = 100;
  { ’ฅแโฎข ง  ฏฎซญฎแโ์๎ เฅ้ฅญญใ๎ ง ค ็ใ }
   BonusTests = 20;
  { “โจซจโ  ฏเฎขฅเชจ ญ  ญฅคฎฏใแโจฌ๋ฅ จญแโเใชๆจจ }
   CheckUtil = 'CHECK.EXE';
  { “โจซจโ  ง ฏใแช  ฏเฎฃเ ฌฌ๋ }
   ExecUtil = 'TIMER.EXE';

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

 Procedure CopyBinary( Source,Dest:String );

{ ---=== “ค ซฅญจฅ ไ ฉซ  ===--- }
 Procedure DelFile( FileName:String );

{ ---=== “ค ซฅญจฅ คฅเฅข  ช โ ซฎฃฎข ===--- }
 Procedure DelTree( DirName:String );

{ ---=== ‘เ ขญฅญจฅ ไ ฉซฎข ===--- }
 Procedure CompareFiles( FileName1,FileName2:String );

{ ---=== เจแใโแโขจฅ ฎก์ฅชโ  ===--- }
 Function ObjectExist( S:String ):Boolean;

{ ---=== ‘ฎงค ญจฅ ช โ ซฎฃ  ===--- }
 Procedure MakeDir( S:String );

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

 Procedure CopyBinary( Source,Dest:String );
   Begin
     SwapVectors;
     Exec(FSearch('COMMAND.COM',GetEnv('PATH')),'/C COPY '+Source+' '+Dest);
     SwapVectors;
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

 Function ObjectExist( S:String ):Boolean;
   Var DirInfo:SearchRec;
   Begin
     FindFirst(S,AnyFile,DirInfo);
     ObjectExist := (DosError = 0);
   End;

 Procedure MakeDir( S:String );
   Var I:Byte; T,TS:String; CurDir:String;
   Begin
     GetDir(0,CurDir);
     T:=S;
     If T[Length(T)]<>'\' then T:=T+'\';
     If Pos(':',T)<>0 then
       Begin
         ChDir(Copy(T,1,3));
         T:=Copy(T,4,Length(S)-2);
       End;
     While T<>'' do
       Begin
         I:=Pos('\',T);
         TS:=Copy(T,1,I-1);
         If Not ObjectExist(TS) then MkDir(TS);
         ChDir(TS);
         T:=Copy(T,I+1,Length(T)-I+1);
       End;
     ChDir(CurDir);
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