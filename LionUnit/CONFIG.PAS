Unit Config;

Interface

{ Функция Установки Переменных }
Type
  T_Var_Set_Function=
    Function(Var_Name,Value:String):Boolean;

{ Файл Конфигурации }
Function Config_File(File_Name:String;Var_Set:T_Var_Set_Function):Boolean;

Implementation

Uses DOS,TextMode;

{$I-}

Function Config_File;
  Var
    T:Text;
    S:String;
    P:Byte;
Begin
   Config_File:=False;
   Assign(T,File_Name);
   Reset(T);
   If IOResult<>0 then Exit;
   Repeat
     Readln(T,S);
     S:=UpCaseString(DelSpaces(S));
     If (Length(S)>0) And Not (S[1] In [';','$','#','%']) then
       Begin
          P:=Pos('=',S);
          If P=0 then Exit;
          If Not Var_Set(Copy(S,1,P-1),Copy(S,P+1,Length(S)-P)) then Exit;
       End;
   Until EOF(T);
   Close(T);
   Config_File:=True;
End;

End.