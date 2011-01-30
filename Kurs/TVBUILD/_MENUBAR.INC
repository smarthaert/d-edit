Var R:TRect;
Begin
  GetExtent(R);
  R.B.Y:=R.A.Y+1;
  MenuBar:=New(PMenuBar,Init(R,NewMenu(
    NewSubMenu('~F~ile',hcNoContext,NewMenu(
      NewItem('~N~ew','',kbNoKey,cmNew,hcNew,
      NewItem('E~x~it','',kbNoKey,cmNew,hcNew,
      Nil))),
    NewSubMenu('~H~elp',hcNoContext,NewMenu(
      NewItem('~A~bout','',kbNoKey,cmNew,hcNew,
      Nil)),
    Nil)))));
End;
