unit struct;
interface

{Наша структура, описывающая человека}
 type tHum = ^human;
      human = record
            name:string;
            age:integer;
            next:tHum;
      end;
 {Указатель на первый элемент}
 var first:tHum;

procedure insert(point:tHum; hum:human);

procedure delete(point, pred:tHum);

function compareToName(a:string; b:string):integer;

procedure sortByAge;

procedure create;

procedure output;

function equals(a, b:human):boolean;

function count:integer;

procedure sortByName;

implementation

{Проверка двух объектов структуры на равенство}
function equals(a, b:human):boolean;
begin
	equals:=(a.name = b.name) and
		(b.age = a.age);
end;

{Вставка после текущего}
procedure insert(point:tHum; hum:human);
	var temp:tHum;
		tempHum:human;
begin
	if(point = NIL) then
	 begin
		point^:=hum;
		exit;
	 end;
	new(temp);
	temp^ := hum;
	temp^.next := point^.next;
	point^.next := temp;
end;

{Удаление по указателю}
procedure delete(point, pred:tHum);
begin
	if(pred <> NIL) then
		pred^.next:=point^.next
	else
		first:=point^.next;
	dispose(point);
end;

{Сравнение по имени. Стадартный интерфейс компараторов}
function compareToName(a:string; b:string):integer;
	var la, lb, l, i:integer;
begin
	la:=length(a);
	lb:=length(b);
	l:=la;
	if(lb < l) then l:=lb;

	for i:=1 to l do begin
		if(a[i] > b[i]) then begin
			compareToName:=1;
			exit;
		end;
		if(a[i] < b[i]) then begin
			compareToName:=-1;
			exit;
		end;
	end;

	if(la > lb) then compareToName:=1;
	if(la < lb) then compareToName:=-1;
	compareToName:=1;
end;

{Количество элементов в структуре}
function count:integer;
	var cur:tHum;
		i:integer;
begin
	cur:=first;
	i:=0;
	while(cur <> NIL) do begin
		cur:=cur^.next;
		inc(i);
	end;
	count:=i;
end;

{Сравнение по возрасту}
function compareToAge(a, b:integer):integer;
begin
 if(a > b) then begin
  compareToAge:=1;
  exit;
 end;
 if(a < b) then begin
  compareToAge:=-1;
  exit;
 end;
 compareToAge:=0;
end;

{Сортировка по возрасту}
procedure sortByAge;
	var cur, pred, max, maxPred : tHum;
		i, j, n:integer;
begin
	n:=count;

	for i:=1 to n do begin
		cur:=first;
		pred:=NIL;
    new(max);
    max^.age:=-32000;
		for j:=1 to n - i + 1 do begin
			if(compareToAge(cur^.age, max^.age) > 0) then
				begin
					max:=cur;
					maxPred:=pred;
				end;
			pred:=cur;
			cur:=cur^.next;
		end;
		if(max^.next = NIL) then
			continue;
		insert(pred, max^);
		delete(max, maxPred);
	end;
end;

{Сравнение по имени}
procedure sortByName;
	var cur, pred, max, maxPred : tHum;
		i, j, n:integer;
begin
	n:=count;

	for i:=1 to n do begin
		cur:=first;
		pred:=NIL;
    new(max);
    max^.name:=chr(250);
    {Ищем максимальный}
		for j:=1 to n - i + 1 do begin
			if(compareToName(cur^.name, max^.name) > 0) then
				begin
					max:=cur;
					maxPred:=pred;
				end;
			pred:=cur;
			cur:=cur^.next;
		end;
    {Перебрасываем элементы}
		if(max^.next = NIL) then
			continue;
		insert(pred, max^);
		delete(max, maxPred);
	end;
end;

{Создание списка}
procedure create;
 var i, age, n:integer;
     name:string;
     cur, temp:tHum;
begin
 write('Input num: ');
 readln(n);
 new(cur);
 first:=cur;

 for i:=1 to n do begin
     writeln('Human ', i, ': ');
     write('Name: ');
     readln(cur^.name);

     write('Age: ');
     readln(cur^.age);
     temp:=cur;
     new(cur);
     temp^.next:=cur;
 end;
 temp^.next:=NIL;
end;

{Вывод структуры}
procedure output;
 var i, age, n:integer;
     name:string;
     cur:tHum;
begin
 i:=0;
 cur:=first;
 repeat
       inc(i);
       writeln('--------------');
       writeln('Human number ', i, ':');
       writeln('Name: ', cur^.name);
       writeln('Age: ', cur^.age);
       cur:=cur^.next;
	   if(i mod 3 = 0) then readln;
 until(cur=NIL);
end;

begin
 {Создаем, выводим}
 create;
 output;
end.