/*
  ПРИЛОЖЕНИЕ А. ИСХОДНЫЙ ТЕКСТ ПРОГРАММЫ
  Курсовая работа по программированию
*/

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#define MaxNum 100 // Максимально возможное количество строчек
#define StrLen 400 // Максимальная длина строки

typedef unsigned char uc;

// Глобальные переменные
char Menu, // Выбранный пункт меню
	 WordToFind[StrLen], // Искомое слово
	 WordToReplace[StrLen]; // Слово, на которое нужно заменить искомое при необходимых обстоятельствах
int NeedCount; // Количество раз, которое искомое слово должно встречаться в тексте, чтобы быть замененным на другое
char S[MaxNum][StrLen]; // Массив строк текста
int Num; // Количество строк}

// Проверяет, является ли входной символ буквой
int IsLetter( uc Ch ){
  uc r = 0; //Сначала считаем, что не является}
  if ((Ch>='A') && (Ch<='Z')) r = 1;
  if ((Ch>='a') && (Ch<='z')) r = 1;
  if ((Ch>=(uc)'А') && (Ch<=(uc)'Я')) r = 1;
  // Цифры, как говорится - тоже буквы. В том смысле, что они являются
  // верными символами при составлении слов, и не являются знаками
  // препинания
  if ((Ch>='0') && (Ch<='9')) r = 1;
  // Поскольку строчные буквы русского алфавита в таблице ASCII
  // делится на 2 части, проверяем каждую часть по отдельности
  if ((Ch>=(uc)'а') && (Ch<=(uc)'п')) r = 1;
  if ((Ch>=(uc)'р') && (Ch<=(uc)'я')) r = 1;
  if ((Ch==240) || (Ch==241)) r = 1; // Буква е:
  return r;
};

// Устанавливает цвет текста - Text и цвет фона BackGround
void Color( int Text,int BackGround ){
  textcolor(Text);
  textbackground(BackGround);
};

// Возвращает строку из Count символов Ch
uc *StrOf( uc Ch,int Count ){
  uc S[StrLen];
  for(int i=0;i<Count;i++) S[i]=Ch;
  S[Count]=0; // Конец строки
  return S;
};

// Рисует текст S посередине строки Y
void WriteCenter( int Y,char *S ){
  gotoxy(40-(strlen(S)/2), Y);
  cprintf("%s",S);
};

// Ждет нажатия клавиши
uc WaitKey(){
  while (kbhit()) getch(); // Очищаем буфер клавиатуры, если в нем что-нибудь есть
  // Ждем нажатия клавиши
  uc Key = getch();
  // Клавиша нажата. Сохраняем значение и выходим из функции
  return Key;
};

// Рисует рамку
void DrawBorder( int X1,int Y1,int X2,int Y2 ){
  gotoxy(X1, Y1);
  cprintf("╔%s╗",StrOf('═',X2-X1));
  for(int i=Y1+1;i<=Y2-1;i++){
	gotoxy(X1, i);
	cprintf("║%s║",StrOf(' ',X2-X1));
  };
  gotoxy(X1, Y2);
  cprintf("╚%s╝",StrOf('═',X2-X1));
};

// Выводит на экран сообщение S и ждет нажатия клавиши
void WriteMessage( char *S ){
  Color(15, 2);
  DrawBorder(35 - (strlen(S)/2), 11, 44 + (strlen(S)/2), 15);
  WriteCenter(13, S);
  WaitKey();
};

// Подтверждение. Возвращает да (1) / нет (0)
int Agreement( char *S ){
  char Key;
  Color(15, 2);
  DrawBorder(35 - (strlen(S)/2), 17, 44 + (strlen(S)/2), 21);
  WriteCenter(19, S);
  // Ждем нажатия клавиши
  while (kbhit()) getch(); // Очищаем буфер клавиатуры
  Key = getch();
  char res = 0; // Сначала считаем, что подтвеждения нет
  if ((Key=='Y') || (Key=='y')) res = 1;
  return res;
};

// Рисует меню
void DrawMenu(){
  Color(7, 0);
  clrscr(); // Очищаем экран перед выполнением программы
  // Рамка меню
  Color(15, 4);
  DrawBorder(10, 8, 70, 18);
  // Рисуем пункты меню
  Color(14, 4);
  WriteCenter(10,"1. Обнулить данные");
  WriteCenter(11,"2. Добавить строку к тексту");
  WriteCenter(12,"3. Удалить строку из текста");
  WriteCenter(13,"4. Выбрать слова и число вхождений");
  WriteCenter(14,"5. Просмотр текущей статистики");
  WriteCenter(15,"6. ПРЕОБРАЗОВАТЬ ТЕКСТ");
  WriteCenter(16,"Esc. Выход");
  // Выводим текст об авторе и названии работы}
  Color(10, 0);
  WriteCenter(3, "Курсовая работа по программированию");
  WriteCenter(4, "Дмитрия Кирюшова, гр. 1372, ВТ, ФКТИ.");
  WriteCenter(5, "1 курс, осенний семестр 2001 года");
  // Выводим сообщение о просьбе выбрать меню
  Color(11, 0);
  WriteCenter(21, "Нажмите клавишу 1 - 6 для продолжения");
};

// Окно просмотра статистики
void WatchStats(){
  int Cur;
  char Key,Key1;
  char Temp[StrLen];
  // Если параметры не заданы - выводим сообщение об этом и выходим}
  if ((WordToFind[0]==0) || (WordToReplace[0]==0) || (NeedCount==0)){
	WriteMessage("Параметры обработки текста не заданы");
	return;
  };
  // Рисуем первую страницу
  Color(15, 2);
  gotoxy(1, 8); cprintf("%s",StrOf('═', 80));
  WriteCenter(8, "╡ Искомое слово ╞");
  gotoxy(1, 9);  cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 10); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 9);  cprintf("%s",WordToFind);
  gotoxy(1, 11); cprintf("%s",StrOf('─', 80));
  WriteCenter(11, "┤ Сколько раз должно встретиться ├");
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",NeedCount);
  gotoxy(1, 14); cprintf("%s",StrOf('─', 80));
  WriteCenter(14, "┤ В этом случае оно заменяется на слово ├");
  gotoxy(1, 15); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 16); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",WordToReplace);
  gotoxy(1, 17); cprintf("%s",StrOf('═', 80));
  WriteCenter(17, "╡ Нажмите любую клавишу для продолжения ... ╞");
  // Ждем нажатия клавиши ...
  WaitKey();
  // ... очищаем экран ...
  DrawMenu();
  // ... и выводим следующее окно
  if (Num==0){
	// Строк нет. Выводим сообщение и выходим
	WriteMessage("Строк не найдено");
	return;
  };
  // Рисуем рамку
  Color(15, 2);
  gotoxy(1, 10); cprintf("%s",StrOf('═', 80));
  WriteCenter(10, "╡ Используйте клавиши Вверх, Вниз и Esc чтобы вернуться в главное меню ╞");
  gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",StrOf('═', 80));

  Cur = 1;
  do{
	gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 15); cprintf("%s",StrOf('═', 80));
	gotoxy(1, 11); cprintf("%s",S[Cur]);
	itoa(Cur,Temp,10);
	sprintf(Temp,"╡ Строка %s ╞",Temp);
	WriteCenter(15,Temp);

	// Читаем нажатие клавиши
	while (kbhit()) getch(); // Очищаем буфер клавиатуры
	Key = getch();
	if (Key==0) Key1 = getch();

	// Анализируем нажатие клавиши
	if (Key==0){
	  if (Key1==72){ Cur--; if (Cur<1) Cur=1; };
	  if (Key1==80){ Cur++; if (Cur>Num) Cur=Num; };
	};
  } while (Key!=27);
};

// Меню добавления строки
void AddStringMenu(){
  //Рисуем рамку}
  Color(15, 2);
  gotoxy(1, 10); cprintf("%s",StrOf('═', 80));
  WriteCenter(10, "╡ Введите новую строку ╞");
  gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",StrOf('═', 80));

  // Добавляем новую строку
  if (Num>=MaxNum){
	WriteMessage("Достигнуто максимальное количество строчек");
  } else {
	gotoxy(1, 11); scanf("%s",S[Num]);
  };
  Num++;
};

// Меню удаления строки
void DelStringMenu(){
  int i,Cur;
  char Key, Key1;
  char Temp[StrLen];
  if (Num==0){
	// Строк нет. Выводим сообщение и выходим
	WriteMessage("Строк не найдено");
	return;
  };
  // Рисуем рамку
  Color(15, 2);
  gotoxy(1, 10); cprintf("%s",StrOf('═', 80));
  WriteCenter(10, "╡ Используйте клавиши Вверх, Вниз и Enter чтобы удалить строку ╞");
  gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 15); cprintf("%s",StrOf('═', 80));

  Cur = 1;
  do{
	gotoxy(1, 11); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 14); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 15); cprintf("%s",StrOf('═', 80));
	gotoxy(1, 11); cprintf("%s",S[Cur]);
	itoa(Cur,Temp,10);
	sprintf(Temp,"╡ Строка %s ╞",Temp);
	WriteCenter(15,Temp);
	// Читаем нажатие клавиши
	while (kbhit()) getch(); // Очищаем буфер клавиатуры
	Key = getch();
	if (Key==0) Key1=getch();

	// Анализируем нажатие клавиши
	if (Key==0){
	  if (Key1==72){ Cur--; if (Cur<1)   Cur=1; };
	  if (Key1==80){ Cur++; if (Cur>Num) Cur=Num; };
	};

  } while ((Key!=13) && (Key!=27));

  if (Key==13){
	if (!Agreement("Вы действительно хотите удалить строку ? ( Y / N )")) Key=255;
  };

  if (Key==13){
	// Удаляем строку и сдвигаем оставшиеся
	Num--;
	for(i=Cur;i<=Num;i++){
	  strcpy(S[i],S[i+1]);
	};
  };
};

// Процедура выбора слова и необходимого количества вхождений}
void ReadWords(){
  char TempS[StrLen]; // Строка, временно хранящая число раз,
					  // которое должно встретиться искомое слово
  int i, // Переменная цикла
  ErrorCode, // Код ошибки при операции Val
  Right; // Верно ли введено слово
  // Рисуем рамку
  Color(15, 2);
  gotoxy(1, 8); cprintf("%s",StrOf('═', 80));
  WriteCenter(8, "╡ Введите искомое слово ╞");
  gotoxy(1, 9); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 10); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 11); cprintf("%s",StrOf('─', 80));
  WriteCenter(11, "┤ Введите, какое количество раз оно должно встретиться ├");
  gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 14); cprintf("%s",StrOf('─', 80));
  WriteCenter(14, "┤ Введите на какое слово его нужно заменить ├");
  gotoxy(1, 15); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 16); cprintf("%s",StrOf(' ', 80));
  gotoxy(1, 17); cprintf("%s",StrOf('═', 80));

  //Вводим сначала искомое слово}
  Right = 1;
  do{
	if (!Right) cprintf("%c",7);
	gotoxy(1, 9); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 10); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 9); scanf("%s",WordToFind);
	// Проверяем, не содержит ли слово небуквенные символы (например,
	// знаки препинания, пробелы и т. д. Слово не должно их содержать
	Right = 1;
	for (i=0;i<strlen(WordToFind);i++)
	  if (!IsLetter(WordToFind[i])) Right=0;
	// Если слово пустое - тоже ошибка
	if (strlen(WordToFind)==0) Right=0;
  } while (!Right); //Вводим до тех пор, пока оно не будет верное

  //Теперь вводим число раз. Вводим, пока не будет нормального числа
  do{
	gotoxy(1, 12); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 13); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 12); scanf("%s",TempS);
	NeedCount=atoi(TempS);
	ErrorCode=(NeedCount==0);
	//Если NeedCount <= 0 -> ошибка}
	if (NeedCount <= 0) ErrorCode=1;
  } while (ErrorCode);

  // Наконец вводим слово, на которое меняем искомое
  Right = 1;
  do{
	if (!Right) cprintf("%c",7);
	gotoxy(1, 15); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 16); cprintf("%s",StrOf(' ', 80));
	gotoxy(1, 15); scanf("%s",WordToReplace);
	// Проверяем, не содержит ли слово небуквенные символы (например,
	// знаки препинания, пробелы и т. д. Слово не должно их содержать
	Right = 1;
	for (i=0;i<strlen(WordToReplace);i++)
	  if (!IsLetter(WordToReplace[i])) Right=0;
	// Если слово пустое - тоже ошибка
	if (strlen(WordToReplace)==0) Right=0;
  } while (!Right); // Вводим до тех пор, пока оно не будет верное
};

// АЛГОРИТМ РЕШЕНИЯ ЗАДАЧИ
void Solve(){
  int
	Count, // Сколько раз искомое слово встретилось в строчке
	Cur, // Номер текущего символа в слове
	RightRange, // Правая граница слова
	i, j; // Переменные цикла
  char Temp[StrLen], // Временная переменная
	   ThisWord[StrLen]; // Текущее слово
  int Ok; // Переменная для проверки совпадения слова
  // Если параметры не заданы - выводим сообщение об этом и выходим
  if ((WordToFind[0]==0) || (WordToReplace[0]==0) || (NeedCount==0)){
	WriteMessage("Параметры обработки текста не заданы");
	return;
  };
  // Анализируем исходный текст построчно
  for(i=0;i<Num;i++){
	Count = 0; // Сначала инициализируем количество вхождений в ноль
	Cur = 0; // Начинаем с начала строки
	ThisWord[0] = 0; // Текущее слово пока пустое
	while (strlen(S[i])>Cur){
	  if (IsLetter(S[i][Cur])){ // Буква
		int t = strlen(ThisWord);
		ThisWord[t]=S[i][Cur];
		ThisWord[t+1]=0;
	  } else { // Не буква
		if (ThisWord[0]!=0){ // Если слово не пустое - работаем с ним
		  // Сравниваем с искомым. Если оно - увеличиваем счетчик
		  if (!strcmp(WordToFind,ThisWord)) Count++;
		};
		//Обнуляем текущее слово}
		ThisWord[0]=0;
	  };
	  Cur++;
	};
	// Проверяем последнее слово. Подразумевается, что равенство выполняется,
	// только если слово ThisWord не пустое
	if (!strcmp(WordToFind,ThisWord)) Count++;
	//Строчка пройдена. Если количество вхождений искомого слова совпадает
	// с необходимым, то заменяем его
	if (Count==NeedCount){
	 // Проверяем, ни становится ли строчка слишком длинной
	  if (strlen(S[i]) + (Count * (strlen(WordToReplace)-strlen(WordToFind)))>StrLen) {
		itoa(i,Temp,10);
		sprintf(Temp,"Невозможно преобразовать строку номер %s.",Temp);
		WriteMessage(Temp);
	  } else {
		//Используем здесь другой алгоритм поиска слова}
		j = 0;
		while (j<=strlen(S[i])- strlen(WordToFind)+1){ // Проходим по всему предложению
		  char T[StrLen];
		  strcpy(T,S[i]+j);
		  T[strlen(WordToFind)]=0;
		  if (!strcmp(T,WordToFind)){ // Данный фрагмент равен слову. Проверяем границы слова
			// Проверяем левую границу
			Ok = 0; //Сначала считаем, что не все в порядке
			if (j==1) Ok = 1;
			if (!Ok){
			  if (!IsLetter(S[i][j-1])) Ok=1;
			};
			if (Ok){ //Проверяем правую границу}
			  Ok = 0; //Сначала считаем, что не все в порядке}
			  RightRange = j + strlen(WordToFind); //Вычисляем правую границу слова}
			  if (RightRange > strlen(S[i])) Ok = 1;
			  if (!Ok){
				if (!IsLetter(S[i][RightRange])) Ok = 1;
			  };
			  if (Ok){ //Все отлично. Слова совпали -> заменяем}
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
  WriteMessage("Преобразование выполнено");
};

//Проверяет нажатую клавишу}
void CheckMenu( char *Key ){
  // Выполняем соответствующую процедуру в зависимости}
  switch (Key[0]){
	case '1' : // Обнуляем значения
	  Num = 0;
	  NeedCount = 0;
	  WordToFind[0] = 0;
	  WordToReplace[0] = 0;
	  WriteMessage("Обнуление выполнено");
	  break;
	case '2' :
	  AddStringMenu(); //Вызов меню добавления строки
	  break;
	case '3' :
	  DelStringMenu(); //Вызов меню удаления строки}
	  break;
	case '4' :
	  ReadWords(); //Вызов меню выбора слов и количества вхождения его}
	  break;
	case '5' :
	  WatchStats(); //Вызов окна просмотра статистики}
	  break;
	case '6' :
	  Solve(); //Запуск процедуры решения задачи}
	  break;
	case 27 :
	  //Выводим сообщение, просящее подтвердить выход из программы
	  if (!Agreement("Вы действительно хотите выйти из программы ? ( Y / N )")) Key[0]=255;
	  //Если подтверждение не получено - меняем код
	  break;
	default:
	  // Нажата неверная клавиша. Выдаем звуковой сигнал и продолжаем работу
	  cprintf("%c",7);
  };
};

void main(){
  // Начальная инициализация
  Num=0; NeedCount=0; WordToFind[0]=0; WordToReplace[0]=0;
  // Основной цикл программы. Работает, пока не нажата клавиша '6' (выход)
  do{
	// Рисуем меню
	DrawMenu();
	// Ждем нажатия клавиши
	Menu = WaitKey();
	// Обрабатываем нажатие
	CheckMenu(&Menu);
  } while (Menu!=27);
  // Нажат выход. Выходим из программы
};