// Капралов/Нестерович 7372 - dron1990@mail.ru
PROGRAM DataBase;

USES crt;

CONST
  FileName = 'payroll.txt';
  TempFile = 'temp.txt';
  Header = '--------------- Главное меню -------------';
  Header1 = '--------------- База данных ---------------';
  Header2 = '------------------ Данные ----------------';
  Separator = '------------------------------------------';
  
Type
  EmployeeRecord = Record
                   ID                    :String[5];
                   Name,Position         :String[20];
                   SSN                   :String[11];
                   Area                  :real;
                   END;
  SSNString = String[11];
VAR
  NewFile,PayrollFile :TEXT;
  EmployeeRec         :EmployeeRecord;
  Title               :Array[1..9] of String[20];
  Oneline             :String[80];
  
  {SEarchprocedure}
Procedure SearchRec(Var PayrollFile: TEXT;
                    EmployeeRec: EmployeeRecord;
                    SSNumber: SSNstring;
		                Var Found: integer);
Begin
  Found := 0;
  Assign(PayrollFile, FileName);
  Reset(PayrollFile);
  While not EOF(PayrollFile) DO
   Begin
     With employeerec DO
       Begin
         Readln(PayrollFile, ID);
         Readln(PayrollFile,Name);
         Readln(PayrollFile,Position);
         Readln(PayrollFile, SSn);
         Readln(PayrollFile, Area);
         IF SSNumber = SSn Then
           Found:=1;
       End;
   End;
Close(PayrollFile);
End;




  {Процедура READRec}
Procedure ReadRec(Var PayrollFile :Text;
                 EmployeeRec :EmployeeRecord);
Var
  SSNumber :String[11];
  Found    :Integer;
Begin
  Writeln;
  Write('Введите номер соц страх');
  Readln(SSNumber);
  SearchRec(PayrollFile, EmployeeRec, SSNumber, Found);
  IF Found = 1 then
    Begin
      Assign(PayrollFile, FileName);
      Reset(PayrollFile);
      While not EOF(PayrollFile) DO
        Begin
          With employeeRec DO
            Begin
              Readln(PayrollFile, ID);
              Readln(PayrollFile,Name);
              Readln(PayrollFile,Position);
              Readln(PayrollFile, SSn);
              Readln(PayrollFile, Area);

              IF SSNumber = SSn Then
                Begin
                  Writeln(Header2);
                  Writeln(Title[1],ID);
                  Writeln(Title[2],Name);
                  Writeln(Title[3],Position);
                  Writeln(Title[4],SSN);
                  Writeln(Title[9],Area);

                End;
            End;
        End;
      Close(PayrollFile);
    End
  Else
    Begin
      Writeln('ССН не найден, попробуйте еще раз');
      Writeln('please try again');
      Writeln;
    End;
End;
{Процедура DELRec}
Procedure DelREc(Var NewFile,PayrollFile :TEXT;
                 EMPLOYEErec :EmployeeRecord);
Var
  SSNumber :String[11];
  Found: integer;
Begin
  Write('Введите номер ССН удаляемого сорудника:');
  Readln(SSNumber);
  SearchRec(PayrollFile, EmployeeRec, SSNumber, Found);
  If found=1 Then
    Begin
      Assign(NewFile,TempFile);
      REwrite(NewFile);
      Assign(PayrollFile, FileName);
      Reset(PayrollFile);
      While NOT EOF(PayrollFile) Do
        Begin
          With EmployeeRec Do
            Begin
              Readln(PayrollFile, ID);
              Readln(PayrollFile, Name);
              Readln(PayrollFile, Position);
              Readln(PayrollFile, Position);
              Readln(PayrollFile, SSN);
              Readln(PayrollFile, Area);

              IF SSNumber <>SSN Then
                Begin
                  Writeln(NewFile,ID);
                  Writeln(NewFile,Name);
                  Writeln(NewFile,Position);
                  Writeln(NewFile,SSN);
                  Writeln(NewFile, Area);
                End;
            End;{end of with}
        End;
      Close(Newfile);
      Close(PayrollFile);
{Копирование New File обратно в файл платежной ведомости}
      Assign(PayrollFile, FileName);
      Rewrite(PayrollFile);
      Assign(NewFile,TempFile);
      Reset(NewFile);
      While NOT EOF(NewFile) Do
        Begin
          Readln(NewFile, OneLine);
          Writeln(PayrollFile, OneLine);
        End;
      Close(NewFile);
      Erase(NewFile);
      Close(PayrollFile);
      Writeln('Сотрудник', SSNumber, 'удален из файла' );
    End
  Else
    Begin
      Writeln('Номер социального страхования',SSNumber, 'не найден');
      Writeln ('Проверьте номер и попробуйте снова');
      Writeln
    End
End;


 {Процедура Add Rec}
Procedure AddREc(Var NewFile,PayrollFile :TEXT;
          EMPLOYEERec :EmployeeRecord);
Begin
  Assign(PayrollFile, FileName);
  Reset(PayrollFile);
  Assign(NewFile,TempFile);
  REwrite(NewFile);
  {Проверка конца текстового файла}
  While NOT EOF(PayrollFile) Do
    Begin
    {Копирование каждой записи из пэйролфайл в ньюфайл}
      Readln(PayrollFile, OneLine);
      Writeln(Newfile, OneLine);
    End;
    {Прием новой записи с клавиатуры}
  With EmployeeRec DO
    Begin
      Write('Пожалуйста введите ID сотрудника');           Readln(ID);
      Write('Имя: ');                                        Readln(Name);
      Write('Должность: ');                                  Readln(Position);
      Write('Номер социального страхования(ххх-хх-хххх): ');Readln(SSN);
      Write('Регион: ');                                     Readln(Area);

      {Сохранение информации в New file}
      Writeln(NewFile,ID);
      Writeln(NewFile,Name);
      Writeln(NewFile,Position);
      Writeln(NewFile,SSN);
      Writeln(NewFile, Area);
    End;
  Close(NewFile);
  Close(PayrollFile);
{Копирование NEWFILE обратно в файл платежной ведомости}
  Assign(PayrollFile, FileName);
  Rewrite(PayrollFile);
  Assign(NewFile,TempFile);
  Reset(NewFile);
  While NOT EOF(NewFile) Do
    Begin
      Readln(NewFile, OneLine);
      Writeln(PayrollFile, OneLine);
    End;
    Close(NewFile);
    Erase(NewFile);
    Close(PayrollFile);
End;



{Процедура АпдэйтРек}
Procedure UpdateRec(Var NewFile, PayrollFile :Text;
                    EmployeeRec :EmployeeRecord);
Var
  SSNumber :String[11];
  Found    :Integer;
Begin
  Write('Пожалуйста введите номер социального страхования удаляемого сотрудника');
  Readln(SSNumber);
  SearchRec(PayrollFile, EmployeeRec, SSNumber, Found);
  If Found=1  Then
    Begin
      Assign(PayrollFile, FileName);
      Reset(PayrollFile);
      Assign(NewFile, TempFile);
      Rewrite(NewFile);
      While not EOF(PayrollFile) DO
        Begin
          With EmployeeRec DO
            Begin
              Readln(PayrollFile, ID);
              Readln(PayrollFile,Name);
              Readln(PayrollFile,Position);
              Readln(PayrollFile, SSn);
              Readln(PayrollFile, Area);

             IF SSNumber <> SSn Then
               Begin
                 Writeln(NewFile,ID);
                 Writeln(NewFile,Name);
                 Writeln(NewFile,Position);
                 Writeln(NewFile,SSN);
                 Writeln(NewFile,Area);
               End
             Else
               Begin
                 Writeln('Пожалуйста введите обновленную информацию');
                 Write(ID);  Readln(ID);
                 Writeln(NewFile,ID);
                 Write('Имя');Readln(Name);
                 Writeln(NewFile,Name);
                 Write('Должность');Readln(Position);
                 Writeln(NewFile,Position);
                 Writeln(NewFile,SSN);
                 Write('Регион');
                 Readln(Area);
                 Writeln(NewFile, Area);
               End;
            End;{of with}
        End;
      Close(NewFile);
      Close(Payrollfile);
{Копирование нью файла обратно в файл платежной ведомости}
      Assign(PayrollFile, FileName);
      Rewrite(PayrollFile);
      Assign(NewFile,TempFile);
      Reset(NewFile);
      While NOT EOF(NewFile) Do
        Begin
          Readln(NewFile, OneLine);
          Writeln(PayrollFile, OneLine);
        End;
      Close(NewFile);
      Erase(NewFile);
      Close(PayrollFile);
{Сообщения пользователя}
      Writeln('Сотрудник',SSNumber, 'обновлен');
    End
  Else
    Begin
      Writeln('SSN',SSNumber, ' не найден');
      Writeln('Проверьте номер и попытайтесь снова');
      Writeln
    End;
End;

{-----------------Процедура меню---------------}
Procedure Menu;
Var
  Option: Integer;
Begin
   Writeln(Header);
   Writeln;
   Writeln('1.Показать запись сотрудника');
   Writeln('2.Добавить нового сотрудника');
   Writeln('3.Удалить сотрудника');
   Writeln('4.Обновить запись сотрудника');
   Writeln('5.Выход' );
   Writeln(Separator);
   Writeln('Сделайте выбор и нажмите цифру');
   Readln(Option);
      Case Option OF
        1 : ReadRec(PayrollFile,EmployeeRec);
        2 : AddRec(NewFile,PayrollFile,EmployeeRec);
        3 : DelRec(NewFile,PayrollFile,EmployeeRec);
        4 : UpdateRec(NewFile,PayrollFile,EmployeeRec);
        5 : Exit
      End;
      Menu
    End;
    

    {----------------Главная программа-----------}


    Begin{Присваивание заголовков}
      clrscr;
      Title[1]:= 'ID: ';
      Title[2]:= 'Имя: ';
      Title[3]:= 'Должность: ';
      Title[4]:= 'CCН: ';
      Title[9]:= 'Регион: ';
      Menu
    End.


