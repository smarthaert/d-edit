Unit _Dialogs;

Interface

  Uses Objects,Menus,Views,Drivers,Dialogs,MsgBox;

 { ---=== Взять число из InputLine ===--- }
  Function GetInputLineNum( IL:PInputLine; Var Error:Boolean ):LongInt;

 { ---=== Сообщение об ошибке ===--- }
  Procedure ErrorMessage( Message:String );

 { ---=== Строка помощи ===--- }
  Function HelpStr( HelpNum:Word; Message:String; Next:PStatusDef ):PStatusDef;

 { ---=== Перевод числа в строку ===--- }
  Function NumStr( N:LongInt ):String;

 { ---=== Диалог создания матрицы ===--- }
  Type
    PMatrixCreateDialog = ^TMatrixCreateDialog;
    TMatrixCreateDialog = Object(TDialog)
      NSizeLine,MSizeLine : PInputLine;
      Constructor Init( Var _R_:TRect );
      Procedure HandleEvent( Var Event:TEvent ); Virtual;
      Procedure MatrixEdit;
    End;

 { ---=== Диалог редактирования матрицы ===--- }
  Type
    TInputLineArray = Array [1..$100] of PInputLine;
    PInputLineArray = ^TInputLineArray;
    TInputLineTable = Array [1..$100] of PInputLineArray;
    PInputLineTable = ^TInputLineTable;
    PMatrixEditDialog = ^TMatrixEditDialog;
    TMatrixEditDialog = Object(TDialog)
      NSize,MSize : Byte;
      Data : PInputLineTable;
      Constructor Init( Var _R_:TRect; _NSize,_MSize:Byte );
      Procedure HandleEvent( Var Event:TEvent ); Virtual;
      Destructor Done; Virtual;
      Function Check:Boolean;
      Function Sqare:Boolean;
      Procedure DecE;
    End;

Implementation

 Uses _Const,App;

 { ---=== Взять число из InputLine ===--- }
  Function GetInputLineNum( IL:PInputLine; Var Error:Boolean ):LongInt;
    Var TempStr:String; ErrorInt:Integer; L:LongInt;
    Begin
      IL^.GetData(TempStr);
      While TempStr[Length(TempStr)]=' ' do
        TempStr:=Copy(TempStr,1,Length(TempStr)-1);
      Val(TempStr,L,ErrorInt);
      Error:=(ErrorInt<>0);
      GetInputLineNum:=L;
    End;

 { ---=== Сообщение об ошибке ===--- }
  Procedure ErrorMessage( Message:String );
    Begin
      MessageBox(^C+Message,nil,mfError+mfOkButton);
    End;

{ ---=== Строка помощи ===--- }
 Function HelpStr( HelpNum:Word; Message:String; Next:PStatusDef ):PStatusDef;
   Begin
     HelpStr := NewStatusDef(HelpNum,HelpNum,
       NewStatusKey(Message,kbNoKey,cmNo,
       StdStatusKeys(nil)),
       Next);
   End;

 { ---=== Перевод числа в строку ===--- }
  Function NumStr( N:LongInt ):String;
    Var Temp:String;
    Begin
      Str(N,Temp);
      NumStr:=Temp;
    End;

{ ---=== Диалог создания матрицы ===--- }
 Constructor TMatrixCreateDialog.Init( Var _R_:TRect );
   Var R:TRect;
   Begin
     R:=_R_;
     R.A.X:=R.B.X Div 2;
     R.A.Y:=R.B.Y Div 2;
     R.B:=R.A;
     R.Grow(21,4);
     Inherited Init(R,'Создание матрицы');
     R.Assign(29,2,40,4);
     Insert(New(PButton,Init(R,'~С~оздать',cmMatrixCreate,bfDefault)));
     R.Assign(29,4,39,6);
     Insert(New(PButton,Init(R,'~О~тмена',cmClose,bfNormal)));
     R.Assign(2,2,28,3);
     NSizeLine:=New(PInputLine,Init(R,80));
     Insert(NSizeLine);
     R.Assign(2,4,28,5);
     MSizeLine:=New(PInputLine,Init(R,80));
     Insert(MSizeLine);
     R.Assign(1,1,12,2); Insert(New(PLabel,Init(R,'С~т~рок',NSizeLine)));
     R.Assign(1,3,12,4); Insert(New(PLabel,Init(R,'Сто~л~бцов',MSizeLine)));
     NSizeLine^.Select;
   End;

 Procedure TMatrixCreateDialog.HandleEvent( Var Event:TEvent );
   Begin
     Inherited HandleEvent(Event);
     If (Event.What And evCommand)<>0 then
       Begin
         Case Event.Command of
           cmClose        : Close;
           cmMatrixCreate : MatrixEdit;
         Else
           Exit;
         End;
         ClearEvent(Event);
       End;
   End;

 Procedure TMatrixCreateDialog.MatrixEdit;
   Var NSize,MSize:LongInt; Error:Boolean; Event:TEvent;
   Begin
     NSize:=GetInputLineNum(NSizeLine,Error);
     If (Error Or (NSize<1) Or (NSize>22)) then
       Begin ErrorMessage('Недопустимое число строк'); Exit; End;
     MSize:=GetInputLineNum(MSizeLine,Error);
     If (Error Or (MSize<1) Or (MSize>22)) then
       Begin ErrorMessage('Недопустимое число столбцов'); Exit; End;
     Event.What:=evMessage;
     Event.Command:=cmMatrixEditDialog;
     Event.InfoWord:=NSize*$100+MSize;
     PutEvent(Event);
     Close;
   End;

{ ---=== Диалог редактирования матрицы ===--- }
 Constructor TMatrixEditDialog.Init;
   Var R:TRect; I,J:Byte;
   Begin
     R:=_R_;
     R.A.X:=R.B.X Div 2;
     R.A.Y:=R.B.Y Div 2;
     R.B:=R.A;
     R.Grow(_MSize*4+2,((_NSize+1) div 2)+1);
     Inherited Init(R,'Матрица');
     NSize:=_NSize; MSize:=_MSize;
     GetMem(Data,NSize*SizeOf(PInputLineArray));
     For I:=1 to NSize do
       Begin
         GetMem(Data^[I],MSize*SizeOf(PInputLine));
         For J:=1 to MSize do
           Begin
             R.Assign(J*8-6,I,J*8+1,I+1);
             Data^[I]^[J]:=New(PInputLine,Init(R,12));
             Insert(Data^[I]^[J]);
           End;
       End;
     Data^[1]^[1]^.Select;
   End;

 Destructor TMatrixEditDialog.Done;
   Var I:Byte;
   Begin
     For I:=1 to NSize do
       FreeMem(Data^[I],MSize*SizeOf(PInputLine));
     FreeMem(Data,NSize*SizeOf(PInputLineArray));
     Inherited Done;
   End;

 Procedure TMatrixEditDialog.HandleEvent( Var Event:TEvent );
   Begin
     Inherited HandleEvent(Event);
     If (Event.What And evCommand)<>0 then
       Begin
         Case Event.Command of
           cmClose        : Close;
           cmMatrixDecE   : If Sqare then If Check then DecE;
         Else
           Exit;
         End;
         ClearEvent(Event);
       End;
   End;

 Function TMatrixEditDialog.Check:Boolean;
   Var Error:Boolean; I,J:Byte;
   Begin
     Check:=True;
     For I:=1 to NSize do
       For J:=1 to MSize do
         Begin
           GetInputLineNum(Data^[I]^[J],Error);
           If Error then
             Begin
               Check:=False;
               ErrorMessage('Ошибка в строке '+NumStr(I)+
                            ' столбце '+NumStr(J));
               Data^[I]^[J]^.Select;
               Exit;
             End;
         End;
   End;

 Function TMatrixEditDialog.Sqare:Boolean;
   Var Error:Boolean; I,J:Byte;
   Begin
     Sqare:=True;
     If MSize <> NSize then
       Begin
         ErrorMessage('Это действие применимо'#13+
                      ^C'только к квадратной матрице');
         Sqare:=False;
       End;
   End;

 Procedure TMatrixEditDialog.DecE;
   Var I:Byte; Error:Boolean; S:String;
   Begin
     For I:=1 to NSize do
       Begin
         S:=NumStr(GetInputLineNum(Data^[I]^[I],Error)-1);
         Data^[I]^[I]^.SetData(S);
       End;
   End;

End.
