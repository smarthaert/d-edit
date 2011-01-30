program Pochta;
        uses graph,crt;
var c:char; k:byte;

procedure initialization;
var
  driver,error_inf: Integer;

begin
     driver := detect;
     initgraph(driver, driver,'egavga.bgi');
     error_inf:= graphresult;
     k:=1;
     c:=' ';
     if error_inf = grok then
        begin
             setbkcolor(7);
             settextstyle(0,0,1);
        end
     else
        begin
             writeln('Ошибка инициализации графики...');
             writeln('Информация об ошибке:', grapherrormsg(error_inf));
             writeln('Нажмите любую клавишу для выхода...');
             readkey;
        end;
end;


procedure search_menu;
var srch:string[10];
          begin
               gotoxy(59,2);
               c:=readkey;
               while (ord(c)<>9) and (ord(c)<>13) do c:=readkey;
               if ord(c)=9 then k:=1;
               if ord(c)=13 then read(srch);
          end;


procedure normsinstyle(x1,y1,x2,y2,msgx,msgy:integer; message:string);
var s,t:real; m,i,d:integer;
          begin
               setfillstyle(1,8);
               s:=0;
               i:=0;
               d:=x1;
               t:=(x2-x1)/7;
               m:=round(t);
               while s<(2*pi/5) do
               begin
                    i:=round(sin(s)*10);
                    d:=d+m;
                    bar(x1,y1+i,x2,y2+i);
                    setcolor(white);
                    outtextxy(msgx,msgy+i,message);
                    setcolor(8);
                    line(msgx,msgy+20,d,msgy+20);
                    delay(190);
                    s:=s+2/10;
               end;

          end;

procedure backsinstyle(x1,y1,x2,y2,msgx,msgy:integer; message:string);
var s,t:real; m,i,d:integer;
    begin
         setfillstyle(1,0);
         s:=2*pi/5;
         d:=x2;
         t:=(x2-x1)/7;
         m:=round(t);
         while s>0 do
               begin
                    i:=round(sin(s)*10);
                    d:=d-m;
                    bar(x1,y1+i+3,x2,y2+i+3);
                    setcolor(8);
                    outtextxy(msgx,msgy+i,message);
                    setcolor(0);
                    line(d,msgy+20,x2+2,msgy+20);
                    delay(100);
                    s:=s-2/10;
               end;
         bar(x1,y1+i,x2,y2+i);
         setcolor(8);
         outtextxy(msgx,msgy,message);

end;


procedure exit_menu;
          begin
               normsinstyle(19,0,60,10,20,2,'выйти');
               c:=readkey;
               while (ord(c)<>9) and (ord(c)<>13) do c:=readkey;
               if ord(c)=9 then inc(k);
               backsinstyle(19,0,60,10,20,2,'выйти');
          end;

procedure add_menu;
          begin
               normsinstyle(99,0,165,10,100,2,'добавить');
                c:=readkey;
               while (ord(c)<>9) and (ord(c)<>13) do c:=readkey;
               if ord(c)=9 then inc(k);
               backsinstyle(99,0,165,10,100,2,'добавить');
          end;



procedure delete_menu;
          begin
               normsinstyle(200,0,256,10,200,2,'удалить');
                c:=readkey;
               while (ord(c)<>9) and (ord(c)<>13) do c:=readkey;
               if ord(c)=9 then inc(k);
               backsinstyle(200,0,256,10,200,2,'удалить');
          end;



procedure top_video;
          begin
               textcolor(8);
               setcolor(8);
               line(0,40,getmaxx,40);
               line(450,40,450,getmaxy);
               setfillstyle(1,1);
               setlinestyle(solidln,3,1);
               rectangle(460,10,630,35);
               {setcolor(8);}
               outtextxy(20,2,'выйти');
               outtextxy(100,2,'добавить');
               outtextxy(200,2,'удалить');
               outtextxy(525,2,'поиск');
          end;


begin
     initialization;
     top_video;
     {while (ord(c)<>9) and (ord(c)<>13) do c:=readkey;
     case ord(c) of
                 9: begin if k=4 then k:=0; inc(k); end;
     end;}
     while ord(c)<>13 do begin
     case k of
                           1: exit_menu;
                           2: add_menu;
                           3: delete_menu;
                           4: search_menu;

     end;
     end;
                 {13: case k of
                            1:
                            2:
                            3:
                            4:}






end.



