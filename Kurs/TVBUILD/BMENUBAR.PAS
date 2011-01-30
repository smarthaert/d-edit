Uses App,Menus,Objects,Views,Drivers,Dialogs,MsgBox,CRT;

Const
  MVTreeTab =2;
  cmSelect  =$1001;
  cmCheckOK =$1002;
  cmNewItem =$1003;
  cmNewPopup=$1004;

Procedure Beep;
Begin
   Sound(1000);
   Delay(10);
   NoSound;
End;

Type
  TabStr=String[40];
  PMenuEditItem=^TMenuEditItem;
  PMenuEditPopup=^TMenuEditPopup;
  TMenuEditItem=
    Object(TObject)
      Owner:PMenuEditPopup;
      Next:PMenuEditItem;
      Name:PString;
      FDChar:Char;
      Constructor Init(_Name:String);
      Procedure PutCol(Col:PStringCollection; Tab:TabStr);Virtual;
      Destructor Done;Virtual;
      Function PutSize:Integer;Virtual;
      Function PutNumPtr(Num:Integer):PMenuEditItem;Virtual;
      Function Command(Com:Word):Word;Virtual;
    End;
  TMenuEditPopup=
    Object(TMenuEditItem)
      Popup:PMenuEditItem;
      ShowSub:Boolean;
      Constructor Init(_Name:String);
      Destructor Done;Virtual;
      Procedure PutCol(Col:PStringCollection; Tab:TabStr);Virtual;
      Procedure AtInsert(P:PMenuEditItem; Num:Word);
      Procedure Insert(P:PMenuEditItem);
      Procedure Delete(P:PMenuEditItem);
      Procedure DeletePtr(P:PMenuEditItem);
      Function PutSize:Integer;Virtual;
      Function PutNumPtr(Num:Integer):PMenuEditItem;Virtual;
      Function Command(Com:Word):Word;Virtual;
    End;
  PMenuEditDialog=^TMenuEditDialog;
  TMenuEditDialog=
    Object(TDialog)
      MVTree:PListBox;
      MenuTree:PMenuEditPopup;
      Constructor Init(Var Center:TRect; _FileName:String);
      Procedure HandleEvent(Var Event:TEvent);Virtual;
      Destructor Done;Virtual;
      { * * * }
      Procedure RefreshMVTree(Focusing:Integer);
      Procedure ClearMenuTree;
      Procedure SelectItem;
      Procedure NewItem(IT:Byte);
      Procedure PopupChange;
      Procedure SaveMenu;
    End;
  PMenuItemEditDialog=^TMenuItemEditDialog;
  TMenuItemEditDialog=
    Object(TDialog)
      NameIL:PInputLine;
      Item:PMenuEditItem;
      ItemType:Byte;
      Constructor Init(Var Center:TRect; _Item:PMenuEditItem);
      Procedure HandleEvent(Var Event:TEvent);Virtual;
      { * * * }
      Function Check:Byte;
      Function SaveRes:Boolean;
      Procedure PutCheckError(Code:Byte);
    End;
  TMyApp=
    Object(TApplication)
      Procedure InitMenuBar;Virtual;
      Procedure HandleEvent(Var Event:TEvent);Virtual;
      { * * * }
      Procedure NewMenuEditDialog;
    End;

{ = = = TMenuEditPopup = = = }

Constructor TMenuEditPopup.Init;
Begin
   Inherited Init(_Name);
   Popup:=Nil;
   FDChar:='';
   ShowSub:=True;
End;

Destructor TMenuEditPopup.Done;
Begin
   While Popup<>Nil do Delete(Popup);
   Inherited Done;
End;

Procedure TMenuEditPopup.PutCol;
  Var
    P:PMenuEditItem;
    S:TabStr;
    I:Byte;
Begin
   Inherited PutCol(Col,Tab);
   If Not ShowSub then Exit;
   S:=Tab;
   If MVTreeTab>0 then
     Begin
        If Next=Nil then
          S:=S+' '
          Else
          S:=S+'³';
        For I:=2 to MVTreeTab do
          S:=S+' ';
     End;
   P:=Popup;
   While P<>Nil do
     Begin
        P^.PutCol(Col,S);
        P:=P^.Next;
     End;
End;

Procedure TMenuEditPopup.AtInsert;
  Var
    I:Word;
    PB,PA:PMenuEditItem;
Begin
   PB:=Nil;
   PA:=Popup;
   For I:=1 to Num do
     Begin
        If PA=Nil then Break;
        PB:=PA;
        PA:=PB^.Next;
     End;
   If PB=Nil then
     Popup:=P
     Else
     PB^.Next:=P;
   P^.Owner:=@Self;
   P^.Next:=PA;
End;

Procedure TMenuEditPopup.Insert;
Begin
   AtInsert(P,$FFFF);
End;

Procedure TMenuEditPopup.DeletePtr;
  Var
    PB,PC:PMenuEditItem;
Begin
   PB:=Nil;
   PC:=Popup;
   While PC<>Nil do
     Begin
        If PC=P then
          Begin
             If PB<>Nil then
               PB^.Next:=PC^.Next
               Else
               Popup:=PC^.Next;
             P^.Owner:=Nil;
             P^.Next:=Nil;
          End;
        PB:=PC;
        PC:=PB^.Next;
     End;
End;

Procedure TMenuEditPopup.Delete;
Begin
   If P<>Nil then
     P^.Free;
End;

Function TMenuEditPopup.PutSize;
  Var
    N:Word;
    P:PMenuEditItem;
Begin
   N:=Inherited PutSize;
   If ShowSub then
     Begin
        P:=Popup;
        While P<>Nil do
          Begin
             Inc(N,P^.PutSize);
             P:=P^.Next;
          End;
     End;
   PutSize:=N;
End;

Function TMenuEditPopup.PutNumPtr;
  Var
    R,P:PMenuEditItem;
    N:Integer;
Begin
   If (Num<0) Or (Num>PutSize-1) then
     Begin
        PutNumPtr:=Nil;
        Exit;
     End;
   R:=Inherited PutNumPtr(Num);
   If Not ShowSub then
     Begin
        PutNumPtr:=R;
        Exit;
     End;
   P:=Popup;
   N:=1;
   While (R=Nil)And(P<>Nil) do
     Begin
        R:=P^.PutNumPtr(Num-N);
        N:=N+P^.PutSize;
        P:=P^.Next;
     End;
   PutNumPtr:=R;
End;

Function TMenuEditPopup.Command;
  Var
    R:Word;
Begin
   R:=0;
   Case Com of
     0:R:=2;
     1:
       Begin
          ShowSub:=Not ShowSub;
          R:=Byte(ShowSub);
          If ShowSub then
            FDChar:=''
            Else
            FDChar:='';
       End;
     Else
       R:=Inherited Command(Com);
   End;
   Command:=R;
End;

{ = = = TMenuEditItem = = = }

Constructor TMenuEditItem.Init;
Begin
   Inherited Init;
   Name:=NewStr(_Name);
   Next:=Nil;
   Owner:=Nil;
   FDChar:='';
End;

Destructor TMenuEditItem.Done;
Begin
   If Owner=Nil then
     Begin
        If Next<>Nil then Next^.Free;
     End
     Else
     Begin
        Owner^.DeletePtr(@Self);
     End;
   DisposeStr(Name);
   Inherited Done;
End;

Procedure TMenuEditItem.PutCol;
  Var
    S,SN:TabStr;
    N:Byte;
Begin
   S:=Tab;
   If MVTreeTab>0 then
     Begin
        If Next=Nil then
          S:=S+'À'
          Else
          S:=S+'Ã';
     End;
   S:=S+FDChar;
   If Name<>Nil then
     SN:=Name^
     Else
     SN:='';
   N:=255;
   While N<>0 do
     Begin
        If N<>255 then
          Delete(SN,N,1);
        N:=Pos('~',SN);
     End;
   S:=S+SN;
   PCollection(Col)^.AtInsert(Col^.Count,NewStr(S));
End;

Function TMenuEditItem.PutSize;
Begin
   PutSize:=1;
End;

Function TMenuEditItem.PutNumPtr;
Begin
   If Num=0 then PutNumPtr:=@Self Else PutNumPtr:=Nil;
End;

Function TMenuEditItem.Command;
  Var
    R:Word;
Begin
   R:=0;
   Case Com of
     0:R:=1;
     Else
       R:=$FFFF;
   End;
   Command:=R;
End;

{ = = = TMenuEditDialog = = = }

Constructor TMenuEditDialog.Init;
  Var
    R,R2:TRect;
    B:PButton;
    {IL:PInputLine;
    LB:PLabel;
    PST:PString;}
    PSB:PScrollBar;
Begin
   R:=Center;
   R.A.X:=(R.A.X+R.B.X) Div 2;
   R.A.Y:=(R.A.Y+R.B.Y) Div 2;
   R.B:=R.A;
   R.Grow(30,8);
   Inherited Init(R,_FileName);
   Palette:=0;
   GetExtent(R);
   R.A:=R.B;
   R.Move(-2,-1);
   Dec(R.A.X,14);
   Dec(R.A.Y,2);
   B:=New(PButton,Init(R,'~S~elect',cmSelect,bfDefault));
   Insert(B);
   R.Move(0,-2);
   B:=New(PButton,Init(R,'New ~I~tem',cmNewItem,bfNormal));
   Insert(B);
   R.Move(0,-2);
   B:=New(PButton,Init(R,'New ~P~opup',cmNewPopup,bfNormal));
   Insert(B);
   {R.Assign(29,7,38,9);
   B:=New(PButton,Init(R,'Cl~o~se',cmClose,bfNormal));
   If B<>Nil then Insert(B);
   R.Assign(2,2,28,3);
   SpeakLine:=New(PInputLine,Init(R,80));
   If SpeakLine<>Nil then
     Begin
        Insert(SpeakLine);
        R.Assign(1,1,12,2);
        LB:=New(PLabel,Init(R,'Speak ~l~ine',SpeakLine));
        If LB<>Nil then
          Insert(LB);
     End;                   }
   GetExtent(R);
   R.B.X:=R.B.X Div 2;
   R.Grow(-2,-2);
   Inc(R.B.Y);
   R2:=R;
   R2.A.X:=R2.B.X-1;
   R2.Move(1,0);
   PSB:=New(PScrollBar,Init(R2));
   Insert(PSB);
   MVTree:=New(PListBox,Init(R,1,PSB));
   Insert(MVTree);
   MenuTree:=Nil;
   ClearMenuTree;
End;

Destructor TMenuEditDialog.Done;
Begin
   If MenuTree<>Nil then MenuTree^.Free;
   Inherited Done;
End;

Procedure TMenuEditDialog.RefreshMVTree;
  Var
    PSC:PStringCollection;
Begin
   PSC:=New(PStringCollection,Init(20,20));
   If MenuTree<>Nil then
     MenuTree^.PutCol(PSC,'');
   MVTree^.NewList(PSC);
   MVTree^.FocusItem(Focusing);
End;

Procedure TMenuEditDialog.ClearMenuTree;
  Var
    Item:PMenuEditItem;
    Popup:PMenuEditPopup;
Begin
   If MenuTree<>Nil then MenuTree^.Free;
   New(MenuTree,Init('Main Menu'));
   Popup:=MenuTree;
   Item:=New(PMenuEditPopup,Init('~F~ile'));
   Popup^.Insert(Item);
   Popup:=PMenuEditPopup(Item);
   Item:=New(PMenuEditItem,Init('~N~ew'));
   Popup^.Insert(Item);
   Item:=New(PMenuEditItem,Init('E~x~it'));
   Popup^.Insert(Item);
   Popup:=MenuTree;
   Item:=New(PMenuEditPopup,Init('~H~elp'));
   Popup^.Insert(Item);
   Popup:=PMenuEditPopup(Item);
   Item:=New(PMenuEditItem,Init('~A~bout'));
   Popup^.Insert(Item);
   RefreshMVTree(0);
End;

Procedure TMenuEditDialog.PopupChange;
  Var
    P:PMenuEditItem;
Begin
   If MVTree=Nil then Exit;
   P:=MenuTree^.PutNumPtr(MVTree^.Focused);
   If P=Nil then Exit;
   P^.Command(1);
   RefreshMVTree(MVTree^.Focused);
End;

Procedure TMenuEditDialog.SelectItem;
  Var
    P:PMenuEditItem;
    R:TRect;
    D:PMenuItemEditDialog;
Begin
   If MVTree=Nil then Exit;
   P:=MenuTree^.PutNumPtr(MVTree^.Focused);
   If P=Nil then Exit;
   If P=PMenuEditItem(MenuTree) then Exit;
   R.A.X:=63;
   R.A.Y:=15;
   R.B:=R.A;
   New(D,Init(R,P));
   Application^.ExecuteDialog(D,Nil);
   RefreshMVTree(MVTree^.Focused);
End;

Procedure TMenuEditDialog.NewItem;
  Var
    P,P2,Item:PMenuEditItem;
    Popup:PMenuEditPopup;
    N:Word;
Begin
   If MVTree=Nil then Exit;
   P:=MenuTree^.PutNumPtr(MVTree^.Focused);
   If P=Nil then Exit;
   If P=PMenuEditItem(MenuTree) then Exit;
   Popup:=P^.Owner;
   N:=0;
   P2:=Popup^.Popup;
   While(P2<>P)And(P2<>Nil) do
     Begin
        P2:=P2^.Next;
        Inc(N);
     End;
   Case IT of
     1:Item:=New(PMenuEditItem,Init('~I~tem'));
     2:
       Begin
          P:=New(PMenuEditItem,Init('~I~tem'));
          Item:=New(PMenuEditPopup,Init('~P~opup'));
          PMenuEditPopup(Item)^.Insert(P);
       End;
   End;
   Popup^.AtInsert(Item,N);
   RefreshMVTree(MVTree^.Focused);
End;

Procedure TMenuEditDialog.HandleEvent;
Begin
   Inherited HandleEvent(Event);
   If (Event.What And evCommand)<>0 then
     Begin
        Case Event.Command of
          cmClose:Close;
          cmSave:SaveMenu;
          cmSelect:SelectItem;
          cmNewItem:NewItem(1);
          cmNewPopup:NewItem(2);
          Else
            Exit;
        End;
        ClearEvent(Event);
     End;
   If (Event.What And evBroadcast)<>0 then
     Begin
        Case Event.Command of
          cmListItemSelected:
            PopupChange;
          {cm:Speaking;}
          Else
            Exit;
        End;
        ClearEvent(Event);
     End;
End;

Procedure TMenuEditDialog.SaveMenu;
  Function Spaces( N:Byte ):String;
    Var Temp:String; I:Byte;
    Begin
      Temp[0]:=Chr(N);
      For I:=1 to N do Temp[I]:=' ';
      Spaces:=Temp;
    End;
  Procedure SaveOneMenu( TabNum:Word; _Menu_:PMenuEditPopup );
    Var CurItem:PMenuEditItem; N,I:Word;
    Begin
      If _Menu_ = Nil then Exit;
      CurItem:=_Menu_^.Popup;
      N:=0;
      While CurItem<>nil do
        Begin
          Case CurItem^.Command(0) of
            1: Writeln(Spaces(TabNum),'NewItem('''+CurItem^.Name^,
                       ''','''',kbNoKey,cmNew,hcNew,');
            2: { SubMenu }
              Begin
                Writeln(Spaces(TabNum),'NewSubMenu('''+CurItem^.Name^,
                        ''',hcNoContext,NewMenu(');
                SaveOneMenu(TabNum+2,PMenuEditPopup(CurItem));
                Writeln('),');
              End;
          End;
          Inc(N);
          CurItem:=CurItem^.Next;
        End;
      Write(Spaces(TabNum),'Nil');
      For I:=1 to N do Write(')');
    End;
Begin
  Assign(Output,'_MENUBAR.INC');
  Rewrite(Output);
  Writeln('Var R:TRect;');
  Writeln('Begin');
  Writeln('  GetExtent(R);');
  Writeln('  R.B.Y:=R.A.Y+1;');
  Writeln('  MenuBar:=New(PMenuBar,Init(R,NewMenu(');
  SaveOneMenu(4,MenuTree);
  Writeln(')));');
  Writeln('End;');
  System.Close(Output);
End;

{ = = = TMenuItemEditDialog = = = }

Constructor TMenuItemEditDialog.Init;
  Var
    R:TRect;
    B:PButton;
    IL:PInputLine;
    PT:PStaticText;
    LB:PLabel;
    PST:PString;
    PSB:PScrollBar;
    S:String;
Begin
   R:=Center;
   R.A.X:=(R.A.X+R.B.X) Div 2;
   R.A.Y:=(R.A.Y+R.B.Y) Div 2;
   R.B:=R.A;
   R.Grow(15,5);
   Inherited Init(R,'Edit Item');
   Item:=_Item;
   ItemType:=Item^.Command(0);
   GetExtent(R);
   R.B.X:=R.A.X;
   R.A.Y:=R.B.Y;
   R.Move(2,-1);
   Inc(R.B.X,10);
   Dec(R.A.Y,2);
   B:=New(PButton,Init(R,'~O~K',cmCheckOK,bfDefault));
   Insert(B);
   GetExtent(R);
   R.A:=R.B;
   R.Move(-2,-1);
   Dec(R.A.X,10);
   Dec(R.A.Y,2);
   B:=New(PButton,Init(R,'Cancel',cmCancel,bfNormal));
   Insert(B);
   GetExtent(R);
   Inc(R.A.X,2);
   Dec(R.B.X,2);
   R.A.Y:=1;
   R.B.Y:=R.A.Y+1;
   Case ItemType of
     1:S:='Command Item';
     2:S:='Sub Menu';
     Else
       S:='Unknown'
   End;
   PT:=New(PStaticText,Init(R,'  Type : '+S));
   Insert(PT);
   R.Move(0,2);
   NameIL:=New(PInputLine,Init(R,25));
   R.Move(0,-1);
   LB:=New(PLabel,Init(R,'~N~ame',NameIL));
   Insert(LB);
   NameIL^.SetData(Item^.Name^);
   Insert(NameIL);
   R.Move(0,2);
End;

Function TMenuItemEditDialog.Check;
Begin
   Check:=0;
   If NameIL^.Data^='' then
     Check:=1;
End;

Procedure TMenuItemEditDialog.PutCheckError;
  Const
    NumErr=1;
    ErrMsg:Array [1..NumErr] of String=
     (
      'Name'
     );
  Var
    S:String;
Begin
   If (Code>=1)And(Code<=NumErr) then
     S:=ErrMsg[Code]
     Else
     Begin
        Str(Code,S);
        S:='Unknown. Number : '+S;
     End;
   MessageBox(^C'Error :'+^M^M^C+S,Nil,mfOKButton+mfError);
End;

Function TMenuItemEditDialog.SaveRes;
  Var
    C:Byte;
    S:String;
Begin
   C:=Check;
   SaveRes:=(C=0);
   If C<>0 then
     Begin
        PutCheckError(C);
        Exit;
     End;
   NameIL^.GetData(S);
   DisposeStr(Item^.Name);
   Item^.Name:=NewStr(S);
End;

Procedure TMenuItemEditDialog.HandleEvent;
  Var
    NewEvent:TEvent;
Begin
   If (Event.What And evCommand)<>0 then
     If Event.Command=cmCheckOK then
       Begin
          ClearEvent(Event);
          If SaveRes then
            Begin
               NewEvent.What:=evCommand;
               NewEvent.Command:=cmOK;
               PutEvent(NewEvent);
            End;
       End;
   Inherited HandleEvent(Event);
End;

{ = = = TMyApp = = = }

Procedure TMyApp.InitMenuBar;
  Var
    R:TRect;
Begin
   GetExtent(R);
   R.B.Y:=R.A.Y+1;
   MenuBar:=New(PMenuBar,Init(R,NewMenu(
   NewSubMenu('~F~ile',hcNoContext,NewMenu(
      NewItem('~N~ew','',kbNoKey,cmNew,hcNew,
      NewItem('~S~ave','',kbNoKey,cmSave,hcSave,
      NewItem('E~x~it','Alt+X',kbAltX,cmQuit,hcExit,
       Nil)))),
   Nil
   ))));
End;

Procedure TMyApp.HandleEvent;
Begin
   Inherited HandleEvent(Event);
   If (Event.What And evCommand)<>0 then
     Begin
        Case Event.Command of
          cmNew:NewMenuEditDialog;
          Else
            Exit;
        End;
        ClearEvent(Event);
     End;
End;

Procedure TMyApp.NewMenuEditDialog;
  Var
    P:PMenuEditDialog;
    R:TRect;
Begin
   Desktop^.GetExtent(R);
   P:=New(PMenuEditDialog,Init(R,'_MENUBAR.INC'));
   InsertWindow(P);
End;

Var
  MyApp:TMyApp;

Begin
   MyApp.Init;
   MyApp.Run;
   MyApp.Done;
End.