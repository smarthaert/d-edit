Program ListSort;{N100319}
 type tHum = ^human;
      human = record
            name:string;
            age:integer;
            next:tHum;
      end;

 var first:tHum;

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
 output;
 readln;
end.