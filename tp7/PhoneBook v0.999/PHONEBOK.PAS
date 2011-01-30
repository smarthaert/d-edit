{Лабораторная работа #1 по дисциплине "программирование".
Выполнил Болычев Виталий Станиславович, ФКТИ, группа 9362, дата выполнения 25.03.2010}
program lab_rab1;
uses crt,dos,filework;

{--------------------------------------------------------}
          begin
               initialization;
               while t<>8 do
                     begin
                          topmenu(t);
                          case t of
                               1:filecon;
                               2:vst_el;
                               3:change;
                               4:del_el;
                               5:find;
                               6:sorting;
                               7:begin close(doc); erase(doc); initialization; end;
                               8:begin
                               close(doc);
                               halt;
                               end;
                          end;
                     end;
          end.
