Unit Tools;

{$I-}

Interface

{ �������������������������������������������������������������������ͻ }
{ � �                          � � � � � �                          � � }
{ �������������������������������������������������������������������ͼ }

{ ---=== �訡�� ===--- }
 Type
   TError = (erNo,erWrongAnswer,erTimeLimit,erRuntime);

{ ---=== ����� �訡�� ===--- }
 Function ErrorNum( _Error_:TError ):Byte;

{ ---=== �訡�� �� ������ ===--- }
 Function ErrorSrc( _Error_:Word ):TError;

{ ---=== ����� �訡�� ===--- }
 Function ErrorText( _Error_:TError ):String;

{ �������������������������������������������������������������������ͻ }
{ � �                           � � � � �                           � � }
{ �������������������������������������������������������������������ͼ }

{ ---=== ����஢���� 䠩�� ===--- }
 Procedure CopyFile( Source,Dest:String );

{ ---=== �������� 䠩�� ===--- }
 Procedure DelFile( FileName:String );

{ ---=== �������� ��ॢ� ��⠫���� ===--- }
 Procedure DelTree( DirName:String );

{ ---=== ������⢨� ��쥪� ===--- }
 Function ObjectExist( S:String ):Boolean;

Implementation

{ �������������������������������������������������������������������ͻ }
{ � �                          � � � � � �                          � � }
{ �������������������������������������������������������������������ͼ }

 Uses CRT,DOS;

{ ---=== ����� �訡�� ===--- }
 Function ErrorNum( _Error_:TError ):Byte;
   Begin
     Case _Error_ of
       erNo           : ErrorNum:=0;
       erWrongAnswer  : ErrorNum:=1;
       erTimeLimit    : ErrorNum:=2;
       erRuntime      : ErrorNum:=3;
     End;
   End;

{ ---=== �訡�� �� ������ ===--- }
 Function ErrorSrc( _Error_:Word ):TError;
   Begin
     Case _Error_ of
       0: ErrorSrc:=erNo;
       1: ErrorSrc:=erWrongAnswer;
       2: ErrorSrc:=erTimeLimit;
       3: ErrorSrc:=erRuntime;
     End;
   End;

{ ---=== ����� �訡�� ===--- }
 Function ErrorText( _Error_:TError ):String;
   Begin
     Case _Error_ of
       erNo          : ErrorText:='����� �ਭ�� !';
       erWrongAnswer : ErrorText:='���ࠢ���� �⢥�';
       erTimeLimit   : ErrorText:='�ॢ�襭�� ����� �६���';
       erRuntime     : ErrorText:='�訡�� �� �६� �ᯮ������ (RuntimeError)';
     End;
   End;

{ �������������������������������������������������������������������ͻ }
{ � �                           � � � � �                           � � }
{ �������������������������������������������������������������������ͼ }

{ ---=== ����஢���� 䠩�� ===--- }
 Procedure CopyFile( Source,Dest:String );
   Begin
     SwapVectors;
     Exec(FSearch('COMMAND.COM',GetEnv('PATH')),'/C COPY '+Source+' '+Dest);
     SwapVectors;
   End;

{ ---=== �������� 䠩�� ===--- }
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

{ ---=== �������� ��ॢ� ��⠫���� ===--- }
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