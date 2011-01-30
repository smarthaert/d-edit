{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ             ‘ ’    €       €      €                ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ‘โเฎช  ขขฎค  ชฎฌ ญค ===--- }
 Type
   PInputStr = ^TInputStr;
   TInputStr = String[78];
   PConsoleInput = ^TConsoleInput;
   TConsoleInput = Object(TTask)
     Input  : PInputStr;
     Cursor : Byte;
     Procedure Init; Virtual;
     Procedure Run; Virtual;
     Procedure Done; Virtual;
     Procedure Edit;
     Procedure ClearStr;
     Procedure ShowStr;
   End;

 Procedure TConsoleInput.Init;
   Begin
     New(Input);
     DrawBorder(1,22,80,24,6);
     TextColor(15); GotoXY(32,22); Write(' Command Line ');
     ClearStr;
     ShowStr;
   End;

 Procedure TConsoleInput.Run;
   Begin
     If KeyPressed then Edit;
   End;

 Procedure TConsoleInput.Done;
   Begin
     Dispose(Input);
   End;

 Procedure TConsoleInput.Edit;
   Var Key:Char;
   Begin
     Key:=ReadKey;
     Case Key of
       #08: {  กฎฉ }
        If Cursor > 1 then
          Begin
            Input^:=Copy(Input^,1,Cursor-2)+Copy(Input^,Cursor,79-Cursor)+' ';
            Dec(Cursor);
          End;
       #13: { Enter }
         Begin
           Command(Input^);
           ClearStr;
         End;
       #27: { ESC }
         Command('ShutDown');
       #00: { ‘โเฅซฎ็ชจ }
         Case ReadKey of
           #75: If Cursor > 1 then Dec(Cursor);
           #77: If Cursor < 78 then Inc(Cursor);
          { Del }
           #83: Input^:=Copy(Input^,1,Cursor-1)+Copy(Input^,Cursor+1,79-Cursor)+' ';
          { Home }
           #71: Cursor:=1;
           #79: { End }
             Begin
               Cursor:=78;
               While Input^[Cursor]=' ' do Dec(Cursor);
               If Cursor < 78 then Inc(Cursor);
             End;
         End;
     Else
       If Cursor < 78 then
         Begin
           Input^:=Copy(Input^,1,Cursor-1)+Key+Copy(Input^,Cursor,78-Cursor);
           Inc(Cursor);
         End;
     End;
     ShowStr;
   End;

 Procedure TConsoleInput.ShowStr;
   Begin
     TextColor(7);
     GotoXY(2,23);
     Write(Input^);
     GotoXY(1+Cursor,23);
   End;

 Procedure TConsoleInput.ClearStr;
   Var I:Byte;
   Begin
     Input^[0]:=#78;
     For I:=1 to 78 do Input^[I]:=' ';
     Cursor:=1;
   End;
