{Лабораторная работа #1 по дисциплине "программирование".
Выполнил Болычев Виталий Станиславович, ФКТИ, группа 9362, дата выполнения 25.03.2010}

unit filework;
     interface
     uses crt,dos;
     type rec=record
               name:string;
               phone:string;
end;
{Поле глобальных пепеменных}
var doc:file of rec; S : PathStr; kont:rec; flg_doc:boolean; t:byte;
{-------------------------------}
     procedure initialization;
     procedure filecon; {Процедура заполнния файла}
     procedure vst_el;
     procedure change;
     procedure del_el;
     procedure sorting;
     procedure print;
     procedure find;
     procedure menuonscr(k:byte); {Процедура визуализации меню-1}
     procedure topmenu(var s:byte); {Процедура выбора меню-2}

{---------------------------------------------------------------}
implementation
var i:byte;
{--------------------------------------------------------------------}

procedure menuonscr(k:byte);
         procedure edit_file;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        textcolor(red);
                        writeln(' +  Добавить элементы');
                        textcolor(blue);
                        writeln(' - Вставить элемент перед последним элементом');
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        writeln(' - Удалить последний элемент с заданным значением');
                        writeln(' - Найти номера всех элементов с заданным значением');
                        writeln(' - Отсортировать по имени');
                        writeln(' - Удалить файл (очистить базу)');
                        writeln(' - Выйти');
                        end;
              procedure change_file;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        textcolor(red);
                        writeln(' +  Вставить элемент перед последним элементом');
                        textcolor(blue);
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        writeln(' - Удалить последний элемент с заданным значением');
                        writeln(' - Найти номера всех элементов с заданным значением');
                        writeln(' - Отсортировать по имени');
                        writeln(' - Удалить файл (очистить базу)');
                        writeln(' - Выйти');
                        end;
              procedure find_file;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        writeln(' - Вставить элемент перед последним элементом');
                        textcolor(red);
                        writeln(' +  Заменить значение последнего по порядку элемента с заданным значением');
                        textcolor(blue);
                        writeln(' - Удалить последний элемент с заданным значением');
                        writeln(' - Найти номера всех элементов с заданным значением');
                        writeln(' - Отсортировать по имени');
                        writeln(' - Удалить файл (очистить базу)');
                        writeln(' - Выйти');
                        end;
              procedure ins_elem;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        writeln(' - Вставить элемент перед последним элементом');
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        textcolor(red);
                        writeln(' +  Удалить последний элемент с заданным значением');
                        textcolor(blue);
                        writeln(' - Найти номера всех элементов с заданным значением');
                        writeln(' - Отсортировать по имени');
                        writeln(' - Удалить файл (очистить базу)');
                        writeln(' - Выйти');
                        end;
              procedure del_elem;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        writeln(' - Вставить элемент перед последним элементом');
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        writeln(' - Удалить последний элемент с заданным значением');
                        textcolor(red);
                        writeln(' +  Найти номера всех элементов с заданным значением');
                        textcolor(blue);
                        writeln(' - Отсортировать по имени');
                        writeln(' - Удалить файл (очистить базу)');
                        writeln(' - Выйти');
                        end;

              procedure sorting;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        writeln(' - Вставить элемент перед последним элементом');
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        writeln(' - Удалить последний элемент с заданным значением');
                        writeln(' - Найти номера всех элементов с заданным значением');
                        textcolor(red);
                        writeln(' +  Отсортировать по имени');
                        textcolor(blue);
                        writeln(' - Удалить файл (очистить базу)');
                        writeln(' - Выйти');
                        end;

              procedure del_file;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        writeln(' - Вставить элемент перед последним элементом');
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        writeln(' - Удалить последний элемент с заданным значением');
                        writeln(' - Найти номера всех элементов с заданным значением');
                        writeln(' - Отсортировать по имени');
                        textcolor(red);
                        writeln(' +  Удалить файл (очистить базу)');
                        textcolor(blue);
                        writeln(' - Выйти');
                        end;
              procedure exit;
                        begin
                        clrscr;
                        writeln(' Выберите один из следующих пунктов меню:');
                        writeln;
                        writeln(' - Добавить элементы');
                        writeln(' - Вставить элемент перед последним элементом');
                        writeln(' - Заменить значение последнего по порядку элемента с заданным значением');
                        writeln(' - Удалить последний элемент с заданным значением');
                        writeln(' - Найти номера всех элементов с заданным значением');
                        writeln(' - Отсортировать по имени');
                        writeln(' - Удалить файл (очистить базу)');
                        textcolor(red);
                        writeln(' +  Выйти');
                        textcolor(blue);
                        end;
              begin
                   case k of
                        1: edit_file;
                        2: change_file;
                        3: find_file;
                        4: ins_elem;
                        5: del_elem;
                        6: sorting;
                        7: del_file;
                        8: exit;
                   end;
              end;

              procedure topmenu(var s:byte);
              var a:char; i:byte;
                  begin
                       i:=1;
                       textbackground(15);
                       textcolor(blue);
                       menuonscr(i);
                       a:=' ';
                       while ord(a)<>13 do
                             begin
                                  a:=readkey;
                                  if ord(a)=0 then a:=readkey;
                                  case ord(a) of
                                       72: begin if i>1 then i:=i-1; menuonscr(i); end;
                                       80: begin if i<8 then inc(i); menuonscr(i); end;
                                       9: begin
                                               clrscr;
                                               print;
                                               readkey;
                                          end;
                                     end;
                                  s:=i;
                             end;
              end;
{----------------------------------------------------------------------}

              procedure initialization;
              var a:char;
                        begin
                        t:=1;
                        clrscr;
                        assign (doc,'data.bin');
                        S := FSearch('data.bin', GetEnv('PATH')); {Ищет файл и возвращает в перемунную S путь(или '' если нет)}
                        if S = '' then
                           begin
                                WriteLn('Базовый файл "Data.bin" не найден!');
                                writeln('Создать необходимый файл? (y/n)');
                                a:=readkey;
                                case a of
                                     'y':begin rewrite(doc); flg_doc:=false; end;
                                     'n':begin
                                              writeln('Нажмите любую клавишу для выхода...');
                                              readkey;
                                              halt;
                                         end;
                                     end;
                           end
                        else
                            begin
                                 reset(doc);
                                 flg_doc:=true; {true - уже существует и найден}
                                 WriteLn('Инициализация успешно завершена... ');
                                 writeln('Базовый файл найден как ', FExpand(S));
                                 delay(2500);
                            end;
              end;


{-----------------------------------------------------------------------------}

procedure filecon;
var a:char;
          begin
               writeln('Впишите имя и номер контакта в соответствующие поля');
               a:='.';
               i:=1;
               if flg_doc=true then seek(doc,filesize(doc));
               repeat
                     write(filepos(doc),'. Имя: ');
                     readln(kont.name);
                     write('   Номер: ');
                     readln(kont.phone);
                     write(doc,kont);
                     writeln('"Esc" - окончить ввод; Любая другая клавиша - продолжить ввод');
                     a:=readkey;
               until ord(a)=27;
          end;

{------------------------------------------------------------------------}

procedure vst_el;
         begin
              seek(doc,filesize(doc)-1);
              read(doc,kont);
              write(doc,kont);
              seek(doc,filesize(doc)-2);
              writeln('Впишите имя и номер контакта в соответствующие поля');
              write('   Имя: ');
              readln(kont.name);
              write('   Номер: ');
              readln(kont.phone);
              write(doc,kont);
         end;

{-----------------------------------------------------------------------}


procedure change;
  var kont_srch:rec; pos:integer;
          begin
               pos:=-1;
               seek(doc,0);
               writeln('Пожалуйста, введите имя контакта');
               readln(kont_srch.name);
               repeat
                     read(doc,kont);
                     if kont.name=kont_srch.name then
                     pos:=filepos(doc)-1;
               until eof(doc);
               if pos=-1 then begin writeln('Совпадений не найдено...'); readkey; end
                  else
                  begin
                       seek(doc,pos);
                       writeln('Впишите новые имя и номер контакта в соответствующие поля');
                       write('   Имя: ');
                       readln(kont.name);
                       write('   Номер: ');
                       readln(kont.phone);
                       write(doc,kont);
                  end;
end;

{--------------------------------------------------------------------}

procedure del_el;
var temp:file of rec; tmp_rec,kont_srch:rec; i,pos:integer;
          begin
               pos:=-1;
               writeln('Пожалуйста, введите имя контакта');
               readln(kont_srch.name);
               seek(doc,0);
               repeat
                     read(doc,kont);
                     if kont.name=kont_srch.name then
                     pos:=filepos(doc)-1;
               until eof(doc);
               if pos=filesize(doc)-1 then
                  begin
                       seek(doc,filesize(doc)-1);
                       truncate(doc);
                  end
               else
                   begin
                        for i:=pos to filesize(doc)-2 do
                            begin
                                 seek(doc,i+1);
                                 read(doc,tmp_rec);
                                 seek(doc,i);
                                 write(doc,tmp_rec);
                            end;
                        seek(doc,filesize(doc)-1);
                        truncate(doc);
                   end;
end;


{-----------------------------------------------------------------------}

procedure print;
          begin
               clrscr;
               seek(doc,0);
               while not eof(doc) do
                     begin
                          read(doc,kont);
                          writeln(filepos(doc),'. ',kont.name);
                          writeln('   ',kont.phone);
                     end;
               if filesize(doc)=0 then
                  writeln('---------- Файл пуст ----------');
          end;

{------------------------------------------------------------------------}

procedure sorting;
          var i,j:integer; el_1,el_2:rec;
          begin
               for i:=1 to filesize(doc)-1 do
                   for j:=0 to filesize(doc)-1-i do
                       begin
                            seek(doc,j);
                            read(doc,el_1);
                            read(doc,el_2);
                            if el_1.name>el_2.name then
                               begin
                               seek(doc,j);
                               write(doc,el_2);
                               write(doc,el_1);
                               end;
                       end;
          end;
{------------------------------------------------------------------------}




procedure find;
          var  i:integer; srch:rec; a:char;
          begin
               writeln('Пожалуйста, введите имя контакта');
               readln(srch.name);
               seek(doc,0);
               for i:=0 to filesize(doc)-1 do
                   begin
                        read(doc,kont);
                        if srch.name=kont.name then
                           begin
                                writeln(i,'. ',kont.name);
                                writeln('   ',kont.phone);
                           end;
                   end;
               readkey;
          end;

end.