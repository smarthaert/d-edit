#include <stdio.h>
#include <stdlib.h>

// ---=== ������� �����易��� ᯨ᮪ ===---
struct FloatList
 {
   float Data;
   FloatList *Prev,*Next;
 };

// ---=== ����� ������� ����易��� ᯨ᮪ ===---
class List
 {
  public:
   FloatList *Root;
  // ���������� ������� � ����� ᯨ᪠
   void Add( float New );
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
   float operator []( int Index );
  // 9. ��ॣ�㦥���� ������ 㬭������ (���襭�� 2-� ᯨ᪮�)
   friend List operator *( List&, List& );
 };

// ---=== ���������� ������ ������� � ����� ᯨ᪠ ===---
void List::Add( float New )
 {
   FloatList *Current,*Buffer;
  // - ��������� ������ ������� - //
   Buffer = new FloatList;
   Buffer->Data = New;
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
   FloatList *Current = Root;
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
   FloatList *Current = Root;
   printf("---=== �뢮��� ᯨ᮪ �� ��࠭ ===---\n");
   while (Current!=NULL)
	{
	  fprintf(stream,"%f\n",Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== �������� �ᥣ� ᯨ᪠ ===---
List::~List()
 {
   FloatList *Buffer;
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
   FloatList *Current = Copy.Root;
   while (Current!=NULL)
	{
	  Add(Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== 3. ��������� � 楫��᫥��� ��ࠬ��஬ ᮧ���騩 ᯨ᮪ �������� ����� ===---
List::List( int NumElem )
 {
   Root = NULL;
   for(int i=0;i<NumElem;i++) Add(0);
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
   float Buf;
   if ((Input = fopen(FileName,"r+")) == NULL)
	{ fprintf(stderr,"�� ���� ������ 䠩� '%s'\n",FileName); return; };
   while (!feof(Input))
	{
	  fscanf(Input,"%f",&Buf);
	  Add(Buf);
	};
   fclose(Input);
 };

// ---=== 6. ������ "++" ���������� ���� 㧥� � ᯨ᮪ ===---
void List::operator ++()
 {
   Add(0);
 };

// ---=== 7. ��ॣ�㦥���� ������ '-' (��ࠬ��� - ����� 㤠�塞��� �������) ===---
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
   printf("����⪠ 㤠����� ���������饣� ������� !\n");
 };

// ---=== 8. ��ॣ�㦥���� ������ ������஢���� ===---
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
   printf("�訡�� ���襭�� � ���������饬� �������� !\n");
   return 0;
 };

// ---=== 9. ��ॣ�㦥���� ������ 㬭������ (���襭�� 2-� ᯨ᪮�) ===---
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
   printf("! %f\n",Test1[1]);
  // ��६�訢��� ��� ᯨ᪠ �ந������ ��ࠧ��
   List Test2 = Test * Test1;
  // �뢮��� १���� �� ��࠭
   Test2 << stdout;
 };

