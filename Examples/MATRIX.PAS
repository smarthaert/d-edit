// Софронов А.В. 7852 - moblex@mail.ru
program Matrix;

{////////// ПОДКЛЮЧАЕМЫЕ МОДУЛИ //////////}
// Подключаем нужный нам модуль
uses
  crt;

{////////// КОНСТАНТЫ //////////}
const
// Максимальное кол-во элементов в строке/столбце
  mxMaxRows = 20;
  mxMaxCols = 30;

{////////// СОБСТВЕННЫЕ ТИПЫ ДАННЫХ //////////}
type
	// Собственный тип данных - один массив в массиве (матрица)
	Tmx = array [1..mxMaxRows, 1..mxMaxCols] of Real;
	// Собственный тип данных - массив вещественных чисел (вектор)
	Tvct = array [1..mxMaxCols] of Real;

{////////// ПЕРЕМЕННЫЕ //////////}	
var
  LineSumm : Real;
  mx : Tmx; // Переменная типа матрицы
  Exit : Char; // Нужна для выхода из программы
  S : String;
  m, n : Byte; // Кол-во элементов в строке/столбце
  WriteLine,Readok,ExistNullsmaller : Boolean; // Нужная для проверки вывода строки матрицы
  vct, SetArray : Tvct; // Переменные типа вектора
  i, j, v, SetPower : Byte; // Нужны для создания в программе циклов

{////////// ФУНКЦИИ И ПРОЦЕДУРЫ //////////}

// Функция безопасного ввода для ЦЕЛЫХ чисел
// В параметре только строка-подсказка при вводе числа
// Нужна для ввода КОЛ-ВА строк/столбцов матрицы, вектора, множества  
function AskInt(Prompt : String; Limit: Integer) : Integer; // Функция вернёт ЦЕЛОЕ значение
var
	S : String;
	Code : Integer;
	V : Byte;
	X, Y : Byte;
begin
	Write(Prompt); // Выводм подсказку (типа "что надо ввести")
	X := WhereX; // Запоминаем позицию курсора по горизонтали
	Y := WhereY; // Запоминаем позицию курсора по вертикали
	repeat
	GoToXY(X, Y); // Переходим в запомненную позицию на экране
	ClrEoL; // Стираем всё до конца строки
	Readln(S); // Считываем то, что ввёл пользователь
	Val(S, V, Code); // Пытаемся привести строку к числу
    // При положительном результате эта функция возвращает 0, иначе код ошибки
	// Повторяем до тех пор, пока пользователь введёт то, что нужно
	// По поводу 2 условия - не должен же пользователь ввести число, большее
	// максимальному кол-во элементов в строке/столбце матрицы!
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
	
// Функция безопасного ввода для вещественных чисел
// Аналогично, что и для целых чисел
// Нужна для ввода ЭЛЕМЕНТОВ матрицы, вектора, множества	
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
	until (Code = 0); // Второе условие не нужно!
	Ask := V;
end;

// Процедура вывода матрицы
// В параметрах: 1) какая матрица 2) сколько строк и столбцов
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

{////////// ПРОГРАММА //////////}

begin
  repeat
    ClrScr; // Очищаем весь экран
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
	// Узнаём кол-во строк матрицы
    n := AskInt('1. BBedem kol-vo strok: ', mxMaxRows);
    Writeln;
	
	// Узнаём кол-во столбцов матрицы
    m := AskInt('2. BBedem kol-vo stolbsov: ', mxMaxCols);
    Writeln;
	
	// Ввод матрицы
    Writeln('3. This is matrix M x N. BBedem elementi matrisi:');
	// Запрашиваем ВСЕ элементы матрицы (в цикле)
    for i := 1 to n do begin
	for j := 1 to m do begin
	Write('-> ', i, 'x', j, ' :');
	mx[i,j] := Ask(' ');
      end;
    end;
    Writeln;
    end;
    until Readok = True;
	// Вывод матрицы
    MatrixPrint(mx, m, n); // Вывод того, что ввели
    Writeln;
	
	// Ввод вектора
    Writeln('4. BBedem vector (', m, ' elements):');
    for i := 1 to m do begin
	Write('-> [', i, '] :');
      vct[i] := Ask(' ');
    end;
	
	// Обработка отрицательных элементов матрицы
       ExistNullSmaller := False;
    for i := 1 to n do begin
		for j := 1 to m do begin
	// Если элемент < 0, заменяем всю строку вектором
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
	
	// Вывод матрицы
    // Покажем, что получилось после первой обработки
    MatrixPrint(mx, m, n);
    Writeln;
	
	// Ввод кол-ва элементов в множестве
    SetPower := AskInt('5. BBedem set power: ', mxMaxCols);
	
	// Ввод элементов множества
    for i := 1 to SetPower do begin
	Write('-> [', i, '] :');
      SetArray[i] := Ask(' ');
    end;
    Writeln;
	
	// Вывод сумм элементов всех строк матрицы
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
	Readln(Exit); // Считываем, что ввёл пользователь
	until Exit in ['Y', 'y']; // Если не "y" и "Y", то повторяем ВСЁ заново
  Write('Bye ');
  Readln;
end.