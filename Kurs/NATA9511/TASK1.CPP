#include <stdio.h>
#include <math.h>
#include <values.h>

// ---=== Точность вычисления суммы ряда ===---
#define delta 0.001

// ---=== Подсчет факториала ===---
float fact( int n )
 {
	float k = 1;
	for (int i=1;i<=n;i++) k*=i;
	return k;
 };

// ---=== Возведение x в степень n ===---
float step( float x,int n )
 {
	float k = 1;
	for (int i=1;i<=n;i++) k*=x;
	return k;
 };

// ---=== Подсчет первой функции ===---
float f1( float x )
 {
	float res = 0, cur_delta = MAXINT;
	int k = 0;
       // Пока точность недостаточна 
	while (fabs(cur_delta) > delta)
	{
         // Вычисляем очередной член ряда 
	  cur_delta=(step(-1,k)*step(x,4*k+2))/fact(4*k+2);
         // Добавляем его
          res+=cur_delta;
	  k++;
	};
       // Возвращаем результат 
	return res;
 }

// ---=== Подсчет второй функции ===---
float f2( float x )
 {
	float r = x/sqrt(2);
	return sin(r)*(exp(r)-exp(-r))/2;
 }

// ---=== Основная программа ===---
void main()
 {
	float r;
	   // Открываем текстовой файл для записи результатов
	FILE *OutX,*OutY1,*OutY2;
	OutX = fopen("task1x.txt","w+");
	OutY1 = fopen("task1y1.txt","w+");
	OutY2 = fopen("task1y2.txt","w+");
	   // В цикле вычислям значения функций от 0.0 до 2.0
	for (int u=0;u<=20;u++)
	{
	  r=((float)u)/10;
	  fprintf(OutX,"%f ",r);
	  fprintf(OutY1,"%f ",f1(r));
	  fprintf(OutY2,"%f ",f2(r));
	}
	fclose(OutX); fclose(OutY1); fclose(OutY2);
 }
