Program LongArifm_realization;

uses Crt;

const c=100; {������⢮ ������⮢ � ���ᨢ�}
      osn=10000; {�᭮����� ��� �࠭���� ������� �ᥫ � ���ᨢ�}

type Tlong = array [0..C] of longint;

var num1, num2 : Tlong; {������ �᫠}
    Rez, Ost: Tlong;   {������� � ���⮪}

procedure readlong (var num:Tlong);
{�⥭�� ������� �ᥫ}
  var i: longint;
      ch: char;
  begin
    for i:=0 to C do  {���樠������ ���ᨢ�}
      num[i]:=0;
    read (ch);
    while ch in ['0'..'9'] do
      begin
        for i:= num[0] downto 1 do
          begin
            num[i+1]:= num[i+1] + (num[i]*10) div osn; {��।������ ������}
            num[i]:= (num[i]*10) mod osn;   {���� � ᫥� �᫮, �᢮������}
          end;                            {�뭥譥� �᫮ ��� ᫥� ����}
        num[1]:= num[1] + ord(ch) - ord ('0');
        if num[num[0]+1] > 0 then inc(num[0]);
        read (ch);
      end;
    writeln;
  end;

procedure WriteLong (num:Tlong);
{�뢮� ���� �ᥫ �� ��࠭}
  var zer, s: string;
      i: longint;
  begin
    write (num[num[0]]);  {�뢮� ���襣� �᫠}
    str (osn div 10, zer);
    for i:= num[0]-1 downto 1 do
      begin
        str (num[i], s);
        while length (s) < length (zer) do  {���������� ������ ��ﬨ}
          s:='0'+s;
        write (s);   {�뢮� ��⠫��� �ᥫ}
      end;
    writeln;
  end;

Procedure SumLong (num1, num2: Tlong; var Rez: Tlong);
{�㬬�஢���� 2-� ������� �ᥫ}
  var i, k: integer;
  begin
    for i:=0 to C do  {���樠������}
    Rez[i]:=0;
    if num1[0] > num2[0] then {����塞 ���ᨬ��쭮� ���-�� �ᥫ}
      k:= num1[0]
    else
      k:= num2[0];
    for i:= 1 to k do  {ॠ���㥬 �㬬�஢����}
      begin
        Rez[i+1]:= (Rez[i] + num1[i] + num2[i]) div osn;
        {��७�ᨬ ������ ���� �� �㬬� (�᫨ ��� ��
        ࠧ�來��� ����� �᭮�����) � ᫥���饥 �᫮}
        Rez[i]:= (Rez[i] + num1[i] + num2[i]) mod osn; {��⠫쭮� ��⠢�塞}
      end;
    If Rez[k+1]=0 then
      Rez[0]:= k
    else
      Rez[0]:=k+1;
  end;

Procedure MultLongLInt (Num: Tlong; n: longint; var Rez: Tlong);
{��������� ������� �᫠ �� �᫮ ⨯� longint
 Num - ����. �᫮; n - �᫮, �� ���஥ 㬭����� (longint); Rez - १����}
  var i: word; {i - c��稪 ��� 横��}
  begin
    for i:= 1 to c do  {���樠������}
      Rez[i]:= 0;
    if n <> 0 then {�஢�ઠ �� �, ���� �� �����⥫� �㫥�}
      begin
        for i:= 1 to Num[0] do {�� 1 �� ������⢠ �祥�}
          begin
            Rez[i+1]:= (Num[i] * n + Rez[i]) div osn;
            {�᫨ �ந�������� ���祭�� � �祩�� �� �����⥫� �����
            �᭮�����, � �뭮ᨬ ������ ���� � ᫥������ �祩��}
            Rez[i]:= (Num[i] * n + Rez[i]) mod osn;
            {� i-� �祩�� ��⠢�塞 ���祭�� �ந�������� (���
            ���襩 ����, �᫨ ��� �뫮 ����� �᭮�����)}
          end;
        if Rez[Num[0]+1] > 0 then
        {�஢��塞/���ࠢ�塞 ������⢮ �祥� � �ந��������}
          Rez[0]:= Num[0]+1
        else
          Rez[0]:= Num[0]
      end;
  end;

Function MoreOrEqual(Num1, Num2: Tlong; sdvig: integer): byte;
{�ࠢ������ 2 ������� �᫠ � ��⮬ ᤢ��� (ᤢ�� �㦥� ��� �������).
�����頥� 0, �᫨ ��ࢮ� ����� ��ண�; 1 - ��஢� ����� �ண��
           2 - ��ࢮ� ࠢ�� ��஬� }
  var i: integer;
  begin
    if ( Num1[0] > (Num2[0] + sdvig) )
    {�᫨ ���-�� �祥� 1-�� �᫠ ����� 祬 ���-�� �祥� 2-�� + ᤢ��,
    � 1-� �᫮ ����� 2-��}
      then
        MoreOrEqual:= 0
    else
      if ( Num1[0] < (Num2[0] + sdvig) )
      {�᫨ �����, � 1-� �᫮ ����� 2-��}
        then
          MoreOrEqual:= 1
      else
      {�᫨ �� ������⢮ �祥� 1-�� ᮢ������ � ������⢮� �祥� 2-��}
        begin
          i:= Num1[0];
          while (i > sdvig) and (Num1[i] = Num2[i-sdvig]) do
          {�ࠢ������ ����।�� �祩�� � ��⮬ ᤢ���;
          �᫨ ���祭�� ࠢ��, ���室�� � ᫥���饩 ���.
          ��室 �� �᫮���, �� �祩�� �����稫���
          (� ���� �᫠ ࠢ��), ��� �� ������� ��ࠢ�� ���祭��}
            dec(i);
          if i= sdvig then
            begin
              MoreOrEqual:=0;
              {��᫠ ᮢ���� � ��⮬ ᤢ���}
              for i:= 1 to sdvig do
                if Num1[i] > 0 then Exit;
              MoreOrEqual:=2;
              {��᫠ ࠢ��, "墮��" �᫠ Num1 ࠢ�� ���}
            end
          else
            MoreOrEqual:= Byte( Num1[i] < Num2[i-sdvig] );
        end;
  end;


Procedure SubstrLong (var num1: Tlong; num2: Tlong; sd: integer);
{���⠭�� ������� �ᥫ c ��⮬ ᤢ��� sd. ������� � num1}
  var i, j: integer; {��६���� ��� 横��}
  begin
    for i:= 1 to num2[0] do {�� 1 �� ���. �祥� �� ��஬ �᫥}
      begin
        dec(Num1[i+sd],Num2[i]);
        {���⠥� �� 㬥��蠥��� i-� �祩�� Num1
        ���⠥��� i-� �祩�� Num2}
        j:= i; {��६����� ��� 横�� �� �����⢮�����}
        while (Num1[j+sd] < 0) and (j <= Num1[0]) do
        {�᫨ १���� � j-� �祩�� �������� ����� ��� � ��
        �⮬ j �� ����� ������⢠ �祥� � Num1, �...}
          begin
            inc(Num1[j+sd], osn);
            {�ਡ���塞 � Num[j] �᭮����� (��� ���筮 ������㥬 ��
            ������� � �⮫���)}
            dec(Num1[j+sd+1]);
            {�����蠥� ������ �祩�� �� �������}
            inc(j);
          end;
      end;
    i:= Num1[0];
    while ( i>1 ) and ( Num1[i]=0 ) do
    {����ࠢ�塞 ����� (������⢮ �祥�) � ࠧ����}
      dec(i);
    Num1[0]:= i;
  end;


Function FindBin (Var Ost: Tlong; B : Tlong; sd: integer): Longint;
{�㭪�� ��� ���᪠ �����業�, �� ����� �㦭� ��������� ����⥫�
B - ����⥫�; Ost - ᭠砫� �������, � ���� - ���⮪ �� �������}
  var Down, Up: word; {������ � ������ �࠭�� ��� ���᪠ �����樥��}
      C: Tlong; {������� ��� �ࠢ����� � ������}
  begin
    down:=0;
    Up:= Osn; {�᭮����� ��⥬� ��᫥���}
    While (Up-1) > Down do
      begin
        MultLongLInt (B, ((Up+Down) div 2), C);
        Case MoreOrEqual (Ost, C, sd) of
          0: Down:= (Up+Down) div 2;
          {�᫨ ������� Ost �����, 祬 �, ⮣�� 㢥��稢��� ������ �࠭���}
          1: Up:= (Up+Down) div 2;
          {�᫨ ������� Ost �����, 祬 C, ⮣�� 㬥��蠥� ������ �࠭���}
          2: begin
               Up:= (Up+Down) div 2;
               Down:= Up;
             end;
          {�᫨ Ost = C, ⮣�� �᫠ ������� ��楫� � ������ �࠭�� ࠢ��
           ������ � ࠢ�� (Up+Down) div 2}
        end;
      end;
    MultLongLInt (B, (Up+Down) div 2, C);
    {����⥫� 㬭����� �� ����祭�� �����樥�� ( (Up+Down) div 2 ).
    ������� � �}
    {��室�� ���⮪ �� �������}
    If MoreOrEqual (Ost, C, sd) = 0 then
    {�᫨ ������� Ost ����� �}
      SubstrLong (Ost, C, sd)
    else
      begin
        SubstrLong (C, Ost, sd);
        Ost:= C;
      end;
    FindBin:= (Up+Down) div 2;
    {����� ���� ��⭮��}
  end;

Procedure MakeDivLong (Num1, Num2: Tlong; Var Rez, Ost: Tlong);
{������� ���� ������� �ᥫ �� �᫮���, �� Num1 > Num2 � ��� �� ࠢ��.
�᫮��� �஢������� � ��楤�� LongDivLong}
  var sd: integer;
  begin
    Ost:= Num1; {��ࢮ��砫쭮� ���祭�� ���⪠}
    sd:= Num1[0] - Num2[0];
    if MoreOrEqual (Num1, Num2, sd) = 1 then
      Dec(sd);
    {Num2 * Osn > Num1, � १���� 1 ���}
    Rez[0]:= sd+1;
    while sd >= 0 do
      begin
        {��室�� ��।��� ���� १����}
        Rez[sd+1]:= FindBin (Ost, Num2, sd);
        dec (sd);
      end;
  end;

Procedure LongDivLong (Num1, Num2 : Tlong; Var Rez, Ost: Tlong);
{������� ���樨 �� ������� � �맮� ��楤��� �������}
  var i: integer;
  begin
    for i:= 1 to c do  {���樠������}
      Rez[i]:= 0;
    for i:= 1 to c do
      Ost[i]:=0;
    Case MoreOrEqual (Num1, Num2, 0) of
      0: MakeDivLong(Num1, Num2, Rez, Ost);
      {�뭮ᨬ � ��楤��� ᠬ� ������� �� �᫮���,
      �� Num1 > Num2 � ��� �� ࠢ��}
      1: Ost:= Num1;
      {�᫨ Num1 ����� Num2, � ���⪮� �� ������� �㤥� Num1}
      2: Rez[1]:=1;{��ࠢ��� ����� R[0]?}
      {�� �᫮���, �� �᫠ ࠢ��, १���� ������� ࠢ�� 1-�}
    end;
  end;




BEGIN
  clrscr;
  readlong (num1);
  readln;
  clrscr;
  readlong (num2);
  clrscr;
  {SumLong (num1,num2,Rez);
  writelong ('��� �㬬� ',Rez);}
  {MultLongLInt (num1,3,Rez); }
  writeln ('Num1 = ');
  writelong (Num1);
  writeln ('Num2 = ');
  writelong (Num2);
  {substrlong (Num2,Num1,0);
  writelong (num2);}
  longdivlong(Num1,Num2, Rez, Ost);
  writeln ('Num1 / Num 2 = ');
  writelong (rez);
  writeln ('Ostatok = ');
  writelong (Ost);
  readln;
END.