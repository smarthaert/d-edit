// В массиве хранятся указатели на первые элементы однотипных списков.
// Каждый элемент каждого из списков содержит в информационной части
// вещественное число. Необходимо найти минимальное и максимальное числа
// среди всех заданных чисел.

#include <stdio.h>
#include <stdlib.h>
#include <values.h>

// ---=== Линейный односвязный список ===---
struct List
 {
   float Data;
   List *Next;
 };

typedef List *PList;

// ---=== Добавление нового элемента в конец списка ===---
PList AddEnd( PList Root, float Data )
 {
   List *Current,*Buffer;
  // - Заведение нового элемента - //
   Buffer = new List;
   Buffer->Data = Data;
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
   return Root;
 }

// ---=== Удаление всего списка ===---
PList DelAll( PList Root )
 {
   List *Buffer;
  // Пока в списке остались элементы
   while (Root!=NULL)
	{
	 // Удаляем первый элемент
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
  return Root;
 };

// ---=== Массив списков ===---
// Размер массива списков (Количество списков в нем)
#define Size 5
// Максимальное генерируемое число элементов в списке
#define MaxNumEl 5
// Максимальное генерируемое число в списке
#define MaxNum 10000
// Собственно сам массив
PList ListArray[Size];

float Min = MAXFLOAT, Max = -MAXFLOAT;

// ---=== Основная программа ===---
void main()
 {
   int i,j; List *Current;
  // Заполняем массив
   randomize();
   for (i=0;i<Size;i++)
	{
	  j = random(MaxNumEl)+1;
	  ListArray[i] = NULL;
	  for (i=0;i<j;i++) ListArray[i] = AddEnd(ListArray[i],random(MaxNum));
	}
  // Поиск миниума и максиума
   for (i=0;i<Size;i++)
	{
	  Current = ListArray[i];
	  while (Current!=NULL)
	   {
		 printf("Список номер %d Элемент %f\n",i+1,Current->Data);
		 if (Current->Data < Min ) Min = Current->Data;
		 if (Current->Data > Max ) Max = Current->Data;
		 Current = Current->Next;
	   }
	}
  // Удаление всех списков
   for (i=0;i<Size;i++) ListArray[i] = DelAll(ListArray[i]);
  // Вывод миниума и максиума на экран
   printf("Миниум %f Максиум %f\n",Min,Max);
 };


