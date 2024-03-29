#include <stdio.h>
#include <stdlib.h>

#define FType 1
#define IType 2
#define LType 3

// ---=== ������� �����易��� ᯨ᮪ ===---
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

// ---=== ����� ������� ����易��� ᯨ᮪ ===---
class List
 {
  public:
   _List_ *Root;
  // ���������� ������� � ����� ᯨ᪠
   void Add( _List_ New );
  // ������⢮ ������⮢ ᯨ᪠
   int Num();
  // �뢮� ᯨ᪠ �� ��࠭
   void Show( FILE *stream );
  // ����⮦���� ᯨ᪠
   ~List();
  // 1. ���⮩ ���������
   List();
  // 2. ��������� ����஢���� � ���樠����樨
   List( List& Copy );
  // 3. ��������� � 楫��᫥��� ��ࠬ��஬ ᮧ���騩 ᯨ᮪ �������� �����
   List( int NumElem );
  // 4. ������ "<<" �뢮���� ᯨ᮪ �� ��࠭
   void operator <<( FILE *stream );
  // 5. ������ ">>" ����㦠��� ᯨ᮪ �� ⥪�⮢��� 䠩��
   void operator >>( char *FileName );
  // 6. ������ "++" ���������� ���� 㧥� � ᯨ᮪
   void operator ++();
  // 7. ��ॣ�㦥���� ������ '-' (��ࠬ��� - ����� 㤠�塞��� �������)
   void operator -( int NumElem );
  // 8. ��ॣ�㦥���� ������ ������஢����
   _List_ operator []( int Index );
 };

// ---=== ���������� ������ ������� � ����� ᯨ᪠ ===---
void List::Add( _List_ New )
 {
   _List_ *Current,*Buffer;
  // - ��������� ������ ������� - //
   Buffer = new _List_;
   Buffer->type = New.type;
   switch (New.type)
    {
      case FType: Buffer->FData = New.FData; break;
      case IType: Buffer->IData = New.IData; break;
      case LType: Buffer->LData = New.LData; break;
    }
   Buffer->Next = NULL;
  // - ��ᮥ������� ������� � �������饬� ᯨ�� -
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

// ---=== ������⢮ ������⮢ ᯨ᪠ ===---
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

// ---=== ��ᬮ�� �ᥣ� ᯨ᪠ (��������⭮) ===---
void List::Show(FILE *stream)
 {
   _List_ *Current = Root;
   printf("---=== �뢮��� ᯨ᮪ �� ��࠭ ===---\n");
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

// ---=== �������� �ᥣ� ᯨ᪠ ===---
List::~List()
 {
   _List_ *Buffer;
  // ���� � ᯨ᪥ ��⠫��� ��������
   while (Root!=NULL)
	{
	 // ����塞 ���� �������
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
 };

// ---=== 1. ���⮩ ��������� ===---
List::List()
 {
   Root = NULL;
 };

// ---=== 2. ��������� ����஢���� � ���樠����樨 ===---
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

// ---=== 3. ��������� � 楫��᫥��� ��ࠬ��஬ ᮧ���騩 ᯨ᮪ �������� ����� ===---
List::List( int NumElem )
 {
   Root = NULL;
   _List_ New;
   New.type  = IType;
   New.IData = 0;
   for(int i=0;i<NumElem;i++) Add(New);
 };

// ---=== 4. ������ "<<" �뢮���� ᯨ᮪ �� ��࠭ ===---
void List::operator<<(FILE *stream)
 {
   Show(stream);
 };

// ---=== 5. ������ ">>" ����㦠��� ᯨ᮪ �� ⥪�⮢��� 䠩�� ===---
void List::operator >>( char *FileName )
 {
   FILE *Input;
   _List_ Buf;
   if ((Input = fopen(FileName,"r+")) == NULL)
	{ fprintf(stderr,"�� ���� ������ 䠩� '%s'\n",FileName); return; };
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

// ---=== 6. ������ "++" ���������� ���� 㧥� � ᯨ᮪ ===---
void List::operator ++()
 {
   _List_ Buf;
   Buf.type  = IType;
   Buf.IData = 0;
   Add(Buf);
 };

// ---=== 7. ��ॣ�㦥���� ������ '-' (��ࠬ��� - ����� 㤠�塞��� �������) ===---
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
   printf("����⪠ 㤠����� ���������饣� ������� !\n");
 };

// ---=== 8. ��ॣ�㦥���� ������ ������஢���� ===---
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
   printf("�訡�� ���襭�� � ���������饬� �������� !\n");
   Current = NULL;
   return *Current;
 };

// ---=== �᭮���� �ணࠬ�� ===---
void main()
 {
  // ������� ���⮩ ᯨ᮪ �� 3 �������
   List Test(3);
  // �����㥬 ��� � ��㣮� ᯨ᮪
   List Test1(Test);
  // ������塞 � ᯨ᮪ �� 䠩��
   Test1 >> "Test.txt";
  // ������塞 �� ���� ������� � �����
   Test1++;
  // ����塞 5-� �������
   Test1 - 5;
  // �뢮� ᯨ᪠ �� ��࠭
   Test1 << stdout;
  // �஢��塞 ������ ������஢����
   printf("! %d\n",Test1[1].IData);
  // �뢮��� १���� �� ��࠭
   Test1 << stdout;
 };

