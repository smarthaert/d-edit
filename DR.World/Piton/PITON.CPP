// ����������������������������������������������������������������ͻ //
// � �                         � � � � �                          � � //
// ����������������������������������������������������������������ͼ //

#include <dos.h>
#include <conio.h>
#include <stdlib.h>
#include <graphics.h>

// ���� ��室� �� ���� ( ��⠭����� � >=1 ��� ��室� )
int EndOfGame = 0;

// ����প� ( ��� ����� Delay ⥬ ��� ��������� )
int Delay = 75;

// �窨
long int Score = 0;

// = = = ���� = = = //

// �������� ���ﭨ� ���⪨ �����
#define Clean 0 // ����� ���⪠
#define Erase 1 // ���⪠ �������� ��࠭��
#define Piton 2 // ���� ��⮭�
#define PHead 3 // ������ ��⮭�
#define Enemy 4 // ���

// ����
#define BackGColor 9
#define PitonColor 12
#define PHeadColor 7
#define EnemyColor 11

// ������� ����� � ���⪠�
#define MapX 24
#define MapY 24

// ������� ���⪨ � ���ᥫ��
#define Size 20

char Map[MapX][MapY];

void ShowScore()
 {
   setfillstyle(1,2);
   bar(MapX*Size,0,639,40);
   char String[10];
   itoa(Score,String,10);
   setcolor(15);
   rectangle(MapX*Size+2,0,639,39);
   settextstyle(1,0,4);
   outtextxy(MapX*Size+20,0,String);
 }

void ShowBox( int x,int y,char Color )
 {
   setfillstyle(1,Color);
   bar(x*Size,y*Size,(x+1)*Size-1,(y+1)*Size-1);
   setcolor(8);
   rectangle(x*Size+1,y*Size+1,(x+1)*Size-2,(y+1)*Size-2);
 }

void MapInit()
 {
   int x,y;
   for(x=MapX*Size;x<640;x++)
     for(y=0;y<480;y++)
       putpixel(x,y,random(2)*8+7);
   for(x=0;x<MapX;x++)
     for(y=0;y<MapY;y++)
       ShowBox(x,y,BackGColor);
   ShowScore();
 }

void MapClear()
 {
   for(int x=0;x<MapX;x++)
     for(int y=0;y<MapY;y++)
       Map[x][y]=Clean;
 }

void MapDraw()
 {
   int x,y,Color;
   for(x=0;x<MapX;x++)
     for(y=0;y<MapY;y++)
      {
        switch(Map[x][y])
         {
           case Clean: Color=-1;         break;
           case Erase: Color=BackGColor; break;
           case Piton: Color=PitonColor; break;
           case PHead: Color=PHeadColor; break;
           case Enemy: Color=EnemyColor; break;
         }
        if(Color>=0) ShowBox(x,y,Color);
      }
 }

// = = = �ࠣ ( ��� ) = = = //

char EnemyLive = 0;

pointtype _Enemy_;

void EnemyStep()
 {
   int x,y;
   if(EnemyLive==0)
    {
      EnemyLive = 1;
      do{ x=random(MapX); y=random(MapY); } while(Map[x][y]!=Clean);
      _Enemy_.x=x; _Enemy_.y=y;
    }
 }

void EnemyDraw()
 {
   Map[_Enemy_.x][_Enemy_.y] = Enemy;
 }

// = = = ��⮭ = = = //

// ���ᨬ��쭠� ����� ��⮭�
#define MaxPitonLength 3072

// ���ࠢ�����
#define Up    0
#define Left  1
#define Right 2
#define Down  3

// ���ࠢ����� �������� ��⮭�
char PitonWay;

// ������ ����� ��⮭�
int PitonLength;

// ���न���� �祪 ��⮭�
pointtype _Piton_[MaxPitonLength];

void PitonInit( int Length,int x,int y,char Way )
 {
   PitonLength=Length;
   for(int i=0;i<PitonLength;i++)
    {
      _Piton_[i].x=x+i;
      _Piton_[i].y=y;
    }
   PitonWay=Way;
 }

int PitonCanMove( int x,int y )
 {
   if ((x>=0) && (x<MapX) && (y>=0) && (y<MapY))
    { return (Map[x][y]!=Piton); }
   else
     return 0;
 }

void PitonMove( int x,int y )
 {
   if(PitonCanMove(x,y))
    {
      for(int i=PitonLength;i>0;i--) _Piton_[i]=_Piton_[i-1];
      _Piton_[0].x=x;
      _Piton_[0].y=y;
      if(Map[x][y]==Enemy)
       {
         EnemyLive = 0;
         PitonLength++;
         Score += 100;
         if((Score%500)==0) Delay=Delay*100/150;
         ShowScore();
       }
    }
   else
     EndOfGame = 1;
 }

void PitonStep()
 {
   switch(PitonWay)
    {
      case Up   : PitonMove(_Piton_[0].x,  _Piton_[0].y-1); break;
      case Left : PitonMove(_Piton_[0].x-1,_Piton_[0].y  ); break;
      case Right: PitonMove(_Piton_[0].x+1,_Piton_[0].y  ); break;
      case Down : PitonMove(_Piton_[0].x,  _Piton_[0].y+1); break;
    };
 }

void PitonDraw()
 {
   Map[_Piton_[PitonLength].x][_Piton_[PitonLength].y]=Erase;
   Map[_Piton_[0].x][_Piton_[0].y]=PHead;
   for(int i=1;i<PitonLength;i++)
     Map[_Piton_[i].x][_Piton_[i].y]=Piton;
 }

// = = = ��ࠢ����� = = = //
void AskManagement()
 {
   if(kbhit())
    {
      switch(getch())
       {
         case 0: // ��५��
           switch(getch())
            {
              case 72: PitonWay=Up;    break;
              case 75: PitonWay=Left;  break;
              case 77: PitonWay=Right; break;
              case 80: PitonWay=Down;  break;
            }; break;
         case 27: // ESC
           EndOfGame=1;
       }
    }
 }

// = = = �᭮���� �ணࠬ�� = = = //
void main()
 {
  // ���樠������ ������� ��砩��� �ᥫ
   randomize();
  // ���樠������ ��䨪�
   int GD=VGA,GM=VGAHI;
   initgraph(&GD,&GM,"");
  // ���樠������ �����
   MapInit();
  // ���樠������ ��⮭�
   PitonInit(3,0,0,Down);
  // �᭮���� 横�
   do
    {
     // ������� �� !
      PitonStep();
      EnemyStep();
     // � ��-�� �������� !
      MapClear();
      PitonDraw();
      EnemyDraw();
      MapDraw();
     // ��ࠢ�����
      AskManagement();
     // ����প�
      delay(Delay);
    }
   while(!EndOfGame);
  // �����⨥ ��䨪�
   closegraph();
 }