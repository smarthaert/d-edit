{
  Алексей Карпачевский: karalexkar@gmail.com
  Матрица размером 2х1 или 1х2 теперь обрабатывается без ошибки. При выводе ответа, для удобства, выводятся также исходные матрицы
}
{$N+}
program matrix;

uses
  crt,
  graph;  {uses moduls}

const
  multipla = 10;      {number of rows and columns of our matrix}

var
  pos, act, a, b, i, j, m, n, o, p: integer; {a,b for video, act for menu, i,j for line, m,n,o,p for two matrixs}
  det:   real; {for determinant}
  ch, q: char; {for answer}
  Matn1, Matn2, Mato: array [1..multipla, 1..multipla] of real; {three matrixs}

  procedure showmat;      {procedure, which helps us to show matrix on the screen}
  var
    i, j: integer;
  begin
    directvideo := False;
    {we need to turn off video, to use 'writeln', 'readln' to show matrix on the screen}

    writeln('________________');
    writeln('Your first matrix');
    for i := 1 to n do begin   {we use cycle to show matrix}
      for j := 1 to m do
        Write(matn1[i, j]: 5: 2, ' ');
      writeln;
    end;

    if o <> 0 then begin
      writeln('________________');
      writeln('Your second matrix');
      for i := 1 to o do begin   {we use cycle to show matrix}
        for j := 1 to p do
          Write(matn2[i, j]: 5: 2, ' ');
        writeln;
      end;
    end;

    writeln('_________________');
    writeln('The result is:');
    for i := 1 to n do begin   {we use cycle to show matrix}
      for j := 1 to m do
        Write(mato[i, j]: 5: 2, ' ');
      writeln;
    end;
    readln;
    directvideo := True;  {turn on video}
  end;

  procedure Readmat;
  {procedure, which helps us to read first matrix from the screen to computer}
  var
    i, j: integer;
  begin
    repeat
      cleardevice;           {I use graph mode for outlet messeges on the screen}
      setbkcolor(15);        {background color}
      settextstyle(2, 0, 6);     {text style}
      Outtextxy(10, 230, 'Please, enter number of rows and columns, then enter the matrix');
      readln(N, m);             {reading number of rows and columns of first matrix'}
      if not (m or n in [0..multipla]) then begin
        {Here I check multipla, it must be between 1 and 10}
        Outtextxy(210, 255, 'Multipla is not correct!');
        readln;
      end else
        for i := 1 to n do     {if multipla correct, i read first matrix}
          for j := 1 to m do
            Read(matn1[i, j]);
    until (m and n in [0..multipla]);
  end;

  procedure Readmat2;
  {this procedure is for reading second matrix, it has some difference from first procedure}
  var
    i, j: integer;
  begin
    repeat
      cleardevice;
      setbkcolor(15);
      settextstyle(2, 0, 5);
      Outtextxy(15, 230,
        'Please, enter number of rows and columns, then enter the second matrix');
      readln(o, p);
      if not (o or p in [0..multipla]) then begin
        Outtextxy(210, 255, 'Multipla is not correct!');
        readln;
      end else
        for i := 1 to o do
          for j := 1 to p do
            Read(matn2[i, j]);
    until (o and p in [0..multipla]);
  end;

  procedure trans;     {here is a procedure, which transponets our matrix'}
  var
    i, j: integer;
  begin
    for i := 1 to n do
      for j := 1 to m do
        mato[i, j] := matn1[j, i];
  end;

  procedure summ;       {This procedure is for summing two matrixs}
  var
    i, j: integer;
  begin
    for i := 1 to n do
      for j := 1 to m do
        mato[i, j] := matn1[i, j] + matn2[i, j];
  end;

  procedure ymnoj;   {Also we can multiply two matrix'}
  var
    i, j, k: integer;
  begin
    for i := 1 to n do
      for j := 1 to m do
        mato[i, j] := 0;
    for i := 1 to n do
      for j := 1 to m do
        for k := 1 to p do
          mato[i, j] := mato[i, j] + matn1[i, k] * matn2[k, j];
  end;

  procedure deter;  {I don't make cycle for finding det, that's why this procedur is not full}
  begin
    det := 0;
    case n of
      1: det := matn1[1, 1];
      2: det := matn1[1, 1] * matn1[2, 2] - matn1[1, 2] * matn1[2, 1];
      3: begin
        det := matn1[1, 1] * matn1[2, 2] * matn1[3, 3] - matn1[1, 3] * matn1[2, 2] * matn1[3, 1];
        det := det + matn1[1, 2] * matn1[2, 3] * matn1[3, 1] + matn1[1, 3] * matn1[2, 1] * matn1[3, 2];
        det := det - matn1[2, 3] * matn1[3, 2] * matn1[1, 1] - matn1[3, 3] * matn1[2, 1] * matn1[1, 2];
      end;
    end;
    directvideo := False;
    writeln('________________');
    writeln('Your matrix');
    for i := 1 to n do begin   {we use cycle to show matrix}
      for j := 1 to m do
        Write(matn1[i, j]: 5: 2, ' ');
      writeln;
    end;

    writeln('Determinant:', det: 5: 2);
    directvideo := True;
  end;

begin
  a := detect;                   {I use graph, and here it is preparations for its using}
  initgraph(a, b, '');
  settextstyle(7, 0, 4);
  for i := 1 to 480 do
    for j := 1 to 640 do
      line(j, i, j, i){something like splash screen};
  Setcolor(1);                       {preparing of the screen}
  outtextxy(200, 220, 'Matrix Counter 1.1');  {name of program}
  delay(60000);
  delay(60000);
  repeat
    cleardevice;                {preparing of the screen for menu}
    setbkcolor(15);
    settextstyle(8, 0, 2);
    outtextxy(10, 220, 'What do you want to do? Please choose using arrows');  {Menu}
    outtextxy(150, 245, '  Det (sorry,now only 2x2 and 3x3)');
    outtextxy(150, 270, '  Sum ');
    outtextxy(150, 295, '  Multiply ');
    outtextxy(150, 320, '  Transponet');
    outtextxy(150, 345, '  Exit');
    setcolor(5);
    rectangle(125, 270, 615, 249);
    pos := 270;
    repeat
      ch := readkey;
      case Ord(ch) of
        80:
          if pos <= 345 then begin
            pos := pos + 25;
            setcolor(15);
            rectangle(125, pos - 25, 615, pos - 46);
            setcolor(5);
            rectangle(125, pos, 615, pos - 21);
          end;
        72:
          if pos >= 295 then begin
            pos := pos - 25;
            setcolor(15);
            rectangle(125, pos + 25, 615, pos + 4);
            setcolor(5);
            rectangle(125, pos, 615, pos - 21);
          end;
        27: exit;
      end;
    until Ord(ch) = 13;
    setcolor(1);
    case pos - 25 of      {here i match numbers and procedurs}
      245: repeat
          readmat;
          if m = n then   {for finding det, matrix must be square}
            deter
          else
            outtextxy(200, 300, 'Matrix must be square!');
          readkey;
        until m = n;{every function has some special demands}
      270: begin            {summing of matrixs}
        repeat
          readmat;
          readmat2;
          if (n = o) and (p = m) then begin
            {number of rows and columns of both matrixs must be equel}
            summ;
            showmat;
          end else
            outtextxy(220, 280, 'Incorrect number of rows and columns! Try again');
          readkey;
        until (n = o) and (m = p);
        o := 0;
      end;
      295: begin         {here is multiply of two matrixs}
        repeat
          readmat;
          readmat2;
          if (m = o) and (p = n) then begin {columns of first=rows of second}
            ymnoj;
            showmat;
          end else
            outtextxy(220, 280, 'Incorrect number of rows and columns! Try again');
          readkey;
        until (m = o) and (n = p);
        o := 0;
      end;
      320: repeat
          readmat;
          if m = n  {matrix must be square} then  begin
            trans;
            showmat;
            readkey;
          end else begin
            outtextxy(220, 280, 'Matrix must be square! Try again');
            readkey;
          end;
        until m = n;{transponent}
      345: exit;    {you can leave this program}
    end;
    clrscr;
    cleardevice;    {preparing screen for the last message}
    setbkcolor(15);
    settextstyle(7, 0, 2);
    outtextxy(185, 220, 'If you want to quit press "esc"');
    {after procedure you can count something again}
    outtextxy(200, 195, 'To continue press any key');
    q := readkey;
  until q = chr(27);
end.
