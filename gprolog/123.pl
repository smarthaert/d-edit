/*	Лабораторная работа №1 	*/
/* Реализовать объект с  не меньше чем 3 свойствами, определить их изменение. */
/*  Выбранный объект: Космческий корабль.У него есть:
-координаты нахождения на карте по оси X и оси Y,
-состояние(цел, незначительная поломка, серьёзная поломка),
-количество   денег */

read_input_file :-
	retractall(ship(_,_,_,_,_)), /* Очищаем базу данных фактов */
	retractall(steps(_)), /* Удаляем количество шагов */
        write('Read input data from "ships.txt"...'),nl,
	seeing(Old),      /* Сохраняем открытый сейчас файл (консоль) */
	see('ships.txt'), /* Открываем файл с исходными данными */
	repeat,
	read(Data),       /* Читаем очередную строку из входного файла */
	process(Data),
	seen,
	see(Old),
	!. /* Закрываем файл */

process(end_of_file) :- !.
process(Data) :-
        write(Data), nl,
	assertz(Data),
	fail.

/* Случайное количество процентов от 0 до 100 */
rand(Z) :- random(X),Z is X*100.

/* N - номер корабля, X,Y - координаты, S - состояние, M-количество денег */
/* встретить планету- 20% - починка, встретить метеорит- 10% - урон, встретить корабль- 25% - торг*/
act(N) :-
	random_move(N), /* Случайное движение корабля N */
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
	/* Если значение изменилось, то напечатаем новое значение */
	( OLD_VALUE =\= NEW_VALUE -> write('->'), write(NEW_VALUE); ! ).

/* Обновить состояние корабря N */
update_ship(N,XN,YN,SN,MN) :-
	ship(N,X,Y,S,M),
	XM is XN, YM is YN, SM is SN, MM is MN,
	write('#'), write(N),
	/* Печатаем изменение координат */
	print('X',X,XM), print('Y',Y,YM), print('S',S,SM), print('M',M,MM), nl,
      	retract(ship(N,X,Y,S,M)),assertz(ship(N,XM,YM,SM,MM)).

/* Корабль N встретил планету */
meet_planet(N,X,Y,S,M) :- update_ship(N,X,Y,S+1,M).
/* Корабль N встретил метеорит */
meteorit(N,X,Y,S,M) :-  update_ship(N,X,Y,S-1,M).
/* Корабль N встретил корабль */
meet_ship(N,X,Y,S,M) :-  update_ship(N,X,Y,S,M+1).

/* Убиваем корабль N - стираем его из базы фактов */
kill_ship(N) :-
	 ship(N,X,Y,S,M),
	 retract(ship(N,X,Y,S,M)).

/* Лабораторная работа №2 - взаимодействие между кораблями */
/* Встреча 2-х: N1 и N2 */
/* При встрече двух кораблей объектов( а не кораблей из случайной встречи),
между ними возникает дуэль. при этом выигрывает тот корабль, состояние
здоровья которого выше. после дуэли здоровье этого корабля уменьшается
на единицу, а второй корабль погибает. Если же оба корабля при входе в
дуэль имеют одинаковый уровень здоровья, выживают оба, но в результате
их уровень здоровья становится равным единице. */
meet_2(N1,N2) :-
	N1 =\= N2, /* Это разные корабли! */
	ship(N1,X1,Y1,S1,M1),
	ship(N2,X2,Y2,S2,M2),
	X1 == X2, Y1 == Y2, /* У двух кораблей строго совпали координаты */
	write('Meet 2: '), write(N1), write(' '), write(N2), nl,
	(  S1 > S2, /* Выигрывает 1-ый */
	   update_ship(N1,X1,Y1,S1-1,M1),
	   kill_ship(N1);
	   S1 < S2, /* Выигрывает 2-ой */
	   update_ship(N2,X2,Y2,S2-1,M2),
	   kill_ship(N2);
	   S1 == S2, /* Уровень здоровья у обоих становится 1 */
	   update_ship(N1,X1,Y1,1,M1),
	   update_ship(N2,X2,Y2,1,M2) ).

/* Проверка встречи N1 со всеми */
meet_2_list(N) :-
	all_ships(X), /* Получаем список всех кораблей */
	meet_2L(N,X). /* Проверяем встречу N1 со списком */
meet_2L(N,[H|T]) :-
	/* write(' %'), write(N), write(' '), write(H), Для отладки */
	meet_2L(N,T),
	( meet_2(N,H); true ),
	!.
meet_2L(_,[]) :- nl.

/* Все корабли */
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

/* Лабораторная работа №3 - моделирование процесса по времени */
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

goal :- /* Основная программа */
   read_input_file,
   modeling.


















