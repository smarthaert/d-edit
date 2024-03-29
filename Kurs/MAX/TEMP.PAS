{ ---=== ���ᠭ�� ⨯� ᯨ᮪ ---===}
 Type
   PNumList = ^TNumList;
   TNumList = Record
     Data : Float;
     Next : PNumList;
   End;

{ ---=== ���������� ������ ������� � ��砫� ᯨ᪠ ---===}
 Procedure NumListAddBeg( Var Root:PNumList; Data:Float );
   Var Current : PNumList;
   Begin
     New(Current);
     Current^.Data := Data;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== ���������� ������ ������� � ����� ᯨ᪠ ---===}
 Procedure NumListAddEnd( Var Root:PNumList; Data:Float );
   Var Current,Buffer : PNumList;
   Begin
    { - ��������� ������ ������� - }
     New(Buffer);
     Buffer^.Data := Data;
     Buffer^.Next := nil;
    { - ��ᮥ������� ������� � �������饬� ᯨ�� - }
     If Root <> nil then
       Begin
         Current := Root;
         While Current^.Next <> nil do Current := Current^.Next;
         Current^.Next := Buffer;
       End
     Else
       Root := Buffer;
     End;

{ ---=== ���������� ������ ������� ��᫥ ������� � ����஬ N ---===}
 Procedure NumListAdd( Var Root:PNumList; N:Integer; Data:Float );
   Var Current,Buffer : PNumList; Counter : Word;
   Begin
    { - ��������� ������ ������� - }
     New(Buffer);
     Buffer^.Data := Data;
    { - ��ᮥ������� ������� � �������饬� ᯨ�� - }
     Current := Root;
     Counter := 0;
     If N <> 0 then
       While Current <> nil do
         Begin
           Inc(Counter);
           If Counter = N then
             Begin
               Buffer^.Next := Current^.Next;
               Current^.Next := Buffer;
               Break; { ����� ��� ������ ��祣� ;) }
             End;
           Current := Current^.Next;
         End
     Else
       Begin
         Buffer^.Next := Root;
         Root := Buffer;
       End;
   End;

{ ---=== ��ᬮ�� �ᥣ� ᯨ᪠ (��������⭮) ---===}
 Procedure NumListShow( Var Root:PNumList );
   Var Current : PNumList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! ��⠢�� ����� ����⢨� �� ��ࠡ�⪥ ������� ᯨ᪠ ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== �������� ������� � ����஬ N ---===}
 Procedure NumListDel( Var Root:PNumList; N:Integer );
   Var Current,Buffer:PNumList; Counter:Integer;
   Begin
     Current := Root;
     Buffer := nil;
     Counter := 0;
    { - �饬 �㦭� ��� ������� - }
     While Current <> nil do
       Begin
         Inc(Counter);
        { - � 㤠�塞 ��� ... - }
         If Counter = N then
           Begin
             If Buffer = nil then
               Root:=Current^.Next
             Else
               Buffer^.Next:=Current^.Next;
             Dispose(Current);
             Break; { ����� ��� ������ ��祣� ;) }
           End;
         Buffer := Current;
         Current := Current^.Next;
       End;
   End;

{ ---=== �������� �ᥣ� ᯨ᪠ ---===}
 Procedure NumListDelAll( Var Root:PNumList );
   Var Buffer : PNumList;
   Begin
    { ���� � ᯨ᪥ ��⠫��� �������� }
     While Root <> nil do
       Begin
        { ����塞 ���� ������� }
         Buffer := Root;
         Root := Root^.Next;
         Dispose(Buffer);
       End;
   End;

{ ---=== ������ ������⢠ ������⮢ ᯨ᪠ ---===}
 Function NumListNum( Var Root:PNumList ):Word;
   Var Current : PNumList; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     NumListNum := Counter;
   End;

{ ---=== �᭮���� �ணࠬ�� ---===}
Var NumList : PNumList;
Begin
  NumList := nil;
End.
