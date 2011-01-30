/*	������������ ������ �1 	*/
/* ����������� ������ �  �� ������ ��� 3 ����������, ���������� �� ���������. */
/*  ��������� ������: ���������� �������.� ���� ����:
-���������� ���������� �� ����� �� ��� X � ��� Y,
-���������(���, �������������� �������, ��������� �������),
-����������   ����� */

read_input_file :-
	retractall(ship(_,_,_,_,_)), /* ������� ���� ������ ������ */
	retractall(steps(_)), /* ������� ���������� ����� */
        write('Read input data from "ships.txt"...'),nl,
	seeing(Old),      /* ��������� �������� ������ ���� (�������) */
	see('ships.txt'), /* ��������� ���� � ��������� ������� */
	repeat,
	read(Data),       /* ������ ��������� ������ �� �������� ����� */
	process(Data),
	seen,
	see(Old),
	!. /* ��������� ���� */

process(end_of_file) :- !.
process(Data) :-
        write(Data), nl,
	assertz(Data),
	fail.

/* ��������� ���������� ��������� �� 0 �� 100 */
rand(Z) :- random(X),Z is X*100.

/* N - ����� �������, X,Y - ����������, S - ���������, M-���������� ����� */
/* ��������� �������- 20% - �������, ��������� ��������- 10% - ����, ��������� �������- 25% - ����*/
act(N) :-
	random_move(N), /* ��������� �������� ������� N */
	ship(N,X,Y,S,M),
	rand(Z),
      ( Z=<20,write('Planet: '),meet_planet(N,X,Y,S,M);
        Z>20, Z=<20+10, write('Meteorit: '), meteorit(N,X,Y,S,M);
        Z>20+10, Z=<25+20+10, write('Ship: '), meet_ship(N,X,Y,S,M);
        Z>25+20+10, write('..nothing..'), nl ).

random_move(N) :-
	write('Move: '),
	ship(N,X,Y,S,M),
	rand(Z),
	(  Z =< 25, update_ship(N,X+1,Y,S,M);
	   Z > 25, Z =< 50, update_ship(N,X-1,Y,S,M);
	   Z > 50, Z =< 75, update_ship(N,X,Y+1,S,M);
	   Z > 75, update_ship(N,X,Y-1,S,M)
	), !.

print(NAME,OLD_VALUE,NEW_VALUE) :-
	write(' '), write(NAME), write('='),
	write(OLD_VALUE),
	/* ���� �������� ����������, �� ���������� ����� �������� */
	( OLD_VALUE =\= NEW_VALUE -> write('->'), write(NEW_VALUE); ! ).

/* �������� ��������� ������� N */
update_ship(N,XN,YN,SN,MN) :-
	ship(N,X,Y,S,M),
	XM is XN, YM is YN, SM is SN, MM is MN,
	write('#'), write(N),
	/* �������� ��������� ��������� */
	print('X',X,XM), print('Y',Y,YM), print('S',S,SM), print('M',M,MM), nl,
      	retract(ship(N,X,Y,S,M)),assertz(ship(N,XM,YM,SM,MM)).

/* ������� N �������� ������� */
meet_planet(N,X,Y,S,M) :- update_ship(N,X,Y,S+1,M).
/* ������� N �������� �������� */
meteorit(N,X,Y,S,M) :-  update_ship(N,X,Y,S-1,M).
/* ������� N �������� ������� */
meet_ship(N,X,Y,S,M) :-  update_ship(N,X,Y,S,M+1).

/* ������� ������� N - ������� ��� �� ���� ������ */
kill_ship(N) :-
	 ship(N,X,Y,S,M),
	 retract(ship(N,X,Y,S,M)).

/* ������������ ������ �2 - �������������� ����� ��������� */
/* ������� 2-�: N1 � N2 */
/* ��� ������� ���� �������� ��������( � �� �������� �� ��������� �������),
����� ���� ��������� �����. ��� ���� ���������� ��� �������, ���������
�������� �������� ����. ����� ����� �������� ����� ������� �����������
�� �������, � ������ ������� ��������. ���� �� ��� ������� ��� ����� �
����� ����� ���������� ������� ��������, �������� ���, �� � ����������
�� ������� �������� ���������� ������ �������. */
meet_2(N1,N2) :-
	N1 =\= N2, /* ��� ������ �������! */
	ship(N1,X1,Y1,S1,M1),
	ship(N2,X2,Y2,S2,M2),
	X1 == X2, Y1 == Y2, /* � ���� �������� ������ ������� ���������� */
	write('Meet 2: '), write(N1), write(' '), write(N2), nl,
	(  S1 > S2, /* ���������� 1-�� */
	   update_ship(N1,X1,Y1,S1-1,M1),
	   kill_ship(N1);
	   S1 < S2, /* ���������� 2-�� */
	   update_ship(N2,X2,Y2,S2-1,M2),
	   kill_ship(N2);
	   S1 == S2, /* ������� �������� � ����� ���������� 1 */
	   update_ship(N1,X1,Y1,1,M1),
	   update_ship(N2,X2,Y2,1,M2) ).

/* �������� ������� N1 �� ����� */
meet_2_list(N) :-
	all_ships(X), /* �������� ������ ���� �������� */
	meet_2L(N,X). /* ��������� ������� N1 �� ������� */
meet_2L(N,[H|T]) :-
	/* write(' %'), write(N), write(' '), write(H), ��� ������� */
	meet_2L(N,T),
	( meet_2(N,H); true ),
	!.
meet_2L(_,[]) :- nl.

/* ��� ������� */
all_ships(ALL_SHIPS) :- findall(N,ship(N,_,_,_,_),ALL_SHIPS).

show_ships :- write('Ships list: '), nl, all_ships(X), show_ships(X).
show_ships([]) :- nl.
show_ships([H|T]) :- ship(H,X,Y,S,M),
	write(' #'), write(H),
	write(' X='), write(X),
	write(' Y='), write(Y),
	write(' S='), write(S),
	write(' M='), write(M),
	nl, show_ships(T).

/* ������������ ������ �3 - ������������� �������� �� ������� */
one_step :- show_ships, all_ships(X), one_step(X).
one_step([]) :- nl.
one_step([H|T]) :-
	write('One step: '), write(H), nl,
	meet_2_list(H),
	act(H),
	one_step(T).

modeling(STEP,STEPS) :-
	STEP =< STEPS,
	write('=== Step '), write(STEP), write(' from '),
	write(STEPS), write(' ==='), nl,
	one_step,
	S is STEP+1, modeling(S,STEPS).
modeling :- write('Modeling:'), nl, steps(STEPS), modeling(1,STEPS).

goal :- /* �������� ��������� */
   read_input_file,
   modeling.


















