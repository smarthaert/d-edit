{ �� �� �����稫 � �� }

{$I-}
Uses Dos;

Const Max=30;{���ᨬ��쭮� ���-�� �����}

Type
  TString=Object
    A,B,C:Real;
  End;

Var
  Input:Text;
(*
  ��ଠ� 䠩��:
  K - ����� �����
  N - ���-�� �����
  A1 \
  B1  \
  C1    \
  A2     \
  B2       - ᠬ� ����
  C2     /
  ...   /
  AN   /
  BN  /
  CN /
*)
  Data:Array[1..Max] of TString;
  S:String;
  K,N:Word;
  Checked:Boolean; { �஢��﫮�� �� ࠭�� }

Procedure Ans(Var I:Word);
  Begin
    Writeln(Output,Data[I].A:3:3);
    Writeln(Output,Data[I].B:3:3);
    Writeln(Output,Data[I].C:3:3);
  End;

Function CheckXParallel(Start:Word):Word;
  Var I:Word;
  Begin
    For I:=Start to N do
      If Data[I].A=0 then CheckXParallel:=I Else CheckXParallel:=0;
  End;

Function CheckYParallel(Start:Word):Word;
  Var I:Word;
  Begin
    For I:=Start to N do
      If Data[I].B=0 then CheckYParallel:=I Else CheckYParallel:=0;
  End;


Var
  I,J:Word;    { Temporary }
  TmpAns:Word; { Temporary }

Begin
  { ����㧪� ���. ������ }
  Assign(Input,'Input.txt');
  Reset(Input);
    Readln(Input,K);
    Readln(Input,N);
    For I:=1 to N do
      Begin
        Readln(Input,Data[I].A);
        Readln(Input,Data[I].B);
        Readln(Input,Data[I].C);
      End;
    If IOResult<>0 then
      Begin
        Writeln('�訡�� � Input.txt');
        Halt(1);
      End;
  Close(Input);
  Assign(Output,'Output.txt');
  Rewrite(Output);
  Case K of
    1 : Begin
          For I:=1 to N do If Data[I].C=0 then Ans(I);
          Exit;
        End;
    2 : Begin
          For I:=1 to N do If Data[I].A=0 then Ans(I);
          Exit;
        End;
    3 : Begin
          For I:=1 to N do If Data[I].B=0 then Ans(I);
          Exit;
        End;
    4 : Begin
          For I:=1 to N do
            Begin
              Checked:=False;
              For J:=I downto 1 do If Data[J].A=Data[I].A then Checked:=True;
              If Not(Checked) then For J:=I to N do
                Begin
                  If Data[I].A=0 then
                    Begin
                      TmpAns:=CheckXParallel(J);
                      If TmpAns<>0 then Ans(TmpAns);
                    End;
                End;
            End;
            Exit;
        End;
  End;
  Close(Output);
End.

{
INPUT.TXT
2
3
0
32
0
0
2
2
}