Program LongArifm_realization;

uses Crt;

const c=1000; {������⢮ ������⮢ � ���ᨢ�}
      osn=10000; {�᭮����� ��� �࠭���� ������� �ᥫ � ���ᨢ�}

type Tlong = array [0..C] of longint;

var num1, num2 : Tlong; {������ �᫠}
    Rez: Tlong;   {�������}

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

Procedure MultLong (Num: Tlong; n: longint; var Rez: Tlong);
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
        if Rez[Num[0]+1] > 0 then {�஢��塞 ������⢮ �祥� � �ந��������}
          Rez[0]:= Num[0]+1
        else
          Rez[0]:= Num[0]
      end;
  end;

Function MoreOrEqual(Num1, Num2: Tlong): boolean;
{�ࠢ������ 2 ������� �᫠.
�����頥� true, �᫨ ��ࢮ� ����� ��ண� ��� ��� ࠢ��}
  var i: integer;
  begin
    if ( Num1[0] > Num2[0] )
    {�᫨ ���-�� �祥� 1-�� �᫠ ����� 祬 ���-�� �祥� 2-��,
    � 1-� �᫮ ����� 2-��}
      then MoreOrEqual:= true
    else
      if ( Num1[0] < Num2[0] ) {�᫨ �����, � 1-� �᫮ ����� 2-��}
        then MoreOrEqual:= false
      else
      {�᫨ �� ������⢮ �祥� 1-�� ᮢ������ � ������⢮� �祥� 2-��}
        begin
          i:= Num1[0];
          while (i>0) and (Num1[i]=Num2[i]) do
          {�ࠢ������ ����।�� �祩�� �᫨ ���祭�� ࠢ��, ���室��
          � ᫥���饩 ���. ��室 �� �᫮���, �� �祩�� �����稫���
          (� ���� �᫠ ࠢ��), ��� �� ������� ��ࠢ�� ���祭��}
            dec(i);
          if i=0 then
            MoreOrEqual:= true {��� ࠢ��}
          else
            if Num1[i] > Num2[i] then
            {�᫨ ��祭�� � i-� �祩�� 1-�� �᫠ ����� ���祭�� �
            i-� �祩�� ��ண�, � 1-� �᫮ �����}
              MoreOrEqual:= true
            else
              MoreOrEqual:= false; {���� 1-� �����}
        end;
  end;


Procedure SubstrLong (var num1: Tlong; num2: Tlong);
{���⠭�� ������� �ᥫ. ������� � num1}
  var i, j: integer; {��६���� ��� 横��}
  begin
    if MoreOrEqual (num1, num2) then
      begin
        for i:= 1 to num2[0] do {�� 1 �� ���. �祥� �� ��஬ �᫥}
          begin
            dec(Num1[i],Num2[i]);
            {���⠥� �� 㬥��蠥��� i-� �祩�� Num1
            ���⠥��� i-� �祩�� Num2}
            j:= i; {��६����� ��� 横�� �� �����⢮�����}
            while (Num1[j] < 0) and (j <= Num1[0]) do
            {�᫨ १���� � j-� �祩�� �������� ����� ��� � ��
            �⮬ j �� ����� ������⢠ �祥� � Num1, �...}
              begin
                inc(Num1[j], osn);
                {�ਡ���塞 � Num[j] �᭮����� (��� ���筮 ������㥬 ��
                ������� � �⮫���)}
                dec(Num1[j+1]);
                {�����蠥� ������ �祩�� �� �������}
                inc(j);
              end;
          end;
        i:= Num1[0];
        while ( i>1 ) and ( Num1[i]=0 ) do
        {����ࠢ�塞 ����� (������⢮ �祥�) � ࠧ����}
          dec(i);
        Num1[0]:= i;
      end
    else
      writeln ('��ࢮ� �᫮ ����� ��ண�!');
  end;

Procedure DivLong;
  begin
  end;

BEGIN
  clrscr;
  readlong (num1);
  num2:= num1;
  {SumLong (num1,num2,Rez);
  writelong ('��� �㬬� ',Rez);}
  MultLong (num1,3,Rez);
  writelong (Rez);
  num1:=rez;
  substrlong (Num2,Num1);
  writelong (num2);
  readln;
END.