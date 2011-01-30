// Линейный двухсвязный список задан указателем на первый элемент.
// В информационных частях узлов списка записаны литеры. Необходимо
// вывести на экран все литеры, которые встречаются в списке более N раз
// (N вводится с клавиатуры) и удалить из списка все соответствующие
// данным литерам узлы.

#include <stdio.h>

// ---=== Линейный двухсвязанный список ===---
struct CharList
 {
   char Data;
   CharList *Prev,*Next;
 };

// ---=== Список ===---
CharList *Root = NULL;

// ---=== Добавление нового элемента в конец списка ===---
void AddEnd( char C )
 {
   CharList *Current,*Buffer;
  // - Заведение нового элемента - //
   Buffer = new CharList;
   Buffer->Data = C;
   Buffer->Next = NULL;
  // - Присоединение элемента к существующему списку -
   if (Root!=NULL)
	{
	  Current = Root;
	  while (Current->Next != NULL) Current = Current->Next;
	  Current->Next = Buffer;
	  Buffer->Prev = Current;
	}
   else
	{
	  Buffer->Prev = NULL;
	  Root = Buffer;
	}
 }

// ---=== Удаление всего списка ===---
void DelAll()
 {
   CharList *Buffer;
  // Пока в списке остались элементы
   while (Root!=NULL)
	{
	 // Удаляем первый элемент
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
 };

// ---=== "Порог удаления" ===---
int N;

// ---=== Просмотр всего списка (поэлементно) ===---
void Show()
 {
   CharList *Current = Root;
   printf("---=== Выводим список на экран ===---\n");
   while (Current!=NULL)
	{
	  printf("%c\n",Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== Поиск символов встречающихся чаще чем N ===---
void Find_Symbols()
 {
   int CurNum;
   CharList *Current = Root,*Cur,*Buf,*Nxt;
   char CurSym;
   while (Current!=NULL)
	{
	 // Подсчитываем число символов
	  CurNum = 0;
	  Cur = Current;
	  CurSym = Current->Data;
	  while (Cur!=NULL)
	   {
		 if (CurSym==Cur->Data) CurNum++;
		 Cur = Cur->Next;
	   }
	 // Если нужно - Выводим на экран и удаляем
	  if (CurNum > N)
	   {
		 printf("Найден символ %c\n",Current->Data);
		 Cur = Current;
		 while (Cur!=NULL)
		  {
			if (CurSym==Cur->Data)
			 {
			   Buf = Cur;
			   if (Cur->Prev!=NULL)
				{
				  Cur = Buf->Prev;
				  Nxt = Buf->Next;
				  if (Nxt!=NULL) Nxt->Prev = Cur;
				  Cur->Next = Nxt;
				}
			   else
				{ Cur = Buf->Next; Root = Cur; Cur->Prev = NULL; }
			   delete Buf;
			 }
			else
			  Cur = Cur->Next;
		  }
		 Current = Root;
	   }
	  else
	   Current = Current->Next;
	}
 };

// ---=== Основная программа ===---
void main()
 {
   AddEnd('D');
   AddEnd('A');
   AddEnd('B');
   AddEnd('D');
   AddEnd('B');
   AddEnd('C');
   AddEnd('D');
   printf("Введите N :");
   scanf("%d",&N);
   Show();
   Find_Symbols();
   Show();
   DelAll();
 };