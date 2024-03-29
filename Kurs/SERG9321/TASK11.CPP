// � �������� �����吝�� ᯨ᪥ ����� ���祭� ⥫�䮭��� ����஢,
// �� ����� ������ ������� �������. ����室��� ���� ����� ⥫�䮭�,
// ���஬� ������� �������襥 �᫮ ࠧ.

#include <stdio.h>
#include <string.h>

// ---=== ������� �����吝� ᯨ᮪ ===---
struct PhoneList
 {
   char *Data;
   PhoneList *Next;
 };

// ---=== ���᮪ ===---
PhoneList *Root = NULL;

// ---=== ���������� ������ ������� � ����� ᯨ᪠ ===---
void AddEnd( char *Str )
 {
   PhoneList *Current,*Buffer;
  // - ��������� ������ ������� - //
   Buffer = new PhoneList;
   Buffer->Data = Str;
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
 }

// ---=== �������� �ᥣ� ᯨ᪠ ===---
void DelAll()
 {
   PhoneList *Buffer;
  // ���� � ᯨ᪥ ��⠫��� ��������
   while (Root!=NULL)
	{
	 // ����塞 ���� �������
	  Buffer = Root;
	  Root = Root->Next;
	  delete Buffer;
	};
 };

// ---=== ��ᬮ�� �ᥣ� ᯨ᪠ (��������⭮) ===---
void Show()
 {
   PhoneList *Current = Root;
   printf("---=== �뢮��� ᯨ᮪ �� ��࠭ ===---\n");
   while (Current!=NULL)
	{
	  printf("%s\n",Current->Data);
	  Current = Current->Next;
	}
 };

// ---=== ���� �������� 㯮�ॡ�塞��� ����� ===---
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
   printf("���ᨬ��쭮� �᫮ ࠧ ����⨫��. �����: %s ���-��: %d\n",Phone,PhoneNum);
 };

// ---=== �᭮���� �ணࠬ�� ===---
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