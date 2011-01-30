Unit Tools;

{$I-}

Interface

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                               €                          ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ่จกช  ===--- }
 Type
   TError = (erNo,erWrongAnswer,erTimeLimit,erRuntime);

{ ---=== ฎฌฅเ ฎ่จกชจ ===--- }
 Function ErrorNum( _Error_:TError ):Byte;

{ ---=== ่จกช  ฏฎ ญฎฌฅเใ ===--- }
 Function ErrorSrc( _Error_:Word ):TError;

{ ---=== ’ฅชแโ ฎ่จกชจ ===--- }
 Function ErrorText( _Error_:TError ):String;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                           ” €                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฎฏจเฎข ญจฅ ไ ฉซ  ===--- }
 Procedure CopyFile( Source,Dest:String );

{ ---=== “ค ซฅญจฅ ไ ฉซ  ===--- }
 Procedure DelFile( FileName:String );

{ ---=== “ค ซฅญจฅ คฅเฅข  ช โ ซฎฃฎข ===--- }
 Procedure DelTree( DirName:String );

{ ---=== เจแใโแโขจฅ ฎก์ฅชโ  ===--- }
 Function ObjectExist( S:String ):Boolean;

Implementation

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                               €                          ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Uses CRT,DOS;

{ ---=== ฎฌฅเ ฎ่จกชจ ===--- }
 Function ErrorNum( _Error_:TError ):Byte;
   Begin
     Case _Error_ of
       erNo           : ErrorNum:=0;
       erWrongAnswer  : ErrorNum:=1;
       erTimeLimit    : ErrorNum:=2;
       erRuntime      : ErrorNum:=3;
     End;
   End;

{ ---=== ่จกช  ฏฎ ญฎฌฅเใ ===--- }
 Function ErrorSrc( _Error_:Word ):TError;
   Begin
     Case _Error_ of
       0: ErrorSrc:=erNo;
       1: ErrorSrc:=erWrongAnswer;
       2: ErrorSrc:=erTimeLimit;
       3: ErrorSrc:=erRuntime;
     End;
   End;

{ ---=== ’ฅชแโ ฎ่จกชจ ===--- }
 Function ErrorText( _Error_:TError ):String;
   Begin
     Case _Error_ of
       erNo          : ErrorText:=' ค ็  ฏเจญ๏โ  !';
       erWrongAnswer : ErrorText:='ฅฏเ ขจซ์ญ๋ฉ ฎโขฅโ';
       erTimeLimit   : ErrorText:='เฅข๋่ฅญจฅ ซจฌจโ  ขเฅฌฅญจ';
       erRuntime     : ErrorText:='่จกช  ขฎ ขเฅฌ๏ จแฏฎซญฅญจ๏ (RuntimeError)';
     End;
   End;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                           ” €                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฎฏจเฎข ญจฅ ไ ฉซ  ===--- }
 Procedure CopyFile( Source,Dest:String );
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

 Function ObjectExist( S:String ):Boolean;
   Var DirInfo:SearchRec;
   Begin
     FindFirst(S,AnyFile,DirInfo);
     ObjectExist := (DosError = 0);
   End;

End.