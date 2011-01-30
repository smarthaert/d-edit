#include <stdio.h>
#include <stdlib.h>

// ---=== Линейный двухсвязанный список ===---
struct FloatList
 {
   float Data;
   FloatList *Prev,*Next;
 };

// ---=== Класс линейный двусвязанный список ===---
class List
 {
  public:
   FloatList *Root;
  // Добавление элемента в конец списка
   void Add( float New );
  // Количество элементов списка
   int Num();
  // Вывод списка на экран
   void Show( FILE *stream );
  // Уничтожение списка
   ~List();
  // 1. Пустой конструктор
   List();
  // 2. Конструктор копирования в инициализации
   List( List& Copy );
  // 3. Конструктор с целочисленным параметром создающий список заданной длины
   List( int NumElem );
  // 4. Операция "<<" выводящая список на экран
   void operator <<( FILE *stream );
  // 5. Операция ">>" загружающая список из текстового файла
   void operator >>( char *FileName );
  // 6. Операция "++" добавляющая один узел в список
   void operator ++();
  // 7. Перегруженная операция '-' (Параметр - номер удаляемого элемента)
   void operator -( int NumElem );
  // 8. Перегруженная операция индексирования
   float operator []( int Index );
  // 9. Перегруженная операция умножения (Смешение 2-х списков)
   friend List operator *( List&, List& );
 };

// ---=== Добавление нового элемента в конец списка ===---
void List::Add( float New )
 {
   FloatList *Current,*Buffer;
  // - Заведение нового элемента - //
   Buffer = new FloatList;
   Buffer->Data = New;
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

// ---=== Количество элементов списка ===---
int List::Num()
 {
   int Index = 0;
   FloatList *Current = Root;
   while (Current!=NULL)
	{
	  Index++;
	  Current = Current->Next;
	}
   return Index;
 };

// ---=== Просмотр всего списка (поэлементно) ===---
void List::Show(FILE *stream)
 {
   FloatList *Current = Root;
   printf("---=== Выводим список на экран ===---\n");
   while (Current!=NULL)
	{
	  fprintf(stream,"%f\n",Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== Удаление всего списка ===---
List::~List()
 {
   FloatList *Buffer;
  // Пока в списке остались элементы
   while (Root!=NULL)
	{
	 // Удаляем первый элемент
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
 };

// ---=== 1. Пустой конструктор ===---
List::List()
 {
   Root = NULL;
 };

// ---=== 2. Конструктор копирования в инициализации ===---
List::List( List& Copy )
 {
   Root = NULL;
   FloatList *Current = Copy.Root;
   while (Current!=NULL)
	{
	  Add(Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== 3. Конструктор с целочисленным параметром создающий список заданной длины ===---
List::List( int NumElem )
 {
   Root = NULL;
   for(int i=0;i<NumElem;i++) Add(0);
 };

// ---=== 4. Операция "<<" выводящая список на экран ===---
void List::operator<<(FILE *stream)
 {
   Show(stream);
 };

// ---=== 5. Операция ">>" загружающая список из текстового файла ===---
void List::operator >>( char *FileName )
 {
   FILE *Input;
   float Buf;
   if ((Input = fopen(FileName,"r+")) == NULL)
	{ fprintf(stderr,"Не могу открыть файл '%s'\n",FileName); return; };
   while (!feof(Input))
	{
	  fscanf(Input,"%f",&Buf);
	  Add(Buf);
	};
   fclose(Input);
 };

// ---=== 6. Операция "++" добавляющая один узел в список ===---
void List::operator ++()
 {
   Add(0);
 };

// ---=== 7. Перегруженная операция '-' (Параметр - номер удаляемого элемента) ===---
void List::operator -( int NumElem )
 {
   int CurIndex = 0;
   FloatList *Current = Root;
   while (Current!=NULL)
	{
	  CurIndex++;
	  if (CurIndex==NumElem)
	   {
		 if (Current->Next!=NULL) Current->Next->Prev = Current->Prev;
		 if (Current->Prev!=NULL)
		   { Current->Prev->Next = Current->Next; }
		 else
		   Root = Current->Next;
		 delete Current;
		 return;
	   };
	  Current = Current->Next;
	}
   printf("Попытка удаления несуществующего элемента !\n");
 };

// ---=== 8. Перегруженная операция индексирования ===---
float List::operator []( int Index )
 {
   int CurIndex = 0;
   FloatList *Current = Root;
   while (Current!=NULL)
	{
	  CurIndex++;
	  if (CurIndex==Index) return Current->Data;
	  Current = Current->Next;
	}
   printf("Ошибка обрашения к несуществующему элементу !\n");
   return 0;
 };

// ---=== 9. Перегруженная операция умножения (Смешение 2-х списков) ===---
List operator *( List& List1, List& List2)
 {
   List NewList,L1(List1),L2(List2);
   int i;
   randomize();
   while ((L1.Root!=NULL) || (L2.Root!=NULL))
	 switch (random(2))
	  {
		case 0: if (L1.Root!=NULL)
				  { i=random(L1.Num())+1; NewList.Add(L1[i]); L1-i; break; };
		case 1: if (L2.Root!=NULL)
				  { i=random(L2.Num())+1; NewList.Add(L2[i]); L2-i; break; };
	  };
   return NewList;
 };

// ---=== Основная программа ===---
void main()
 {
  // Заводим пустой список на 3 элемента
   List Test(3);
  // Копируем его в другой список
   List Test1(Test);
  // Добавляем в список из файла
   Test1 >> "Test.txt";
  // Добавыляем еще один элемент в конец
   Test1++;
  // Удаляем 5-ый элемент
   Test1 - 5;
  // Вывод списка на экран
   Test1 << stdout;
  // Проверяем операцию индексирования
   printf("! %f\n",Test1[1]);
  // Перемешиваем два списка произвольным образом
   List Test2 = Test * Test1;
  // Выводим результат на экран
   Test2 << stdout;
 };

