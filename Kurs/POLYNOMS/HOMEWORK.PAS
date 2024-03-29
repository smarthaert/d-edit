{ HomeWork For SNV (Smirnova Natalya Victorovna) }
Uses Polynoms,Polynom_;

 { = = = ���� ��� ����⢨⥫��� ��p��� = = = }
  Function Real_Roots( P:Polynom ):Array_Of_Real;
    Var Result:Array_Of_Real;	 { ��p�� �p������� }
	Temp:Array_Of_Real;	 { ��p�� �p������� � ����饭�ﬨ �� �訡�� }
	_Derive : Polynom;	 { �p��������� }
	Min_Max : Array_Of_Real; { ��窨 ����㬠 / ����㬠 }
	C,I:Word;		 { ���稪� }
	Minus_Limit:ShortInt;	 { ���� �������� �p� X -> -��᪮��筮�� }
	Plus_Limit:ShortInt;	 { ���� �������� �p� X -> +��᪮��筮�� }
	L,X,Y,DL,UL:Real_Type;	 { DL - ������ �p����  UL - ��p娩 }
    Begin
      Writeln(Q,'Polynom Real Roots');
      If P^.Deg=0 then { ��p���⪠ �訡�� }
	Begin
	  New(Result,Init(0));
	  Real_Roots:=Result;
	  Writeln(Q,'��ࠡ�⪠ �訡��');
	  Exit;
	End;
      If P^.Deg=1 then { ��p���⪠ ��������� �p������� }
	Begin
	  If P^.G(1)<>0 then
	    Begin
	      New(Result,Init(1));
	      Result^.S(1,-(P^.G(0)/P^.G(1)));
	    End
	  Else
	    New(Result,Init(0));
	  Writeln(Q,'��ࠡ�⪠ ��������� �ࠢ����� ',P^.G(1),'X + ',P^.G(0));
	  Real_Roots:=Result;
	  Exit;
	End;
     { * * * ��p���⪠ ���������� ��������� * * * }
      Writeln(Q,'��ࠡ�⪠ ���������� ���������');
     { 1. ��६ �ந������� }
      _Derive:=Derive(P);
      _Show_Polynom(P);
      Writeln(Q,'�ந�������');
      _Show_Polynom(_Derive);
     { 2. ��室�� �� ��୨ - ����६�� }
      Min_Max:=Real_Roots(_Derive);
      Writeln(Q,'��୨');
      _Show_Array(Min_Max);
     { 3. ��室�� ����� �p������ �������� �� ��᪮��筮�� }
      Plus_Limit:=Round(P^.Plus_Limit);
      Minus_Limit:=Round(P^.Minus_Limit);
      Writeln(Q,'�।�� �� +��᪮��筮�� ',Plus_Limit);
      Writeln(Q,'�।�� �� -��᪮��筮�� ',Minus_Limit);
     { 4. �饬 �࠭��� �������� }
      If Min_Max^.Num>0 then
	Begin
	 { ���� ������ �p����� }
	  L:=1; X:=Min_Max^.G(1); Y:=P^.Value(X);
	  If Minus_Limit*Y>=0 then
	    DL:=X
	  Else
	    Repeat L:=L*2; DL:=X-L; Until P^.Value(DL)*Y<=0;
	 { ���� ��p孥� �p����� }
	  L:=1; X:=Min_Max^.G(Min_Max^.Num); Y:=P^.Value(X);
	  If Plus_Limit*Y>=0 then
	    UL:=X
	  Else
	    Repeat L:=L*2; UL:=X+L; Until P^.Value(UL)*Y<=0;
	End;
      Writeln(Q,'�।��� ',DL,' - ',UL);
     { ���� ��p��� �� �p�����⪠� ���p��⠭�� / �뢠��� }
      New(Temp,Init(_Derive^.Deg+1));
      Writeln(Q,'����६㬮� ',Min_Max^.Num);
      Case Min_Max^.Num of
	0:   { ��� ����p��㬮� }
	  Begin
	    Y:=P^.Value(0);
	    If Y<>0 then
	      Begin
		X:=Y*_Derive^.Value(0); L:=1;
		Repeat L:=L*2; Until P^.Value(-X*L)*Y<=0;
		If X>0 then
		  Temp^.S(1,P^.Find_Root(0,-X*L))
		Else
		  Temp^.S(1,P^.Find_Root(-X*L,0));
	      End
	    Else
	      Temp^.S(1,0);
	  End;
	1:   { 1 ����p��� }
	  Begin
	    Temp^.S(1,P^.Find_Root(DL,Min_Max^.G(1)));
	    Temp^.S(2,P^.Find_Root(Min_Max^.G(1),UL));
	  End;
	Else { ����� ����p��㬮� }
	  Begin
	    Temp^.S(1,P^.Find_Root(DL,Min_Max^.G(1)));
	    For C:=2 to Temp^.Num-1 do
	       Temp^.S(C,P^.Find_Root(Min_Max^.G(C-1),Min_Max^.G(C)));
	    Temp^.S( Temp^.Num,P^.Find_Root(Min_Max^.G(1),UL));
	  End;
      End;
      Writeln(Q,'Temp');
      _Show_Array(Temp);
      I:=0;
      For C:=1 to Temp^.Num do
	If Temp^.G(C)<>Max_Real then
	  Begin Inc(I); Temp^.S(I,Temp^.G(C)); End;
      New( Result, Init(I) );
      For C:=1 to I do Result^.S(C,Temp^.G(C));
      Writeln(Q,'Result');
      _Show_Array(Result);
      Dispose( Temp, Done );
      Dispose( _Derive, Done );
      Dispose( Min_Max, Done );
      Real_Roots:=Result;
    End;

Procedure MyExitProc; Far;
  Begin
    Close(Q);
    Writeln('Exit');
  End;

Function F( X:Real ):Real;
  Begin
    F:=Sqrt(4*x*x + 7*x + 3) - Sqrt(2*x*x - 8*x + 17) - 4;
  End;

Var A,B,SumAB,MulAB,Temp,Summ,Mull,S,C,M:Polynom; T:Array_Of_Real;
Begin
  ExitProc:=@MyExitProc;
  Assign(Q,'PROCESS.TXT');
  Rewrite(Q);
  New(Temp,Init(0));
  New(A,Init(2)); With A^ do Begin S(2,4); S(1,7); S(0,3); End;
  New(B,Init(2)); With B^ do Begin S(2,2); S(1,-8); S(0,17); End;
  SumAB:=pAdd(A,B); MulAB:=pMul(A,B);
  Temp^.S(0,16);
  Summ:=pSub(SumAB,Temp);
  Temp^.S(0,4);
  Mull:=pMul(MulAB,Temp);
  S:=pMul(Summ,Summ);
  C:=pSub(S,Mull);
  Find_Root_Limit:=0.00000000001;
  T:=Real_Roots(C);
  Write('A = '); Show_Polynom(A);
  Write('B = '); Show_Polynom(B);
  Write('SumAB = '); Show_Polynom(SumAB);
  Write('MulAB = '); Show_Polynom(MulAB);
  Write('C = '); Show_Polynom(C);
  Write('T = '); Show_Array(T);
  Writeln('F = ',F(1.64));
End.