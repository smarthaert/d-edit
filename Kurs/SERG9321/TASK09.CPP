// Задан линейный односвязный список, каждый элемент которого
// (В информационной части) содержит указатель на строку.
// Необходимо написать программу, удаляющую из списка все узлы,
// которым соответствуют строки,
// содержащие введенный с клавиатуры символ.

#include <stdio.h>
#include <conio.h>

// ---=== Линейный односвязный список ===---
struct StrList
 {
   char *Data;
   StrList *Next;
 };

// ---=== Список ===---
StrList *Root = NULL;

// ---=== Добавление нового элемента в конец списка ===---
void AddEnd( char *Str )
 {
   StrList *Current,*Buffer;
  // - Заведение нового элемента - //
   Buffer = new StrList;
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
   StrList *Buffer;
  // Пока в списке остались элементы
   while (Root!=NULL)
    {
     // Удаляем первый элемент
      Buffer = Root;
      Root = Root->Next;
      delete Buffer;
    };
 };

// ---=== Удаление элементов содержащих символ Symbol ===---
void Del_Sym( char Symbol )
 {
   StrList *Current = Root,*Buffer = NULL;
   char *Str; int i;
   printf("Удаляем все строки содержащие '%c'\n",Symbol);
  // - Ищем нужный нам элемент -
   while (Current!=NULL)
	{
	  Str = Current->Data;
	  for(i = 0;Str[i]!=0 && Str[i]!=Symbol;i++);
	 // - И удаляем его ... -
	  if (Str[i]==Symbol)
	   {
		 if (Buffer==NULL)
		   { Root = Current->Next; }
		 else
		   Buffer->Next = Current->Next;
		 delete Current;
		 Current = Buffer;
	   }
	  Buffer = Current;
	  Current = Current->Next;
	}
 };

// ---=== Просмотр всего списка (поэлементно) ===---
void Show()
 {
   StrList *Current = Root;
   printf("---=== Выводим список на экран ===---\n");
   while (Current!=NULL)
	{
	  printf("%s\n",Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== Основная программа ===---
void main()
 {
   AddEnd("ABC");
   AddEnd("DEF");
   AddEnd("GHI");
   AddEnd("TEST");
   Show();
   printf("Введите символ !\n");
   char C = getch();
   Del_Sym(C);
   Show();
   DelAll();
 };