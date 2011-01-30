program Step;
Var x:real;
    N:integer;
Function ST(N:integer):real;
         Begin if N=0
               then ST:=1
               else if odd(N)
                    then ST:= x*sqr(ST(N div 2))
                    else ST:= sqr(ST(N div 2))
         End;
Begin writeln('Введите значение числа и искомую степень');
      read(x,N);
      writeln('Число ',x,' в степени ', N, ' равно ',ST(N):0:4)
End.