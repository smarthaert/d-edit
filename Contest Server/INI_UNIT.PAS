{ ���������������������������������������������ͻ }
{ �  ---=== ��쥪� - 䠩� ���樠����樨 ===---  � }
{ ���������������������������������������������ͼ }
Unit INI_UNIT;

Interface

 Type
   TINIFile = Object
     Constructor Run( INIFileName:String ); { ��ࠡ�⪠ 䠩�� ���樠����樨 }
     Procedure SetVar( Name,Value:String ); Virtual; 
   End;

Implementation

 Uses IOTools;

{ --=== �������� �஡���� � ��砫� ��ப� � � ���� ===-- }
 Function DelSpaces( S:String ):String;
   Begin
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     While S[1]=' ' do S:=Copy(S,2,Length(S)-1);
     DelSpaces := S;
   End;

{ --=== ��ॢ�� ��ப� � ���孨� ॣ���� ===-- }
 Function UpCaseStr( S:String ):String;
   Var I:Byte;
   Begin
     For I:=1 to Length(S) do S[I]:=UpCase(S[I]);
     UpCaseStr:=S;
   End;

 Constructor TINIFile.Run( INIFileName:String );
   Var T:Text; S:String; P:Byte;
   Begin
     OpenTextForRead(T,INIFileName);
     Repeat
       Readln(T,S);
       S:=UpCaseStr(DelSpaces(S));
       If ((S<>'') And (S[1]<>'#')) then
         Begin
           P:=Pos('=',S);
           SetVar( DelSpaces(Copy(S,1,P-1)),
                   DelSpaces(Copy(S,P+1,Length(S)-P)) );
         End;
     Until EOF(T);
     Close(T);
   End;

 Procedure TINIFile.SetVar( Name,Value:String ); Begin End;

End.