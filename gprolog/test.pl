a(1,2).
a(2,3).
g(X) :- a(X,Y), write(X), write(' '), write(Y), nl.
goal(All) :- findall(X,g(X),All), retractall(a(_,_)).
