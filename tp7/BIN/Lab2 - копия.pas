Program Lab2;{N100319}
 type tHum = ^human;
      human = record
            name:string;
            age:integer;
            next:tHum;
      end;

 var first:tHum;
 
function equals(a, b:human):boolean;
begin
	equals:=(a.name = b.name) and
		(b.age = a.age);
end;

procedure insert(point:tHum; hum:human);
	var temp:tHum;
		tempHum:human;
begin
	new(temp);
	temp^ := hum;
	writeln('temp^.name= ', temp^.name);
	temp^.next := point^.next;
	point^.next := temp;
end;

procedure insertPos;
	var	a, b, eq:human;
		cur:tHum;
begin	
	writeln('---Input human to compare---');
	write('  name: ');
	readln(eq.name);
	write('  age: ');
	readln(eq.age);
	writeln;
	
	writeln('---Input human to insert---');
	write('  name: ');
	readln(b.name);
	write('  age: ');
	readln(b.age);
	writeln;
	
	cur:=first;
	
	while(cur <> NIL) do begin
		writeln(cur^.name);
		if(equals(cur^, eq)) then
		begin
			insert(cur, b);
			writeln('---');
		end;
		cur := cur^.next;
	end;
	{while(not eof(tf)) do begin
		read(tf, a);
		write(f, a);
		if(equals(a, eq)) then
			write(f, b);
	end;
	close(f);
	close(tf);}
end;

procedure changePos;
	var i, j:integer;
		a, b, eq:human;
		cur:tHum;
begin
	
	writeln('---Input human to compare---');
	write('  name: ');
	readln(eq.name);
	write('  age: ');
	readln(eq.age);
	writeln;
	
	writeln('---Input human to rechange---');
	write('  name: ');
	readln(b.name);
	write('  age: ');
	readln(b.age);
	writeln;
	
	cur:=first;	
	while(cur <> NIL) do begin
		if(equals(cur^, eq)) then
			begin
				cur^.name := b.name;
				cur^.age := b.age;
				break;
			end;
		cur:=cur^.next;
		writeln('---');
	end;
	{i:=0;
	while(not eof(f) and not equals(a, eq)) do begin
		read(f, a);
		inc(i);
	end;
	
	if(not equals(a, eq)) then exit;
	
	seek(f, i - 1);
	write(f, b);
	
	close(f);}
end;

procedure delete(point, pred:tHum);
begin
	if(pred <> NIL) then
		pred^.next:=point^.next
	else
		first:=point^.next;
	dispose(point);
end;

procedure deletePos;
	var	a, eq:human;
		flag:boolean;
		cur, pred:tHum;
begin
	writeln('---Input human to compare and delete---');
	write('  name: ');
	readln(eq.name);
	write('  age: ');
	readln(eq.age);
	writeln;
	
	cur:=first;
	pred:=NIL;
	while(cur <> NIL) do begin
		if(equals(cur^, eq)) then
			begin
				delete(cur, pred);
				break;
			end;
		pred:=cur;
		cur:=cur^.next;
	end;
end;

procedure find;
	var i:integer;
		a, eq:human;
		cur:tHum;
begin
	writeln('---Input human to find---');
	write('  name: ');
	readln(eq.name);
	write('  age: ');
	readln(eq.age);
	writeln;
	
	i:=0;
	cur:=first;
	while(cur <> NIL) do begin
		inc(i);
		if(equals(cur^, eq)) then
			break;
		cur:=cur^.next;
	end;
	
	writeln('The number is ', i);
end;

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

procedure sortByAge;
	var cur, pred, max, maxPred : tHum;
		i, j, n:integer;
begin
	n:=count;
	
	for i:=1 to n do begin
		cur:=first;
		pred:=NIL;
		for j:=1 to n - i + 1 do begin
			if(cur^.age > max^.age) then
				begin
					max:=cur;
					maxPred:=pred;
				end;
			pred:=cur;
			cur:=cur^.next;
		end;
		insert(cur, max^);
		delete(max, maxPred);
	end;
end;

procedure create;
 var i, age, n:integer;
     name:string;
     cur:tHum;
begin
 write('Input num: ');
 readln(n);

 new(first);
 writeln('Human ', 1, ': ');
 write('Name: ');
 readln(name);
 first^.name:=name;

 write('Age: ');
 readln(age);
 first^.age:=age;
 first^.next:=cur;

 for i:=2 to n do begin
     writeln('Human ', i, ': ');
     write('Name: ');
     readln(cur^.name);

     write('Age: ');
     readln(cur^.age);
     new(cur^.next);
     cur^.next:=cur;
 end;
 writeln(first^.name);
 cur^.next:=NIL;
end;

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
 until(cur=NIL);
end;

begin
 create;
 insertPos;
 output;
 readln;
end.