#include <conio.h>
#include <iostream.h>

void main()
 {
   clrscr();
   cout << "\nа) ";
   long int t=1000;
   for(int i=0;i<100;i++)
    {
      cout << t << ' ';
      if (t>0) { t = - (t - 2); } else t = - t - 2;
    };
   cout << "\nб) ";
   int a = 2, k = 1;
   for (i=0;i<100;i++)
    {
      cout << k * a << ' ';
      if (k==a) a++,k=0;
      k++;
    };
   cout << "\nв) ";
   t = 1000; a = 0,k = -1; int r = -2;
   for (i=0;i<100;i++)
    {
      k++;
      if (k==3) k=0,r=-r;
      switch (r)
       {
	case -2: cout << t << ' '; t+=r; break;
	case +2: cout << a << ' '; a+=r; break;
       };
    };
   cout << "\nг) ";
   a = 2; t = a; k = -1;
   for (i=0;i<100;i++)
    {
      k++;
      if (k==4) k=0,a++,t=a;
      cout << t << ' ';
      t*=a;
    };
   cout << "\n\n Нажмите любую клавишу !";
   getch();
 }