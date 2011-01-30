#include <stdio.h>                   //Начала
#include <conio.h>

typedef struct list                  //Это наша структура списка
 {
 int info;
 struct list *next;
 } ListElement;


int main()
{
int i,a = 0;                        //Ну тут всякие переменные и указатели
int str,write;
ListElement *Top, *p, *q ,*o;

clrscr();
printf("This program will sort you number data by increasing of value");
printf("\nPlease input numbers.  If you want to stop input '666' \n\n\n");
Top = o = p = q = NULL;             //Ща мы их обнулим

scanf("%d",&str);                   //Первый элемент
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
 scanf("%d",&str);                  //И все остальные
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
    o -> next = p;                  //Вставляем в середину
    p -> next = q;
    q = Top;
    break;
    }
   if(q -> info > p ->info && 1 == a)
    {
    p -> next = q;                 //В начало
    Top = p;
    q = Top;
    break;
    }
   if(q -> info < p -> info && q -> next != NULL)
    {
    o = q;                         //Это не место для такого элемента
    q = q -> next;
    }
   else
    {
    q -> next = p;                 //В конец
    p -> next = NULL;
    q = Top;
    break;
   }
  }
 }
FILE *f1;                          //Пишем в файлик
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
while(NULL != p)                   //Выводим на экран
 {
 printf("%d ",p -> info);
 p = p -> next;
 }
q = Top;
while(NULL != q)                   //Память тоже хочет свободы
 {
 p = q;
 q = q -> next;
 delete p;
 }
printf("\n");
getch();                           //Конеца
return(0);
}