// �������� �.�. 7852 - moblex@mail.ru
program Matrix;

{////////// ������������ ������ //////////}
// ���������� ������ ��� ������
uses
  crt;

{////////// ��������� //////////}
const
// ������������ ���-�� ��������� � ������/�������
  mxMaxRows = 20;
  mxMaxCols = 30;

{////////// ����������� ���� ������ //////////}
type
	// ����������� ��� ������ - ���� ������ � ������� (�������)
	Tmx = array [1..mxMaxRows, 1..mxMaxCols] of Real;
	// ����������� ��� ������ - ������ ������������ ����� (������)
	Tvct = array [1..mxMaxCols] of Real;

{////////// ���������� //////////}	
var
  LineSumm : Real;
  mx : Tmx; // ���������� ���� �������
  Exit : Char; // ����� ��� ������ �� ���������
  S : String;
  m, n : Byte; // ���-�� ��������� � ������/�������
  WriteLine,Readok,ExistNullsmaller : Boolean; // ������ ��� �������� ������ ������ �������
  vct, SetArray : Tvct; // ���������� ���� �������
  i, j, v, SetPower : Byte; // ����� ��� �������� � ��������� ������

{////////// ������� � ��������� //////////}

// ������� ����������� ����� ��� ����� �����
// � ��������� ������ ������-��������� ��� ����� �����
// ����� ��� ����� ���-�� �����/�������� �������, �������, ���������  
function AskInt(Prompt : String; Limit: Integer) : Integer; // ������� ������ ����� ��������
var
	S : String;
	Code : Integer;
	V : Byte;
	X, Y : Byte;
begin
	Write(Prompt); // ������ ��������� (���� "��� ���� ������")
	X := WhereX; // ���������� ������� ������� �� �����������
	Y := WhereY; // ���������� ������� ������� �� ���������
	repeat
	GoToXY(X, Y); // ��������� � ����������� ������� �� ������
	ClrEoL; // ������� �� �� ����� ������
	Readln(S); // ��������� ��, ��� ��� ������������
	Val(S, V, Code); // �������� �������� ������ � �����
    // ��� ������������� ���������� ��� ������� ���������� 0, ����� ��� ������
	// ��������� �� ��� ���, ���� ������������ ����� ��, ��� �����
	// �� ������ 2 ������� - �� ������ �� ������������ ������ �����, �������
	// ������������� ���-�� ��������� � ������/������� �������!
	until (Code = 0) and (V <= Limit);
	AskInt := V;
end;
function AskBool(Prompt : String) : Boolean;
var
	C : char;
begin
	write(Prompt);
	repeat
	C := Readkey;
	until c in ['y','Y','n','N'];
	if c in ['y','Y'] then
	     AskBool := True
	else
	     Askbool := False;
	writeln(c);
	end;
	
// ������� ����������� ����� ��� ������������ �����
// ����������, ��� � ��� ����� �����
// ����� ��� ����� ��������� �������, �������, ���������	
function Ask(Prompt : String) : Real;
var
	S : String;
	Code : Integer;
	V : Real;
	X, Y : Byte;
begin
	Write(Prompt);
	X := WhereX;
	Y := WhereY;
	repeat
		GoToXY(X, Y);
		ClrEoL;
		Readln(S);
		Val(S, V, Code);
	until (Code = 0); // ������ ������� �� �����!
	Ask := V;
end;

// ��������� ������ �������
// � ����������: 1) ����� ������� 2) ������� ����� � ��������
procedure MatrixPrint(mx : Tmx; m, n : Integer);
var
	i, j : Integer;
begin
	for i := 1 to n do begin
	Write(i, ' : ');
		for j := 1 to m do
	Write(mx[i,j] :5 :1, ' ');
    Writeln;
  end;
end;

function ReadFromFile(s : String) : Boolean;
var
    F : text;
    rl : real;
    i, j : Byte;
    begin
    Assign(F, S + '.Txt');
    {$I-}
    Reset(F);
    if IOResult = 0 then begin
    i := 1;
    repeat
    j := 1;
    repeat
    Read(F,rl);
    mx[i,j] := Round(rl);
    Inc(j);
    until Eoln(F);
    Inc(i);
    until EoF(F);
    n := i-1;
    m := j-1;
    close(F);
    ReadFromFile := True;
    end
    else begin
    writeln('Owibka! TekstoBii dokyment ne naiden!');
    ReadFromFile := False;
    end;
    {$I+}
    end;

    procedure WriteToFile;
    var
    i,j,v : Byte;
    F: text;
    begin
    Assign(F, 'output.txt');
    Rewrite(f);

    writeln(F, '#Matrix#');
      for i:= 1 to n do begin
      for j:= 1 to m do
       write( F, mx[i,j] :2:2, ' ');
       writeln(F);
       end;
       writeln(F);
       writeln(F);

       writeln(F, '#Vector#');
       for j :=1 to m do
	      write(F, vct[j]:2:2, ' ');
	      writeln(F);
	      writeln(F);
	      writeln(F);

	      writeln(F, '#Task One#');
	      ExistNullSmaller := False;
		for i:= 1 to n do begin
      for j:= 1 to m do begin
      if  (mx[i,j] < 0) then begin
      ExistNullSmaller :=
      True;
      for v:= 1 to m do mx[i, v] := vct[v];
      end;
      end;
      end;
      if ExistNullSmaller = False then
	     Writeln(F, 'Net elementov,kotorie niwe nylia');
	     Writeln(F);
	      writeln(F, '#Task Two#');
		for i:= 1 to n do begin
		writeLine := True;
      for j:= 1 to m do begin
      if i= setArray[j] then
      writeline := False;
      end;

      if writeline = True then begin
      Linesumm :=0;
      for j := 1 to m do begin
      linesumm := linesumm + mx[i,j];
      end;
      write(F, i, ' : ',
      Linesumm:5:2);
      writeln(f);
      end;
      end;
      writeln(F);

      writeln(F, 'Bce cdelano');
      Close(f);
      end;

{////////// ��������� //////////}

begin
  repeat
    ClrScr; // ������� ���� �����
	Writeln('***** MATRIX PROCESSING *****');
    Writeln;
    Writeln('BEGIN');
    Writeln;
    repeat
    if (AskBool('Bi xotite 4itat iz faila? ') = True) then begin
    writeln;
    write('BBebite imia faila:');
    Readln(S);
    Readok:= ReadFromFile(S);
    end
    else begin
    Readok := True;
	// ����� ���-�� ����� �������
    n := AskInt('1. BBedem kol-vo strok: ', mxMaxRows);
    Writeln;
	
	// ����� ���-�� �������� �������
    m := AskInt('2. BBedem kol-vo stolbsov: ', mxMaxCols);
    Writeln;
	
	// ���� �������
    Writeln('3. This is matrix M x N. BBedem elementi matrisi:');
	// ����������� ��� �������� ������� (� �����)
    for i := 1 to n do begin
	for j := 1 to m do begin
	Write('-> ', i, 'x', j, ' :');
	mx[i,j] := Ask(' ');
      end;
    end;
    Writeln;
    end;
    until Readok = True;
	// ����� �������
    MatrixPrint(mx, m, n); // ����� ����, ��� �����
    Writeln;
	
	// ���� �������
    Writeln('4. BBedem vector (', m, ' elements):');
    for i := 1 to m do begin
	Write('-> [', i, '] :');
      vct[i] := Ask(' ');
    end;
	
	// ��������� ������������� ��������� �������
       ExistNullSmaller := False;
    for i := 1 to n do begin
		for j := 1 to m do begin
	// ���� ������� < 0, �������� ��� ������ ��������
	if (mx[i, j] < 0) then
		for v := 1 to m do
   begin
   ExistNullSmaller := True;
		mx[i, v] := vct[v];
      end;
    end;
    end;
    if ExistNullSmaller = False Then
    Writeln('Net elementov kotorie niwe nylia');
    Writeln;
	
	// ����� �������
    // �������, ��� ���������� ����� ������ ���������
    MatrixPrint(mx, m, n);
    Writeln;
	
	// ���� ���-�� ��������� � ���������
    SetPower := AskInt('5. BBedem set power: ', mxMaxCols);
	
	// ���� ��������� ���������
    for i := 1 to SetPower do begin
	Write('-> [', i, '] :');
      SetArray[i] := Ask(' ');
    end;
    Writeln;
	
	// ����� ���� ��������� ���� ����� �������
    for i := 1 to n do begin
	WriteLine := True;
	for j := 1 to m do begin
	if i = SetArray[j] then
		WriteLine := False;
      end;

      if WriteLine = True then begin
	LineSumm := 0;
	for j := 1 to m do begin
		LineSumm := LineSumm + mx[i,j];
	end;
	Write(i, ' : ', LineSumm:5:1);
	Writeln;
      end;
    end;
       writeToFile;
    Writeln;
    Writeln('END');
    Writeln;
    Write('-> Exit? (Y,N) ');
	Readln(Exit); // ���������, ��� ��� ������������
	until Exit in ['Y', 'y']; // ���� �� "y" � "Y", �� ��������� �Ѩ ������
  Write('Bye ');
  Readln;
end.