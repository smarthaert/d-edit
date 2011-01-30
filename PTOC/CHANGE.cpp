/*
  ���������� �. �������� ����� ���������
  ���ᮢ�� ࠡ�� �� �ணࠬ��஢����
*/

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#define MaxNum 100 // ���ᨬ��쭮 ��������� ������⢮ ���祪
#define StrLen 400 // ���ᨬ��쭠� ����� ��ப�

typedef unsigned char uc;

// �������� ��६����
char Menu, // ��࠭�� �㭪� ����
	 WordToFind[StrLen], // �᪮��� ᫮��
	 WordToReplace[StrLen]; // �����, �� ���஥ �㦭� �������� �᪮��� �� ����室���� �����⥫��⢠�
int NeedCount; // ������⢮ ࠧ, ���஥ �᪮��� ᫮�� ������ ��������� � ⥪��, �⮡� ���� ��������� �� ��㣮�
char S[MaxNum][StrLen]; // ���ᨢ ��ப ⥪��
int Num; // ������⢮ ��ப}

// �஢����, ���� �� �室��� ᨬ��� �㪢��
int IsLetter( uc Ch ){
  uc r = 0; //���砫� ��⠥�, �� �� ����}
  if ((Ch>='A') && (Ch<='Z')) r = 1;
  if ((Ch>='a') && (Ch<='z')) r = 1;
  if ((Ch>=(uc)'�') && (Ch<=(uc)'�')) r = 1;
  // �����, ��� �������� - ⮦� �㪢�. � ⮬ ��᫥, �� ��� �����
  // ���묨 ᨬ������ �� ��⠢����� ᫮�, � �� ����� �������
  // �९������
  if ((Ch>='0') && (Ch<='9')) r = 1;
  // ��᪮��� ����� �㪢� ���᪮�� ��䠢�� � ⠡��� ASCII
  // ������� �� 2 ���, �஢��塞 ������ ���� �� �⤥�쭮��
  if ((Ch>=(uc)'�') && (Ch<=(uc)'�')) r = 1;
  if ((Ch>=(uc)'�') && (Ch<=(uc)'�')) r = 1;
  if ((Ch==240) || (Ch==241)) r = 1; // �㪢� �:
  return r;
};

// ��⠭�������� 梥� ⥪�� - Text � 梥� 䮭� BackGround
void Color( int Text,int BackGround ){
  textcolor(Text);
  textbackground(BackGround);
};

// �����頥� ��ப� �� Count ᨬ����� Ch
uc *StrOf( uc Ch,int Count ){
  uc S[StrLen];
  for(int i=0;i<Count;i++) S[i]=Ch;
  S[Count]=0; // ����� ��ப�
  return S;
};

// ����� ⥪�� S ���।��� ��ப� Y
void WriteCenter( int Y,char *S ){
  gotoxy(40-(strlen(S)/2), Y);
  cprintf("%s",S);
};

// ���� ������ ������
uc WaitKey(){
  while (kbhit()) getch(); // ��頥� ���� ����������, �᫨ � ��� ��-����� ����
  // ���� ������ ������
  uc Key = getch();
  // ������ �����. ���࠭塞 ���祭�� � ��室�� �� �㭪樨
  return Key;
};

// ����� ࠬ��
void DrawBorder( int X1,int Y1,int X2,int Y2 ){
  gotoxy(X1, Y1);
  cprintf("�%s�",StrOf('�',X2-X1));
  for(int i=Y1+1;i<=Y2-1;i++){
	gotoxy(X1, i);
	cprintf("�%s�",StrOf(' ',X2-X1));
  };
  gotoxy(X1, Y2);
  cprintf("�%s�",StrOf('�',X2-X1));
};

// �뢮��� �� �࠭ ᮮ�饭�� S � ���� ������ ������
void WriteMessage( char *S ){
  Color(15, 2);
  DrawBorder(35 - (strlen(S)/2), 11, 44 + (strlen(S)/2), 15);
  WriteCenter(13, S);
  WaitKey();
};

// ���⢥ত����. �����頥� �� (1) / ��� (0)
int Agreement( char *S ){
  char Key;
  Color(15, 2);
  DrawBorder(35 - (strlen(S)/2), 17, 44 + (strlen(S)/2), 21);
  WriteCenter(19, S);
  // ���� ������ ������
  while (kbhit()) getch(); // ��頥� ���� ����������
  Key = getch();
  char res = 0; // ���砫� ��⠥�, �� ���⢥������ ���
  if ((Key=='Y') || (Key=='y')) res = 1;
  return res;
};

// ����� ����
void DrawMenu(){
  Color(7, 0);
  clrscr(); // ��頥� �࠭ ��। �믮������� �ணࠬ��
  // ����� ����
  Color(15, 4);
  DrawBorder(10, 8, 70, 18);
  // ���㥬 �㭪�� ����
  Color(14, 4);
  WriteCenter(10,"1. ���㫨�� �����");
  WriteCenter(11,"2. �������� ��ப� � ⥪���");
  WriteCenter(12,"3. ������� ��ப� �� ⥪��");
  WriteCenter(13,"4. ����� ᫮�� � �᫮ �宦�����");
  WriteCenter(14,"5. ��ᬮ�� ⥪�饩 ����⨪�");
  WriteCenter(15,"6. ������������� �����");
  WriteCenter(16,"Esc. ��室");
  // �뢮��� ⥪�� �� ���� � �������� ࠡ���}
  Color(10, 0);
  WriteCenter(3, "���ᮢ�� ࠡ�� �� �ணࠬ��஢����");
  WriteCenter(4, "������ ����订�, ��. 1372, ��, ����.");
  WriteCenter(5, "1 ����, �ᥭ��� ᥬ���� 2001 ����");
  // �뢮��� ᮮ�饭�� � ���졥 ����� ����
  Color(11, 0);
  WriteCenter(21, "������ ������� 1 - 6 ��� �த�������");
};

// ���� ��ᬮ�� ����⨪�
void WatchStats(){
  int Cur;
  char Key,Key1;
  char Temp[StrLen];
  // �᫨ ��ࠬ���� �� ������ - �뢮��� ᮮ�饭�� �� �⮬ � ��室��}
  if ((WordToFind[0]==0) || (WordToReplace[0]==0) || (NeedCount==0)){
	WriteMessage("��ࠬ���� ��ࠡ�⪨ ⥪�� �� ������");
	return;
  };
  // ���㥬 ����� ��࠭���
  Color(15, 2);
  gotoxy(1, 8); cprintf("%s",StrOf('�', 80));
  WriteCenter(8, "� �᪮��� ᫮�� �");
  gotoxy(1, 9);  cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 10); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 9);  cprintf("%s",WordToFind);
  gotoxy(1, 11); cprintf("%s",StrOf('�', 80));
  WriteCenter(11, "� ����쪮 ࠧ ������ ��������� �");
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",NeedCount);
  gotoxy(1, 14); cprintf("%s",StrOf('�', 80));
  WriteCenter(14, "� � �⮬ ��砥 ��� ��������� �� ᫮�� �");
  gotoxy(1, 15); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 16); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",WordToReplace);
  gotoxy(1, 17); cprintf("%s",StrOf('�', 80));
  WriteCenter(17, "� ������ ���� ������� ��� �த������� ... �");
  // ���� ������ ������ ...
  WaitKey();
  // ... ��頥� �࠭ ...
  DrawMenu();
  // ... � �뢮��� ᫥���饥 ����
  if (Num==0){
	// ��ப ���. �뢮��� ᮮ�饭�� � ��室��
	WriteMessage("��ப �� �������");
	return;
  };
  // ���㥬 ࠬ��
  Color(15, 2);
  gotoxy(1, 10); cprintf("%s",StrOf('�', 80));
  WriteCenter(10, "� �ᯮ���� ������ �����, ���� � Esc �⮡� �������� � ������� ���� �");
  gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",StrOf('�', 80));

  Cur = 1;
  do{
	gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 15); cprintf("%s",StrOf('�', 80));
	gotoxy(1, 11); cprintf("%s",S[Cur]);
	itoa(Cur,Temp,10);
	sprintf(Temp,"� ��ப� %s �",Temp);
	WriteCenter(15,Temp);

	// ��⠥� ����⨥ ������
	while (kbhit()) getch(); // ��頥� ���� ����������
	Key = getch();
	if (Key==0) Key1 = getch();

	// ��������㥬 ����⨥ ������
	if (Key==0){
	  if (Key1==72){ Cur--; if (Cur<1) Cur=1; };
	  if (Key1==80){ Cur++; if (Cur>Num) Cur=Num; };
	};
  } while (Key!=27);
};

// ���� ���������� ��ப�
void AddStringMenu(){
  //���㥬 ࠬ��}
  Color(15, 2);
  gotoxy(1, 10); cprintf("%s",StrOf('�', 80));
  WriteCenter(10, "� ������ ����� ��ப� �");
  gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",StrOf('�', 80));

  // ������塞 ����� ��ப�
  if (Num>=MaxNum){
	WriteMessage("���⨣��� ���ᨬ��쭮� ������⢮ ���祪");
  } else {
	gotoxy(1, 11); scanf("%s",S[Num]);
  };
  Num++;
};

// ���� 㤠����� ��ப�
void DelStringMenu(){
  int i,Cur;
  char Key, Key1;
  char Temp[StrLen];
  if (Num==0){
	// ��ப ���. �뢮��� ᮮ�饭�� � ��室��
	WriteMessage("��ப �� �������");
	return;
  };
  // ���㥬 ࠬ��
  Color(15, 2);
  gotoxy(1, 10); cprintf("%s",StrOf('�', 80));
  WriteCenter(10, "� �ᯮ���� ������ �����, ���� � Enter �⮡� 㤠���� ��ப� �");
  gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",StrOf('�', 80));

  Cur = 1;
  do{
	gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 15); cprintf("%s",StrOf('�', 80));
	gotoxy(1, 11); cprintf("%s",S[Cur]);
	itoa(Cur,Temp,10);
	sprintf(Temp,"� ��ப� %s �",Temp);
	WriteCenter(15,Temp);
	// ��⠥� ����⨥ ������
	while (kbhit()) getch(); // ��頥� ���� ����������
	Key = getch();
	if (Key==0) Key1=getch();

	// ��������㥬 ����⨥ ������
	if (Key==0){
	  if (Key1==72){ Cur--; if (Cur<1)   Cur=1; };
	  if (Key1==80){ Cur++; if (Cur>Num) Cur=Num; };
	};

  } while ((Key!=13) && (Key!=27));

  if (Key==13){
	if (!Agreement("�� ����⢨⥫쭮 ��� 㤠���� ��ப� ? ( Y / N )")) Key=255;
  };

  if (Key==13){
	// ����塞 ��ப� � ᤢ����� ��⠢訥��
	Num--;
	for(i=Cur;i<=Num;i++){
	  strcpy(S[i],S[i+1]);
	};
  };
};

// ��楤�� �롮� ᫮�� � ����室����� ������⢠ �宦�����}
void ReadWords(){
  char TempS[StrLen]; // ��ப�, �६���� �࠭��� �᫮ ࠧ,
					  // ���஥ ������ ��������� �᪮��� ᫮��
  int i, // ��६����� 横��
  ErrorCode, // ��� �訡�� �� ����樨 Val
  Right; // ��୮ �� ������� ᫮��
  // ���㥬 ࠬ��
  Color(15, 2);
  gotoxy(1, 8); cprintf("%s",StrOf('�', 80));
  WriteCenter(8, "� ������ �᪮��� ᫮�� �");
  gotoxy(1, 9); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 10); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 11); cprintf("%s",StrOf('�', 80));
  WriteCenter(11, "� ������, ����� ������⢮ ࠧ ��� ������ ��������� �");
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf('�', 80));
  WriteCenter(14, "� ������ �� ����� ᫮�� ��� �㦭� �������� �");
  gotoxy(1, 15); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 16); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 17); cprintf("%s",StrOf('�', 80));

  //������ ᭠砫� �᪮��� ᫮��}
  Right = 1;
  do{
	if (!Right) cprintf("%c",7);
	gotoxy(1, 9); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 10); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 9); scanf("%s",WordToFind);
	// �஢��塞, �� ᮤ�ন� �� ᫮�� ���㪢���� ᨬ���� (���ਬ��,
	// ����� �९������, �஡��� � �. �. ����� �� ������ �� ᮤ�ঠ��
	Right = 1;
	for (i=0;i<strlen(WordToFind);i++)
	  if (!IsLetter(WordToFind[i])) Right=0;
	// �᫨ ᫮�� ���⮥ - ⮦� �訡��
	if (strlen(WordToFind)==0) Right=0;
  } while (!Right); //������ �� �� ���, ���� ��� �� �㤥� ��୮�

  //������ ������ �᫮ ࠧ. ������, ���� �� �㤥� ��ଠ�쭮�� �᫠
  do{
	gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 12); scanf("%s",TempS);
	NeedCount=atoi(TempS);
	ErrorCode=(NeedCount==0);
	//�᫨ NeedCount <= 0 -> �訡��}
	if (NeedCount <= 0) ErrorCode=1;
  } while (ErrorCode);

  // ������� ������ ᫮��, �� ���஥ ���塞 �᪮���
  Right = 1;
  do{
	if (!Right) cprintf("%c",7);
	gotoxy(1, 15); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 16); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 15); scanf("%s",WordToReplace);
	// �஢��塞, �� ᮤ�ন� �� ᫮�� ���㪢���� ᨬ���� (���ਬ��,
	// ����� �९������, �஡��� � �. �. ����� �� ������ �� ᮤ�ঠ��
	Right = 1;
	for (i=0;i<strlen(WordToReplace);i++)
	  if (!IsLetter(WordToReplace[i])) Right=0;
	// �᫨ ᫮�� ���⮥ - ⮦� �訡��
	if (strlen(WordToReplace)==0) Right=0;
  } while (!Right); // ������ �� �� ���, ���� ��� �� �㤥� ��୮�
};

// �������� ������� ������
void Solve(){
  int
	Count, // ����쪮 ࠧ �᪮��� ᫮�� ����⨫��� � ���窥
	Cur, // ����� ⥪�饣� ᨬ���� � ᫮��
	RightRange, // �ࠢ�� �࠭�� ᫮��
	i, j; // ��६���� 横��
  char Temp[StrLen], // �६����� ��६�����
	   ThisWord[StrLen]; // ����饥 ᫮��
  int Ok; // ��६����� ��� �஢�ન ᮢ������� ᫮��
  // �᫨ ��ࠬ���� �� ������ - �뢮��� ᮮ�饭�� �� �⮬ � ��室��
  if ((WordToFind[0]==0) || (WordToReplace[0]==0) || (NeedCount==0)){
	WriteMessage("��ࠬ���� ��ࠡ�⪨ ⥪�� �� ������");
	return;
  };
  // ��������㥬 ��室�� ⥪�� �����筮
  for(i=0;i<Num;i++){
	Count = 0; // ���砫� ���樠�����㥬 ������⢮ �宦����� � ����
	Cur = 0; // ��稭��� � ��砫� ��ப�
	ThisWord[0] = 0; // ����饥 ᫮�� ���� ���⮥
	while (strlen(S[i])>Cur){
	  if (IsLetter(S[i][Cur])){ // �㪢�
		int t = strlen(ThisWord);
		ThisWord[t]=S[i][Cur];
		ThisWord[t+1]=0;
	  } else { // �� �㪢�
		if (ThisWord[0]!=0){ // �᫨ ᫮�� �� ���⮥ - ࠡ�⠥� � ���
		  // �ࠢ������ � �᪮��. �᫨ ��� - 㢥��稢��� ���稪
		  if (!strcmp(WordToFind,ThisWord)) Count++;
		};
		//����塞 ⥪�饥 ᫮��}
		ThisWord[0]=0;
	  };
	  Cur++;
	};
	// �஢��塞 ��᫥���� ᫮��. ���ࠧ㬥������, �� ࠢ���⢮ �믮������,
	// ⮫쪮 �᫨ ᫮�� ThisWord �� ���⮥
	if (!strcmp(WordToFind,ThisWord)) Count++;
	//���窠 �ன����. �᫨ ������⢮ �宦����� �᪮���� ᫮�� ᮢ������
	// � ����室���, � �����塞 ���
	if (Count==NeedCount){
	 // �஢��塞, �� �⠭������ �� ���窠 ᫨誮� �������
	  if (strlen(S[i]) + (Count * (strlen(WordToReplace)-strlen(WordToFind)))>StrLen) {
		itoa(i,Temp,10);
		sprintf(Temp,"���������� �८�ࠧ����� ��ப� ����� %s.",Temp);
		WriteMessage(Temp);
	  } else {
		//�ᯮ��㥬 ����� ��㣮� ������ ���᪠ ᫮��}
		j = 0;
		while (j<=strlen(S[i])- strlen(WordToFind)+1){ // ��室�� �� �ᥬ� �।�������
		  char T[StrLen];
		  strcpy(T,S[i]+j);
		  T[strlen(WordToFind)]=0;
		  if (!strcmp(T,WordToFind)){ // ����� �ࠣ���� ࠢ�� ᫮��. �஢��塞 �࠭��� ᫮��
			// �஢��塞 ����� �࠭���
			Ok = 0; //���砫� ��⠥�, �� �� �� � ���浪�
			if (j==1) Ok = 1;
			if (!Ok){
			  if (!IsLetter(S[i][j-1])) Ok=1;
			};
			if (Ok){ //�஢��塞 �ࠢ�� �࠭���}
			  Ok = 0; //���砫� ��⠥�, �� �� �� � ���浪�}
			  RightRange = j + strlen(WordToFind); //����塞 �ࠢ�� �࠭��� ᫮��}
			  if (RightRange > strlen(S[i])) Ok = 1;
			  if (!Ok){
				if (!IsLetter(S[i][RightRange])) Ok = 1;
			  };
			  if (Ok){ //�� �⫨筮. ����� ᮢ���� -> �����塞}
				char T1[StrLen],T2[StrLen];
				strcpy(T1,S[i]);
				T1[j-1]=0;
				strcpy(T2,S[i]+j+strlen(WordToFind));
				T2[strlen(S[i])]=0;
				sprintf(S[i],"%s%s%s",T1,WordToReplace,T2);
				//S[i] = Copy(S[i], 1, j - 1) + WordToReplace + Copy(S[i], j + strlen(WordToFind), strlen(S[i]));
				j += strlen(WordToReplace);
			  };
			};
		  };
		  j++;
		};
	  };
	};
  };
  WriteMessage("�८�ࠧ������ �믮�����");
};

//�஢���� ������� �������}
void CheckMenu( char *Key ){
  // �믮��塞 ᮮ⢥�������� ��楤��� � ����ᨬ���}
  switch (Key[0]){
	case '1' : // ����塞 ���祭��
	  Num = 0;
	  NeedCount = 0;
	  WordToFind[0] = 0;
	  WordToReplace[0] = 0;
	  WriteMessage("���㫥��� �믮�����");
	  break;
	case '2' :
	  AddStringMenu(); //�맮� ���� ���������� ��ப�
	  break;
	case '3' :
	  DelStringMenu(); //�맮� ���� 㤠����� ��ப�}
	  break;
	case '4' :
	  ReadWords(); //�맮� ���� �롮� ᫮� � ������⢠ �宦����� ���}
	  break;
	case '5' :
	  WatchStats(); //�맮� ���� ��ᬮ�� ����⨪�}
	  break;
	case '6' :
	  Solve(); //����� ��楤��� �襭�� �����}
	  break;
	case 27 :
	  //�뢮��� ᮮ�饭��, ����饥 ���⢥न�� ��室 �� �ணࠬ��
	  if (!Agreement("�� ����⢨⥫쭮 ��� ��� �� �ணࠬ�� ? ( Y / N )")) Key[0]=255;
	  //�᫨ ���⢥ত���� �� ����祭� - ���塞 ���
	  break;
	default:
	  // ����� ����ୠ� ������. �뤠�� ��㪮��� ᨣ��� � �த������ ࠡ���
	  cprintf("%c",7);
  };
};

void main(){
  // ��砫쭠� ���樠������
  Num=0; NeedCount=0; WordToFind[0]=0; WordToReplace[0]=0;
  // �᭮���� 横� �ணࠬ��. ����⠥�, ���� �� ����� ������ '6' (��室)
  do{
	// ���㥬 ����
	DrawMenu();
	// ���� ������ ������
	Menu = WaitKey();
	// ��ࠡ��뢠�� ����⨥
	CheckMenu(&Menu);
  } while (Menu!=27);
  // ����� ��室. ��室�� �� �ணࠬ��
};