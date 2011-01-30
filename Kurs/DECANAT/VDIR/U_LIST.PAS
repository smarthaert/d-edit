{ ╔═╤════════════════════════╤═╗ }
{ ║ │ Списки и Деревья Строк │ ║ }
{ ╚═╧════════════════════════╧═╝ }
Unit U_List;

Interface

 { === Строка === }
  Type TString = String[78];
 { === Список строк === }
  Type
    PStrList = ^TStrList;
    TStrList = Record
      Data : TString;
      Next : PStrList;
    End;
 { === Процедура обработки строки === }
  TStrProc = Procedure ( S:TString );

 { === Удаление списка строк === }
  Procedure DisposeStrList( Var List:PStrList );
 { === Добавление элемента в список строк === }
  Procedure AddStrList( Var List:PStrList; Elem:TString );
 { === Удаление элемента из списока строк === }
  Procedure DelStrList( Var List:PStrList; Elem:TString );
 { === Для каждого элемента списка строк === }
  Procedure ForEachStrList( List:PStrList; Proc:TStrProc );
 { === Вывод строки на стандартное устройство вывода === }
  Procedure WriteOneStr( S:TString ); Far;

 { === Дерево строк === }
  Type
    TStrTreeFlag = (_StrTreeDir_,_StrTreeItem_);
    PStrTree = ^TStrTree;
    TStrTree = Record
      Data   : TString;
      Flag   : TStrTreeFlag;
      Next   : PStrTree;
      UpDir  : PStrTree;
      SubDir : PStrTree;
    End;

 { === Удаление дерева строк === }
  Procedure DisposeStrTree( Var Tree:PStrTree );
 { === Добавление элемента в дерево строк (Из каталога Tree) === }
  Procedure AddStrTree( Var Tree:PStrTree; Elem:TString;
                         _UpDir_:PStrTree; DirFlag:TStrTreeFlag );
 { === Удаление элемента из дерева строк === }
  Procedure DelStrTree( Var Tree:PStrTree; Elem:TString );
 { === Для каждого элемента дерева строк === }
  Procedure ForEachStrTree( Tree:PStrTree; Proc:TStrProc );
 { === Переход в надкаталог === }
  Procedure StrTreeUpDir( Var Tree:PStrTree );
 { === Переход в подкаталог === }
  Procedure StrTreeSubDir( Var Tree:PStrTree; Elem:TString );

Implementation

 { === Удаление списка строк === }
  Procedure DisposeStrList( Var List:PStrList );
    Var Temp:PStrList;
    Begin
      While List<>nil do
        Begin
          Temp:=List^.Next;
          Dispose(List);
          List:=Temp;
        End;
    End;

 { === Добавление элемента в список строк === }
  Procedure AddStrList( Var List:PStrList; Elem:TString );
    Var Last,Temp:PStrList;
    Begin
      Last:=nil; Temp:=List;
      While Temp<>nil do
        Begin
          Last:=Temp;
          Temp:=Temp^.Next;
        End;
      New(Temp); Temp^.Next:=nil; Temp^.Data:=Elem;
      If Last=nil then List:=Temp Else Last^.Next:=Temp;
    End;

 { === Удаление элемента из списока строк === }
  Procedure DelStrList( Var List:PStrList; Elem:TString );
    Var Last,Temp,Cur:PStrList;
    Begin
      Last:=nil; Cur:=List;
      While Cur<>nil do
        Begin
          Temp:=Cur^.Next;
          If Cur^.Data = Elem then
            Begin
              Dispose(Cur);
              If Last=nil then List:=Temp Else Last^.Next:=Temp;
              Break;
            End;
          Last:=Cur;
          Cur:=Temp;
        End;
    End;

 { === Для каждого элемента списка строк === }
  Procedure ForEachStrList( List:PStrList; Proc:TStrProc );
    Var Cur:PStrList;
    Begin
      Cur:=List;
      While Cur<>nil do
        Begin
          Proc(Cur^.Data);
          Cur:=Cur^.Next;
        End;
    End;

 { === Вывод на стандартное устройство вывода === }
  Procedure WriteOneStr( S:TString );
    Begin
      Writeln('Строка : ',S);
    End;

 { === Удаление дерева строк === }
  Procedure DisposeStrTree( Var Tree:PStrTree );
    Var Temp:PStrTree;
    Begin
      While Tree<>nil do
        Begin
          Temp:=Tree^.Next;
          If Tree^.SubDir<>nil then DisposeStrTree(Tree^.SubDir);
          Dispose(Tree);
          Tree:=Temp;
        End;
    End;

 { === Добавление элемента в дерево строк (Из каталога Tree) === }
  Procedure AddStrTree( Var Tree:PStrTree; Elem:TString;
                         _UpDir_:PStrTree; DirFlag:TStrTreeFlag );
    Var Last,Temp:PStrTree;
    Begin
      Last:=nil; Temp:=Tree;
      While Temp<>nil do
        Begin
          Last:=Temp;
          Temp:=Temp^.Next;
        End;
      New(Temp);
      With Temp^ do
        Begin
          Next:=nil;
          Data:=Elem;
          UpDir:=_UpDir_;
          SubDir:=nil;
          Flag:=DirFlag;
        End;
      If Last=nil then Tree:=Temp Else Last^.Next:=Temp;
    End;

 { === Удаление элемента из дерева строк === }
  Procedure DelStrTree( Var Tree:PStrTree; Elem:TString );
    Var Last,Temp,Cur:PStrTree;
    Begin
      Last:=nil; Cur:=Tree;
      While Cur<>nil do
        Begin
          Temp:=Cur^.Next;
          If Cur^.Data = Elem then
            Begin
              If Cur^.SubDir<>nil then DisposeStrTree(Cur^.SubDir);
              Dispose(Cur);
              If Last=nil then Tree:=Temp Else Last^.Next:=Temp;
              Break;
            End;
          Last:=Cur;
          Cur:=Temp;
        End;
    End;

 { === Для каждого элемента дерева строк === }
  Procedure ForEachStrTree( Tree:PStrTree; Proc:TStrProc );
    Var Cur:PStrTree;
    Begin
      Cur:=Tree;
      While Cur<>nil do
        Begin
          Proc(Cur^.Data);
          If Cur^.SubDir<>nil then ForEachStrTree(Cur^.SubDir,Proc);
          Cur:=Cur^.Next;
        End;
    End;

 { === Переход в надкаталог === }
  Procedure StrTreeUpDir( Var Tree:PStrTree );
    Begin
      If Tree^.UpDir<>nil then Tree:=Tree^.UpDir;
    End;

 { === Переход в подкаталог === }
  Procedure StrTreeSubDir( Var Tree:PStrTree; Elem:TString );
    Var Last,Temp,Cur:PStrTree;
    Begin
      Cur:=Tree;
      While Cur<>nil do
        Begin
          If ((Cur^.Data = Elem) And (Cur^.Flag=_StrTreeDir_)) then
            Tree:=Cur;
          Cur:=Cur^.Next;
        End;
    End;

End.