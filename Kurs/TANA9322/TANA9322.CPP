#include <stdio.h>
#include <stdlib.h>

#define FType 1
#define IType 2
#define LType 3

// ---=== Линейный двухсвязанный список ===---
struct _List_
 {
   char type;
   union
    {
      float FData;
      int   IData;
      long  LData;
    };
   float Data;
   _List_ *Prev,*Next;
 };

// ---=== Класс линейный двусвязанный список ===---
class List
 {
  public:
   _List_ *Root;
  // Добавление элемента в конец списка
   void Add( _List_ New );
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
   _List_ operator []( int Index );
 };

// ---=== Добавление нового элемента в конец списка ===---
void List::Add( _List_ New )
 {
   _List_ *Current,*Buffer;
  // - Заведение нового элемента - //
   Buffer = new _List_;
   Buffer->type = New.type;
   switch (New.type)
    {
      case FType: Buffer->FData = New.FData; break;
      case IType: Buffer->IData = New.IData; break;
      case LType: Buffer->LData = New.LData; break;
    }
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
   _List_ *Current = Root;
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
   _List_ *Current = Root;
   printf("---=== Выводим список на экран ===---\n");
   while (Current!=NULL)
	{
	  switch (Current->type)
	   {
	     case FType: fprintf(stream,"float %f\n",Current->FData); break;
	     case IType: fprintf(stream,"int   %d\n",Current->IData); break;
	     case LType: fprintf(stream,"long  %lu\n",Current->LData); break;
	   }
	  Current = Current->Next;
	}
 };

// ---=== Удаление всего списка ===---
List::~List()
 {
   _List_ *Buffer;
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
   _List_ *Current = Copy.Root;
   while (Current!=NULL)
	{
	  Add(*Current);
	  Current = Current->Next;
	}
 };

// ---=== 3. Конструктор с целочисленным параметром создающий список заданной длины ===---
List::List( int NumElem )
 {
   Root = NULL;
   _List_ New;
   New.type  = IType;
   New.IData = 0;
   for(int i=0;i<NumElem;i++) Add(New);
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
   _List_ Buf;
   if ((Input = fopen(FileName,"r+")) == NULL)
	{ fprintf(stderr,"Не могу открыть файл '%s'\n",FileName); return; };
   while (!feof(Input))
	{
	  fscanf(Input,"%d",&Buf.type);
	  switch (Buf.type)
	   {
	     case FType: fscanf(Input,"%f",&Buf.FData); break;
	     case IType: fscanf(Input,"%d",&Buf.IData); break;
	     case LType: fscanf(Input,"%lu",&Buf.LData); break;
	   };
	  Add(Buf);
	};
   fclose(Input);
 };

// ---=== 6. Операция "++" добавляющая один узел в список ===---
void List::operator ++()
 {
   _List_ Buf;
   Buf.type  = IType;
   Buf.IData = 0;
   Add(Buf);
 };

// ---=== 7. Перегруженная операция '-' (Параметр - номер удаляемого элемента) ===---
void List::operator -( int NumElem )
 {
   int CurIndex = 0;
   _List_ *Current = Root;
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
_List_ List::operator []( int Index )
 {
   int CurIndex = 0;
   _List_ *Current = Root;
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
   printf("! %d\n",Test1[1].IData);
  // Выводим результат на экран
   Test1 << stdout;
 };

