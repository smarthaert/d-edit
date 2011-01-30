// ╘шёхщёър  ═рЄры№ 
program theSnake;

uses graph,crt;

type direction=(up,down,right,left); { direction of snake's movement }
     segment=record             { one 'piece' of snake's boby }
	     x,y:integer;
	     d:direction
	     end;

                                { constants for different pictures }
const hhor=1;                   { snake's head }
    { hvert=2; }                { not used }
      bod=3;                    { piece of snake's body }
    { thor=4; }                 { not used }
    { tvert=5; }                { not used }
      land=6;                   {   }
      f=7;                      {   }

      MapX = 128;
      MapY = 96;

label plgn; { play new game label }
      {pl1}

var ltext,ls:string;

    l,r:integer;

    scol, { snake's body color }
    pcol, { color of picture on snake }
    lcol:integer; { land color }

    rpt:boolean; { repeat the game }

    snk:array[1..7] of pointer; { array for exemplars of game graphics blocks }

    snake:array [1..1000] of segment;   { this is a snake }

    sizebod,    { size of picture for body }
    sizeland,   { size of picture for land }
    sizehead,   { size of picture for head }
    sizefood,   { size of picture for food }
                { all this is used when plcing pictures to memory }
    i,j:integer;

    used:array[0..MapX,0..MapY] of boolean; { used for snake body }

    food:record        { stores location of food for snake }
         x,y:integer
	 end;

    dr,md,err:integer; { used for graphics initialization }

{    key:char; }         { stores pressed key to control the snake }

    delay_duration:integer; { influenses snake speed }

{ places new food }
procedure PlaceFood;
begin
  repeat food.x:=random(MapX-2)+1;
	 food.y:=random(MapY-5)+3;
  until not used[food.x,food.y];
end;

procedure move;        { procedure; most game is inside it }
begin
  delay(delay_duration); { pause before snake makes one move }

  with snake[1] do { where was snake's head now is body }
  begin
    putimage(x*5,y*5,snk[bod]^,normalput);
    used[x,y]:=true;

    while keypressed do { if some key was pressed, checks if it
                          changed direction of movement         }
    begin
      case ReadKey of
        #0:
          case ReadKey of
            #72:if d<>down then d:=up;     { up arrow         }
            #80:if d<>up then d:=down;     { down arrow       }
            #77:if d<>left then d:= right; { right arrow      }
            #75:if d<>right then d:=left;  { left arrow       }
          end;
        #27:halt end;                  { Esc to exit game }
      end;

      for i:=l-1 downto 1 do         { changing coordinates of each }
  begin snake[i+1].x:=snake[i].x;    { snake's segment              }
	snake[i+1].y:=snake[i].y;
	snake[i+1].d:=snake[i].d
  end;

      case d of                                     { cheks if snake      }
       up:begin y:=y-1; if y=2 then y:=MapY-2 end;      { has left the screen }
       down:begin y:=y+1; if y=MapY-3 then y:=3 end;
       right:begin x:=x+1; if x=MapX-1 then x:=1 end;
       left:begin x:=x-1; if x=0 then x:=MapX-2 end
      end;

       if (snake[1].x=food.x)and(snake[1].y=food.y) { checks if snake eats }
       then                                         { food                 }
   begin l:=l+2;

	 str(l div 2-3,ls); { counting score }

         PlaceFood; { places new food }

         putimage(food.x*5,food.y*5,snk[f]^,normalput); { drawing food }
	 setfillstyle(1,0);
	 bar(70,1,110,13); { to rewrite score amount on screen puts black bar }
	 line(4,0,4,4);
         outtextxy(75,8,ls);
    end;

  if used[snake[1].x,snake[1].y] then
  begin setcolor(not lcol); { if snake has crushed }
	settextjustify(centertext,centertext);
	outtextxy(getmaxx div 2,getmaxy div 2,ltext);
	rpt:=false;
  end
       else putimage(x*5,y*5,snk[hhor]^,normalput); { if hasn't crushed }


       putimage(snake[l].x*5,snake[l].y*5,snk[land]^,normalput); { snake's }
       used[snake[l].x,snake[l].y]:=false;                       { tail is }
                                                                 { moving  }
                                                                 { from    }
                                                                 { where   }
                                                                 { it was  }
 end
end;




begin writeln('Choose snake color (from 1 to 14)');   { snake color }
      repeat readln(scol) until (scol>0)and(scol<15);
      if scol>1 then scol:=scol+1;                    { 2 - color of land }
      {write('Определите цвет узора на змейке ');
      readln(pcol);}
      writeln('Choose snake speed (from 1 to 12)');   { snake speed }
      repeat readln(delay_duration) until (delay_duration<13)and(delay_duration>0);
      delay_duration:=(13-delay_duration)*2000;

      pcol:=14;

      dr:=vga;                         { initializing graphics }
      md:=vgahi;                       {                       }
      initgraph(dr,md,'');             {                       }

      err:=graphresult;                { if error in           }
      if err<>grok                     { initializing show it  }
      then write(grapherrormsg(err))   {                       }
      else                             { else start program }
 begin ltext:=chr(1)+' '+chr(2)+' GAME OVER! TRY AGAIN? y/n '+chr(2)+' '+chr(1);
       settextjustify(centertext,centertext); { text shown when loose game}

  plgn:l:=6;      { starting snake length }
       rpt:=true; { game will run if rpt=true }

       with snake[1] do
  begin d:=right;
	for x:=0 to MapX do { all squares are free when start game }
  	  for y:=0 to MapY do
	    used[x,y]:=false;

	randomize;         { random starting position of snake }
	x:=random(MapX-16)+16;
	y:=random(MapY-16)+16;

        PlaceFood;
  end;

	for i:=2 to l do
	begin snake[i].x:=snake[1].x;
	      snake[i].y:=snake[1].y;
	      snake[i].d:=snake[1].d
	end;

       lcol:=2;
       setrgbpalette(2,5,15,1);       { making standart green darker }
       setcolor(2);
       setfillstyle(1,2);
       bar(5,15,getmaxx-5,getmaxy-5); { filling game screen by green color }

       setcolor(scol);                { drawing square of snake body }
       setfillstyle(1,scol);
       bar(5,5,9,9);
       setcolor(pcol);
       line(7,6,8,7);
       line(6,7,7,8);
       putpixel(5,5,2);
       putpixel(5,9,2);
       putpixel(9,9,2);
       putpixel(9,5,2);

       sizebod:=imagesize(5,5,9,9); { size of body image in bytes }
       getmem(snk[bod],sizebod);    { memory for keeping body image }
       getimage(5,5,9,9,snk[bod]^); { placing image of snake's body to
                                    { memory                           }

       setfillstyle(1,2);            { drawing land square }
       bar(5,5,9,9);                 {                     }
       sizeland:=imagesize(5,5,9,9); { size of land image in bytes }
       getmem(snk[land],sizeland);   { memory for keeping land image }
       getimage(5,5,9,9,snk[land]^); { placing land image to memory }

       setcolor(pcol);               { drawing snake's head }
       setfillstyle(1,pcol);
       bar(5,5,9,9);
       putpixel(5,5,2);
       putpixel(5,9,2);
       putpixel(9,9,2);
       putpixel(9,5,2);
       sizehead:=imagesize(5,5,9,9); { size of head image in bytes }
       getmem(snk[hhor],sizehead);   { memory for keeping head image }
       getimage(5,5,9,9,snk[hhor]^); { placing head image to memory }

       putimage(5*snake[1].x,5*snake[1].y,snk[bod]^,normalput);
       { drawing first segment of snake }

       setfillstyle(1,0); { drawing abowe where all pictures were drawn
                            before saved in memory                      }
       bar(5,5,9,9);

       setcolor(not lcol);  { drawing first food and saving it's image }
       setfillstyle(1,not lcol);
       bar(food.x*5+1,food.y*5+1,food.x*5+3,food.y*5+3);
       sizefood:=imagesize(food.x*5,food.y*5,food.x*5+4,food.y*5+4);
       getmem(snk[f],sizefood);
       getimage(food.x*5,food.y*5,food.x*5+4,food.y*5+4,snk[f]^);
       putimage(5*food.x,5*food.y,snk[f]^,normalput);

       setfillstyle(1,0); { drawing a game screen }
       bar(0,0,4,4);
       bar(90,1,150,13);
       setcolor(15);
       rectangle(4,0,635,475);
       line(4,14,635,14);
       setcolor(15);
       settextjustify(centertext,centertext);
       outtextxy(50,8,'Score: '); { place to display score }
       outtextxy(75,8,'0');
       settextjustify(lefttext,centertext);

       repeat
         move    { launch game }
       until rpt=false;

       while true do { if loose the game may choose to continue }
         case readKey of
           'y','Y': goto plgn;
           'n','N': break;
         end;
  end;

  closegraph;                   { turn the graphics off! }
  freemem(snk[bod],sizebod);    { cleaning memory }
  freemem(snk[land],sizeland);  {                 }
  freemem(snk[hhor],sizehead);  {                 }
  freemem(snk[f],sizefood);     {                 }
end.