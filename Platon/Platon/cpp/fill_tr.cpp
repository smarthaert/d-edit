// Треугольник с закрасой по Гуро
#include  <conio.h>
#include  <stdlib.h>
#include  <graphics.h>

class triangle{
  long P[3][2]; // Координаты вершин
  long Light[3]; // Освещенность
 public:
 // Констуктор - задаем вершины
  triangle( int x1,int y1,int x2,int y2,int x3,int y3,int l1,int l2,int l3 ){
	P[0][0] = x1; P[0][1] = y1;
	P[1][0] = x2; P[1][1] = y2;
	P[2][0] = x3; P[2][1] = y3;
	Light[0] = l1; Light[1] = l2; Light[2] = l3;
  };
 // Обмен двух значений местами
  void swap( long *a, long *b ){
	long temp; temp=a[0]; a[0]=b[0]; b[0]=temp;
  };
 // Вывод на жкран
  void draw(){
	long a,b,x1,x2,x,y;
	for (a=0;a<2;a++)
	  for (b=a;b<3;b++)
		if (P[a][1]>P[b][1]){ swap(&P[a][0],&P[b][0]); swap(&P[a][1],&P[b][1]);}
	setcolor(5);
	if ((P[0][1]!=P[1][1]) && (P[0][1]!=P[2][1]))
	  for (a=P[0][1];a<=P[1][1];a++){
		x1 = (long)(((P[2][0]-P[0][0])*(a-P[0][1])/(P[2][1]-P[0][1])))+P[0][0];
		x2 = (long)(((P[1][0]-P[0][0])*(a-P[0][1])/(P[1][1]-P[0][1])))+P[0][0];
		if (x1>x2) swap(&x1,&x2);
		for (b=x1;b<=x2;b++) putpixel(b,a,rand()%16);
	  };
	if ((P[0][1]!=P[2][1]) && (P[1][1]!=P[2][1]))
	  for (a=P[1][1];a<=P[2][1];a++){
		x1 = (int)(((P[2][0]-P[0][0])*(a-P[0][1])/(P[2][1]-P[0][1])))+P[0][0];
		x2 = (int)(((P[2][0]-P[1][0])*(a-P[1][1])/(P[2][1]-P[1][1])))+P[1][0];
		if (x1>x2) swap(&x1,&x2);
		for (b=x1;b<=x2;b++) putpixel(b,a,rand()%16);
	  };
   // Окружаем полигоном
	setcolor(15);
	int points[8];
	for(a=0;a<4;a++)
	  for(b=0;b<2;b++)
		points[a*2+b]=P[a%3][b];
	drawpoly(4,points);
  };
};

class StdVGAMode{
 public:
  StdVGAMode( int ){
	int GD = VGA,GM = VGAHI;
	initgraph(&GD,&GM,"");
  };
  ~StdVGAMode(){
	closegraph();
  };
};

void main(){
  StdVGAMode _StdVGAMode(1);
//  triangle T(200,100,400,250,450,400);
  triangle T(200,100,450,400,400,250,1,1,1);
  T.draw();
  getch();
};