Uses U_List;

Var Test,Cur:PStrTree;
Begin
  Writeln(MemAvail);
  Test:=nil;
  AddStrTree(Test,'��⠫��',nil,_StrTreeDir_);
  Cur:=Test;
  StrTreeSubDir(Cur,'��⠫��');
  AddStrTree(Cur^.SubDir,'�����',Cur,_StrTreeItem_);
  AddStrTree(Test,'������ 1',nil,_StrTreeItem_);
  AddStrTree(Test,'������ 2',nil,_StrTreeItem_);
  DelStrTree(Test,'������ 2');
  ForEachStrTree(Test,WriteOneStr);
  DisposeStrTree(Test);
  Writeln(MemAvail);
End.