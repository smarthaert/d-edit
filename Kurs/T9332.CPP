#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>

#define IntType   1
#define LongType  2
#define FloatType 3

// ---=== Линейный двухсвязанный список ===---
struct list
 {
   char type;
   union
	{
	  float DataF;
	  int DataI;
	  long DataL;
	};
   list *Prev,*Next;
 };

// ---=== Класс линейный двусвязанный список ===---
class List
 {
  public:
   list *Root;
  // Добавление элемента в конец списка
   void Add( list *Buffer );
  // Удаление элемента
   void DelElem( int NumElem );
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
  // 4. Операция "<<" выводящая список в поток
   void operator <<( FILE *stream );
  // 5. Операция ">>" загружающая список из текстового файла
   void operator >>( char *FileName );
  // 6. Операция "++" добавляющая один узел в список
   void operator ++();
  // 7. Перегруженная операция индексирования
   list& operator []( int Index );
  // 8. Функция удаления узла с заданным числом, заданного типа
   void Del( int type, int i );
  // 9. Перегруженная операция деления (Разность 2-х списков)
   friend List operator /( List&, List& );
 };

// ---=== Добавление нового элемента в конец списка ===---
void List::Add( list *Buffer )
 {
   list *Current;
  // - Заведение нового элемента - //
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

// ---=== Удаление элемента ===---
void List::DelElem( int NumElem )
 {
   int CurIndex = 0;
   list *Current = Root;
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

// ---=== Количество элементов списка ===---
int List::Num()
 {
   int Index = 0;
   list *Current = Root;
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
   list *Current = Root;
   printf("---=== Выводим список на экран ===---\n");
   while (Current!=NULL)
	{
	  switch (Current->type)
	   {
		 case IntType   : fprintf(stream,"int %d\n",Current->DataI); break;
		 case LongType  : fprintf(stream,"long %l\n",Current->DataL); break;
		 case FloatType : fprintf(stream,"float %f\n",Current->DataF); break;
	   };
	  Current = Current->Next;
	}
 };

// ---=== Удаление всего списка ===---
List::~List()
 {
   list *Buffer;
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
   list *Current = Copy.Root, *Buffer;
   while (Current!=NULL)
		{
		  Buffer = new list;
		  Buffer->type = Current->type;
		  switch (Current->type)
		   {
			 case IntType   : Buffer->DataI = Current->DataI; break;
			 case LongType  : Buffer->DataL = Current->DataL; break;
			 case FloatType : Buffer->DataF = Current->DataF; break;
		   };
		  Add(Buffer);
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
   char type;
   list *Buf;
   Buf = new list;
   if ((Input = fopen(FileName,"r+")) == NULL)
	{ fprintf(stderr,"Не могу открыть файл '%s'\n",FileName); return; };
   while (!feof(Input))
	{
	  fscanf(Input,"%d",&type);
	  Buf->type = type;
	  switch (Buf->type)
	   {
		 case IntType   : fscanf(Input,"%d",&Buf->DataI); break;
		 case LongType  : fscanf(Input,"%l",&Buf->DataL); break;
		 case FloatType : fscanf(Input,"%f",&Buf->DataF); break;
	   };
	  Add(Buf);
	};
   fclose(Input);
 };

// ---=== 6. Операция "++" добавляющая один узел в список ===---
void List::operator ++()
 {
   Add(0);
 };

// ---=== 7. Перегруженная операция индексирования ===---
list& List::operator []( int Index )
 {
   int CurIndex = 0;
   list *Current = Root;
   while (Current!=NULL)
		{
		  CurIndex++;
		  if (CurIndex==Index) return *Current;
		  Current = Current->Next;
		}
   printf("Ошибка обрашения к несуществующему элементу !\n");
   Current = NULL;
   return *Current;
 };

// 8. Функция удаления узла с заданным числом, заданного типа
void List::Del( int type, int i )
 {
 };

// 9. Перегруженная операция деления (Разность 2-х списков)
List operator /( List&, List& )
 {
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
  // Вывод списка на экран
   Test1 << stdout;
  // Проверяем операцию индексирования
   printf("! %f\n",Test1[1]);
 };

