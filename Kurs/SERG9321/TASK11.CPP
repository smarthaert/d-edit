// В линейном односвязном списке задан перечень телефонных номеров,
// по которым звонит некоторый абонент. Необходимо выявить номер телефона,
// которому звонили наибольшее число раз.

#include <stdio.h>
#include <string.h>

// ---=== Линейный односвязный список ===---
struct PhoneList
 {
   char *Data;
   PhoneList *Next;
 };

// ---=== Список ===---
PhoneList *Root = NULL;

// ---=== Добавление нового элемента в конец списка ===---
void AddEnd( char *Str )
 {
   PhoneList *Current,*Buffer;
  // - Заведение нового элемента - //
   Buffer = new PhoneList;
   Buffer->Data = Str;
   Buffer->Next = NULL;
  // - Присоединение элемента к существующему списку -
   if (Root!=NULL)
	{
	  Current = Root;
	  while (Current->Next != NULL) Current = Current->Next;
	  Current->Next = Buffer;
	}
   else
     Root = Buffer;
 }

// ---=== Удаление всего списка ===---
void DelAll()
 {
   PhoneList *Buffer;
  // Пока в списке остались элементы
   while (Root!=NULL)
	{
	 // Удаляем первый элемент
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
 };

// ---=== Просмотр всего списка (поэлементно) ===---
void Show()
 {
   PhoneList *Current = Root;
   printf("---=== Выводим список на экран ===---\n");
   while (Current!=NULL)
	{
	  printf("%s\n",Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== Поиск наиболее употребляемого номера ===---
void Find()
 {
   char *Phone;
   int PhoneNum = 0,CurNum;
   PhoneList *Current = Root,*Cur;
   while (Current!=NULL)
	{
	  CurNum = 0;
	  Cur = Current;
	  while (Cur!=NULL)
	   {
		 if (strcmp(Current->Data,Cur->Data)==0) CurNum++;
		 Cur = Cur->Next;
	   }
	  if (CurNum > PhoneNum) { PhoneNum = CurNum; Phone = Current->Data; }
	  Current = Current->Next;
	}
   printf("Максимальное число раз встретился. Номер: %s Кол-во: %d\n",Phone,PhoneNum);
 };

// ---=== Основная программа ===---
void main()
 {
   AddEnd("111-11-11");
   AddEnd("121-23-43");
   AddEnd("222-22-22");
   AddEnd("111-11-11");
   AddEnd("131-29-78");
   AddEnd("111-11-11");
   Show();
   Find();
   DelAll();
 };