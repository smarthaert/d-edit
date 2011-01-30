Unit Paths;

Interface

Uses DOS;

Const
  ProgramPath:PathStr='';
  GamePath:PathStr='';
  DataPath:PathStr='DATA\';

Procedure NewPaths(Path:PathStr);

Implementation

Procedure NewPaths;
Begin
   GamePath:=FExpand(ProgramPath+Path);
   DataPath:=GamePath+'DATA\'
End;

Procedure Init_All;
  Var
    Dir:DirStr;
    Name:NameStr;
    Ext:ExtStr;
Begin
   FSplit(FExpand(ParamStr(0)),Dir,Name,Ext);
   ProgramPath:=Dir;
   NewPaths('');
End;

Begin
   Init_All;
End.