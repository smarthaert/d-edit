Uses U_List;

Var Test,Cur:PStrTree;
Begin
  Writeln(MemAvail);
  Test:=nil;
  AddStrTree(Test,'Каталог',nil,_StrTreeDir_);
  Cur:=Test;
  StrTreeSubDir(Cur,'Каталог');
  AddStrTree(Cur^.SubDir,'Денис',Cur,_StrTreeItem_);
  AddStrTree(Test,'Запись 1',nil,_StrTreeItem_);
  AddStrTree(Test,'Запись 2',nil,_StrTreeItem_);
  DelStrTree(Test,'Запись 2');
  ForEachStrTree(Test,WriteOneStr);
  DisposeStrTree(Test);
  Writeln(MemAvail);
End.