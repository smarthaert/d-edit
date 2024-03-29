// � ���ᨢ� �࠭���� 㪠��⥫� �� ���� �������� ����⨯��� ᯨ᪮�.
// ����� ������� ������� �� ᯨ᪮� ᮤ�ন� � ���ଠ樮���� ���
// ����⢥���� �᫮. ����室��� ���� �������쭮� � ���ᨬ��쭮� �᫠
// �।� ��� �������� �ᥫ.

#include <stdio.h>
#include <stdlib.h>
#include <values.h>

// ---=== ������� �����吝� ᯨ᮪ ===---
struct List
 {
   float Data;
   List *Next;
 };

typedef List *PList;

// ---=== ���������� ������ ������� � ����� ᯨ᪠ ===---
PList AddEnd( PList Root, float Data )
 {
   List *Current,*Buffer;
  // - ��������� ������ ������� - //
   Buffer = new List;
   Buffer->Data = Data;
   Buffer->Next = NULL;
  // - ��ᮥ������� ������� � �������饬� ᯨ�� -
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

// ---=== �������� �ᥣ� ᯨ᪠ ===---
PList DelAll( PList Root )
 {
   List *Buffer;
  // ���� � ᯨ᪥ ��⠫��� ��������
   while (Root!=NULL)
	{
	 // ����塞 ���� �������
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
  return Root;
 };

// ---=== ���ᨢ ᯨ᪮� ===---
// ������ ���ᨢ� ᯨ᪮� (������⢮ ᯨ᪮� � ���)
#define Size 5
// ���ᨬ��쭮� ������㥬�� �᫮ ������⮢ � ᯨ᪥
#define MaxNumEl 5
// ���ᨬ��쭮� ������㥬�� �᫮ � ᯨ᪥
#define MaxNum 10000
// ����⢥��� ᠬ ���ᨢ
PList ListArray[Size];

float Min = MAXFLOAT, Max = -MAXFLOAT;

// ---=== �᭮���� �ணࠬ�� ===---
void main()
 {
   int i,j; List *Current;
  // ������塞 ���ᨢ
   randomize();
   for (i=0;i<Size;i++)
	{
	  j = random(MaxNumEl)+1;
	  ListArray[i] = NULL;
	  for (i=0;i<j;i++) ListArray[i] = AddEnd(ListArray[i],random(MaxNum));
	}
  // ���� ����㬠 � ����㬠
   for (i=0;i<Size;i++)
	{
	  Current = ListArray[i];
	  while (Current!=NULL)
	   {
		 printf("���᮪ ����� %d ������� %f\n",i+1,Current->Data);
		 if (Current->Data < Min ) Min = Current->Data;
		 if (Current->Data > Max ) Max = Current->Data;
		 Current = Current->Next;
	   }
	}
  // �������� ��� ᯨ᪮�
   for (i=0;i<Size;i++) ListArray[i] = DelAll(ListArray[i]);
  // �뢮� ����㬠 � ����㬠 �� ��࠭
   printf("����� %f ����� %f\n",Min,Max);
 };


