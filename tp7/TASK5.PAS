Uses TaskUnit;

{ ---=== �������� ��६���� ===--- }
 Var M : Array [1..1000] of TPoint;
     _Type,SortType : Word;
     A : TLine;

{ ---=== ���� ��室��� ������ ===--- }
 Procedure InputData;
   Var I:Word; MNum:Word;
   Begin
     Assign(Input,'INPUT.TXT');
     Reset(Input);
    { ����� A }
     Read(A.A); Read(A.B); Read(A.C);
    { ���� }
     Read(MNum);
     For I:=1 to MNum do
       Begin Read(M[I].X); Read(M[I].Y); End;
     InitLenArray(MNum);
    { ��� ������� }
     ReadCountLenTaskType(SortType,_Type,B,C);
     Close(Input);
   End;

{ ---=== ������ ����ﭨ� ===--- }
 Procedure CountLen;
   Var I:Word;
   Begin
     For I:=1 to LenNum do
       LenArray^[I].Len := LineToPoint(A,M[I]);
   End;

{ ---=== �뢮� ������ ===--- }
 Procedure OutputData;
   Var Temp:Word;
   Begin
     Assign(Output,'OUTPUT.TXT');
     Rewrite(Output);
     Case SortType of
       1: { �����⠭�� ����ﭨ� }
         Repeat
           Temp:=GetMin;
           If Temp<>0 then
             With M[Temp] do
               Begin
                 Writeln('(',X:0:7,',',Y:0:7,')');
                 LenArray^[Temp].Present:=False;
               End;
         Until Temp = 0;
       2: { ��뢠��� ����ﭨ� }
         Repeat
           Temp:=GetMax;
           If Temp<>0 then
             With M[Temp] do
               Begin
                 Writeln('(',X:0:7,',',Y:0:7,')');
                 LenArray^[Temp].Present:=False;
               End;
         Until Temp = 0;
     End;
     Close(Output);
   End;

{ ---=== �᭮���� �ணࠬ�� ===--- }
Begin
  InputData;
  CountLen;
  Work(_Type);
  OutputData;
  DoneLenArray;
End.
{
INPUT.TXT
0 1 1
2
1 1
2 2
1
4 0
}