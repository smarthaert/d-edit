#include <stdio.h>                   //��砫�
#include <conio.h>

typedef struct list                  //�� ��� ������� ᯨ᪠
 {
 int info;
 struct list *next;
 } ListElement;


int main()
{
int i,a = 0;                        //�� ��� ��直� ��६���� � 㪠��⥫�
int str,write;
ListElement *Top, *p, *q ,*o;

clrscr();
printf("This program will sort you number data by increasing of value");
printf("\nPlease input numbers.  If you want to stop input '666' \n\n\n");
Top = o = p = q = NULL;             //�� �� �� ���㫨�

scanf("%d",&str);                   //���� �������
if(str != 666)
 {
 q = new ListElement;
 q -> info = str;
 q -> next = NULL;
 Top = q;
 }
else
return(-1);

while(1)
 {
 scanf("%d",&str);                  //� �� ��⠫��
 if(str == 666)
  {
  break;
  }
  p = new ListElement;
  p -> info = str;
  a = 0;
  o = NULL;
  while(1)
   {
   a++;
   if(q -> info > p ->info && 1 != a)
    {
    o -> next = p;                  //��⠢�塞 � �।���
    p -> next = q;
    q = Top;
    break;
    }
   if(q -> info > p ->info && 1 == a)
    {
    p -> next = q;                 //� ��砫�
    Top = p;
    q = Top;
    break;
    }
   if(q -> info < p -> info && q -> next != NULL)
    {
    o = q;                         //�� �� ���� ��� ⠪��� �������
    q = q -> next;
    }
   else
    {
    q -> next = p;                 //� �����
    p -> next = NULL;
    q = Top;
    break;
   }
  }
 }
FILE *f1;                          //��襬 � 䠩���
f1 = fopen("data.txt","w");
p = Top;
while(NULL != p)
 {
 fprintf(f1,"%d ",p -> info);
 p = p -> next;
 }
p = Top;
clrscr();
gotoxy(30,13);
while(NULL != p)                   //�뢮��� �� ��࠭
 {
 printf("%d ",p -> info);
 p = p -> next;
 }
q = Top;
while(NULL != q)                   //������ ⮦� ��� ᢮����
 {
 p = q;
 q = q -> next;
 delete p;
 }
printf("\n");
getch();                           //�����
return(0);
}