Unit Tools;

{$I-}

Interface

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                          � � � � � �                          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ ---=== �荐！� ===--- }
 Type
   TError = (erNo,erWrongAnswer,erTimeLimit,erRuntime);

{ ---=== ���ム �荐！� ===--- }
 Function ErrorNum( _Error_:TError ):Byte;

{ ---=== �荐！� �� ���ム� ===--- }
 Function ErrorSrc( _Error_:Word ):TError;

{ ---=== �オ痰 �荐！� ===--- }
 Function ErrorText( _Error_:TError ):String;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                           � � � � �                           � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ ---=== ����牀���┘ ����� ===--- }
 Procedure CopyFile( Source,Dest:String );

{ ---=== ����キ┘ ����� ===--- }
 Procedure DelFile( FileName:String );

{ ---=== ����キ┘ ぅ爛�� ��������� ===--- }
 Procedure DelTree( DirName:String );

{ ---=== 踸痺矚癶┘ �′オ�� ===--- }
 Function ObjectExist( S:String ):Boolean;

Implementation

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                          � � � � � �                          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

 Uses CRT,DOS;

{ ---=== ���ム �荐！� ===--- }
 Function ErrorNum( _Error_:TError ):Byte;
   Begin
     Case _Error_ of
       erNo           : ErrorNum:=0;
       erWrongAnswer  : ErrorNum:=1;
       erTimeLimit    : ErrorNum:=2;
       erRuntime      : ErrorNum:=3;
     End;
   End;

{ ---=== �荐！� �� ���ム� ===--- }
 Function ErrorSrc( _Error_:Word ):TError;
   Begin
     Case _Error_ of
       0: ErrorSrc:=erNo;
       1: ErrorSrc:=erWrongAnswer;
       2: ErrorSrc:=erTimeLimit;
       3: ErrorSrc:=erRuntime;
     End;
   End;

{ ---=== �オ痰 �荐！� ===--- }
 Function ErrorText( _Error_:TError ):String;
   Begin
     Case _Error_ of
       erNo          : ErrorText:='������ �爬�閧� !';
       erWrongAnswer : ErrorText:='�ク��※�讚覃 �癶モ';
       erTimeLimit   : ErrorText:='踳�謌キ┘ �━��� ∇ガキ�';
       erRuntime     : ErrorText:='�荐！� 〓 ∇ガ� �甎���キ�� (RuntimeError)';
     End;
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                           � � � � �                           � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ ---=== ����牀���┘ ����� ===--- }
 Procedure CopyFile( Source,Dest:String );
   Begin
     SwapVectors;
     Exec(FSearch('COMMAND.COM',GetEnv('PATH')),'/C COPY '+Source+' '+Dest);
     SwapVectors;
   End;

{ ---=== ����キ┘ ����� ===--- }
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

{ ---=== ����キ┘ ぅ爛�� ��������� ===--- }
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