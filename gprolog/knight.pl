act(N,HP,XP,X,Y,LVL) :-  
           random(E),Z is E*100,(Z=<5,write('Dragon!'),nl,battledragon(N,HP,XP,X,Y,LVL);
                     Z>5,Z=<10,pit(N,HP,XP,X,Y,LVL);
                    Z>10,Z=<20,potion(N,HP,XP,X,Y,LVL);
                    Z>20,Z=<50,write('Monster!'),nl,battlemonster(N,HP,XP,X,Y,LVL);Z>50,write('Hm...nothing!'),nl),!.

battledragon(N,HP,XP,X,Y,LVL) :-  random(E),Z is E*100,
                                  (Z=<30,killdragon(N,HP,XP,X,Y,LVL);
                                  knockeddragon(N,HP,XP,X,Y,LVL)),!.

     killdragon(N,HP,XP,X,Y,LVL) :- write('I killed Dragon!'),nl,XP1 is XP+LVL*5,
                                    retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP1,X,Y,LVL)),
                                    ulvl(N,HP,XP1,X,Y,LVL),!.

     knockeddragon(N,HP,XP,X,Y,LVL) :- write('I am hited by Dragon!'),nl,random(E),Z is E*100,
                                       (Z=<20,Z1 is 20;Z>=100,Z1 is 100;Z1 is Z),write(' Damage is -'),write(Z1),nl,
                                       (Z1=<HP,HP1 is HP - Z1;HP1 is 0),
                                       (HP1=0,killed(N,HP,XP,X,Y,LVL);
                                        retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP1,XP,X,Y,LVL)),
                                        battledragon(N,HP1,XP,X,Y,LVL)),!.

     killed(N,HP,XP,X,Y,LVL) :- write('I am killed!'),nl,XP1 is XP-LVL*5,HP1 is 100,
                                retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP1,XP1,0,0,LVL)),
                                dlvl(N,HP1,XP1,0,0,LVL),!.

battlemonster(N,HP,XP,X,Y,LVL) :-  random(E),Z is E*100,
                                   Q is 50+LVL,(Q>80,Q1 is 80;Q=<80,Q1 is Q),
                                   (Z=<Q,killmonster(N,HP,XP,X,Y,LVL);knockedmonster(N,HP,XP,X,Y,LVL)),!.

     killmonster(N,HP,XP,X,Y,LVL) :- write('I killed monster!'),nl,
                                     XP1 is XP+LVL*3,
                                     retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP1,X,Y,LVL)),
                                     ulvl(N,HP,XP1,X,Y,LVL),!.

     knockedmonster(N,HP,XP,X,Y,LVL) :- write('I am hited by monster!'),nl,random(E),Z is E*100,
                                        (LVL>20,L is 20;L is LVL),
                                        (Z=<20-L,Z1 is 20-L;Z>=70-L,Z1 is 70-L;Z1 is Z),write(' Damage is -'),
                                        write(Z1),nl,
                                        (Z1=<HP,HP1 is HP - Z1;HP1 is 0),
                                        (HP1=0,killed(N,HP,XP,X,Y,LVL);
                                        retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP1,XP,X,Y,LVL)),
                                        battlemonster(N,HP1,XP,X,Y,LVL)),!.

pit(N,HP,XP,X,Y,LVL) :- write('A PIT!'),nl,HP1 is HP-35,(HP1=<0,killed(N,HP,XP,X,Y,LVL);HP1>0,
                        retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP1,XP,X,Y,LVL))),!.                            

potion(N,HP,XP,X,Y,LVL) :- write('O, healing!'),nl,HP1 is HP+25,(HP1>=100,HP2 is 100;HP2 is HP1),
                           retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP2,XP,X,Y,LVL)),!.

ulvl(N,HP,XP,X,Y,LVL) :- XP1 is XP-(LVL*3)*(LVL*5),(XP1>0,write('Lvl up!'),nl,HP1 is 100,LVL1 is LVL+1;
                         XP1=<0,LVL1 is LVL,HP1 is HP),
                         retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP1,XP,X,Y,LVL1)),!.

dlvl(N,HP,XP,X,Y,LVL) :- (XP<0,XP2 is 0,LVL1 is 1;(XP2 is XP,XP1 is XP-((LVL-1)*3*(LVL-1)*5),
                         (XP1<0,write('Lvl down!'),nl,LVL1 is LVL-1;LVL1 is LVL))),
                         retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP2,X,Y,LVL1)),!.

heal(N,HP,XP,X,Y,LVL) :- write('I heal myself!'),nl,HP1 is HP+10,(HP1>=100,HP2 is 100;HP2 is HP1),
                           retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP2,XP,X,Y,LVL)),!. 

show(N,I) :- knight(N,HP,XP,X,Y,LVL),write('Step #'),write(I),nl,
                                  write('Knight #'),write(N),nl,
                                  write('HP  : '),write(HP),nl,
                                  write('XP  : '),write(XP),nl,
                                  write('X   : '),write(X),nl,
                                  write('Y   : '),write(Y),nl,
                                  write('LVL : '),write(LVL),nl.


init :- write('Enter number of knights : '),read(K),nl,(K>0,initilization(K,0);
        write('Error#1 : Number of knights cannot be less then 1'),nl),!.
initilization(K,I) :- I1 is I+1,I1=<K,write('Enter X of '),write(I1),write(' knight : '),read(X),
                                      write('Enter Y of '),write(I1),write(' knight : '),read(Y),
                      assertz(knight(I1,100,0,X,Y,1)),initilization(K,I1),!;write('OK'),nl,start1(K),!.


start1(K) :-  randomize,write('Enter the number of steps : '),read(I),start2(K,I),!.
start2(K,I) :- I>0,analization(K,1,I,[]),I1 is I-1,start2(K,I1);I=<0,start,!.



add(E,S,[E|S]).
connect([H|T],C,S) :- connect(T,[H|C],S).
connect([],C,C). 
cop(S,S).

analization1(K,N,P,C) :-  add(N,C,C1),knight(N,HP,XP,X,Y,LVL),arround(N,X,Y,[],K,0,P,C1),!.

analization(K,N,P,C) :- (N=<K,member1(N,C),knight(N,HP,XP,X,Y,LVL),arround(N,X,Y,[],K,0,P,S),connect(S,C,C1),N1 is N+1,analization(K,N1,P,C1);N=<K,N1 is N+1,analization(K,N1,P,C);1==1),!.

arround(N,X,Y,S,K,I,P,C) :- X1 is X-1,X2 is X+1,Y1 is Y-1,Y2 is Y+1,(knight(NUM,HP,XP,X,Y,LVL);
                      knight(NUM,HP,XP,X1,Y,LVL);
                      knight(NUM,HP,XP,X2,Y,LVL);
                      knight(NUM,HP,XP,X,Y1,LVL);
                      knight(NUM,HP,XP,X,Y2,LVL);
                      knight(NUM,HP,XP,X1,Y1,LVL);
                      knight(NUM,HP,XP,X2,Y2,LVL);
                      knight(NUM,HP,XP,X1,Y2,LVL);
                      knight(NUM,HP,XP,X2,Y1,LVL)),member1(NUM,S),I1 is I+1,add(NUM,S,S1),
       (I1<K,arround(N,X,Y,S1,K,I1,P,C);(I1>=3,!,go(S1,I1,K,P),cop(S1,C);go1(S1,P),cop(S1,C);1==1,cop(S1,C))),!.

lok(N,S,N2,K) :- (N=<K,(member1(N,S),N2 is N;N1 is N+1,lok(N1,S,N2,K));N2 is N),!.

member1(_,[]) :- 1==1.
member1(N,[H|T]) :- H\=N,member1(N,T). 

go(S,I,K,P) :- movec(S,S,I,0,P),!.
go1([N|T],P) :- moven(N,P),go1(T,P).
go1([],P).

moven(N,P) :- knight(N,HP,XP,X,Y,LVL),(HP<50,show(N,P),heal(N,HP,XP,X,Y,LVL),show(N,P);random(E),Z is E*100,
                                                                 (Z=<25, movehxn(N,HP,XP,X,Y,LVL,P);
                                                                  Z>25,Z=<50, movehyn(N,HP,XP,X,Y,LVL,P);
                                                                  Z>50,Z=<75, movelxn(N,HP,XP,X,Y,LVL,P);
                                                                  Z>75,       movelyn(N,HP,XP,X,Y,LVL,P))),!.

movehxn(N,HP,XP,X,Y,LVL,P) :- X1 is X+1,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP,X1,Y,LVL)),act(N,HP,XP,X1,Y,LVL),show(N,P),!.
movehyn(N,HP,XP,X,Y,LVL,P) :- Y1 is Y+1,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP,X,Y1,LVL)),act(N,HP,XP,X,Y1,LVL),show(N,P),!.
movelxn(N,HP,XP,X,Y,LVL,P) :- X1 is X-1,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP,X1,Y,LVL)),act(N,HP,XP,X1,Y,LVL),show(N,P),!.
movelyn(N,HP,XP,X,Y,LVL,P) :- Y1 is Y-1,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),asserta(knight(N,HP,XP,X,Y1,LVL)),act(N,HP,XP,X,Y1,LVL),show(N,P),!.

movec(S,[N|T],I,K,P) :- knight(N,HP,XP,X,Y,LVL),(HP<50,K1 is K+1;K1 is K),movec(S,T,I,K1,P),!.
movec(S,[],I,K,P) :- (K>=I/2,F is 1,move(S,F,P);F is 0,move(S,F,P)),!.

move(S,F,P) :- (F==1,healing(S,P);moving(S,P)).

healing([N|T],P) :- knight(N,HP,XP,X,Y,LVL),heal(N,HP,XP,X,Y,LVL),show(N,P), healing(T,P).
healing([],P).

moving(S,P) :- random(E),Z is E*100,(Z=<25, movehx(S,P);
                                   Z>25,Z=<50, movehy(S,P);
                                   Z>50,Z=<75, movelx(S,P);
                                   Z>75,       movely(S,P)),!.

movehx([N|T],P) :- knight(N,HP,XP,X,Y,LVL),X1 is X+1,!,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),
                 asserta(knight(N,HP,XP,X1,Y,LVL)),act(N,HP,XP,X1,Y,LVL),show(N,P),movehx(T,P),!.
movehx([],P).

movehy([N|T],P) :- knight(N,HP,XP,X,Y,LVL),Y1 is Y+1,!,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),
                 asserta(knight(N,HP,XP,X,Y1,LVL)),act(N,HP,XP,X,Y1,LVL),show(N,P),movehy(T,P),!.
movehy([],P).

movelx([N|T],P) :- knight(N,HP,XP,X,Y,LVL),X1 is X-1,!,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),
                 asserta(knight(N,HP,XP,X1,Y,LVL)),act(N,HP,XP,X1,Y,LVL),show(N,P),movelx(T,P),!.
movelx([],P).

movely([N|T],P) :- knight(N,HP,XP,X,Y,LVL),Y1 is Y-1,!,show(N,P),retract(knight(N,HP,XP,X,Y,LVL)),
                 asserta(knight(N,HP,XP,X,Y1,LVL)),act(N,HP,XP,X,Y1,LVL),show(N,P),movely(T,P),!.
movely([],P).


allretract(N) :- retract(knight(N,HP,XP,X,Y,LVL)),N1 is N+1,allretract(N1);1==1,!.
start :- write('1 - begin ; 2 - clear list of knights ; 3 - exit from start : '),read(C),(C==1, init;C==2, allretract(1),write('DONE'),nl,start;C==3;start),!.
Y,LVL),show(N,P),movelx(T