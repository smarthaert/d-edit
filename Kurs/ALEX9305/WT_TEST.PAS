Uses WT_Lib;

{ ---=== ��������� �ணࠬ�� ===--- }
Var Test : TDictionary;
Begin
 { ������� ᫮���� }
  Test.New('TEST.DIC');
 { ������塞 � ���� ᫮�� }
  Test.Add('ABCDEF');
  Test.Add('ABD');
 { H�室�� �㦭�� ᫮�� }
  Writeln(Test.Find('ABC'));
 { ����塞 ���㦭�� ᫮�� ;) }
{  Test.Del('ABCDEF');}
 { ���࠭塞 ��������� � ����뢠�� 䠩� }
  Test.Done;
End.