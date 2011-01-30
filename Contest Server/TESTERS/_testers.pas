{ ����� ��� �ணࠬ� �஢�ન �⢥⮢ }

Unit _Testers;

{$I-}

Interface

 Const { ���� ��室� }
   cdAllOK = 0; { ����� ��������� � �� � ���浪� }
   cdPrErr = 1; { Presentation Error }
   cdWrAns = 2; { Wrong Answer }
   cdParam = 3; { �訡�� �� ����⨨ �室����/��室���� 䠩�� }

{ ����饭�� �� ��室� �� �ணࠬ�� }
 Messages : Array [0..3] of String =
  ( '����� ��������� � �� � ���浪�',
    'Presentation Error',
    'Wrong Answer',
    '�訡�� �� ����⨨ �室����/��室���� 䠩��');

 Var FI,F1,F2:Text; { �ࠢ������� 䠩�� }

{ --=== ����⨥ �ࠢ�������� 䠩��� ===-- }
 Procedure OpenFiles( Header:String );
{ --=== �����⨥ �ࠢ�������� 䠩��� ===-- }
 Procedure CloseFiles;
{ --=== ��室 �� �ணࠬ�� � ����� ������ Code ===-- }
 Procedure ExitProg( Code:Integer );
{ --=== �⥭�� �᫠ ⨯� LongInt ===-- }
 Function ReadLongInt( Var T:Text ):LongInt;

Implementation

{ --=== ��室 �� �ணࠬ�� � ����� ������ Code ===-- }
 Procedure ExitProg( Code:Integer );
   Begin
     Writeln(Messages[Code]);
     CloseFiles;
     Halt(Code);
   End;

{ --=== ����⨥ �ࠢ�������� 䠩��� ===-- }
 Procedure OpenFiles( Header:String );
   Begin
     If ParamCount = 3 then
       Begin
         Assign(FI,ParamStr(1));
         Assign(F1,ParamStr(2));
         Assign(F2,ParamStr(3));
         Reset(FI); If IOResult<>0 then ExitProg(cdParam);
         Reset(F1); If IOResult<>0 then ExitProg(cdParam);
         Reset(F2); If IOResult<>0 then ExitProg(cdParam);
       End
     Else
       Begin
         Writeln(Header+' <Input> <Standart Output> <User Output>');
         Halt(0);
       End;
   End;

{ --=== �����⨥ �ࠢ�������� 䠩��� ===-- }
 Procedure CloseFiles;
   Begin
     Close(FI);
     Close(F1);
     Close(F2);
   End;

{ --=== �⥭�� �᫠ ⨯� LongInt ===-- }
 Function ReadLongInt( Var T:Text ):LongInt;
   Var N:LongInt;
   Begin
     Read(T,N);
     If IOResult<>0 then ExitProg(cdPrErr);
     ReadLongInt:=N;
   End;

End.