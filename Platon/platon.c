#include <conio.h>
#include <math.h>
#include <graphics.h>

// - ����� -
#define MaxDimSpace 6
#define MaxDimNods 96
#define MaxDimLoops 200
  char Mask[36] = "123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ";
  float pi = atan(1.0)*4;
  float Dx,Dy;
 // Geometry Definitions
  float DimAngle = 300.0;
  int DimSpace;
  int DimNods;
  int DimLoops;
  int DimPlanes;
  typedef float TP[MaxDimSpace];
  TP W[MaxDimNods];
  int Loops[MaxDimLoops][2];
  float Rotate[MaxDimSpace][MaxDimSpace];
 // Geometry Data
  int DS[10] = { 4, 3, 3, 5, 4, 4, 4, 5,  6, 3}; // �����p����
  int DN[10] = { 4, 8, 6, 5, 8,24,16,32, 64,12}; // ��᫠ ��p設
  int DL[10] = { 6,12,12,10,24,96,32,80,192,30}; // ��᫠ p���p
  int DP[10] = { 4, 6, 8, 4, 8, 8, 6, 6,  6,20}; // ��᫠ �p����
  int DD[10] = { 3, 4, 3, 3, 3, 3, 4, 4,  4, 3}; // �����p���� �����㣮�쭨���
 // ����⠡
  int Disp[10] = { 50,100,170,40,180,120, 80, 80, 80, 10};
 // H�砫쭮� �p�饭��
  int XT[10][4] =
   {{1,2,3,2},{1,2,1,2},{1,2,1,2},
    {1,2,3,1},{1,2,1,2},{1,2,1,2},
    {1,2,3,2},{1,1,2,1},{1,2,3,1},
    {1,2,3,1}};
  int YT[10][4] =
   {{4,4,4,3},{3,3,2,3},{3,3,2,3},
	{4,4,4,3},{4,4,2,3},{4,4,3,3},
	{4,4,4,3},{5,4,5,3},{6,5,4,3},
	{6,5,4,3}};
  float RT[10][4] =
   {{pi/6,pi/7,-pi/8,0},
	{pi/6,pi/7,-pi/9,pi/8},
	{pi/6,pi/7,-pi/9,0},
	{pi/6,pi/7,-pi/9,pi/7},
	{pi/6,pi/7,-pi/9,0},
	{pi/6,pi/7,-pi/9,0},
	{pi/6,pi/7,-pi/9,0},
	{pi/6,pi/7,-pi/9,0},
	{pi/6,pi/7,-pi/9,pi/7},
	{pi/6,pi/7,-pi/9,pi/7}};
 // ����饥 �p�饭��
  int TX[10][4] =
   {{1,2,3,2},{1,2,3,2},{1,2,1,2},
	{1,2,3,4},{1,2,3,2},{1,2,1,2},
	{1,2,3,2},{1,2,3,4},{1,2,1,2},
	{1,2,1,2}};
  int TY[10][4] =
   {{4,4,4,3},{2,3,1,3},{2,3,3,3},
	{5,5,5,5},{4,4,1,3},{4,3,2,2},
	{4,4,4,3},{5,5,5,5},{6,4,5,3},
	{6,4,5,3}};
  float TR[10][4] =
   {{1/DimAngle,-1/DimAngle,1/DimAngle,0},
	{1/DimAngle,-1/DimAngle,1/DimAngle,0},
	{1/DimAngle,-1/DimAngle,1/DimAngle,0},
	{1/DimAngle,-1/DimAngle,1/DimAngle,0},
	{1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle},
	{1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle},
	{1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle},
	{1/DimAngle,-1/DimAngle,1/DimAngle,0},
	{1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle},
	{1/DimAngle,-1/DimAngle,1/DimAngle,1/DimAngle}};
 // * ��p�����-3 *
  int T3[4][4] =
   {{ 1, 1, 1,-3},
	{ 1, 1,-3, 1},
	{ 1,-3, 1, 1},
	{-3, 1, 1, 1}};
  int LT3[6][2] = {{1,2},{1,3},{1,4},{2,3},{2,4},{3,4}};
  int PT3[4][3] = {{1,2,3},{1,3,4},{1,4,2},{2,4,3}};
 // * �㡨�-3 *
  int C3[8][3] =
   {{-1,-1,-1},{-1,-1, 1},
	{-1, 1,-1},{-1, 1, 1},
	{ 1,-1,-1},{ 1,-1, 1},
	{ 1, 1,-1},{ 1, 1, 1}};
  int LC3[12][2] =
   {{1,2},{1,3},{2,4},{3,4},
	{1,5},{2,6},{3,7},{4,8},
	{5,6},{5,7},{6,8},{7,8}};
  int PC3[6][4] =
   {{1,2,4,3},{1,5,6,2},{1,3,7,5},
	{3,4,8,7},{2,6,8,4},{5,7,8,6}};
 // * �����p-3 *
  int O3[6][3] =
   {{ 1, 0, 0},{-1, 0, 0},
	{ 0, 1, 0},{-0,-1, 0},
	{ 0, 0, 1},{-0, 0,-1}};
  int LO3[12][2] =
   {{ 1, 3},{ 1, 4},{ 1, 5},{ 1, 6},
	{ 2, 3},{ 2, 4},{ 2, 5},{ 2, 6},
	{ 3, 5},{ 3, 6},{ 4, 5},{ 4, 6}};
  int PO3[8][3] =
   {{1,6,4},{1,4,5},{1,5,3},{2,5,4},
	{3,5,2},{2,4,6},{1,3,6},{2,6,3}};
 // * ��p�����-4 *
  int T4[5][5] =
   {{ 1, 1, 1, 1,-4},
	{ 1, 1, 1,-4, 1},
	{ 1, 1,-4, 1, 1},
	{ 1,-4, 1, 1, 1},
	{-4, 1, 1, 1, 1}};
  int LT4[10][2] =
   {{1,2},{1,3},{2,3},{2,4},{3,4},
	{3,5},{4,5},{4,1},{5,1},{5,2}};
  int PT4[4][3] = {{1,2,3},{1,3,4},{1,4,2},{2,4,3}};
 // * �����p-4 *
  int O4[8][4] =
   {{ 1, 0, 0, 0},{-1, 0, 0, 0},
	{ 0, 1, 0, 0},{ 0,-1, 0, 0},
	{ 0, 0, 1, 0},{ 0, 0,-1, 0},
	{ 0, 0, 0, 1},{ 0, 0, 0,-1}};
  int LO4[24][2] =
   {{ 1, 3},{ 1, 4},{ 1, 5},{ 1, 6},{ 1, 7},{ 1, 8},
	{ 2, 3},{ 2, 4},{ 2, 5},{ 2, 6},{ 2, 7},{ 2, 8},
	{ 3, 5},{ 3, 6},{ 3, 7},{ 3, 8},{ 4, 5},{ 7, 6},
	{ 4, 6},{ 4, 7},{ 4, 8},{ 5, 7},{ 5, 8},{ 6, 8}};
  int PO4[8][3] =
   {{1,6,4},{1,4,5},{1,5,3},{2,5,4},
	{3,5,2},{2,4,6},{1,3,6},{2,6,3}};
 // * 24-�祩�� *
  int L4[24][4] =
   {{ 1, 1, 0, 0},{ 1,-1, 0, 0},
	{ 1, 0, 1, 0},{ 1, 0,-1, 0},
	{ 1, 0, 0, 1},{ 1, 0, 0,-1},
	{-1, 1, 0, 0},{-1,-1, 0, 0},
	{-1, 0, 1, 0},{-1, 0,-1, 0},
	{-1, 0, 0, 1},{-1, 0, 0,-1},
	{ 0, 1, 1, 0},{ 0, 1,-1, 0},
	{ 0, 1, 0, 1},{ 0, 1, 0,-1},
	{ 0, 0, 1, 1},{ 0, 0, 1,-1},
	{ 0,-1, 1, 0},{ 0,-1,-1, 0},
	{ 0,-1, 0, 1},{ 0,-1, 0,-1},
	{ 0, 0,-1, 1},{ 0, 0,-1,-1}};
  int LL4[96][2] =
   {{ 1, 3},{ 1, 4},{ 1, 5},{ 1, 6},{ 1,13},
	{ 1,14},{ 1,15},{ 1,16},{ 2, 3},{ 2, 4},
	{ 2, 5},{ 2, 6},{ 2,19},{ 2,20},{ 2,21},
	{ 2,22},{ 3, 5},{ 3, 6},{ 3,13},{ 3,17},
	{ 3,18},{ 3,19},{ 4, 5},{ 4, 6},{ 4,14},
	{ 4,20},{ 4,23},{ 4,24},{ 5,15},{ 5,17},
	{ 5,21},{ 5,23},{ 6,16},{ 6,18},{ 6,22},
	{ 6,24},{ 7, 9},{ 7,10},{ 7,11},{ 7,12},
	{ 7,13},{ 7,14},{ 7,15},{ 7,16},{ 8, 9},
	{ 8,10},{ 8,11},{ 8,12},{ 8,19},{ 8,20},
	{ 8,21},{ 8,22},{ 9,11},{ 9,12},{ 9,13},
	{ 9,17},{ 9,18},{ 9,19},{10,11},{10,12},
	{10,14},{10,20},{10,23},{10,24},{11,15},
	{11,17},{11,21},{11,23},{12,16},{12,18},
	{12,22},{12,24},{13,15},{13,16},{13,17},
	{13,18},{14,15},{14,16},{14,23},{14,24},
	{15,17},{15,23},{16,18},{16,24},{17,19},
	{17,21},{18,19},{18,22},{19,21},{19,22},
	{20,21},{20,22},{20,23},{20,24},{21,23},
	{22,24}};
  int PL4[8][3] =
   {{1,6,4},{1,4,5},{1,5,3},{2,5,4},
	{3,5,2},{2,4,6},{1,3,6},{2,6,3}};
 // * �㡨�-4 *
  int C4[16][4] =
   {{-1,-1,-1,-1},{-1,-1, 1,-1},
	{-1, 1,-1,-1},{-1, 1, 1,-1},
	{ 1,-1,-1,-1},{ 1,-1, 1,-1},
	{ 1, 1,-1,-1},{ 1, 1, 1,-1},
	{-1,-1,-1, 1},{-1,-1, 1, 1},
	{-1, 1,-1, 1},{-1, 1, 1, 1},
	{ 1,-1,-1, 1},{ 1,-1, 1, 1},
	{ 1, 1,-1, 1},{ 1, 1, 1, 1}};
  int LC4[32][2] =
   {{ 1, 2},{ 1, 3},{ 2, 4},{ 3, 4},
	{ 1, 5},{ 2, 6},{ 3, 7},{ 4, 8},
	{ 5, 6},{ 5, 7},{ 6, 8},{ 7, 8},
	{ 1, 9},{ 2,10},{ 3,11},{ 4,12},
	{ 5,13},{ 6,14},{ 7,15},{ 8,16},
	{ 9,10},{ 9,11},{10,12},{11,12},
	{ 9,13},{10,14},{11,15},{12,16},
	{13,14},{13,15},{14,16},{15,16}};
  int PC4[6][4] =
   {{1,2,4,3},{1,5,6,2},{1,3,7,5},
	{3,4,8,7},{4,2,6,8},{5,7,8,6}};
 // * �㡨�-5 *
  int C5[32][5] =
   {{-1,-1,-1,-1,-1},{-1,-1,-1,-1, 1},
	{-1,-1,-1, 1,-1},{-1,-1,-1, 1, 1},
	{-1,-1, 1,-1,-1},{-1,-1, 1,-1, 1},
	{-1,-1, 1, 1,-1},{-1,-1, 1, 1, 1},
	{-1, 1,-1,-1,-1},{-1, 1,-1,-1, 1},
	{-1, 1,-1, 1,-1},{-1, 1,-1, 1, 1},
	{-1, 1, 1,-1,-1},{-1, 1, 1,-1, 1},
	{-1, 1, 1, 1,-1},{-1, 1, 1, 1, 1},
	{ 1,-1,-1,-1,-1},{ 1,-1,-1,-1, 1},
	{ 1,-1,-1, 1,-1},{ 1,-1,-1, 1, 1},
	{ 1,-1, 1,-1,-1},{ 1,-1, 1,-1, 1},
	{ 1,-1, 1, 1,-1},{ 1,-1, 1, 1, 1},
	{ 1, 1,-1,-1,-1},{ 1, 1,-1,-1, 1},
	{ 1, 1,-1, 1,-1},{ 1, 1,-1, 1, 1},
	{ 1, 1, 1,-1,-1},{ 1, 1, 1,-1, 1},
	{ 1, 1, 1, 1,-1},{ 1, 1, 1, 1, 1}};
  int LC5[80][2] =
   {{ 1, 2},{ 1, 3},{ 1, 5},{ 1, 9},{ 1,17},
	{ 2, 4},{ 2, 6},{ 2,10},{ 2,18},{ 3, 4},
	{ 3, 7},{ 3,11},{ 3,19},{ 4, 8},{ 4,12},
	{ 4,20},{ 5, 6},{ 5, 7},{ 5,13},{ 5,21},
	{ 6, 8},{ 6,14},{ 6,22},{ 7, 8},{ 7,15},
	{ 7,23},{ 8,16},{ 8,24},{ 9,10},{ 9,11},
	{ 9,13},{ 9,25},{10,12},{10,14},{10,26},
	{11,12},{11,15},{11,27},{12,16},{12,28},
	{13,14},{13,15},{13,29},{14,16},{14,30},
	{15,16},{15,31},{16,32},{17,18},{17,19},
	{17,21},{17,25},{18,20},{18,22},{18,26},
	{19,20},{19,23},{19,27},{20,24},{20,28},
	{21,22},{21,23},{21,29},{22,24},{22,30},
	{23,24},{23,31},{24,32},{25,26},{25,27},
	{25,29},{26,28},{26,30},{27,28},{27,31},
	{28,32},{29,30},{29,31},{30,32},{31,32}};
  int PC5[6][4] =
   {{1,2,4,3},{1,5,6,2},{1,3,7,5},
	{3,4,8,7},{2,6,8,4},{5,7,8,6}};
 // * �㡨�-6 *
  int C6[64][6] =
   {{-1,-1,-1,-1,-1,-1},{-1,-1,-1,-1,-1, 1},
	{-1,-1,-1,-1, 1,-1},{-1,-1,-1,-1, 1, 1},
	{-1,-1,-1, 1,-1,-1},{-1,-1,-1, 1,-1, 1},
	{-1,-1,-1, 1, 1,-1},{-1,-1,-1, 1, 1, 1},
	{-1,-1, 1,-1,-1,-1},{-1,-1, 1,-1,-1, 1},
	{-1,-1, 1,-1, 1,-1},{-1,-1, 1,-1, 1, 1},
	{-1,-1, 1, 1,-1,-1},{-1,-1, 1, 1,-1, 1},
	{-1,-1, 1, 1, 1,-1},{-1,-1, 1, 1, 1, 1},
	{-1, 1,-1,-1,-1,-1},{-1, 1,-1,-1,-1, 1},
	{-1, 1,-1,-1, 1,-1},{-1, 1,-1,-1, 1, 1},
	{-1, 1,-1, 1,-1,-1},{-1, 1,-1, 1,-1, 1},
	{-1, 1,-1, 1, 1,-1},{-1, 1,-1, 1, 1, 1},
	{-1, 1, 1,-1,-1,-1},{-1, 1, 1,-1,-1, 1},
	{-1, 1, 1,-1, 1,-1},{-1, 1, 1,-1, 1, 1},
	{-1, 1, 1, 1,-1,-1},{-1, 1, 1, 1,-1, 1},
	{-1, 1, 1, 1, 1,-1},{-1, 1, 1, 1, 1, 1},
	{ 1,-1,-1,-1,-1,-1},{ 1,-1,-1,-1,-1, 1},
	{ 1,-1,-1,-1, 1,-1},{ 1,-1,-1,-1, 1, 1},
	{ 1,-1,-1, 1,-1,-1},{ 1,-1,-1, 1,-1, 1},
	{ 1,-1,-1, 1, 1,-1},{ 1,-1,-1, 1, 1, 1},
	{ 1,-1, 1,-1,-1,-1},{ 1,-1, 1,-1,-1, 1},
	{ 1,-1, 1,-1, 1,-1},{ 1,-1, 1,-1, 1, 1},
	{ 1,-1, 1, 1,-1,-1},{ 1,-1, 1, 1,-1, 1},
	{ 1,-1, 1, 1, 1,-1},{ 1,-1, 1, 1, 1, 1},
	{ 1, 1,-1,-1,-1,-1},{ 1, 1,-1,-1,-1, 1},
	{ 1, 1,-1,-1, 1,-1},{ 1, 1,-1,-1, 1, 1},
	{ 1, 1,-1, 1,-1,-1},{ 1, 1,-1, 1,-1, 1},
	{ 1, 1,-1, 1, 1,-1},{ 1, 1,-1, 1, 1, 1},
	{ 1, 1, 1,-1,-1,-1},{ 1, 1, 1,-1,-1, 1},
	{ 1, 1, 1,-1, 1,-1},{ 1, 1, 1,-1, 1, 1},
	{ 1, 1, 1, 1,-1,-1},{ 1, 1, 1, 1,-1, 1},
	{ 1, 1, 1, 1, 1,-1},{ 1, 1, 1, 1, 1, 1}};
  int LC6[192][2] =
   {{ 1, 2},{ 1, 3},{ 1, 5},{ 1, 9},{ 1,17},{ 1,33},
	{ 2, 4},{ 2, 6},{ 2,10},{ 2,18},{ 2,34},{ 3, 4},
	{ 3, 7},{ 3,11},{ 3,19},{ 3,35},{ 4, 8},{ 4,12},
	{ 4,20},{ 4,36},{ 5, 6},{ 5, 7},{ 5,13},{ 5,21},
	{ 5,37},{ 6, 8},{ 6,14},{ 6,22},{ 6,38},{ 7, 8},
	{ 7,15},{ 7,23},{ 7,39},{ 8,16},{ 8,24},{ 8,40},
	{ 9,10},{ 9,11},{ 9,13},{ 9,25},{ 9,41},{10,12},
	{10,14},{10,26},{10,42},{11,12},{11,15},{11,27},
	{11,43},{12,16},{12,28},{12,44},{13,14},{13,15},
	{13,29},{13,45},{14,16},{14,30},{14,46},{15,16},
	{15,31},{15,47},{16,32},{16,48},{17,18},{17,19},
	{17,21},{17,25},{17,49},{18,20},{18,22},{18,26},
	{18,50},{19,20},{19,23},{19,27},{19,51},{20,24},
	{20,28},{20,52},{21,22},{21,23},{21,29},{21,53},
	{22,24},{22,30},{22,54},{23,24},{23,31},{23,55},
	{24,32},{24,56},{25,26},{25,27},{25,29},{25,57},
	{26,28},{26,30},{26,58},{27,28},{27,31},{27,59},
	{28,32},{28,60},{29,30},{29,31},{29,61},{30,32},
	{30,62},{31,32},{31,63},{32,64},{33,34},{33,35},
	{33,37},{33,41},{33,49},{34,36},{34,38},{34,42},
	{34,50},{35,36},{35,39},{35,43},{35,51},{36,40},
	{36,44},{36,52},{37,38},{37,39},{37,45},{37,53},
	{38,40},{38,46},{38,54},{39,40},{39,47},{39,55},
	{40,48},{40,56},{41,42},{41,43},{41,45},{41,57},
	{42,44},{42,46},{42,58},{43,44},{43,47},{43,59},
	{44,48},{44,60},{45,46},{45,47},{45,61},{46,48},
	{46,62},{47,48},{47,63},{48,64},{49,50},{49,51},
	{49,53},{49,57},{50,52},{50,54},{50,58},{51,52},
	{51,55},{51,59},{52,56},{52,60},{53,54},{53,55},
	{53,61},{54,56},{54,62},{55,56},{55,63},{56,64},
	{57,58},{57,59},{57,61},{58,60},{58,62},{59,60},
	{59,63},{60,64},{61,62},{61,63},{62,64},{63,64}};
  int PC6[6][4] =
   {{1,2,4,3},{1,5,6,2},{1,3,7,5},
	{8,7,3,4},{2,6,8,4},{5,7,8,6}};
 // * ������� - 3 *
  int I3[20][3];
  int LI3[30][2] =
   {{ 1, 2},{ 1, 3},{ 1, 4},{ 1, 5},{ 1, 6},
	{ 6,11},{ 2,11},{ 2, 7},{ 7, 3},{ 3, 8},
	{ 8, 4},{ 4, 9},{ 9, 5},{ 5,10},{10, 6},
	{ 2, 3},{ 3, 4},{ 4, 5},{ 5, 6},{ 6, 2},
	{ 7, 8},{ 8, 9},{ 9,10},{10,11},{11, 7},
	{12, 7},{12, 8},{12, 9},{12,10},{12,11}};
  int PI3[20][3] =
   {{ 3, 2, 1},{ 4, 3, 1},{ 5, 4, 1},{ 6, 5, 1},{ 2, 6, 1},
	{ 6, 2,11},{11, 2, 7},{ 3, 7, 2},{ 7, 3, 8},{ 4, 8, 3},
	{ 8, 4, 9},{ 5, 9, 4},{ 9, 5,10},{ 6,10, 5},{10, 6,11},
	{12, 7, 8},{12, 8, 9},{12, 9,10},{12,10,11},{12,11, 7}};

class figure{
  void SetPages( int P1,int P2 ){
	setactivepage(P1);
	setvisualpage(P2);
  };
 // ����஥��� ������� 3D
  void BuildI3(){
	int i; float Tau,r;
	Tau=(1+sqrt(5))/2;
	r=Tau-0.5;
	for (i=0;i<5;i++){
	  I3[i+1][0] = int(20*cos(i*pi/2.5));
	  I3[i+1][1] = int(20*sin(i*pi/2.5));
	  I3[i+1][2] = +10;
	  I3[i+6][0] = int(20*cos((i+0.5)*pi/2.5));
	  I3[i+6][1] = int(20*sin((i+0.5)*pi/2.5));
	  I3[i+6][2] = -10;
	};
	I3[0][0]  = 0;
	I3[0][1]  = 0;
	I3[0][2]  = int(20*r);
	I3[11][0] = 0;
	I3[11][1] = 0;
	I3[11][2] = -int(20*r);
  };
 // Geometry Program
  void Rotate_Vect( int num ){
	int i,j;
	TP Y;
	for (i=0;i<MaxDimSpace;i++) Y[i]=0;
	for (i=0;i<DimSpace;i++)
	  for (j=0;j<DimSpace;j++)
		Y[i]=Y[i] + Rotate[i][j] * W[num][j];
	for (i=0;i<DimSpace;i++) W[num][i]=Y[i];
  }

  void Rotate_Comp( int n, int m, float a ){
	float ca,sa;
	int j,i;
	for (i=0;i<MaxDimSpace;i++)
	  for (j=0;j<MaxDimSpace;j++)
		Rotate[i][j]=0;
	for(i=0;i<DimSpace;i++)
	  Rotate[i][i]=1;
	sa=sin(2*pi*a); ca=cos(2*pi*a);
	Rotate[n-1][n-1] = ca; Rotate[n-1][m-1] = -sa;
	Rotate[m-1][n-1] = sa; Rotate[m-1][m-1] = ca;
	for (i=0;i<DimNods;i++)
	  Rotate_Vect(i);
  };

  int XC( TP T ){
	return (int)(x0+Dx*T[0]);
  };

  int YC( TP T ){
	return (int)(y0+Dy*T[1]);
  };

  void ShowLoops( int Ind ){
	int i,j;
	for (i=0;i<DimLoops;i++)
	  for (j=0;j<2;j++)
		switch (Ind) {
		  case 0: Loops[i][j]=LT3[i][j]; break;
		  case 1: Loops[i][j]=LC3[i][j]; break;
		  case 2: Loops[i][j]=LO3[i][j]; break;
		  case 3: Loops[i][j]=LT4[i][j]; break;
		  case 4: Loops[i][j]=LO4[i][j]; break;
		  case 5: Loops[i][j]=LL4[i][j]; break;
		  case 6: Loops[i][j]=LC4[i][j]; break;
		  case 7: Loops[i][j]=LC5[i][j]; break;
		  case 8: Loops[i][j]=LC6[i][j]; break;
		  case 9: Loops[i][j]=LI3[i][j]; break;
	   };
	for (i=0;i<DimLoops;i++)
	  line( XC(W[Loops[i][0]-1]),YC(W[Loops[i][0]-1]),
			XC(W[Loops[i][1]-1]),YC(W[Loops[i][1]-1]));
  };

  void ShowNamb(){
	char st[2] = "1";
	for (int i=0;i<DimNods;i++){
	  st[0]=Mask[i];
	  outtextxy( XC(W[i])-10,YC(W[i])-8,st);
	};
  };

  // Planes
  float Minor2( int p1,int p2 ){
	return  W[p1-1][0]*W[p2-1][1]-W[p2-1][0]*W[p1-1][1];
  };
  float Area( int p1,int p2,int p3 ){
	return (Minor2(p2,p3)+Minor2(p3,p1)+Minor2(p1,p2))/2;
  };
  void ShowTr( int p1,int p2,int p3 ){
	int Triangle[6] =
	  { XC(W[p1-1]), YC(W[p1-1]),
		XC(W[p2-1]), YC(W[p2-1]),
		XC(W[p3-1]), YC(W[p3-1]) };
	fillpoly(sizeof(Triangle)/sizeof(pointtype),Triangle);
  };
  void ShowSq( int p1,int p2,int p3,int p4 ){
	int Square[8] =
	  { XC(W[p1-1]), YC(W[p1-1]), XC(W[p2-1]), YC(W[p2-1]),
		XC(W[p3-1]), YC(W[p3-1]), XC(W[p4-1]), YC(W[p4-1]) };
	fillpoly(sizeof(Square)/sizeof(pointtype),Square);
  };
  void ShowPlanes( int Ind ){
	int i,k; float r; TP P;
	for (k=0;k<DimPlanes;k++){
	  switch (Ind){
		case 0: r=Area(PT3[k][0],PT3[k][1],PT3[k][2]); break;
		case 1: r=Area(PC3[k][0],PC3[k][1],PC3[k][2]); break;
		case 2: r=Area(PO3[k][0],PO3[k][1],PO3[k][2]); break;
		case 3: r=Area(PT4[k][0],PT4[k][1],PT4[k][2]); break;
		case 4: r=Area(PO4[k][0],PO4[k][1],PO4[k][2]); break;
		case 5: r=Area(PL4[k][0],PL4[k][1],PL4[k][2]); break;
		case 6: r=Area(PC4[k][0],PC4[k][1],PC4[k][2]); break;
		case 7: r=Area(PC5[k][0],PC5[k][1],PC5[k][2]); break;
		case 8: r=Area(PC6[k][0],PC6[k][1],PC6[k][2]); break;
		case 9: r=Area(PI3[k][0],PI3[k][1],PI3[k][2]); break;
	  };
	  setfillstyle(1,(k%6)+1);
  //	SetFillPattern(Paterns[k], Green);
	  if (r>0)
		switch (Ind) {
		  case 0: ShowTr(PT3[k][0],PT3[k][1],PT3[k][2]); break;
		  case 1: ShowSq(PC3[k][0],PC3[k][1],PC3[k][2],PC3[k][3]); break;
		  case 2: ShowTr(PO3[k][0],PO3[k][1],PO3[k][2]); break;
		  case 3: ShowTr(PT4[k][0],PT4[k][1],PT4[k][2]); break;
		  case 4: ShowTr(PO4[k][0],PO4[k][1],PO4[k][2]); break;
		  case 5: ShowTr(PL4[k][0],PL4[k][1],PL4[k][2]); break;
		  case 6: ShowSq(PC4[k][0],PC4[k][1],PC4[k][2],PC4[k][3]); break;
		  case 7: ShowSq(PC5[k][0],PC5[k][1],PC5[k][2],PC5[k][3]); break;
		  case 8: ShowSq(PC6[k][0],PC6[k][1],PC6[k][2],PC6[k][3]); break;
		  case 9: ShowTr(PI3[k][0],PI3[k][1],PI3[k][2]);
		};
	};
  };
 public:
  int x0,y0;
  figure(){ BuildI3(); };
 // Subroutines
  void InitData( int Ind ){
	int i,j;
	int Xasp,Yasp;
	getaspectratio(&Xasp,&Yasp);
	DimSpace  = DS[Ind];
	DimNods   = DN[Ind];
	DimLoops  = DL[Ind];
	DimPlanes = DP[Ind];
	for (i=0;i<MaxDimSpace;i++)
	  for (j=0;j<MaxDimNods;j++)
		W[i][j]=0;
	for (j=0;j<DimSpace;j++)
	  for (i=0;i<DimNods;i++)
		switch (Ind){
		  case 0: W[i][j]=T3[i][j]; break;
		  case 1: W[i][j]=C3[i][j]; break;
		  case 2: W[i][j]=O3[i][j]; break;
		  case 3: W[i][j]=T4[i][j]; break;
		  case 4: W[i][j]=O4[i][j]; break;
		  case 5: W[i][j]=L4[i][j]; break;
		  case 6: W[i][j]=C4[i][j]; break;
		  case 7: W[i][j]=C5[i][j]; break;
		  case 8: W[i][j]=C6[i][j]; break;
		  case 9: W[i][j]=I3[i][j]; break;
		};
	Dx=Disp[Ind];
	Dy=((float)Xasp*Disp[Ind])/Yasp;
  };

  void MakeMove( int Ind ){
	int n,Page;
	char Ch;
	float Angle = 3/DimAngle;
	Page=0; SetPages(Page,1-Page);
	while (!kbhit()){
	  for (n=0;n<4;n++)
		Rotate_Comp(TX[Ind][n],TY[Ind][n],TR[Ind][n]);
	  clearviewport();
	  ShowLoops(Ind);
	  ShowPlanes(Ind);
	  ShowNamb();
	  Page=1-Page; SetPages(Page,1-Page);
	};
	while(kbhit()) getch();
	clearviewport();
  };

};

// - Main -
class applet{
  figure Figure;
  int Complex;
  void OpenEGAHi(){
	int Driver=VGA,Mode=EGAHI;
	initgraph(&Driver,&Mode,"");
	Figure.x0=getmaxx()/2; Figure.y0=getmaxy()/2;
  };
 public:
  void run(){
	Complex = 4;
	OpenEGAHi();
	Figure.InitData(Complex);
	Figure.MakeMove(Complex);
	getch();
	closegraph();
  };
};

void main(){
  applet Applet;
  Applet.run();
};