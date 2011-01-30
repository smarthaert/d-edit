package pdd;

import java.awt.*;
import java.math.*;
import java.util.*;

//Класс данных
class data {
  static int nt=0;
  static Panel cardsPanel1;
  static CardLayout cards1;
  static Panel cardsPanel0;
  static CardLayout cards0;
  static boolean izobr=true;
  static Scene scenes[] = new Scene[c.numScenes0];
  static Image images[] = new Image[c.numImages];
  static FonIm fonIm[] = new FonIm[c.numScenes];
  static int sizes[] = {1,10};
  static Camera cam;
  static int frames=0;
  static int frames0=0;
  static long time=System.currentTimeMillis();
  static Image offImage;                   //Вторая видеостраница
  static Graphics gc;                      //Полотно видеостраницы
  static Random r = new Random();
  static int cursor=300;
  static int currScene=0;
  static int colorSveto;
  static long timer=0;
  static int mesto=0;
  static int status=0;
  static int faza=0;
  static Car3 cars[] = new Car3[c.maxCars];
  static Human123 humans[] = new Human123[c.maxHumans];
  static long startTime;
  static String text="";
  static Color col;
  static String text2="";
  static Elem0 elem[];
  static Scene3 scene3;
  static int pravila[][] = {
    {4,1,1,0},
    {1,1,1,0},
    {2,1,1,0},
    {1,2,1,0},
    {2,2,1,0},
    {3,1,2,1},
    {3,2,2,3},
    {4,2,2,3}        //NumRules=8
  };
  static int type;
  static int aktiv=0;
  static int colAktiv=0;
  static int t1, v1, t2, v2;
  static boolean save=false;
  static long timeMove;
  static int moveFaza=0;
  static int html[];
  static Image human[];
  static Image dog[];
  static Image dog2[];
  static int timeHuman=0;
  static int fazaHuman=0;
  static int timeDog=0;
  static int fazaDog=0;
  static double speedHuman=2;
  static double lastSpeedHuman=0;
  static int realX;
  static hero heros[];
  static boolean turbo=false;
  static Image human3d[] = new Image[6];
  static Image human3d2[] = new Image[6];
  static boolean resheno=false;
  static boolean pusk=false;
  static boolean pusto=false;
  static String o0="", o1="";
}

class hero {
  double width;
  double height;
  double speed;
  double pause;
  Image im[];
}

class group {
  int aaa[] = new int[4];
}

class Elem0 {
  Image el[];
  Elem0(int i) {
    el = new Image[i];
  }
}

class FonIm {
  Image Im[];
  FonIm(int i) {
    Im = new Image[i];
  }
}

//Класс функций
class f {
  static void setNt(int t, int v1, int v2) {
    int res=t*100;
    v1--;
    switch(t) {
      case(1): {res+=2*v1; break;}
      case(2): {res+=2*v1; break;}
      case(3): {res+=3*v1; break;}
      case(4): {res+=2*v1; break;}
      case(5): {res+=3*v1; break;}
      default: res+=3*v1;
    }
    data.nt=res+v2;
  }
  static void prichina() {
    boolean ok=false;
    if ((data.status>2)&&(data.colorSveto>2)) data.text="Вы пошли на запрещенный свет!";
    else if ((data.status>2)&&(data.colorSveto==2)&&(data.mesto==1)) data.text="Нельзя начинать идти на желтый!";
    else if ((data.status<=2)&&(data.colorSveto<=2)&&(data.mesto==0)) data.text="Нельзя оставаться посреди дороги!";
    else if ((data.status<=2)&&(data.colorSveto<=1)) data.text="Надо переходить дорогу!";
    else if ((data.status>3)&&(data.mesto==1)) data.text="Надо смотреть влево!";
    else if ((data.status>2)&&(data.status<5)&&(data.mesto==0)) data.text="Надо смотреть вправо!";
    else {
      ok=true;
      if (data.status<=2) data.text="ПОЗДРАВЛЯЮ! Вы остались живы!";
      else data.text="ПОЗДРАВЛЯЮ! Вы перешли дорогу!";
    }
  }
/*  static boolean testCar(int x, int y) {
    boolean res=false;
    for(int i=0; (i<data.cars.length)&&(!res); i++) {
      if ((data.cars[i].x==x)&&(data.cars[i].y==y)) res=true;
    }
    return res;
  }
  static boolean testCar2(int x0, int y0, int dx, int dy) {
    boolean res=false;
    if (dx==0) {
      int step = (Math.abs(dy))/dy;
      for(int y=y0+step; (Math.abs(y-y0)<Math.abs(dy))&&(!res) ; y+=step) {
        if (testCar(x0,y)) res=true;
      }
    }
    else {
      int step = (Math.abs(dx))/dx;
      for(int x=x0+step; (Math.abs(x-x0)<Math.abs(dx))&&(!res) ; x+=step) {
        if (testCar(x,y0)) res=true;
      }
    }
    return res;
  }
  static boolean testCar3(int x0, int y0, int dx, int dy, int d) {
    boolean res=false;
    if (dx==0) {
      for(int x=x0-d; (x<=x0+d)&&(!res); x++) {
        if (testCar2(x, y0, dx, dy)) res=true;
      }
    }
    else {
      for(int y=y0-d; (y<=y0+d)&&(!res); y++) {
        if (testCar2(x0, y, dx, dy)) res=true;
      }
    }
    return res;
  }
*/
  static boolean testPlace(int x0, int y0, int dx, int dy) {
    boolean res=false;
    for(int i=0; (i<data.cars.length)&&(!res); i++) {
      if ((data.cars[i].x>=x0)&&(data.cars[i].x<=(x0+dx))&&(data.cars[i].y>=y0)&&(data.cars[i].y<=(y0+dy))) res=true;
    }
    int t;
    if (data.currScene!=2) t=data.humans.length;
    else t=1;
    for(int i=0; (i<t)&&(!res); i++) {
      if ((data.humans[i].x>=x0)&&(data.humans[i].x<=(x0+dx))&&(data.humans[i].y>=y0)&&(data.humans[i].y<=(y0+dy))) res=true;
    }
    return res;
  }

  static Point3d trans(Point3d p0, Camera cam, Dimension d) {
    double tx=p0.x*Math.cos(cam.a1)-p0.y*Math.sin(cam.a1);
    double ty=p0.x*Math.sin(cam.a1)+p0.y*Math.cos(cam.a1);
    double tz=p0.z;
    double tx2=tx;
    double ty2=ty*Math.cos(cam.a2)-tz*Math.sin(cam.a2);
    double tz2=ty*Math.sin(cam.a2)+tz*Math.cos(cam.a2)+cam.b;
    Point3d p = new Point3d();
    p.x=(int)((600*tx2*cam.focusX/tz2)+d.width/2);   //?????
    p.y=(int)((400*ty2*cam.focusY/tz2)+d.height/2);  //????
    p.z=(int)(tz2);
    return p;
  }

  static String elToText(element el0, boolean b) {
    if (!b) {
      if ((el0.type==0)&&(el0.value==0)) return("ЛЮБОЙ свет");
      if ((el0.type==0)&&(el0.value==1)) return("горит красный свет");
      if ((el0.type==0)&&(el0.value==2)) return("горит красно-желтый свет");
      if ((el0.type==0)&&(el0.value==3)) return("горит зеленый свет");
      if ((el0.type==0)&&(el0.value==4)) return("горит желтый свет");
      if ((el0.type==1)&&(el0.value==0)) return("ЛЮБОЕ положение на переходе");
      if ((el0.type==1)&&(el0.value==1)) return("пешеход в начале перехода");
      if ((el0.type==1)&&(el0.value==2)) return("пешеход посредине перехода");
      if ((el0.type==2)&&(el0.value==0)) return("ЛЮБОЕ состояние (идти, стоять)");
      if ((el0.type==2)&&(el0.value==1)) return("пешеход стоит");
      if ((el0.type==2)&&(el0.value==2)) return("пешеход идет");
      if ((el0.type==3)&&(el0.value==0)) return("ЛЮБОЕ положение головы");
      if ((el0.type==3)&&(el0.value==1)) return("пешеход смотрит влево");
      if ((el0.type==3)&&(el0.value==2)) return("пешеход смотрит прямо");
      if ((el0.type==3)&&(el0.value==3)) return("пешеход смотрит вправо");
      return("БРЕД КАКОЙ-ТО");
    }
    else {
      if ((el0.type==0)&&(el0.value==0)) return("ЛЮБОЙ свет");
      if ((el0.type==0)&&(el0.value==1)) return("Горит красный свет");
      if ((el0.type==0)&&(el0.value==2)) return("Горит красно-желтый свет");
      if ((el0.type==0)&&(el0.value==3)) return("Горит зеленый свет");
      if ((el0.type==0)&&(el0.value==4)) return("Горит желтый свет");
      if ((el0.type==1)&&(el0.value==0)) return("ЛЮБОЕ положение на переходе");
      if ((el0.type==1)&&(el0.value==1)) return("Пешеход в начале перехода");
      if ((el0.type==1)&&(el0.value==2)) return("Пешеход посредине перехода");
      if ((el0.type==2)&&(el0.value==0)) return("ЛЮБОЕ состояние (идти, стоять)");
      if ((el0.type==2)&&(el0.value==1)) return("Пешеход стоит");
      if ((el0.type==2)&&(el0.value==2)) return("Пешеход идет");
      if ((el0.type==3)&&(el0.value==0)) return("ЛЮБОЕ положение головы");
      if ((el0.type==3)&&(el0.value==1)) return("Пешеход смотрит влево");
      if ((el0.type==3)&&(el0.value==2)) return("Пешеход смотрит прямо");
      if ((el0.type==3)&&(el0.value==3)) return("Пешеход смотрит вправо");
      return("БРЕД КАКОЙ-ТО");
    }
  }
  static void setAktiv(int n) {
    data.aktiv=n;
    int zx[] = new int[4];
    And2 a = (And2)data.scene3.l.left.v.firstElement();
    zx[a.el1.type]=a.el1.value;
    zx[a.el2.type]=a.el2.value;
    if (n!=999) {
      a = (And2)data.scene3.l.right.v.elementAt(n);
      zx[a.el1.type]=a.el1.value;
      zx[a.el2.type]=a.el2.value;
      if ((a.el1.value==0)||(a.el2.value==0)) {
        data.izobr=false;
        if ((a.el1.value==0)&&(a.el2.value==0)) data.pusto=true;
        else {
          data.pusto=false;
          data.o0=elToText(a.el1,true)+",";
          data.o1=elToText(a.el2,false)+".";
        }
        return;
      }
    }
    else {
      zx[data.t1]=data.v1;
      zx[data.t2]=data.v2;
    }
    switch(zx[0]) {
      case(1): {data.colorSveto=3; break; }
      case(2): {data.colorSveto=5; break; }
      case(3): {data.colorSveto=0; break; }
      case(4): {data.colorSveto=2; break; }
    }
    if (zx[1]==1) data.mesto=1;
    else data.mesto=0;
    if (zx[2]==1) data.status=0;
    else data.status=3;
    data.status+=zx[3]-1;
    data.izobr=true;
  }
  static void setSveto() {
    element a;
    if (((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el1.type==0) a=((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el1;
    else a=((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el2;
    switch(data.colorSveto) {
      case(0): { a.value=3; break;}
      case(2): { a.value=4; break;}
      case(3): { a.value=1; break;}
      case(5): { a.value=2; break;}
    }
  }
  static void setHuman() {
    element a=((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el1;
    switch(a.type) {
      case(1): { if (data.mesto==1) a.value=1; else a.value=2; break;}
      case(2): { if (data.status<=2) a.value=1; else a.value=2; break;}
      case(3): { a.value=data.status%3+1; break;}
    }
    a=((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el2;
    switch(a.type) {
      case(1): { if (data.mesto==1) a.value=1; else a.value=2; break;}
      case(2): { if (data.status<=2) a.value=1; else a.value=2; break;}
      case(3): { a.value=data.status%3+1; break;}
    }
  }
  static void gen_new() {
          element t1 = ((And2)data.scene3.l.left.v.elementAt(0)).el1;
          data.status=0;
          switch(t1.type) {
            case(0): {
              switch(t1.value) {
                case(1): {data.colorSveto=3 ;break; }
                case(2): {data.colorSveto=5 ;break; }
                case(3): {data.colorSveto=0 ;break; }
                case(4): {data.colorSveto=2 ;break; }
              }
              break;
            }
            case(1): { if (t1.value==1) data.mesto=1; else data.mesto=0; break;}
            case(2): { data.status=data.status%3+3*(t1.value-1); break;}
            case(3): { data.status=data.status/3*3+t1.value-1; break;}
          }
          element t2 = ((And2)data.scene3.l.left.v.elementAt(0)).el2;
          switch(t2.type) {
            case(0): {
              switch(t2.value) {
                case(1): {data.colorSveto=3 ;break; }
                case(2): {data.colorSveto=5 ;break; }
                case(3): {data.colorSveto=0 ;break; }
                case(4): {data.colorSveto=2 ;break; }
              }
              break;
            }
            case(1): { if (t2.value==1) data.mesto=1; else data.mesto=0; break;}
            case(2): { data.status=data.status%3+3*(t2.value-1); break;}
            case(3): { data.status=data.status/3*3+t2.value-1; break;}
          }
          if ((t1.type!=0)&&(t2.type!=0)) {
            do {
              data.colorSveto=Math.abs(data.r.nextInt()%6);
            }
            while ((data.colorSveto==1)||(data.colorSveto==4));
          }
          if ((t1.type!=1)&&(t2.type!=1)) data.mesto=Math.abs(data.r.nextInt()%2);
          if ((t1.type!=2)&&(t2.type!=2)) data.status=data.status%3+3*Math.abs(data.r.nextInt()%2);
          if ((t1.type!=3)&&(t2.type!=3)) data.status=data.status/3*3+Math.abs(data.r.nextInt()%3);
          for(int i=0; i<c.maxCars; i++) {
            data.cars[i].reset();
          }
          f.setSveto();
          f.setHuman();
          data.izobr=true;
  }
  static void pusk() {
    for(int i=0; i<c.maxCars; i++) {
      data.cars[i].carFaza=0;
    }
    data.faza++;
    data.colAktiv++;
    data.startTime=data.timer;
  }
}

//Класс констант
class c {
  static final int
    sleepTime=40,
    numImages=79,
    colorSmooth=50,
    numCars=4,
    carSizeX=15,      //???
    carSizeY=10,      //???
    numScenes=2,
    numScenes0=3,
    numFones=2,
    numRules=8,
    max=6,
    maxCars=12,
    maxHumans=4;
  static final String
    help="Ситуация на перекрестке описывается состоянием\n"+
         "светофоров и состоянием пешехода. Пешеход может\n"+
         "находиться в начале пешеходного перехода или\n"+
         "посредине, он может идти или стоять, и при этом\n"+
         "смотреть влево, прямо или вправо. Вы должны по\n"+
         "заданным в условии задачи параметрам перечислить\n"+
         "все случаи других параметров, не нарушающих\n"+
         "правила дорожного движения.";
}

class Point3d {
  double x,y,z;
  Point3d() {}
  Point3d(double x0, double y0, double z0) {
    x=x0; y=y0; z=z0;
  }
}

class Camera {
  double a1, a2, b;
  double focusX;
  double focusY;
}
