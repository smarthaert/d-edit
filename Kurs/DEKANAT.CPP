#include <io.h>
#include <fcntl.h>
#include <iostream.h>
#include <dos.h>
#include <stdlib.h>
#include <conio.h>
#include <stdio.h>
#include <string.h>

#define FileName "dekanat.dat"
const unsigned long
   Male=1,
   Female=0,
   Married=1,
   NotMarried=0;

struct student
{
  char Name[30];
  unsigned long Group;
  unsigned long Sex;
  unsigned long Birthday;
  unsigned long House;  //nome obchejitiya
  unsigned long Ball;
  unsigned long Stip;   //stipendiya
  unsigned long Married;
  unsigned long Widow;
};


void ShowRec(student Rec)
{
   long i;
   char key;
   cout << endl;
   cout << "Фамилия: " << Rec.Name << endl;
   cout << "Номер группы: " << Rec.Group  <<endl;

   cout << "Пол: ";
     if (Rec.Sex==Male)
       cout <<  "муж"<<endl; else cout << "жен" << endl;
   cout << "Год рождения: "  << Rec.Birthday <<endl;
   cout << "Номер обшежития: "  << Rec.Group <<endl;
   cout << "Средний балл: "  << Rec.Ball  <<endl;
   cout << "Стипендия: "  << Rec.Stip <<endl;
   cout << "Семейное положение: ";
     if (Rec.Married==Married)
       cout << "состоит в браке" << endl; else cout << "в браке не состоит" << endl;
   cout << "Состоял ранее в браке: ";
     if (Rec.Widow==Married)
       cout << "да" << endl; else cout << "нет" << endl;
}

student EditRec()
{
   student Rec;
   char key;
   //clrscr();
   cout << endl;
   while (kbhit()) getch();
   cout << "Фамилия: "; cin >> Rec.Name;

   cout << "Номер группы: "; cin >> Rec.Group;

   do  {
         cout << "Пол (1-муж,2-жен): ";
         key=getche();
         cout << endl;
       } while (!((key=='1')||(key=='2')));
   if (key=='1') Rec.Sex=Male; else Rec.Sex=Female;


   cout << "Год рождения: "  ;
   cin >> Rec.Birthday;

   cout << "Номер обшежития: ";
   cin >> Rec.Group;

   cout << "Средний балл: ";
   cin >> Rec.Ball;

   cout << "Стипендия: ";
   cin >> Rec.Stip;

   do  {
          cout << "Семейное положение (1-состоит в  браке,2-нет): ";
          key=getche();
          cout << endl;
       } while (!((key=='1')||(key=='2')));
   if (key=='1') Rec.Married=Married; else Rec.Married=NotMarried;


   do  {
         cout << "Состоял ранее в браке (1-да,2-нет) :";
         key=getche();
         cout << endl;
       } while (!((key=='1')||(key=='2')));
    if (key=='1') Rec.Widow=Married; else Rec.Widow=NotMarried;
   return Rec;
}


void IOErr()
{
  cout << endl << "IO Error, press any key" << endl;
  getch();
}

void ReWrite()
{
  FILE *BF;
  if ((BF=fopen(FileName,"w"))==NULL) IOErr();
  fcloseall();
}

void WriteRec(int RecNum, student *Rec)
{
  FILE *BF;
  if ((BF=fopen(FileName,"r+"))==NULL) IOErr(); else
  {
    fseek(BF,((RecNum-1)*sizeof(student)),SEEK_SET);
    fwrite(Rec,sizeof(student),1,BF);
  };
  flushall();
  fcloseall();
}

void ReadRec(int RecNum, student *Rec)
{
  FILE *BF;
  if ((BF=fopen(FileName,"r"))==NULL) IOErr(); else
  {
    fseek(BF,((RecNum-1)*sizeof(student)),SEEK_SET);
    fread(Rec,sizeof(student),1,BF);
  };
  fcloseall();
}

long int NumRec()
{
  FILE *BF; long int Size;
  if ((BF=fopen(FileName,"r"))==NULL) IOErr(); else
  {
    fseek(BF,0,SEEK_END);
    Size = ftell(BF) / sizeof(student);
  };
  fcloseall();
  return Size;
}

void AddRec( student *Rec )
{
   WriteRec(NumRec()+1,Rec);
}

void Truncate( long int RecNum )
{
  int handle;
  handle = open(FileName,O_RDWR);
  chsize(handle,RecNum*sizeof(student));
  close(handle);
}

void DelRec( long int Num )
{
  student Rec;
  for(long int i=(Num+1);i<=NumRec();i++)
  {
    ReadRec (   i, &Rec );
    WriteRec( i-1, &Rec );
  }
  Truncate(NumRec()-1);
}

void Sort_Name()
{
  student R1,R2;
  long int i,j,n;
  n = NumRec();
  for (i=1;i<n;i++)
    for (j=(i+1);j<=n;j++)
    {
      ReadRec(i,&R1); ReadRec(j,&R2);
      if (strcmp(R1.Name,R2.Name) < 0)
      {
        WriteRec(i,&R2); WriteRec(j,&R1);
      }
    }
}

void Sort_Ball()
{
  student R1,R2;
  long int i,j,n;
  n = NumRec();
  for (i=1;i<n;i++)
    for (j=(i+1);j<=n;j++)
    {
      ReadRec(i,&R1); ReadRec(j,&R2);
      if (R1.Ball>R2.Ball)
      {
        WriteRec(i,&R2); WriteRec(j,&R1);
      }
    }
}


void Resort()
{
   char key;
   do
   {
     cout << endl << "1-по имени " << endl;
     cout << "2-по ср баллу " << endl;
     cout << "3-по cтипендии " << endl;
     cout << "4-по имени " << endl;
     key= getche();
   } while (!('1'<=key<='5'));
   if (key==1) Sort_Name;
   if (key==2) Sort_Ball;

}


void ShowList()
{
  student Rec;
  for (long int i=1;i<=NumRec();i++)
  {
    ReadRec(i,&Rec);
    ShowRec(Rec);
    getch();
  }
  cout << "всего студентов: " << NumRec() << endl;
}


void MainMenu()
{
  char key;
  student Rec;
  long Num=1;
  do
  {
    //clrscr();
    cout << endl<< "запись номер " << Num << endl;
    cout << "всего записей "<< NumRec() << endl;
    cout << "1-след запись"  << endl;
    cout << "2-пред запись" << endl;
    cout << "3-редактировать" << endl;
    cout << "4-удалить"<< endl;
    cout << "5-новая запись"<< endl;
    cout << "6-текущая запись" << endl;
    cout << "7-пересортировка" << endl;
    cout << "8-выход" << endl;

    cout << "1-8:"; key=getche(); cout <<endl;

    if (key=='1') {
                  //clrscr();
                  if (Num<NumRec()) {
                                      Num++;
                                      ReadRec(Num,&Rec);
                                      ShowRec(Rec);
                                    }
                                else cout << "последняя запись" << endl;

                  cout << "press any key"<< endl;
                  getch();
                };
    if (key=='2') {
                   //clrscr();
                   if (Num>1) {
                                Num--;
                                ReadRec(Num,&Rec);
                                ShowRec(Rec);

                              } else cout <<"первая запись" << endl;
                    cout << "press any key" << endl;
                    getch();
                  }

    if (key=='5') {
                    //clrscr();
                    Rec=EditRec();
                    AddRec(&Rec);
                    ShowRec(Rec);
                    cout << "press any key" << endl;
                    getch();
                  }
     if (key=='3') {
                     //clrscr();
                     ReadRec(Num,&Rec);
                     ShowRec(Rec);
                     Rec=EditRec();
                     WriteRec(Num,&Rec);
                     cout << "press any key" << endl;
                     getch();
                   }
      if (key=='4') {
                      ShowRec(Rec); cout << "удалена" << endl;
                      DelRec(Num);
                      cout << "press any key" << endl;
                      getch();
                    }


    if (key=='6') {ShowRec(Rec);};
    if (key=='7') {Resort();};
    if (key=='8') {exit(EXIT_SUCCESS);};
   } while (1);  //(!((key<='6')&(key>='1')));
}



void main()
{
  _fmode=O_BINARY;
  clrscr();
  student Rec;
  MainMenu();
}
