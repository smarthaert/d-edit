Unit Filer;

Interface

Const Text1='Visit http://www.datacomm.ch/asuter';

Var FDone:Boolean;

Procedure FCopy(QFile,ZFile:String;OverWrite:Boolean);
Procedure FAdd(ZFile,QFile:String);
Procedure FErase(QFile:String);
Procedure FRename(QFile,ZFile:String;OverWrite:Boolean);
Function FileExist(Name:String):Boolean;
Function GetSufix(S:String):String;
Function GetPrefix(S:String):String;
Function GetProgDir:String;

Implementation

Procedure FCopy;

Var
   QF, ZF: File;
   NumRead, NumWritten: Word;
   Buf: Array[1..2048] Of Char;

Begin
     FDone:=False;
     If FileExist(QFile) Then
        Begin
             If (OverWrite=False) And
                FileExist(ZFile) Then Exit;
             Assign(QF, QFile);
             Reset(QF, 1);
             Assign(ZF, ZFile);
             Rewrite(ZF, 1);
             Repeat
                   BlockRead(QF, Buf, SizeOf(Buf), NumRead);
                   BlockWrite(ZF, Buf, NumRead, NumWritten);
             Until (NumRead = 0) or (NumWritten <> NumRead);
             Close(QF);
             Close(ZF);
             FDone:=True;
        End;
End;

Procedure FAdd;

Var
   QF, ZF: File;
   NumRead, NumWritten: Word;
   Buf: Array[1..2048] Of Char;

Begin
     FDone:=False;
     If FileExist(QFile) Then
        Begin
             Assign(ZF,ZFile);
             If FileExist(ZFile) Then Begin ReSet(ZF,1); Seek(ZF,FileSize(ZF)); End
                                 Else ReWrite(ZF,1);
             Assign(QF, QFile);
             Reset(QF, 1);
             Repeat
                   BlockRead(QF, Buf, SizeOf(Buf), NumRead);
                   BlockWrite(ZF, Buf, NumRead, NumWritten);
             Until (NumRead = 0) or (NumWritten <> NumRead);
             Close(QF);
             Close(ZF);
             FDone:=True;
        End;
End;

Procedure FErase;

Var F:File;

Begin
     Assign(F,QFile);
     {$I-}
     Erase(F);
     {$I+}
     If IOResult=0 Then FDone:=True
                   Else FDone:=False;
End;

Procedure FRename(QFile,ZFile:String;OverWrite:Boolean);

Var F:File;

Begin
     FDone:=False;
     If FileExist(QFile) Then
        Begin
             If (OverWrite=False) And
                FileExist(ZFile) Then Exit;
             If FileExist(ZFile) Then
                Begin
                     Assign(F,ZFile);
                     Erase(F);
                End;
             Assign(F,QFile);
             Rename(F,ZFile);
             FDone:=True;
        End;
End;

Function FileExist;

Var F:File;

Begin
     Assign(F,Name);
     {$I-}
     Reset(F);
     {$I+}
     If IOResult=0 Then
        Begin
             FileExist:=True;
             Close(F);
        End
     Else FileExist:=False;
End;

Function GetSufix;

Var ss:String;

Begin
     ss:=S;
     Delete(ss,1,Pos('.',ss));
     If ss=S Then ss:='';
     GetSufix:=ss;
End;

Function GetPrefix;

Var ss:String;

Begin
     ss:=S;
     Delete(ss,Pos('.',ss),Length(ss)-Pos('.',ss)+1);
     GetPrefix:=ss;
End;

Function GetProgDir;

Var S:String;

Begin
     S:=ParamStr(0);
     Repeat
           Delete(S,Length(S),1);
     Until S[Length(S)]='\';
     GetProgDir:=S;
End;

Begin
     WriteLn(Text1);
End.