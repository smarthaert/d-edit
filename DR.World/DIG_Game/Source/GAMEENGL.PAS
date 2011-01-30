{                (c) Copyright Andrea Boehm, 1997. All rights reserved.}
{ Hi boys, my name is Andrea Boehm, I live in Tradate (VA) Italy. This is the
  first game I made and I know it isn't fantastic but I'm only 14 and I
  program with Turbo Pascal since a year so let me to learn more in my future
  years. Special thanks to Luca Barbetti: my neighbour who has help me a lot
  in the realization of this game.
  To contact me send an E-mail at boehm@mercury.tread.it
  and visit my Turbo Pascal site http://www.dido.net/pascal/home.html
                                 HAVE FUN GUYS !!!}
Program DIGITAL_INTERACTIVE_GAMES;
uses crt,gdriver,gkernel;
var freq:word;
    nota,chra:char;
    moneta,tent:string;
    puntata,numero,montepremi,AspectLoc,rad:real;
    a,b,c,d,e,f,g,h,i,ch,l,k,m,n,o,p,nu,w:integer;
    q,r,s,t,delta,alfa,direzione,life,laps,oldx,oldy,x,y:integer;
    first_time,time,scontro:boolean;
    label 5,6,7,8,9,10;

const up=1;
      down=2;
      right=3;
      left=4;

Procedure PISTA;
 Begin
 writeln ('                                    Start                              ');
 writeln ('                                   รฤฤฤฤฤฤ                             ');
 writeln ('       ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
 writeln ('       บ                                                               บ');
 writeln ('       บ                                                               บ');
 writeln ('       บ                                                               บ');
 writeln ('       บ           ษอออออออออออออออออออออออออออออออออออออออป           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           บ                                       บ           บ');
 writeln ('       บ           ศอออออออออออออออออออออออออออออออออออออออผ           บ');
 writeln ('       บ                                                               บ');
 writeln ('       บ                                                               บ');
 writeln ('       บ                                                               บ');
 writeln ('       ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ');
 writeln;
 end;
 Procedure STATUS;
  Begin
   gotoxy (10,23);
   writeln ('               Life: ',life,'                Laps:',laps);
  end;
 Procedure CRASH;
  Begin
   gotoxy (oldx,oldy);
   write (' ');
   gotoxy (x,y);
   Sound (400);
   Delay (100);
   NoSound;
   write ('ฑฑฑ');
   Delay (1800);
   gotoxy (x,y);
   write ('   ');
   if y<4 then
            Begin
             y:=4;
             direzione:=right;
            end;
   if y>21 then
             Begin
              y:=21;
              direzione:=left;
             end;
   if x>71 then
             Begin
              x:=71;
              direzione:=down;
             end;
   if x<9 then
             Begin
              x:=9;
              direzione:=up;
             end;
   life:=life-1;
   if life=0 then
       Begin
        writeln;
        clrscr;
        textmode (1);
        textbackground (1);
        textcolor (14);
        clrscr;
        textcolor (30);
        gotoxy (6,12);
        writeln ('        HAI PERSO !!!');
        readln;
        scontro:=true;
        textmode (3);
       end;
  end;
 Procedure STAMPA;
  Begin
   gotoxy (oldx,oldy);
   write (' ');
   gotoxy (x,y);
   writeln ('Ü');
  end;
 Procedure SU;
  Begin
   direzione:=up;
   dec (y);
   if y<4 then CRASH;
  end;
 Procedure GIU;
  Begin
   direzione:=down;
   inc (y);
   if y>21 then CRASH;
  end;
 Procedure DESTRA;
  Begin
   direzione:=right;
   inc (x);
   if x>71 then CRASH;
  end;
 Procedure SINISTRA;
  Begin
   direzione:=left;
   dec (x);
   if x<8 then CRASH;
  end;
 Procedure TASTO;
  Begin
   if (keypressed) then
    Begin
      chra:=readkey;
      if chra=#72 then SU
      else if chra=#80 then GIU
           else if chra=#75 then SINISTRA
                else if chra=#77 then DESTRA
    end;
 end;
Procedure VINTO;
  Begin
   writeln;
   clrscr;
   textmode (1);
   textbackground (1);
   textcolor (14);
   clrscr;
   textcolor (30);
   gotoxy (5,13);
   writeln ('  CONGRATULATIONS YOU WON !!!');
   readln;
  end;
Begin
 begin
 InitGraphic;
 DefineWorld (1,0,1000,1000,0);
 SelectWorld (1);
 SelectWindow (1);
 DrawBorder;
 rad:=1.5;
 AspectLoc:=GetAspect;
 SetAspect (0.2);
 Setforegroundcolor (1);
 for i:=1 to 15 do
     Begin
      DrawCircle (500,500,rad);
      SetAspect (0.2+i/10);
      rad:=rad-0.05;
     end;
 end;
 Delay (8000);
 SetAspect (AspectLoc);
 LeaveGraphic;
 textmode (1);
 textbackground (1);
 clrscr;
 textcolor (31);
 gotoxy (8,9);
 writeln ('DIGITAL INTERACTIVE GAMES');
 textcolor (14);
 gotoxy (9,14);
 writeln ('Designed by Andrea Boehm');
 gotoxy (5,16);
 writeln ('Special thanks to Luca Barbetti');
 gotoxy (29,25);
 writeln ('Version 2.1');
 readln;
 5:
  clrscr;
  textmode (3);
  textbackground (1);
  clrscr;
  writeln;
  textcolor (14);
  writeln;
  textcolor (14);
  writeln ('          1. Roulette ');
  writeln;
  writeln ('          2. Dies ');
  writeln;
  writeln ('          3. Master Mind ');
  writeln;
  writeln ('          4. Music Player ');
  writeln;
  writeln ('          5. Turbo Race  -Beta Version- ');
  writeln;
  writeln ('          6. Exit ');
  writeln;
  write ('   Choose a game by typing a number :');
  textcolor (30);
  readln (ch);
  case ch of
 1:Begin
     Begin
      Sound (400);
      Delay (300);
      Sound (500);
      delay (300);
      Sound (600);
      Delay (300);
      Sound (300);
      Delay (300);
      Sound (200);
      Delay (300);
      Sound (500);
      Delay (300);
      Sound (400);
      Delay (300);
      Sound (800);
      Delay (300);
      time:=true;
     end;
    Nosound;
   repeat
    alfa:=0;
    clrscr;
    textbackground (3);
    clrscr;
    textcolor (4);
    writeln ('          * * * * * * * * * * * * * * * * * * * * * * * * * * *');
    writeln ('          *    ___   ___              ___ _____ _____   ___   *');
    writeln ('          *   ณ___ณ ณ   ณ ณ   ณ ณ    ณ___   ณ     ณ    ณ___   *');
    writeln ('          *   ณ \   ณ___ณ ณ___ณ ณ___ ณ___   ณ     ณ    ณ___   *');
    writeln ('          *                                                   *');
    writeln ('          * * * * * * * * * * * * * * * * * * * * * * * * * * *');
    if (time) then
            Begin
             alfa:=alfa+4;
             writeln (' Choose currency');
             gotoxy (2,4+alfa);
             readln (moneta);
             writeln (' Type the amount of money you have');
             gotoxy (2,6+alfa);
             readln (montepremi);
             time:=false;
            end;
    writeln (' Type the amount of money you want to gamble ');
    gotoxy (2,8+alfa);
    readln (puntata);
    if (puntata>montepremi) then
                        Begin
                         writeln ('Sorry but you are cheating !');
                         readln;
                         goto 5
                        end
    else
       Begin
        writeln (' Choose a number from 0 to 36');
        gotoxy (2,10+alfa);
        readln (numero);
        if numero>36 then
     Begin
      writeln;
      writeln (' The number you choose is illegal');
      readln;
      goto 5;
     end;
    randomize;
    for i:= 1 to 1 do
                    Begin
                     a:=random (37);
                     writeln (' The drawn number is ',a);
                    end;
    readln;
    if numero=a then
                 Begin
                   for l:=1 to 30 do
                                 Begin
                                  freq:=l*50+200;
                                  Sound (freq);
                                  Delay (80);
                                 end;
                   NoSound;
                   writeln (' Congratulations! You won ',puntata*36:4:0,moneta);
                   montepremi:=montepremi+puntata*36;
                   writeln ('Your total money is  ',montepremi:4:0,moneta);
                   end
    else
        Begin
          for l:=30 downto 1 do
                             Begin
                              freq:=l*50+200;
                              Sound (freq);
                              Delay (80);
                             end;
          NoSound;
          writeln (' Sorry, you lost ',puntata:4:0, moneta);
          montepremi:=montepremi-puntata;
          writeln (' Your total money is ',montepremi:4:0,moneta);
        end;
        if montepremi=0 then
                       Begin
                         writeln;
                         writeln ('     Sorry, but you haven''t got any money left !');
                         readln;
                         goto 5;
                       end;
    readln;
    writeln (' Type 1 to play again or 2 to exit');
    gotoxy (2,17+alfa);
    readln (ch);
    end;
   until ch=2;
    goto 5
   end;
 2: Begin
       Begin
        Sound (600);
        Delay (300);
        Sound (500);
        Delay (300);
        Sound (400);
        Delay (300);
        Sound (300);
        Delay (300);
        Sound (400);
        Delay (300);
        Sound (500);
        Delay (300);
        Sound (400);
        Delay (300);
        Sound (800);
        Delay (300);
        Sound (800);
        Delay (600);
        Sound (1200);
        Delay (200);
        first_time:=true;
       end;
      Nosound;
     repeat
      delta:=0;
      clrscr;
      textbackground (3);
      clrscr;
      textcolor (4);
      writeln ('                       * * * * * * * * * * * * * ');
      writeln ('                       *            ___  ___   * ');
      writeln ('                       *   ณ \   ณ ณ___ ณ__    * ');
      writeln ('                       *   ณ___\ ณ ณ___ ___ณ   * ');
      writeln ('                       *                       * ');
      writeln ('                       * * * * * * * * * * * * * ');
      if (first_time) then
              Begin
                delta:=delta+4;
                writeln (' Choose currency');
                gotoxy (2,4+delta);
                readln (moneta);
                writeln (' Type the amount of money you have');
                gotoxy (2,6+delta);
                readln (montepremi);
                first_time:=false;
              end;
      writeln (' Type the amount of money you want to gamble');
      gotoxy (2,delta+8);
      readln (puntata);
      if (puntata)>(montepremi) then
                   Begin
                    writeln (' Sorry but you are cheating ! ');
                    readln;
                    goto 5
                   end
      else
        Begin
         randomize;
         for i:=1 to 1 do
                     Begin
                      6:
                       a:=random (7);
                       b:=random (7);
                       if (a=0) or (b=0) then goto 6
                       else writeln (' The drawn numbers are ',a,' e ',b);
                       readln;
                     end;
        end;
      if a=b then
        Begin
         if a=6 then
                Begin
                 for l:=1 to 60 do
                                Begin
                                 freq:=l*50+200;
                                 Sound (freq);
                                 Delay (80);
                                end;
                 NoSound;
                 writeln (' Congratulations! You won ',puntata*36:4:0,moneta);
                 montepremi:=montepremi+puntata*36;
                 writeln (' Your total money is ',montepremi:4:0,moneta);
                 readln;
                end
         else
         if a+b=6 then
                    Begin
                     for l:=1 to 40 do
                                  Begin
                                   freq:=l*50+200;
                                   Sound (freq);
                                   Delay (80);
                                  end;
                     NoSound;
                     writeln (' You won ',puntata*3:4:0,moneta);
                     montepremi:=montepremi+puntata*3;
                     writeln (' Your total money is ',montepremi:4:0,moneta);
                     readln;
                    end
         else
           Begin
              for l:=40 downto 1 do
                                 Begin
                                  freq:=l*50+200;
                                  Sound (freq);
                                  Delay (80);
                                 end;
              NoSound;
              writeln (' Sorry, you lose ',puntata:4:0,moneta);
              montepremi:=montepremi-puntata;
              writeln (' Your total money is ',montepremi:4:0,moneta);
              readln;
           end;
           end
         else
           Begin
             if (a=6) or (b=6) then
                                 Begin
                                  for l:=1 to 50 do
                                                Begin
                                                 freq:=l*50+200;
                                                 Sound (freq);
                                                 Delay (80);
                                                end;
                   NoSound;
                   writeln (' Congratulations! You won ',puntata*10:4:0,moneta);
                   montepremi:=montepremi+puntata*10;
                   writeln (' Your total money is ',montepremi:4:0,moneta);
                   readln;
                  end
             else
               Begin
                 if a+b=6 then
                             Begin
                              for l:=1 to 40 do
                                    Begin
                                     freq:=l*50+200;
                                     Sound (freq);
                                     Delay (80);
                                    end;
                 NoSound;
                 writeln (' You won ',puntata*3:4:0,moneta);
                 montepremi:=montepremi+puntata*3;
                 writeln (' Your total money is ',montepremi:4:0,moneta);
                 readln;
               end
      else
        Begin
         for l:= 40 downto 1 do
                            Begin
                             freq:=l*50+200;
                             Sound (freq);
                             Delay (80);
                            end;
         NoSound;
         writeln (' Sorry, but you lose ',puntata:4:0,moneta);
         montepremi:=montepremi-puntata;
         writeln (' Your total money is ',montepremi:4:0,moneta);
         readln;
        end;
        end;
        end;
    writeln (' Type 1 to play again or 2 to exit');
    gotoxy (2,delta+15);
    readln (ch);
    until ch=2;
    goto 5
    end;
 3: Begin
     clrscr;
     textbackground (3);
     clrscr;
     textcolor (4);
     writeln ('       * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
     writeln ('       *        __   __ _____  ___  ___                        *');
     writeln ('       *  ณ\/ณ ณ__ณ ณ__   ณ   ณ___ ณ___ณ   ณ\/ณ ณ ณ\  ณ  ณ\    *');
     writeln ('       *  ณ  ณ ณ  ณ ___ณ  ณ   ณ___ ณ  \    ณ  ณ ณ ณ  \ณ  ณ__\  *');
     writeln ('       *                                                       *');
     writeln ('       * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
     Sound (700);
     Delay (700);
     Sound (800);
     Delay (300);
     Sound (600);
     Delay (350);
     Sound (400);
     Delay (700);
     Sound (800);
     Delay (600);
     Sound (200);
     Delay (600);
     NoSound;
     randomize;
     for k:=1 to 1 do
                  Begin
                   8:
                   m:=random (10);
                   n:=random (10);
                   o:=random (10);
                   p:=random (10);
                  end;
     if (m=n) or (m=o) or (m=p) or (n=o) or (n=p) or (o=p) then goto 8
     else
      Begin
       nu:=0;
       writeln ('      Type 4 digits in the range 0 to 9 without blanks');
       writeln;
       writeln ('          You can''t have 2 or more same digits');
       writeln;
       writeln ('x=correct digit in the correct place');
       writeln ('y=correct digit in the wrong place');
       9:
       nu:=nu+1;
       if nu=11 then
                 Begin
                  for l:=30 downto 1 do
                  Begin
                  freq:=l*50+200;
                  Sound (freq);
                  Delay (80);
                  end;
                  NoSound;
                  writeln;
                  writeln ('       Sorry you have run out of chances');
                  writeln;
                  writeln ('       The right combination is ',m,n,o,p);
                  readln;
                  goto 5
                 end
       else
       Begin
       7:
       for i:=1 to 4 do
       tent [i]:= chr (0);
       readln (tent);
       q:=ord (tent [1])-48;
       r:=ord (tent [2])-48;
       s:=ord (tent [3])-48;
       t:=ord (tent [4])-48;
       for i:=1 to 4 do
                     Begin
                      if (tent [i]< '0') or (tent [i]> '9') then goto 7;
                     end;
       gotoxy (30,12+nu);
       if q=m then write (' x')
       else
        Begin
         if q=n then write (' y')
         else
          Begin
           if q=o then write (' y')
           else
            Begin
             if q=p then write (' y');
            end;
          end;
        end;
       if r=n then write (' x')
       else
        Begin
         if r=m then write (' y')
         else
          Begin
           if r=o then write (' y')
           else
            Begin
             if r=p then write (' y');
            end;
          end;
        end;
       if s=o then write (' x')
       else
        Begin
         if s=m then write (' y')
         else
          Begin
           if s=n then write (' y')
           else
            Begin
             if s=p then write (' y');
            end;
          end;
        end;
       if t=p then write (' x')
       else
        Begin
         if t=m then write (' y')
         else
          Begin
           if t=n then write (' y')
           else
            Begin
             if t=o then write (' y');
            end;
          end;
        end;
       writeln;
       if (q=m) and (r=n) and (s=o) and (t=p) then
                                     Begin
                                      for l:=1 to 40 do
                                        Begin
                                         freq:=l*50+200;
                                         Sound (freq);
                                         Delay (80);
                                        end;
                                      NoSound;
                                      VINTO;
                                      goto 5
                                     end
       else goto 9
       end;
       end;
       end;
 4: Begin
    clrscr;
    textbackground (1);
    clrscr;
    textcolor (14);
    writeln ('    You can play the first 7 notes with the first 7 numbers, hit 8 to exit');
    writeln;
    writeln ('                                   0=pause');
    10:
    nota:=readkey;
    if (nota>'8') or (nota<'0') then goto 10
    else
   Begin
   case nota of
    '1': Begin
          Sound (262);
          repeat until keypressed;
          goto 10;
         end;
    '2': Begin
          Sound (294);
          repeat until keypressed;
          goto 10;
         end;
    '3': Begin
          Sound (330);
          repeat until keypressed;
          goto 10;
         end;
    '4': Begin
          Sound (349);
          repeat until keypressed;
          goto 10;
         end;
    '5': Begin
          Sound (392);
          repeat until keypressed;
          goto 10;
         end;
    '6': Begin
          Sound (440);
          repeat until keypressed;
          goto 10;
         end;
    '7': Begin
          Sound (494);
          repeat until keypressed;
          goto 10;
         end;
    '8': Begin
          NoSound;
          goto 5;
         end;
    '0': Begin
          NoSound;
          goto 10;
         end;
    end;
    end;
    end;
 5:  Begin
   clrscr;
   textmode (3);
   scontro:=false;
   life:=3;
   laps:=1;
   oldx:=10;
   oldy:=10;
   x:=oldx;
   y:=oldy;
   PISTA;
   repeat
    if scontro=true then goto 5;
    TASTO;
    STAMPA;
    STATUS;
    oldx:=x;
    oldy:=y;
     if direzione=up  then SU;
      if direzione=down then GIU;
      if direzione=right then DESTRA;
      if direzione=left then SINISTRA;
          if (direzione<right) then Delay (160)
         else Delay (100);
   until chra=#27;
   textmode (3);
  clrscr;
  goto 5;
  end;
 6: exit
    end;
 End.




















