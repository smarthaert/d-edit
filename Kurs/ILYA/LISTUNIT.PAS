Unit ListUnit;

Interface

Uses TPCrt, TPWindow, TPEdit, PolyUnit, CoefUnit;

{ ******************** }
{ * ���᮪ ��������� * }
{ ******************** }
Type
  PPolynom = ^TPolynom;
  TPolynom = Record
    Name : String;
    Data : PXStep;
    Next : PPolynom;
  End;

Const Polynoms : PPolynom = nil;

Var ListWindow : WindowPtr;

{ --- ����⮦���� ��� ��������� --- }
Procedure DeleteAllPolynoms;
{ --- C������� ᯨ᪠ ��������� --- }
Procedure List_Polynom;
{ --- �������� ������ �������� --- }
Procedure New_Polynom;
{ --- �뢮� �������� �� ��࠭ --- }
Procedure Show_Polynom;
{ --- ������஢���� �������� --- }
Procedure Edit_Polynom;
{ --- �������� �������� --- }
Procedure Del_Polynom;
{ --- �������� ��������� --- }
Procedure Add_Polynom;
{ --- ���⠭�� ��������� --- }
Procedure Sub_Polynom;
{ --- ����஢�� �������� --- }
Procedure Sort_Polynom;

Implementation

{ --- ���������� �������� --- }
Function AddPolynom( NewPolynomName : String ) : PPolynom;
  Var NewEl, Cur : PPolynom;
  Begin
   { ������� ���� ������� � ������塞 ��� ���� }
    New(NewEl);
    NewEl^.Name := NewPolynomName;
    NewEl^.Data := nil;
    NewEl^.Next := nil;
   { �����頥� 㪠��⥫� �� ��� ������� }
    AddPolynom := NewEl;
   { �᫨ ᯨ᮪ ���⮩ => �⠢�� ���� ������� � ��砫� ᯨ᪠ }
    If Polynoms = nil then  Begin  Polynoms := NewEl; Exit; End;
   { ���� => �饬 ��᫥���� �������騩 ������� ... }
    Cur := Polynoms;
    While Cur^.Next <> nil do Cur := Cur^.Next;
   { ... � ������塞 ���� ������� � ����� }
    Cur^.Next := NewEl;
  End;

{ --- ����⮦���� ��� ��������� --- }
Procedure DeleteAllPolynoms;
  Var Buf : PPolynom;
  Begin
    While Polynoms <> nil do
      Begin
        Buf := Polynoms;
        Polynoms := Polynoms^.Next;
        DelPol(Buf^.Data);
        Dispose(Buf);
      End;
  End;

{ --- �������� ��।�������� �������� --- }
Procedure DelPolynom( Name : String );
  Var Cur, Buf : PPolynom;
  Begin
    Cur := Polynoms;
    Buf := nil;
    While Cur <> nil do
      Begin
        If Cur^.Name = Name then
          Begin
            If Buf <> nil then
              Buf^.Next := Cur^.Next
            Else
              Polynoms := Cur^.Next;
            Dispose(Cur);
            Exit;
          End;
        Buf := Cur;
        Cur := Cur^.Next;
      End;
  End;

{ --- ����� ������� ---}
Function GetPolynom( Name : String ) : PPolynom;
  Var Cur : PPolynom;
  Begin
    Cur := Polynoms;
    While Cur <> nil do
      Begin
        If Cur^.Name = Name then
          Begin
            GetPolynom := Cur;
            Exit;
          End;
        Cur := Cur^.Next;
      End;
    GetPolynom := nil;
  End;

{ --- �������� ᯨ᪠ ��������� --- }
Procedure List_Polynom;
  Var Cur : PPolynom;
  Begin
    ActivateWindow(ListWindow);
    ClrScr;
    Cur := Polynoms;
    While Cur <> nil do
      Begin
        Writeln(Cur^.Name);
        Cur := Cur^.Next;
      End;
  End;

{ --- �஢�ઠ �� Esc --- }
Procedure ReadEscape( Str : String; Var Esc : boolean; Var S : String );
 Begin
  S:='';
  ReadString (Str, 7, 23, 17, $0F, $0F, $0F, Esc, S);
 End;

{ --- �������� �������� --- }
Procedure New_Polynom;
  Var Window : WindowPtr; S : String; Esc : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '���� ������ ��������');
    DisplayWindow(Window);
    ReadEscape('������ ���: ', Esc, S);
    If Esc then
      Begin
        KillWindow(Window);
        Exit;
      End;
    If Length(S)=0 then
      ErrorMessage('          ��� �� ����� ���� ����� !')
    Else
      If GetPolynom(S) <> nil then
        ErrorMessage('  ������� � ⠪�� ������ 㦥 ������� !')
    Else
      Begin
        KillWindow(Window);
        PolynomEdit('���� �������� "' + S + '"', AddPolynom(S)^.Data);
      End;
    KillWindow(Window);
  End;

{ --- �뢮� �������� --- }
Procedure Show_Polynom;
  Var Window : WindowPtr; S : String; C : PPolynom; Esc : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '�뢮� �������� �� ��࠭');
    DisplayWindow(Window);
    ReadEscape('������ ���: ', Esc, S);
    If Esc then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C := GetPolynom(S);
    If C<>nil then
      Begin
        KillWindow(Window);
        PolynomShow('��ᬮ�� "' + S + '"', C^.Data)
      End
      Else
        ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
    KillWindow(Window);
  End;

{ --- �������� �������� --- }
Procedure Del_Polynom;
  Var Window : WindowPtr; S : String; C : PPolynom; Esc : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '�������� ��������');
    DisplayWindow(Window);
    ReadEscape('������ ���: ', Esc, S);
    If Esc then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C := GetPolynom(S);
    If C <> nil then
      DelPolynom(S)
    Else
      ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
    KillWindow(Window);
  End;

{ --- ������஢���� ��������� ---- }
Procedure Edit_Polynom;
  Var Window : WindowPtr; S : String; C : PPolynom; Esc : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '������஢���� ��������');
    DisplayWindow(Window);
    ReadEscape('������ ���: ', Esc, S);
    If Esc then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C := GetPolynom(S);
    If C <> nil then
      Begin
        KillWindow(Window);
        PolynomEdit('������஢���� "' + S + '"', C^.Data)
      End
    Else
      ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
    KillWindow(Window);
  End;

{ ---  �������� ��������� --- }
Procedure Add_Polynom;
  Var Window : WindowPtr;
      S1, S2, S3 : String;
      C1, C2, C3 : PPolynom;
      T1, T2 : PXStep;
      D1, D2, D3 : PDigit;
      Esc1, Esc2, Esc3 : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '�������� ���������');
    DisplayWindow(Window);
    ReadEscape('������ ��� 1-��� ��������: ', Esc1, S1);
    If Esc1 then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C1 := GetPolynom(S1);
    If C1 = nil then
      Begin
        ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
        KillWindow(Window); Exit;
      End;
    ReadEscape('������ ��� 2-��� ��������: ', Esc2, S2);
    If Esc2 then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C2 := GetPolynom(S2);
    If C2 = nil then
      Begin
        ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
        KillWindow(Window); Exit;
      End;
    ReadEscape('������ ��� ��������-�㬬�: ', Esc3, S3);
    If Esc3 then
      Begin
        KillWindow(Window);
        Exit;
      End;
    If GetPolynom(S3) <> nil then
      Begin
        ErrorMessage('  ������� � ⠪�� ������ 㦥 ������� !');
        KillWindow(Window); Exit;
      End;
    ClrScr;
    If (not Esc1) and (not Esc2) and (not Esc3) then
      Begin
        C3 := AddPolynom(S3);
        T1 := C1^.Data;
        While T1 <> nil do
          Begin
            D1 := Get_X_Step(C1^.Data, T1^.Step);
            D2 := Get_X_Step(C2^.Data, T1^.Step);
            If D2 = nil then MakeCoef(D2, '0');
            D3 := AddCoef(D1, D2);
            MakeXStep(C3^.Data, ShowCoef(D3), T1^.Step);
            T1 := T1^.NextStep;
          End;
        T2 := C2^.Data;
        While T2 <> nil do
          Begin
            D1 := Get_X_Step(C1^.Data, T2^.Step);
            D2 := Get_X_Step(C2^.Data, T2^.Step);
            If D1 = nil then
            MakeXStep(C3^.Data, ShowCoef(D2), T2^.Step);
            T2 := T2^.NextStep;
          End;
        KillWindow(Window);
        SortPolynom(C3^.Data);
        PolynomShow('��ᬮ�� "' + S3 + '"', C3^.Data);
      End;
    KillWindow(Window);
  End;

{ --- ���⠭�� ��������� --- }
Procedure Sub_Polynom;
  Var Window : WindowPtr;
      S1, S2, S3 : String;
      C1, C2, C3 : PPolynom;
      T1, T2 : PXStep;
      D1, D2, D3 : PDigit;
      Esc1, Esc2, Esc3 : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '���⠭�� ���������');
    DisplayWindow(Window);
    ReadEscape('������ ��� 1-��� ��������: ', Esc1, S1);
    If Esc1 then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C1 := GetPolynom(S1);
    If C1 = nil then
      Begin
        ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
        KillWindow(Window); Exit;
      End;
    ReadEscape('������ ��� 2-��� ��������: ', Esc2, S2);
    If Esc2 then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C2 := GetPolynom(S2);
    If C2 = nil then
      Begin
        ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
        KillWindow(Window); Exit;
      End;
    ReadEscape('������ ��� ��������-ࠧ����: ', Esc3, S3);
    If Esc3 then
      Begin
        KillWindow(Window);
        Exit;
      End;
    If GetPolynom(S3) <> nil then
      Begin
        ErrorMessage('  ������� � ⠪�� ������ 㦥 ������� !');
        KillWindow(Window); Exit;
      End;
    ClrScr;
    If (not Esc1) and (not Esc2) and (not Esc3) then
      Begin
        C3 := AddPolynom(S3);
        T1 := C1^.Data;
        While T1 <> nil do
          Begin
            D1 := Get_X_Step(C1^.Data, T1^.Step);
            D2 := Get_X_Step(C2^.Data, T1^.Step);
            If D2 = nil then MakeCoef(D2, '0');
            D3 := SubCoef(D1, D2);
            MakeXStep(C3^.Data, ShowCoef(D3), T1^.Step);
            T1 := T1^.NextStep;
          End;
        T2 := C2^.Data;
        While T2 <> nil do
          Begin
            D1 := Get_X_Step(C1^.Data, T2^.Step);
            D2 := Get_X_Step(C2^.Data, T2^.Step);
            If D1 = nil then
              Begin
                MakeCoef(D1,'0');
                D3 := SubCoef(D1, D2);
                MakeXStep(C3^.Data, ShowCoef(D3), T2^.Step);
              End;
            T2 := T2^.NextStep;
          End;
        KillWindow(Window);
        SortPolynom(C3^.Data);
        PolynomShow('��ᬮ�� "' + S3 + '"', C3^.Data);
      End;
    KillWindow(Window);
  End;

{ --- ����஢�� �������� --- }
Procedure Sort_Polynom;
  Var Window : WindowPtr; S : String; C : PPolynom; Esc : boolean;
  Begin
    MakeWindow(Window, 22, 6, 70, 10, True, True, False, $07, $07, $0F,
      '����஢�� �����樥�⮢ ��������');
    DisplayWindow(Window);
    ReadEscape('������ ���: ', Esc, S);
    If Esc then
      Begin
        KillWindow(Window);
        Exit;
      End;
    C := GetPolynom(S);
    If C<>nil then
      Begin
        SortPolynom(C^.Data);
        KillWindow(Window);
        PolynomShow('��ᬮ�� "' + S + '"', C^.Data);
      End
    Else
      ErrorMessage('  �������� � ⠪�� ������ �� ������� !');
    KillWindow(Window);
  End;

End.
