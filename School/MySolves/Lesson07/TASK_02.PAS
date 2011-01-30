Program Fibon;
Var f1,N:integer;
Function FIB(N:integer):integer;
var f:integer;
begin if N=1
      then begin fib:=0; f1:=1 end
      else begin f:=fib(N-1);
                 fib:=f+f1;
                 f1:=f
           end;
end;
BEGIN f1:=0;
writeln('Введите номер искомого числа Фибоначчи: ');
read(N);
writeln('Это число равно ',fib(N))
END.