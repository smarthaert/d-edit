{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                 P O L Y N O M 'S   L I B R A R Y                  � � }
{ � �                          Version 3.11                             � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

Unit Polynoms;

Interface

 { = = = �｀� � ��痰ガ� = = = }
  Procedure Runtime_Error( Message:String );

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖          �ォ痰※皀�讚襯 ��甄�           崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = �ォ痰※皀�讚�� ��甄� = = = }
  Type Real_Type = Extended;

 { = = = ��─��跏ゥ �ォ痰※皀�讚�� ��甄� = = = }
  Const Max_Real : Real_Type = 1.1E4932;

 { = = = �┃�祠 ├ 2-� �ォ痰※皀�讚諷 ��瓮� = = = }
  Function Min( Real_1,Real_2:Real_Type ):Real_Type;

 { = = = ���瓱祠 ├ 2-� �ォ痰※皀�讚諷 ��瓮� = = = }
  Function Max( Real_1,Real_2:Real_Type ):Real_Type;

 { = = = ���� �ォ痰※皀�讚��� ��甄� = = = }
  Function Sign( Real_Number:Real_Type ):ShortInt;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖           �����オ甅襯 ��甄�             崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = �����オ甅�� ��甄� = = = }
  Type Complex = ^Complex_Block;
       Complex_Block = Record
         Re,Im : Real_Type;
       End;

 { = = = �痰���→� = = = }
  Function cSet( Re,Im:Real_Type ):Complex;

 { = = = �祠�� = = = }
  Function cAdd( C1,C2:Complex ):Complex;

 { = = = ��Л�痰� = = = }
  Function cSub( C1,C2:Complex ):Complex;

 { = = = �p�├▲ぅ�┘ = = = }
  Function cMul( C1,C2:Complex ):Complex;

 { = = = ��痰��� = = = }
  Function cDiv( C1,C2:Complex ):Complex;

 { = = = ���む�� = = = }
  Function cSqr( C:Complex ):Complex;
  
 { = = = ��爛�� = = = }
  Function cSqrt( C:Complex ):Complex;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖       ��瘁│ �ォ痰※皀�讚諷 ��瓮�       崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = ���瓱���讚覃 ��Кム ��瘁│� = = = }
  Const Array_Of_Real_Size = 65535 div SizeOf(Real_Type);

 { = = = �┓ ��瘁│ �ォ痰※皀�讚諷 ��瓮� = = = }
  Type T_Array_Of_Real = Array [1..Array_Of_Real_Size] of Real_Type;
       P_Array_Of_Real = ^T_Array_Of_Real;

 { = = = ��瘁│ �ォ痰※皀�讚諷 ��瓮� = = = }
  Type Array_Of_Real = ^Array_Of_Real_Block;
       Array_Of_Real_Block = Object
        { ����腑痰〓 ��ガキ皰� }
         Num:Word;
        { ���甌� ��ガキ皰� }
         List:P_Array_Of_Real;
        { �癶イキ┘ ���閧� ��� ���甌� ��ガキ皰� }
         Constructor Init( Elements_Num:Word );
        { �砒�痰�� � ���p謔┘ ���瓷� ��ガキ皰� }
         Destructor Done;
        { �Кキキ┘ ���腑��� ��ガキ�� }
         Procedure S( N:Word; New_Value:Real_Type );
        { �腮硅���┘ ���腑��� ��ガキ�� ���ム N }
         Function G( N:Word ):Real_Type;
       End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖        ��瘁│ �����オ甅諷 ��瓮�         崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = ���瓱���讚覃 ��Кム ��瘁│� = = = }
  Const Array_Of_Complex_Size = 65535 div SizeOf(Complex_Block);

 { = = = �┓ ��瘁│ �����オ甅諷 ��瓮� = = = }
  Type T_Array_Of_Complex = Array [1..Array_Of_Complex_Size] of Complex_Block;
       P_Array_Of_Complex = ^T_Array_Of_Complex;

 { = = = ��瘁│ �����オ甅諷 ��瓮� = = = }
  Type Array_Of_Complex = ^Array_Of_Complex_Block;
       Array_Of_Complex_Block = Object
        { ����腑痰〓 ��ガキ皰� }
         Num:Word;
        { ���甌� ��ガキ皰� }
         List:P_Array_Of_Complex;
        { �癶イキ┘ ���閧� ��� ���甌� ��ガキ皰� }
         Constructor Init( Elements_Num:Word );
        { �砒�痰�� � ���p謔┘ ���瓷� ��ガキ皰� }
         Destructor Done;
        { �Кキキ┘ ���腑��� ��ガキ�� }
         Procedure S( N:Word; New_Value:Complex );
        { �腮硅���┘ ���腑��� ��ガキ�� ���ム N }
         Function G( N:Word ):Complex;
       End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖             ｡譽�� ���┃��              崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = ��膈�痰� ���瓷� ��p�ォ = = = }
  Var Find_Root_Limit : Real_Type;

 { = = = ｡譽�� ���┃�� = = = }
  Type Polynom = ^Polynom_Block;
       Polynom_Block = Object( Array_Of_Real_Block )
        { ���罔��├�罔� ���瓷� ��辟筥罔キ皰� }
         Constructor Init( _Deg:Word );
        { �皀�キ� ���┃��� }
         Function Deg:Integer;
        { �Кキキ┘ ���腑��� ��辟筥罔キ�� �ムイ X � �皀�キ� N }
         Procedure S( N:Word; New_Value:Real_Type );
        { �腮硅���┘ ���腑��� ��辟筥罔キ�� ��pイ X � �皀�キ� N }
         Function G( N:Word ):Real_Type;
        { �諛�甄キ┘ ���腑��� ���┃��� �p� �������� X }
         Function Value( X:Real_Type ):Real_Type;
        { ���瓷 ､���� ��p�� �モ�ぎ� ��絎皰�┬ �� �p��ウ竄�� [A..B] }
         Function Find_Root( A,B:Real_Type ):Real_Type;
        { ���� �爛ぅ�� ���┃��� �� +�メ���ョ��痰� }
         Function Plus_Limit:Real_Type;
        { ���� �爛ぅ�� ���┃��� �� -�メ���ョ��痰� }
         Function Minus_Limit:Real_Type;
       End;

 { = = = �祠�� ���┃���� = = = }
  Function pAdd( A,B:Polynom ):Polynom;

 { = = = ��Л�痰� ���┃���� = = = }
  Function pSub( A,B:Polynom ):Polynom;

 { = = = �p�├▲ぅ�┘ ���┃���� = = = }
  Function pMul( A,B:Polynom ):Polynom;

 { = = = �p�├〓き�� = = = }
  Function Derive( P:Polynom ):Polynom;

 { = = = �ギ�pイカキ�覃 ��皀�p�� = = = }
  Function Integral( P:Polynom; C:Real_Type ):Polynom;

 { = = = ｯpイカキ�覃 ��皀�p�� = = = }
  Function DefineIntegral( P:Polynom; A,B:Real_Type ):Real_Type;

 { = = = ���瓷 �瓮� �ォ痰※皀�讚諷 ��p�ォ = = = }
  Function Polynom_Real_Roots( P:Polynom ):Array_Of_Real;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖       ｡譽�� �����オ甅覃 ���┃��        崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = ｡譽�� �����オ甅覃 ���┃�� = = = }
  Type Complex_Polynom = ^Complex_Polynom_Block;
       Complex_Polynom_Block = Object( Array_Of_Complex_Block )
        { ���罔��├�罔� ���瓷� ��辟筥罔キ皰� }
         Constructor Init( _Deg:Word );
        { �皀�キ� ���┃��� }
         Function Deg:Integer;
        { �Кキキ┘ ���腑��� ��辟筥罔キ�� �ムイ X � �皀�キ� N }
         Procedure S( N:Word; New_Value:Complex );
        { �腮硅���┘ ���腑��� ��辟筥罔キ�� ��pイ X � �皀�キ� N }
         Function G( N:Word ):Complex;
        { �諛�甄キ┘ ���腑��� ���┃��� �p� �������� X }
         Function Value( X:Complex ):Complex;
       End;

 { = = = �祠�� ���┃���� = = = }
  Function cpAdd( A,B:Complex_Polynom ):Complex_Polynom;

 { = = = ��Л�痰� ���┃���� = = = }
  Function cpSub( A,B:Complex_Polynom ):Complex_Polynom;

 { = = = �p�├▲ぅ�┘ ���┃���� = = = }
  Function cpMul( A,B:Complex_Polynom ):Complex_Polynom;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖   ｡譽�� �牀´�-���┃�����讚�� �祗�罔�  崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = ｡譽�� �牀´�-���┃�����讚�� �祗�罔� = = = }
  Type A_Polynom = ^A_Polynom_Block;
       A_Polynom_Block = Object
         Up,Down:Polynom; { ��甄�皀�� � Л��キ�皀�� む�； }
        { ���罔��├�罔� ���瓷� ��辟筥罔キ皰� }
         Constructor Init( Up_Deg,Down_Deg:Word );
        { �砒�痰�� � ���p謔┘ ���瓷� ��辟筥罔キ皰� }
         Destructor Done;
        { �Кキキ┘ ���腑��� ��辟筥罔キ�� ��甄�皀�� ��pイ X � �皀�キ� N }
         Procedure SU( N:Word; NewValue:Real_Type );
        { �Кキキ┘ ���腑��� ��辟筥罔キ�� ����キ�皀�� ��pイ X � �皀�キ� N }
         Procedure SD( N:Word; NewValue:Real_Type );
        { �腮硅���┘ ���腑��� ��辟筥罔キ�� ��甄�皀�� ��pイ X � �皀�キ� N }
         Function GU( N:Word ):Real_Type;
        { �腮硅���┘ ���腑��� ��辟筥罔キ�� ����キ�皀�� ��pイ X � �皀�キ� N }
         Function GD( N:Word ):Real_Type;
        { �諛�甄キ┘ ���腑��� �p� �������� X }
         Function Value( X:Real_Type ):Real_Type;
        { �ォ痰※皀�讚襯 ��爿� }
         Function Real_Roots:Array_Of_Real;
       End;

 { = = = �祠�� �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function apAdd( A,B:A_Polynom ):A_Polynom;

 { = = = ��Л�痰� �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function apSub( A,B:A_Polynom ):A_Polynom;

 { = = = �p�├▲ぅ�┘ �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function apMul( A,B:A_Polynom ):A_Polynom;

 { = = = �p�├〓き�� �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function aDerive( P:A_Polynom ):A_Polynom;

{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }
{ <><><><><><><><><><> } Implementation { <><><><><><><><><><> }
{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }

 { = = = �｀� � ��痰ガ� = = = }
  Procedure Runtime_Error( Message:String );
    Begin
      Asm Mov AX,0003h; Int 10h; End; { Reset Text Mode }
      Writeln('Runtime Error : ',Message);
      Halt(1);
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖          �ォ痰※皀�讚襯 ��甄�           崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = �┃�祠 ├ 2-� �ォ痰※皀�讚諷 ��瓮� = = = }
  Function Min( Real_1,Real_2:Real_Type ):Real_Type;
    Begin
      If Real_1 < Real_2 then Min:=Real_1 Else Min:=Real_2;
    End;

 { = = = ���瓱祠 ├ 2-� �ォ痰※皀�讚諷 ��瓮� = = = }
  Function Max( Real_1,Real_2:Real_Type ):Real_Type;
    Begin
      If Real_1 > Real_2 then Max:=Real_1 Else Max:=Real_2;
    End;

 { = = = ���� �ォ痰※皀�讚��� ��甄� = = = }
  Function Sign( Real_Number:Real_Type ):ShortInt;
    Begin
      If Real_Number>0 then Sign:=1;
      If Real_Number=0 then Sign:=0;
      If Real_Number<0 then Sign:=-1;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖           �����オ甅襯 ��甄�             崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

 { = = = �痰���→� = = = }
  Function cSet( Re,Im:REal_Type ):Complex;
    Var Result:Complex;
    Begin
      New(Result);
      Result^.Re:=Re;
      Result^.Im:=Im;
      cSet:=Result;
    End;

 { = = = �祠�� = = = }
  Function cAdd( C1,C2:Complex ):Complex;
    Var Result:Complex;
    Begin
      New(Result);
      Result^.Re:=C1^.Re+C2^.Re;
      Result^.Im:=C1^.Im+C2^.Im;
      cAdd:=Result;
    End;

 { = = = ��Л�痰� = = = }
  Function cSub( C1,C2:Complex ):Complex;
    Var Result:Complex;
    Begin
      New(Result);
      Result^.Re:=C1^.Re-C2^.Re;
      Result^.Im:=C1^.Im-C2^.Im;
      cSub:=Result;
    End;

 { = = = �p�├▲ぅ�┘ = = = }
  Function cMul( C1,C2:Complex ):Complex;
    Var Result:Complex;
    Begin
      New(Result);
      Result^.Re:=C1^.Re*C2^.Re-C1^.Im*C2^.Im;
      Result^.Im:=C1^.Re*C2^.Im+C1^.Im*C2^.Re;
      cMul:=Result;
    End;

 { = = = ��痰��� = = = }
  Function cDiv( C1,C2:Complex ):Complex;
    Var Result:Complex; Temp:Real_Type;
    Begin
      New(Result);
      Temp:=Sqr(C2^.Re)+Sqr(C2^.Im);
      If Temp<>0 then
        Begin
          Result^.Re:=(C1^.Re*C2^.Re+C1^.Im*C2^.Im)/Temp;
          Result^.Im:=(C1^.Im*C2^.Re-C1^.Re*C2^.Im)/Temp;
        End
      Else
        Runtime_Error('�カキ┘ �� ���� !');
      cDiv:=Result;
    End;

 { = = = ���む�� = = = }
  Function cSqr( C:Complex ):Complex;
    Begin
      cSqr:=cMul(C,C);
    End;
  
 { = = = ��爛�� = = = }
  Function cSqrt( C:Complex ):Complex;
    Var Result:Complex; Temp:Real_Type;
    Begin
      New(Result);
      Temp:=Sqrt(Sqr(C^.Re)+Sqr(C^.Im));
      Result^.Re:=Sqrt((Temp+C^.Re)/2);
      Result^.Im:=Sign(C^.Im)*Sqrt((Temp-C^.Re)/2);
      cSqrt:=Result;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖       ��瘁│ �ォ痰※皀�讚諷 ��瓮�       崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

  Constructor Array_Of_Real_Block.Init;
    Var Size:Word;
    Begin
      If Elements_Num > Array_Of_Real_Size then
        Runtime_Error('��Г��┘ ���茯�� ���跏��� ��瘁│� !');
      Num:=Elements_Num;
      Size:=Num*SizeOf(Real_Type);
      If Size > MaxAvail then
        Runtime_Error('�イ�痰�皰膈� ���閧� ��� ��Г���� ��瘁│� !');
      GetMem(List,Size);
    End;

  Destructor Array_Of_Real_Block.Done;
    Begin
      FreeMem(List,Num*SizeOf(Real_Type));
    End;

  Procedure Array_Of_Real_Block.S;
    Begin
      If N <= Num then
        List^[N]:=New_Value
      Else
        Runtime_Error('�痰���→� ���腑��� �メ竕メ癶竡薀�� ��ガキ�� !');
    End;

  Function Array_Of_Real_Block.G;
    Var Result:Complex;
    Begin
      If N <= Num then
        G:=List^[N]
      Else
        Runtime_Error('�腮硅���┘ ���腑��� �メ竕メ癶竡薀�� ��ガキ�� !');
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖        ��瘁│ �����オ甅諷 ��瓮�         崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

  Constructor Array_Of_Complex_Block.Init;
    Var Size:Word;
    Begin
      If Elements_Num > Array_Of_Complex_Size then
        Runtime_Error('��Г��┘ ���茯�� ���跏��� ��瘁│� !');
      Num:=Elements_Num;
      Size:=Num*SizeOf(Complex_Block);
      If Size > MaxAvail then
        Runtime_Error('�イ�痰�皰膈� ���閧� ��� ��Г���� ��瘁│� !');
      GetMem(List,Size);
    End;

  Destructor Array_Of_Complex_Block.Done;
    Begin
      FreeMem(List,Num*SizeOf(Complex_Block));
    End;

  Procedure Array_Of_Complex_Block.S;
    Begin
      If N <= Num then
        List^[N]:=New_Value^
      Else
        Runtime_Error('�痰���→� ���腑��� �メ竕メ癶竡薀�� ��ガキ�� !');
    End;

  Function Array_Of_Complex_Block.G;
    Var Result:Complex;
    Begin
      If N <= Num then
        Begin
          New(Result);
          Result^:=List^[N];
          G:=Result;
        End
      Else
        Runtime_Error('�腮硅���┘ ���腑��� �メ竕メ癶竡薀�� ��ガキ�� !');
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖             ｡譽�� ���┃��              崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

  Constructor Polynom_Block.Init;
    Begin
      Inherited Init(_Deg+1);
    End;

  Function Polynom_Block.Deg;
    Begin
      Deg:=Num-1;
    End;

  Procedure Polynom_Block.S;
    Begin
      Inherited S(N+1,New_Value);
    End;

  Function Polynom_Block.G;
    Begin
      G:= Inherited G(N+1);
    End;

  Function Polynom_Block.Value;
    Var Result:Real_Type; I:Word;
    Begin
      Result:=List^[Num];
      For I:=(Num-1) downto 1 do Result:=List^[I]+Result*X;
      Value:=Result;
    End;

  Function Polynom_Block.Find_Root;
    Var XB,XE,X,YB,YE,Y:Real_Type; Inc_Flag:Boolean;
    Begin
      XB:=A; YB:=Value(XB);
      XE:=B; YE:=Value(XE);
      Inc_Flag:=YE>YB;
      If YB*YE<=0 then { �甄� YB � YE ━ヮ� p�Л襯 Л��� }
        Begin
          Repeat
            X:=(XB+XE)/2; Y:=Value(X);
            If Inc_Flag then
              If Y>0 then XE:=X Else XB:=X { �祗�罔� 〓�p�痰�モ }
            Else
              If Y<0 then XE:=X Else XB:=X; { �祗�罔� 磧襤�モ }
          Until (XE-XB)<Find_Root_Limit;
          Find_Root:=X;
        End
      Else { �甄� YB � YE ━ヮ� �え�����襯 Л��� }
        X:=Max_Real;
      Find_Root:=X;
    End;

  Function Polynom_Block.Plus_Limit;
    Begin
      Plus_Limit:=Round(G(Deg)/Abs(G(Deg)));
    End;

  Function Polynom_Block.Minus_Limit;
    Begin
      Minus_Limit:=1-((Deg mod 2)*2)*Round(G(Deg)/Abs(G(Deg)));
    End;

 { = = = �祠�� ���┃���� = = = }
  Function pAdd( A,B:Polynom ):Polynom;
    Var Result:Polynom; I,C,D:Word;
    Begin
      C:=Trunc(Min(A^.Deg,B^.Deg));
      D:=Trunc(Max(A^.Deg,B^.Deg));
      New(Result,Init(D));
      For I:=0 to C do Result^.S(I,A^.G(I)+B^.G(I));
      If A^.Deg=D then
        For I:=(C+1) to D do Result^.S(I,A^.G(I))
      Else
        For I:=(C+1) to D do Result^.S(I,B^.G(I));
      pAdd:=Result;
    End;

 { = = = ��Л�痰� ���┃���� = = = }
  Function pSub( A,B:Polynom ):Polynom;
    Var Result:Polynom; I,C,D:Word;
    Begin
      C:=Trunc(Min(A^.Deg,B^.Deg));
      D:=Trunc(Max(A^.Deg,B^.Deg));
      New(Result,Init(D));
      For I:=0 to C do Result^.S(I,A^.G(I)-B^.G(I));
      If A^.Deg=D then
        For I:=(C+1) to D do Result^.S(I,A^.G(I))
      Else
        For I:=(C+1) to D do Result^.S(I,-B^.G(I));
      pSub:=Result;
    End;

 { = = = �p�├▲ぅ�┘ ���┃���� = = = }
  Function pMul( A,B:Polynom ):Polynom;
    Var Result:Polynom; I,J:Word;
    Begin
      New(Result,Init(A^.Deg+B^.Deg));
      For I:=0 to Result^.Deg do Result^.S(I,0);
      For I:=0 to A^.Deg do
        For J:=0 to B^.Deg do
          Result^.S(I+J,Result^.G(I+J)+A^.G(I)*B^.G(J));
      pMul:=Result;
    End;

 { = = = �p�├〓き�� = = = }
  Function Derive( P:Polynom ):Polynom;
    Var Result:Polynom; I:Word;
    Begin
      New(Result,Init(P^.Deg-1));
      For I:=0 to Result^.Deg do Result^.S(I,(I+1)*P^.G(I+1));
      Derive:=Result;
    End;

 { = = = �ギ�pイカキ�覃 ��皀�p�� = = = }
  Function Integral( P:Polynom; C:Real_Type ):Polynom;
    Var Result:Polynom; I:Word;
    Begin
      New(Result,Init(P^.Deg+1));
      Result^.S( 0, C );
      For I:=0 to P^.Deg do Result^.S(I+1,P^.G(I)/(I+1));
      Integral:=Result;
    End;

 { = = = ｯpイカキ�覃 ��皀�p�� = = = }
  Function DefineIntegral( P:Polynom; A,B:Real_Type ):Real_Type;
    Var Temp:Polynom;
    Begin
      Temp:=Integral(P,0);
      DefineIntegral:=Temp^.Value(B)-Temp^.Value(A);
    End;

 { = = = ���瓷 �瓮� �ォ痰※皀�讚諷 ��p�ォ = = = }
  Function Polynom_Real_Roots( P:Polynom ):Array_Of_Real;
    Var Result:Array_Of_Real;    { ��p�� �p�↓キ�� }
        Temp:Array_Of_Real;      { ��p�� �p�↓キ�� � ���♂キ�鍖� �� �荐！� }
        _Derive : Polynom;       { �p�├〓き�� }
        Min_Max : Array_Of_Real; { ��腦� �┃�祠� / ���瓱祠� }
        C,I:Word;                { �腑砒┴� }
        Minus_Limit:ShortInt;    { ���� ���┃��� �p� X -> -�メ���ョ��痰� }
        Plus_Limit:ShortInt;     { ���� ���┃��� �p� X -> +�メ���ョ��痰� }
        L,X,Y,DL,UL:Real_Type;   { DL - �└�┤ �pイカ  UL - ��p紲� }
    Begin
      If P^.Deg=0 then { ｡p�｀皖� �荐！� }
        Begin
          New(Result,Init(0));
          Polynom_Real_Roots:=Result;
          Exit;
        End;
      If P^.Deg=1 then { ｡p�｀皖� �┃ォ���� �p�↓キ�� }
        Begin
          If P^.G(1)<>0 then
            Begin
              New(Result,Init(1));
              Result^.S(1,-(P^.G(0)/P^.G(1)));
            End
          Else
            New(Result,Init(0));
          Polynom_Real_Roots:=Result;
          Exit;
        End;
     { * * * ｡p�｀皖� �カ┃ォ�諷 ���┃���� * * * }
     { 1. �ムガ 蹍├〓き竡 }
      _Derive:=Derive(P);
     { 2. ��絎え� ゥ ��爿� - ��痰爛�祠� }
      Min_Max:=Polynom_Real_Roots(_Derive);
     { 3. ��絎え� Л��� �pイカ�� ���┃��� �� ．瓷��ョ��痰� }
      Plus_Limit:=Round(P^.Plus_Limit);
      Minus_Limit:=Round(P^.Minus_Limit);
     { 4. �薀� �����肓 ���┃��� }
      If Min_Max^.Num>0 then
        Begin
         { ���瓷 �└�ォ �p���肓 }
          L:=1; X:=Min_Max^.G(1); Y:=P^.Value(X);
          If Minus_Limit*Y>=0 then
            DL:=X
          Else
            Repeat L:=L*2; DL:=X-L; Until P^.Value(DL)*Y<=0;
         { ���瓷 ▲p絖ォ �p���肓 }
          L:=1; X:=Min_Max^.G(Min_Max^.Num); Y:=P^.Value(X);
          If Plus_Limit*Y>=0 then
            UL:=X
          Else
            Repeat L:=L*2; UL:=X+L; Until P^.Value(UL)*Y<=0;
        End;
     { ���瓷 ��p�ォ �� �p��ウ竄��� 〓�p�痰���� / 磧襤���� }
      New(Temp,Init(_Derive^.Deg+1));
      Case Min_Max^.Num of
        0:   { �モ ��痰pガ祠�� }
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
        1:   { 1 ��痰pガ祠 }
          Begin
            Temp^.S(1,P^.Find_Root(DL,Min_Max^.G(1)));
            Temp^.S(2,P^.Find_Root(Min_Max^.G(1),UL));
          End;
        Else { ����� ��痰pガ祠�� }
          Begin
            Temp^.S(1,P^.Find_Root(DL,Min_Max^.G(1)));
            For C:=2 to Temp^.Num-1 do
               Temp^.S(C,P^.Find_Root(Min_Max^.G(C-1),Min_Max^.G(C)));
            Temp^.S( Temp^.Num,P^.Find_Root(Min_Max^.G(1),UL));
          End;
      End;
      I:=0;
      For C:=1 to Temp^.Num do
        If Temp^.G(C)<>Max_Real then
          Begin Inc(I); Temp^.S(I,Temp^.G(C)); End;
      New( Result, Init(I) );
      For C:=1 to I do Result^.S(C,Temp^.G(C));
      Dispose( Temp, Done );
      Dispose( _Derive, Done );
      Dispose( Min_Max, Done );
      Polynom_Real_Roots:=Result;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖       ｡譽�� �����オ甅覃 ���┃��        崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

  Constructor Complex_Polynom_Block.Init;
    Begin
      Inherited Init(_Deg+1);
    End;

  Function Complex_Polynom_Block.Deg;
    Begin
      Deg:=Num-1;
    End;

  Procedure Complex_Polynom_Block.S;
    Begin
      Inherited S(N+1,New_Value);
    End;

  Function Complex_Polynom_Block.G;
    Begin
      G:= Inherited G(N+1);
    End;

  Function Complex_Polynom_Block.Value;
    Var Result:Complex; I:Word;
    Begin
      New(Result);
      Result^:=List^[Num];
      For I:=(Num-1) downto 1 do
        Begin
          Result^.Re:=List^[I].Re + Result^.Re*X^.Re - Result^.Im*X^.Im;
          Result^.Im:=List^[I].Im + Result^.Re*X^.Im + Result^.Im*X^.Re;
        End;
      Value:=Result;
    End;

 { = = = �祠�� ���┃���� = = = }
  Function cpAdd( A,B:Complex_Polynom ):Complex_Polynom;
    Var Result:Complex_Polynom; I,C,D:Word;
    Begin
      C:=Trunc(Min(A^.Deg,B^.Deg));
      D:=Trunc(Max(A^.Deg,B^.Deg));
      New(Result,Init(D));
      For I:=0 to C do Result^.S(I,cAdd(A^.G(I),B^.G(I)));
      If A^.Deg=D then
        For I:=(C+1) to D do Result^.S(I,A^.G(I))
      Else
        For I:=(C+1) to D do Result^.S(I,B^.G(I));
      cpAdd:=Result;
    End;

 { = = = ��Л�痰� ���┃���� = = = }
  Function cpSub( A,B:Complex_Polynom ):Complex_Polynom;
    Var Result:Complex_Polynom; I,C,D:Word;
    Begin
      C:=Trunc(Min(A^.Deg,B^.Deg));
      D:=Trunc(Max(A^.Deg,B^.Deg));
      New(Result,Init(D));
      For I:=0 to C do Result^.S(I,cSub(A^.G(I),B^.G(I)));
      If A^.Deg=D then
        For I:=(C+1) to D do Result^.S(I,A^.G(I))
      Else
        For I:=(C+1) to D do Result^.S(I,cSub(cSet(0,0),B^.G(I)));
      cpSub:=Result;
    End;

 { = = = �p�├▲ぅ�┘ ���┃���� = = = }
  Function cpMul( A,B:Complex_Polynom ):Complex_Polynom;
    Var Result:Complex_Polynom; I,J:Word;
    Begin
      New(Result,Init(A^.Deg+B^.Deg));
      For I:=0 to Result^.Deg do Result^.S(I,cSet(0,0));
      For I:=0 to A^.Deg do
        For J:=0 to B^.Deg do
          Result^.S(I+J,cAdd(Result^.G(I+J),cMul(A^.G(I),B^.G(J))));
      cpMul:=Result;
    End;

 { 畋陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳賃� }
 { 崖   ｡譽�� �牀´�-���┃�����讚�� �祗�罔�  崖 }
 { 請陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳陳珍� }

  Constructor A_Polynom_Block.Init( Up_Deg,Down_Deg:Word );
    Begin
      New(Up,Init(Up_Deg));
      New(Down,Init(Down_Deg));
    End;

  Destructor A_Polynom_Block.Done;
    Begin
      Dispose(Up,Done);
      Dispose(Down,Done);
    End;

  Procedure A_Polynom_Block.SU( N:Word; NewValue:Real_Type );
    Begin
      Up^.S(N,NewValue);
    End;

  Procedure A_Polynom_Block.SD( N:Word; NewValue:Real_Type );
    Begin
      Down^.S(N,NewValue);
    End;

  Function A_Polynom_Block.GU( N:Word ):Real_Type;
    Begin
      GU:=Up^.G(N);
    End;

  Function A_Polynom_Block.GD( N:Word ):Real_Type;
    Begin
      GD:=Down^.G(N);
    End;

  Function A_Polynom_Block.Value( X:Real_Type ):Real_Type;
    Var Temp:Real;
    Begin
      Temp:=Down^.Value(X);
      If Temp<>0 then Value:=Up^.Value(X)/Temp Else Value:=Max_Real;
    End;

  Function A_Polynom_Block.Real_Roots:Array_Of_Real;
    Var U,D,Temp,Result:Array_Of_Real; UC,DC,TC,I:Word;
    Begin
      U:=Polynom_Real_Roots(Up);
      D:=Polynom_Real_Roots(Down);
      New(Temp,Init(U^.Num));
      DC:=1; TC:=0;
      For UC:=1 to Up^.Deg do
        Begin
          While (((D^.G(DC)<U^.G(UC)) And (DC<D^.Num))) do Inc(DC);
          If D^.G(DC)<>U^.G(UC) then
            Begin
              Inc(TC);
              Temp^.S(TC,U^.G(UC));
            End;
        End;
      New(Result,Init(TC));
      For I:=1 to TC do Result^.S(I,Temp^.G(I));
      Dispose(Temp,Done);
      Dispose(U,Done);
      Dispose(D,Done);
      Real_Roots:=Result;
    End;
    
 { = = = �祠�� �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function apAdd( A,B:A_Polynom ):A_Polynom;
    Var Result:A_Polynom;
    Begin
      New(Result,Init(0,0));
      Result^.Up:=pAdd(pMul(A^.Up,B^.Down),pMul(B^.Up,A^.Down));
      Result^.Down:=pMul(A^.Down,B^.Down);
      apAdd:=Result;
    End;

 { = = = ��Л�痰� �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function apSub( A,B:A_Polynom ):A_Polynom;
    Var Result:A_Polynom;
    Begin
      New(Result,Init(0,0));
      Result^.Up:=pSub(pMul(A^.Up,B^.Down),pMul(B^.Up,A^.Down));
      Result^.Down:=pMul(A^.Down,B^.Down);
      apSub:=Result;
    End;

 { = = = �p�├▲ぅ�┘ �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function apMul( A,B:A_Polynom ):A_Polynom;
    Var Result:A_Polynom;
    Begin
      New(Result,Init(0,0));
      Result^.Up:=pMul(A^.Up,B^.Up);
      Result^.Down:=pMul(A^.Down,B^.Down);
      apMul:=Result;
    End;

 { = = = �p�├〓き�� �牀´�-��罔����讚諷 �祗�罔� = = = }
  Function aDerive( P:A_Polynom ):A_Polynom;
    Var Result:A_Polynom;
    Begin
      New(Result,Init(0,0));
      Result^.Up:=pSub(pMul(Derive(P^.Up),P^.Down),
                       pMul(P^.Up,Derive(P^.Down)));
      Result^.Down:=pMul(P^.Down,P^.Down);
      aDerive:=Result
    End;

End.