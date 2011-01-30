// ��������/���������� 7372 - dron1990@mail.ru
PROGRAM DataBase;

USES crt;

CONST
  FileName = 'payroll.txt';
  TempFile = 'temp.txt';
  Header = '--------------- ������� ���� -------------';
  Header1 = '--------------- ���� ������ ---------------';
  Header2 = '------------------ ������ ----------------';
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




  {��������� READRec}
Procedure ReadRec(Var PayrollFile :Text;
                 EmployeeRec :EmployeeRecord);
Var
  SSNumber :String[11];
  Found    :Integer;
Begin
  Writeln;
  Write('������� ����� ��� �����');
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
      Writeln('��� �� ������, ���������� ��� ���');
      Writeln('please try again');
      Writeln;
    End;
End;
{��������� DELRec}
Procedure DelREc(Var NewFile,PayrollFile :TEXT;
                 EMPLOYEErec :EmployeeRecord);
Var
  SSNumber :String[11];
  Found: integer;
Begin
  Write('������� ����� ��� ���������� ���������:');
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
{����������� New File ������� � ���� ��������� ���������}
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
      Writeln('���������', SSNumber, '������ �� �����' );
    End
  Else
    Begin
      Writeln('����� ����������� �����������',SSNumber, '�� ������');
      Writeln ('��������� ����� � ���������� �����');
      Writeln
    End
End;


 {��������� Add Rec}
Procedure AddREc(Var NewFile,PayrollFile :TEXT;
          EMPLOYEERec :EmployeeRecord);
Begin
  Assign(PayrollFile, FileName);
  Reset(PayrollFile);
  Assign(NewFile,TempFile);
  REwrite(NewFile);
  {�������� ����� ���������� �����}
  While NOT EOF(PayrollFile) Do
    Begin
    {����������� ������ ������ �� ���������� � �������}
      Readln(PayrollFile, OneLine);
      Writeln(Newfile, OneLine);
    End;
    {����� ����� ������ � ����������}
  With EmployeeRec DO
    Begin
      Write('���������� ������� ID ����������');           Readln(ID);
      Write('���: ');                                        Readln(Name);
      Write('���������: ');                                  Readln(Position);
      Write('����� ����������� �����������(���-��-����): ');Readln(SSN);
      Write('������: ');                                     Readln(Area);

      {���������� ���������� � New file}
      Writeln(NewFile,ID);
      Writeln(NewFile,Name);
      Writeln(NewFile,Position);
      Writeln(NewFile,SSN);
      Writeln(NewFile, Area);
    End;
  Close(NewFile);
  Close(PayrollFile);
{����������� NEWFILE ������� � ���� ��������� ���������}
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



{��������� ���������}
Procedure UpdateRec(Var NewFile, PayrollFile :Text;
                    EmployeeRec :EmployeeRecord);
Var
  SSNumber :String[11];
  Found    :Integer;
Begin
  Write('���������� ������� ����� ����������� ����������� ���������� ����������');
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
                 Writeln('���������� ������� ����������� ����������');
                 Write(ID);  Readln(ID);
                 Writeln(NewFile,ID);
                 Write('���');Readln(Name);
                 Writeln(NewFile,Name);
                 Write('���������');Readln(Position);
                 Writeln(NewFile,Position);
                 Writeln(NewFile,SSN);
                 Write('������');
                 Readln(Area);
                 Writeln(NewFile, Area);
               End;
            End;{of with}
        End;
      Close(NewFile);
      Close(Payrollfile);
{����������� ��� ����� ������� � ���� ��������� ���������}
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
{��������� ������������}
      Writeln('���������',SSNumber, '��������');
    End
  Else
    Begin
      Writeln('SSN',SSNumber, ' �� ������');
      Writeln('��������� ����� � ����������� �����');
      Writeln
    End;
End;

{-----------------��������� ����---------------}
Procedure Menu;
Var
  Option: Integer;
Begin
   Writeln(Header);
   Writeln;
   Writeln('1.�������� ������ ����������');
   Writeln('2.�������� ������ ����������');
   Writeln('3.������� ����������');
   Writeln('4.�������� ������ ����������');
   Writeln('5.�����' );
   Writeln(Separator);
   Writeln('�������� ����� � ������� �����');
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
    

    {----------------������� ���������-----------}


    Begin{������������ ����������}
      clrscr;
      Title[1]:= 'ID: ';
      Title[2]:= '���: ';
      Title[3]:= '���������: ';
      Title[4]:= 'CC�: ';
      Title[9]:= '������: ';
      Menu
    End.


