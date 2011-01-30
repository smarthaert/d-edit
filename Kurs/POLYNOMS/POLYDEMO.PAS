{ �����������������������������������������������������������������������ͻ }
{ � �                   P O L Y N O M 'S   D E M O                      � � }
{ � �                          Version 3.11                             � � }
{ �����������������������������������������������������������������������ͼ }

Uses CRT,Polynoms;

{ = = = ����⢨⥫쭮� ��᫮ ��� ��ப� = = = }
Function Real_As_String( R:Real_Type ):String;
  Var Result:String;
  Begin
    Str(R:0:0,Result);
    Real_As_String:=Result;
  End;

{ = = = �������᭮� ��᫮ ��� ��ப� = = = }
Function Complex_As_String( C:Complex ):String;
  Var Result:String;
  Begin
    Result:=Real_As_String(C^.Re);
    If C^.Im>0 then Result:=Result+'+'+Real_As_String(C^.Im)+'i';
    If C^.Im<0 then Result:=Result+Real_As_String(C^.Im)+'i';
    Complex_As_String:=Result;
  End;

{ = = = �뢮� �������� �� ��࠭ = = = }
Procedure Show_Polynom( P:Polynom );
  Var I:Word;
  Begin
    Write('Polynom :  Deg = ',P^.Deg,'  Coef : ');
    For I:=P^.Deg downto 0 do Write(P^.G(I):0:4,'; ');
    Writeln;
  End;

{ = = = �뢮� ���ᨢ� ����⢨⥫��� ��ᥫ = = = }
Procedure Show_Array( P:Array_Of_Real );
  Var I:Word;
  Begin
    Write(' Array : ');
    For I:=1 to P^.Num do Write(P^.G(I):0:8,'; ');
    Writeln;
  End;

{ = = = �த������� = = = }
Procedure _Continue_;
  Begin
    Writeln;
    TextColor(14);
    Write(' >>> Press Any Key to Continue, Please ! <<< ');
    ReadKey;
    TextColor(7);
    Writeln;
    Writeln;
  End;

{ = = = ���������� = = = }
Procedure Header( _Header_:String );
  Var I:Byte;
  Begin
    ClrScr;
    TextColor(11);
    Writeln('  ',_Header_);
    TextColor(9);
    Write(' ');
    For I:=1 to (Length(_Header_)+2) do Write('=');
    TextColor(7);
    Writeln;
    Writeln;
  End;

{ = = = ����� / ����� = = = }
Procedure Min_Max_Sign_Demo;
  Var I,A,B:Integer;
  Begin
    Header('Min Max Sign Demo');
    For I:=1 to 5 do
      Begin
        A:=Random(256);
        B:=Random(256);
        Writeln(' ��᫠ ',A:4,', ',B:3,'  Min ',Min(A,B):4:0,'  Max ',Max(A,B):4:0);
      End;
    Writeln('=====================================');
    For I:=-5 to 5 do
      Writeln('   ���� (Sign) �� �᫠ ',I,' ࠢ�� ',Sign(I));
    _Continue_;
  End;

{ = = = ��������� ��᫠ = = = }
Procedure Complex_Numbers_Demo;
  Var A,B,C,D,E,F:Complex; I:Byte;
  Begin
    Header('Complex Numbers Demo');
    For I:=1 to 4 do
      Begin
        A:=cSet(LongInt(Random(10))-5,LongInt(Random(10))-5);
        B:=cSet(LongInt(Random(10))-5,LongInt(Random(10))-5);
        C:=cAdd(A,B); D:=cSub(A,B); E:=cMul(A,B); F:=cDiv(A,B);
        Writeln('��᫠ : ',Complex_As_String(A):20,' � ',Complex_As_String(B):20);
        Writeln('    Add ',Complex_As_String(C):20,' Sub ',Complex_As_String(D):20);
        Writeln('    Mul ',Complex_As_String(E):20,' Div ',Complex_As_String(F):20);
        Writeln;
        Dispose(A); Dispose(B); Dispose(C); Dispose(D); Dispose(E); Dispose(F);
      End;
    _Continue_;
  End;

{ = = = �������� = = = }
Procedure Polynoms_Demo;
  Var Test:Polynom; Roots:Array_Of_Real;
  Begin
    Header('Polynoms Demo');
    New(Test,Init(5));
    Test^.S(5,1);
    Test^.S(4,0);
    Test^.S(3,1);
    Test^.S(2,0);
    Test^.S(1,0);
    Test^.S(0,-1);
    Find_Root_Limit:=0.000000001;
    Roots:=Polynom_Real_Roots(Test);
    Show_Array(Roots);
    Dispose(Roots,Done);
    Dispose(Test,Done);
    _Continue_;
  End;

{ = = = �᭮���� �ணࠬ�� = = = }
Begin
  Randomize;
  Min_Max_Sign_Demo;
  Complex_Numbers_Demo;
  Polynoms_Demo;
  Runtime_Error('����� ��������樮���� �ணࠬ�� !');
End.