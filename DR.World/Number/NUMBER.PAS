{ 浜冤様様様様様様様様様様様様様様様様様様様用融 }
{ � �  踸�ム �牀������ �� Turbo-Pascal 7.0  � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様溶夕 }
Uses CRT;

Var Limit,Option,U,D,N:Integer; Ans:Char;
Begin
  Randomize;
  Limit:=1000; { 踳ぅ� か� 腮瓮� }
  Repeat
   { �襦�� ��爬���� ┌琺  }
    ClrScr;
    TextColor(11);
    Writeln(' 浜冤冤様様様様様様様様様様様様様様様様様様様用用融');
    Writeln(' � � �  � � � �  � � � � � �  -  � � � � � �  � � �');
    Writeln(' 藩詫詫様様様様様様様様様様様様様様様様様様様溶溶夕');
    Writeln(' ------======韶韶韶 Lion  Studio 韶韶韶======------');
    Writeln;
    TextColor(10);
    Writeln(' � 轤�� ┌爛 腮甄� �甎��讌竡矚� �� 0 ぎ ',Limit);
    Writeln;
    TextColor(7);
    Writeln(' �襦ム�皀 ��爬��� ┌琺 ����� 罔籥�≪� ���※蓊 :');
    Writeln('  1  ����る��モ� �� - �癸�る��モ ����跪皀�');
    Writeln('  2  ����る��モ ����跪皀� - �癸�る��モ� ��');
    Writeln('  0  �諷�� � ｯム�罔���竡 瓱痰ガ�');
    Writeln;
    Write('  �▲え皀 ���ム �礒��� ��罔� : ');
    Readln(Option);
    Writeln;
   { ��＝癶キ�� ┌�� }
    Case Option of
      1: { === 1 === }
        Begin
          Writeln('����る��モ� �� - �癸�る��モ ����跪皀�');
          D:=0;
          U:=Limit;
          Repeat
            N:=(U+D) div 2;
            Writeln(' ��茱 腮甄� ｀�跏� ',N,'  1 - ��  0 - �モ  : ',D,'-',U);
            Ans:=ReadKey;
            If Ans='1' then D:=(N+1) Else U:=N;
            If U=D then
              Begin
                Writeln(' ��茱 腮甄� ',U);
                D:=Limit; { Break }
                Break;
              End;
          Until D>U;
          ReadKey;
        End;
      2: { === 2 === }
        Begin
          U:=Random(Limit);
          Writeln('����る��モ ����跪皀� - �癸�る��モ� ��');
          Repeat
            Write(' �▲え皀 腮甄� ');
            Readln(D);
            if U>D then Writeln('��� 腮甄� ｀�跏� !');
            if U<D then Writeln('��� 腮甄� �キ跏� !');
          Until U=D;
          Writeln(' �� ������� !!! ');
          Readln;
        End;
    End;
  Until Option=0;
End.
