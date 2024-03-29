{ ---=== ���ᠭ�� ⨯� ᯨ᮪ ---===}
 Type
   PPolyList = ^TPolyList;
   TPolyList = Record
     Name : String;
     Data : Polynom;
     Next : PPolyList;
   End;

{ ---=== ���������� ������ ������� � ��砫� ᯨ᪠ ---===}
 Procedure PolyListAddBeg( Var Root:PPolyList; Name:String; Data:Polynom );
   Var Current : PPolyList;
   Begin
     New(Current);
     Current^.Name := Name;
     Current^.Data := Data;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== ���������� ������ ������� � ����� ᯨ᪠ ---===}
 Procedure PolyListAddEnd( Var Root:PPolyList; Name:String; Data:Polynom );
   Var Current,Buffer : PPolyList;
   Begin
    { - ��������� ������ ������� - }
     New(Buffer);
     Buffer^.Name := Name;
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
 Procedure PolyListAdd( Var Root:PPolyList; N:Integer; Name:String; Data:Polynom );
   Var Current,Buffer : PPolyList; Counter : Word;
   Begin
    { - ��������� ������ ������� - }
     New(Buffer);
     Buffer^.Name := Name;
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
 Procedure PolyListShow( Var Root:PPolyList );
   Var Current : PPolyList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! ��⠢�� ����� ����⢨� �� ��ࠡ�⪥ ������� ᯨ᪠ ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== �������� ������� � ����஬ N ---===}
 Procedure PolyListDel( Var Root:PPolyList; N:Integer );
   Var Current,Buffer:PPolyList; Counter:Integer;
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
 Procedure PolyListDelAll( Var Root:PPolyList );
   Var Buffer : PPolyList;
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
 Function PolyListNum( Var Root:PPolyList ):Word;
   Var Current : PPolyList; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     PolyListNum := Counter;
   End;

{ ---=== ���᮪ ��������� ---===}
Const PolyList : PPolyList = nil;
