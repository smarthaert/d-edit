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
   cout << "�������: " << Rec.Name << endl;
   cout << "����� ��㯯�: " << Rec.Group  <<endl;

   cout << "���: ";
     if (Rec.Sex==Male)
       cout <<  "��"<<endl; else cout << "���" << endl;
   cout << "��� ஦�����: "  << Rec.Birthday <<endl;
   cout << "����� ��襦���: "  << Rec.Group <<endl;
   cout << "�।��� ����: "  << Rec.Ball  <<endl;
   cout << "�⨯�����: "  << Rec.Stip <<endl;
   cout << "�������� ���������: ";
     if (Rec.Married==Married)
       cout << "��⮨� � �ࠪ�" << endl; else cout << "� �ࠪ� �� ��⮨�" << endl;
   cout << "����� ࠭�� � �ࠪ�: ";
     if (Rec.Widow==Married)
       cout << "��" << endl; else cout << "���" << endl;
}

student EditRec()
{
   student Rec;
   char key;
   //clrscr();
   cout << endl;
   while (kbhit()) getch();
   cout << "�������: "; cin >> Rec.Name;

   cout << "����� ��㯯�: "; cin >> Rec.Group;

   do  {
         cout << "��� (1-��,2-���): ";
         key=getche();
         cout << endl;
       } while (!((key=='1')||(key=='2')));
   if (key=='1') Rec.Sex=Male; else Rec.Sex=Female;


   cout << "��� ஦�����: "  ;
   cin >> Rec.Birthday;

   cout << "����� ��襦���: ";
   cin >> Rec.Group;

   cout << "�।��� ����: ";
   cin >> Rec.Ball;

   cout << "�⨯�����: ";
   cin >> Rec.Stip;

   do  {
          cout << "�������� ��������� (1-��⮨� �  �ࠪ�,2-���): ";
          key=getche();
          cout << endl;
       } while (!((key=='1')||(key=='2')));
   if (key=='1') Rec.Married=Married; else Rec.Married=NotMarried;


   do  {
         cout << "����� ࠭�� � �ࠪ� (1-��,2-���) :";
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
     cout << endl << "1-�� ����� " << endl;
     cout << "2-�� �� ����� " << endl;
     cout << "3-�� c⨯����� " << endl;
     cout << "4-�� ����� " << endl;
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
  cout << "�ᥣ� ��㤥�⮢: " << NumRec() << endl;
}


void MainMenu()
{
  char key;
  student Rec;
  long Num=1;
  do
  {
    //clrscr();
    cout << endl<< "������ ����� " << Num << endl;
    cout << "�ᥣ� ����ᥩ "<< NumRec() << endl;
    cout << "1-᫥� ������"  << endl;
    cout << "2-�। ������" << endl;
    cout << "3-।���஢���" << endl;
    cout << "4-㤠����"<< endl;
    cout << "5-����� ������"<< endl;
    cout << "6-⥪��� ������" << endl;
    cout << "7-������஢��" << endl;
    cout << "8-��室" << endl;

    cout << "1-8:"; key=getche(); cout <<endl;

    if (key=='1') {
                  //clrscr();
                  if (Num<NumRec()) {
                                      Num++;
                                      ReadRec(Num,&Rec);
                                      ShowRec(Rec);
                                    }
                                else cout << "��᫥���� ������" << endl;

                  cout << "press any key"<< endl;
                  getch();
                };
    if (key=='2') {
                   //clrscr();
                   if (Num>1) {
                                Num--;
                                ReadRec(Num,&Rec);
                                ShowRec(Rec);

                              } else cout <<"��ࢠ� ������" << endl;
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
                      ShowRec(Rec); cout << "㤠����" << endl;
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
