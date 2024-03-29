Unit Test;

Interface

{ -= ���ᠭ�� ⨯� ᯨ᮪ =- }
 Type
   PFieldList = ^TFieldList;
   TFieldList = Record
     ItemName : String; { ��� ���� }
     ItemType : String; { ��� ���� }
     ItemComm : String; { ���ᠭ�� ���� }
     Next : PFieldList;
   End;

{ -= ���������� ������ ������� � ��砫� ᯨ᪠ =- }
 Procedure FieldListAddBeg( Var Root:PFieldList; ItemName:String; ItemType:String; ItemComm:String );
{ -= ���������� ������ ������� � ����� ᯨ᪠ =- }
 Procedure FieldListAddEnd( Var Root:PFieldList; ItemName:String; ItemType:String; ItemComm:String );
{ -= ���������� ������ ������� ��᫥ ������� � ����஬ N =- }
 Procedure FieldListAdd( Var Root:PFieldList; N:Integer; ItemName:String; ItemType:String; ItemComm:String );
{ -= ��ᬮ�� �ᥣ� ᯨ᪠ (��������⭮) =- }
 Procedure FieldListShow( Var Root:PFieldList );
{ -= �������� ������� � ����஬ N =- }
 Procedure FieldListDel( Var Root:PFieldList; N:Integer );
{ -= �������� �ᥣ� ᯨ᪠ =- }
 Procedure FieldListDelAll( Var Root:PFieldList );
{ -= ������ ������⢠ ������⮢ ᯨ᪠ =- }
 Function FieldListNum( Var Root:PFieldList ):Word;

Implementation

{ -= ���������� ������ ������� � ��砫� ᯨ᪠ =- }
 Procedure FieldListAddBeg( Var Root:PFieldList; ItemName:String; ItemType:String; ItemComm:String );
   Var Current : PFieldList;
   Begin
     New(Current);
     Current^.ItemName := ItemName; { ��� ���� }
     Current^.ItemType := ItemType; { ��� ���� }
     Current^.ItemComm := ItemComm; { ���ᠭ�� ���� }
     Current^.Next := Root;
     Root := Current;
   End;

{ -= ���������� ������ ������� � ����� ᯨ᪠ =- }
 Procedure FieldListAddEnd( Var Root:PFieldList; ItemName:String; ItemType:String; ItemComm:String );
   Var Current,Buffer : PFieldList;
   Begin
  { - ��������� ������ ������� - }
     New(Buffer);
     Buffer^.ItemName := ItemName; { ��� ���� }
     Buffer^.ItemType := ItemType; { ��� ���� }
     Buffer^.ItemComm := ItemComm; { ���ᠭ�� ���� }
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

{ -= ���������� ������ ������� ��᫥ ������� � ����஬ N =- }
 Procedure FieldListAdd( Var Root:PFieldList; N:Integer; ItemName:String; ItemType:String; ItemComm:String );
   Var Current,Buffer : PFieldList; Counter : Word;
   Begin
  { - ��������� ������ ������� - }
     New(Buffer);
     Buffer^.ItemName := ItemName; { ��� ���� }
     Buffer^.ItemType := ItemType; { ��� ���� }
     Buffer^.ItemComm := ItemComm; { ���ᠭ�� ���� }
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

{ -= ��ᬮ�� �ᥣ� ᯨ᪠ (��������⭮) =- }
 Procedure FieldListShow( Var Root:PFieldList );
   Var Current : PFieldList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! ��⠢�� ����� ����⢨� �� ��ࠡ�⪥ ������� ᯨ᪠ ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ -= �������� ������� � ����஬ N =- }
 Procedure FieldListDel( Var Root:PFieldList; N:Integer );
   Var Current,Buffer:PFieldList; Counter:Integer;
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

{ -= �������� �ᥣ� ᯨ᪠ =- }
 Procedure FieldListDelAll( Var Root:PFieldList );
   Var Buffer : PFieldList;
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

{ -= ������ ������⢠ ������⮢ ᯨ᪠ =- }
 Function FieldListNum( Var Root:PFieldList ):Word;
   Var Current : PFieldList; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     FieldListNum := Counter;
   End;

End.
