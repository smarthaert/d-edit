#include <conio.h>
#include <iostream.h>
#include <complex.h>

complex input_complex()
 {
   double x,y;
   cout << " Re = "; cin >> x;
   cout << " Im = "; cin >> y;
   return complex(x,y);
 };

void main()
 {
   clrscr();
   cout << "Решение линейного дифференциального уравнения с постоянными коэфиициентами:\n";
   cout << "a*y'' + b*y' + c*y + d = 0\n";
   complex a,b,c,d;
   cout << "a: "; a = input_complex(); cout << " a = " << a << "\n";
   cout << "b: "; b = input_complex(); cout << " b = " << b << "\n";
   cout << "c: "; c = input_complex(); cout << " c = " << c << "\n";
   cout << "d: "; d = input_complex(); cout << " d = " << d << "\n";
/*   complex t,y0,yd0;
   if (c!=0)
	{
	  t = -d/c;
	 // Вычисление корней характеристичесого уравнения
	  printf("Характеристическое уравнение: %f*p^2 + %f*p + %f = 0\n",a,b,c);
	  float D = b*b-4*a*c,p1,p2,p;
	  if (a!=0)
	   {
		 p1 = (-b+sqrt(D))/(2*a),
		 p2 = (-b-sqrt(D))/(2*a);
		 printf("Корни характеристического уравнения: p1 = %f p2 = %f\n",p1,p2);
		 printf("Общее решение:");
		 printf("y = a1*e^(%f*x) + a2*e^(%f*x) + %f\n",p1,p2,t);
		 printf("Начальные условия:\n");
		 printf("y(0) = "); scanf("%f",&y0);
		 printf("y'(0) = "); scanf("%f",&yd0);
		 float a1,a2;
		 a1 = ( y0*p2-yd0-t*(p2-1) ) / (p2-p1);
		 a2 = ( y0*p1-yd0-t*(p1-1) ) / (p1-p2);
		 printf("Общее решение с учетом начальных условий:");
         printf("y = %f*e^(%f*x) + %f*e^(%f*x) + %f\n",a1,p1,a2,p2,t);
       }
      else
       {
         p = -c/b;
         printf("Корень характеристического уравнения: p = %f\n",p);
         printf("Общее решение:");
         printf("y = a*e^(%f*x) + a2*e^(%f*x) + %f\n",p,t);
		 printf("Начальные условия:\n");
		 printf("y(0) = "); scanf("%f",&y0);
		 float a = -y0/t;
		 printf("Общее решение с учетом начальных условий:");
		 printf("y = %f*e^(%f*x) + %f\n",a,p,t);
	   };
	}
   else
	{
	};*/
 };