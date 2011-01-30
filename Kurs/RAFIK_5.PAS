uses
  TPString,
  TPCrt,
  TPCmd,
  TPWindow,
  TPMenu;
type
   tstud=record
           fam:string[15];
           n:string[6];
           sem:string[7];
           pol:string[9];
         end;
   tfrec=record
          adr:word;
          inf:tstud;
         end;
   tf=file of tfrec;


procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($0E, $2E, $03, $1E, $0B, $0E, $19, $78);
  Frame1 : FrameArray = '╔╚╗╝═║';

begin
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(14,2,1,Horizontal,Frame1,Color1,'');
    MenuMode(True, False, False);
    MenuItem('СОЗДАНИЕ',2,1,1,'');
    MenuItem('КОРРЕКЦИЯ',12,1,2,'');
    SubMenu(26,4,1,Vertical,Frame1,Color1,'');
      MenuMode(True, False, False);
      MenuItem('ЗАМЕНА ДАННЫХ',1,1,44,'');
      MenuItem('УДАЛЕНИЕ',2,1,45,'');
      MenuItem('ИЗМЕНЕНИЕ',3,1,46,'');
      PopSublevel;
    MenuItem('ПРОСМОТР',24,1,3,'');
    SubMenu(36,4,1,Vertical,Frame1,Color1,'');
      MenuMode(True, False, False);
      MenuItem('I КУРС',1,1,5,'');
      SubMenu(49,5,1,Vertical,Frame1,Color1,'');
        MenuMode(True, False, False);
        MenuItem('фкти',1,1,11,'');
        SubMenu(56,6,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('9331',1,1,15,'');
          MenuItem('9332',2,1,16,'');
          MenuItem('9361',3,1,17,'');
          PopSublevel;
        MenuItem('фэа',2,1,12,'');
        SubMenu(56,7,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('9432',1,1,18,'');
          MenuItem('9456',2,1,19,'');
          MenuItem('9421',3,1,20,'');
          PopSublevel;
        MenuItem('фэл',3,1,13,'');
        SubMenu(56,8,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('9532',1,1,21,'');
          MenuItem('9546',2,1,22,'');
          MenuItem('9543',3,1,23,'');
          PopSublevel;
        MenuItem('ртф',4,1,14,'');
        SubMenu(56,9,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('9123',1,1,24,'');
          MenuItem('9145',2,1,25,'');
          MenuItem('9132',3,1,26,'');
          MenuItem('9145',4,1,27,'');
          PopSublevel;
        PopSublevel;
      MenuItem('II курс',2,1,6,'');
      MenuItem('III курс',3,1,7,'');
      MenuItem('IV курс',4,1,8,'');
      MenuItem('V курс',5,1,9,'');
      MenuItem('выпускники',6,1,10,'');
      SubMenu(42,11,1,Vertical,Frame1,Color1,'');
        MenuMode(True, False, False);
        MenuWidth(9);
        MenuItem('фэа',1,1,28,'');
        SubMenu(46,13,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('54321',1,1,35,'');
          MenuItem('5423',2,1,36,'');
          PopSublevel;
        MenuItem('ртф',2,1,34,'');
        SubMenu(46,14,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('5323 ',1,1,37,'');
          MenuItem('5345',2,1,38,'');
          PopSublevel;
        MenuItem('фкти',3,1,30,'');
        SubMenu(46,15,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('5323',1,1,39,'');
          MenuItem('5312',2,1,40,'');
          PopSublevel;
        MenuItem('фэл',4,1,31,'');
        SubMenu(46,16,1,Vertical,Frame1,Color1,'');
          MenuMode(True, False, False);
          MenuItem('5643',1,1,41,'');
          MenuItem('5674',2,1,42,'');
          MenuItem('5676',3,1,43,'');
          PopSublevel;
        MenuItem('',5,1,32,'');
        MenuItem('',6,1,33,'');
        MenuItem('',7,1,29,'');
        PopSublevel;
      PopSublevel;
    MenuItem('ВЫХОД',34,1,4,'');
    PopSublevel;

  ResetMenu(M);
  SetMenuDelay(M, 10);
end;

var
  M : Menu;
  Ch : Char;
  Key : MenuKey;
  f:tf;
  stud:tfrec;
  n:integer;
  nok,tek:char;
  Sh,tok:char;

procedure fopen(var f:tf);   {процедура открытия файла}
begin
  assign(F,'c:\RAF_3.dat');
  {$I-}
  reset(f);
  if IOResult<>0 then
    rewrite(f);
  {$I+}
end;
procedure date(var F:tf{; N:word});  {создание списка файла}
 var  Sh:char; { R:TFrec;  B:word; }
   begin
     repeat
     CLRSCR;
       gotoxy(27,4);
       write('ВВОД ДАННЫХ О СТУДЕНТЕ');
       GOTOXY(5,8);
       write('');
       GOTOXY(5,9);
       WRITE('                                                                      ');
       gotoxy(5,10);
       write('      ФАМИЛИЯ            ГРУППА        СЕМ. ПОЛОЖЕНИЕ       ПОЛ       ');
       GOTOXY(5,11);
       write('');
       GOTOXY(5,12);
       WRITE('                                                                      ');
       gotoxy(5,13);
       write('                                                                      ');
       GOTOXY(5,14);
       write('');
       GOTOXY(7,13);
       readln(stud.inf.fam);
       GOTOXY(29,13);
       readln(stud.inf.n);
       gotoxy(47,13);
       readln(stud.inf.sem);
       gotoxy(66,13);
       readln(stud.inf.pol);
  {     seek(f,0);
       read(f,stud.inf.pol);
       if stud.inf.pol=m  then  do

        read(f,stud);
         stud.adr:=buf;

         seek(f,0);
         read(f,R);
         buf:=r.adr;
         seek(f,0);
         r.adr:=N;

         N:=stud.adr;


         while (not EOF(f)) and  (stud.inf.pol<>stud.adr.pol)   do



        end;   }
       write(f,stud);
       gotoxy(6,16);
       write('продолжим? (1-да;0-нет)');
       readln(Sh);
     until Sh='0';
   end;
procedure makefile(var f:tf);  {запись информации в файл}
begin
  fopen(F);
  date(F);
  close(F);
end;

procedure writefile(var f:tf); { чтение информации с файла }
 begin
  fopen(f);
  while not EOF(f) do
    begin
      read(f,stud);
      writeln(stud.inf.pol:4,' ',stud.inf.fam:6,stud.inf.n:7,stud.inf.sem:8);
    end;
  READLN;
  close(f);
 END;
procedure Getstud (var f:tf;          {изменение данных о студенте}
                       fam:string);   { по указанной фамилии}
 var SH:char;

begin
    fopen(f);
    repeat
    CLRSCR;
     GOTOXY(5,5);
     WRITE('СТРОКА ПОДСКАСКИ :');
     GOTOXY(25,5);
     write('введите фамилию студента:  ');
     GOTOXY(51,5);
     readln(fam);
     seek(f,0);
     read(f,stud);
     while (not EOF(f)) and  (fam<>stud.inf.fam)   do
      read(f,stud);
       if fam=stud.inf.fam  then
         begin
          seek(f,filepos(f)-1);
          GOTOXY(10,7);
          WRITE('<<ВВОД НОВЫХ ДАННЫХ О СТУДЕНТЕ>>');
          GOTOXY(5,8);
          write('╔═══════════════════╦═════════════════╦═════════════════╗');
          GOTOXY(5,9);
          write('║     ФАМИЛИЯ       ║     ГРУППА      ║  СЕМ. ПОЛОЖЕНИЕ ║');
          GOTOXY(5,10);
          write('╠═══════════════════╬═════════════════╬═════════════════╣');
          GOTOXY(5,11);
          write('║                   ║                 ║                 ║');
          GOTOXY(5,12);
          write('');
          GOTOXY(7,11);
          readln(stud.inf.fam);
          GOTOXY(29,11);
          readln(stud.inf.n);
          gotoxy(45,11);
          readln(stud.inf.sem);
          write(f,stud);
         end
       else
        begin
         GOTOXY(5,14);
         writeln('стуудент не найден');
        end;
     GOTOXY(5,15);
     write('продолжим? (1-да; 0-нет)');
     readln(Sh);
    until Sh='0';
   CLRSCR;
end;
procedure write_n(var f:tf;            { просмотр данных о студенте}
                      fam:string);         { по указанной фамилии}
 var Sh:char;
begin
 fopen(f);
  repeat
   writeln('введите фамилию студента:  ');
   readln(fam);
   seek(f,0);
   while (not EOF(f)) and  (fam<>stud.inf.fam)   do
    read(f,stud);
       if fam=stud.inf.fam  then
         begin
          seek(f,filepos(f)-1);
          writeln(stud.inf.pol:5,stud.inf.n,stud.inf.sem:7)
         end
       else
          writeln('студент не найден');
   write('продолжим? (1-да; 0-нет)');
   readln(Sh);
  until Sh='0';
 READLN;
end;
procedure delfrec(var f:tf;            { удаление данных о студенте}
                      fam:string);        { по указанной фамилии}
var b:word; r:tfrec;
    buf:word;    ch:char;
begin
  fopen(f);
  repeat
   writeln('введите фамилию студента:  ');
   readln(fam);
   seek(f,0);
   read(f,stud) ;
   while (not EOF(f)) and  (fam<>stud.inf.fam)   do
    read(f,stud);
       if fam=stud.inf.fam  then
        begin
         while not eof(f)  do
          begin
           read(f,stud);
           seek(f,filepos(f)-2);
           write(f,stud);
           seek(f,filepos(f)+1);
          end;
           seek(f,filepos(f)-1);
           truncate(f);
        end
       else
        writeln('студент не найден');
   write('продолжим? (1-да; 0-нет)');
   readln(ch);
 until ch='0';
close(f);
end;


procedure tranckrip(var f:tf);
begin
gotoxy(20,40);
writeln('В ПРОЦЕССЕ ОТЛАДКИ');
readln;
end;

begin
   REPEAT
  CLRSCR;
  InitMenu(M);
  Key := MenuChoice(M, Ch);
  EraseMenu(M, False);
  CASE KEY OF
    1:makefile(F);
    3:writefile( f);
    44:Getstud(f,stud.inf.fam);
    45:delfrec(f,stud.inf.fam);
    46:tranckrip(f);
  END;
 UNTIL KEY=4;
CLRSCR;
  end.

{  InitMenu(M);
  Key := MenuChoice(M, Ch);
  EraseMenu(M, False);
  Writeln('Key=', Key, ' Ch=#', Ord(Ch));
end.  }
