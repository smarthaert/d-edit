{ * Упраление игрой * }
Unit Control;

Interface

{ - Клавиши управления - }
 Type
   TControl = Object
     Up    : Array [1..2] of Byte;
     Down  : Array [1..2] of Byte;
     Left  : Array [1..2] of Byte;
     Right : Array [1..2] of Byte;
     Fire  : Array [1..2] of Byte;
    { Инициализация упpавляющих клавиш }
     Procedure LoadKeys( FileName:String );
    { Сохранение упpавляющих клавиш }
     Procedure SaveKeys( FileName:String );
    { Функция ожидаюшая нажатия клавиши и возврашающая ее скан-код }
     Procedure GetKey( Var Key:Byte );
    { Переопределение клавиш }
     Procedure RedefineKeys;
   End;

Implementation

 Uses RunError,GameKeyb;

{ Инициализация упpавляющих клавиш }
 Procedure TControl.LoadKeys( FileName:String );
   Var F:File;
   Begin
     OpenFileRE(F,'Keys',FileName);
     BlockRead(F,Up   ,2);
     BlockRead(F,Down ,2);
     BlockRead(F,Left ,2);
     BlockRead(F,Right,2);
     BlockRead(F,Fire ,2);
     Close(F);
   End;

{ Сохранение упpавляющих клавиш }
 Procedure TControl.SaveKeys( FileName:String );
   Var F:File;
   Begin
     Assign(F,FileName);
     Rewrite(F,1);
     BlockWrite(F,Up,2);
     BlockWrite(F,Down,2);
     BlockWrite(F,Left,2);
     BlockWrite(F,Right,2);
     BlockWrite(F,Fire,2);
     Close(F);
   End;

{ Функция ожидаюшая нажатия клавиши и возврашающая ее скан-код }
 Procedure TControl.GetKey( Var Key:Byte );
   Var I:Byte;
   Begin
     Write('(',KeyNames[Key],')');
     While AnyPressed do;
     While Not AnyPressed do;
     For I:=1 to 127 do
       If Keys[I] then Break;
     Key:=I;
     Writeln('-> [',Key,'] ',KeyNames[Key]);
   End;

{ Переопределение клавиш }
 Procedure TControl.RedefineKeys;
   Var I:Byte;
   Begin
     Writeln('Redefine Control Keys for TANKS');
     For I:=1 to 2 do
       Begin
         Writeln;
         Writeln('  Redefine keys for Player ',I);
         Write('    Up    '); GetKey(Up[I]);
         Write('    Down  '); GetKey(Down[I]);
         Write('    Left  '); GetKey(Left[I]);
         Write('    Right '); GetKey(Right[I]);
         Write('    Fire  '); GetKey(Fire[I]);
       End;
   End;

End.