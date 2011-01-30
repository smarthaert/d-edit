 package pdd;

import java.awt.*;
import java.util.*;

//Класс элемента Z-буфера сцены
class zBuffElem {
  Point3d koord;  //Координаты спрайта на экране (и его удаленность)
  int sprite,     //Указатель на спрайт
      width,      //Ширина спрайта
      height,     //Высота спрайта
      number;     //Номер объекта сцены, который создал этот спрайт
  Image image;    //Спрайт (если sprite=9999)
  boolean ramka=false;  //Рамка вокруг спрайта
}
//Класс Z-буфера
class zBuff {
  Vector zb = new Vector();
  //Очистка буфера
  void reset() {
    zb=new Vector();
  }
  //Добавление элемента в буфер
  void add(zBuffElem el, int n) {
    el.number=n;
    boolean b = true;
    for(int i=0; b&&(i<zb.size()); i++) {
      zBuffElem el0 = (zBuffElem)zb.elementAt(i);
      if (el0.koord.z<el.koord.z) {
        zb.insertElementAt(el,i);
        b=false;
      }
    }
    if (b==true) zb.addElement(el);
  }
}

//Класс сцены
class Scene extends Canvas {
  Camera cam;                       //Положение камеры
  Vector objects = new Vector();    //Список объектов сцены
  zBuff zb = new zBuff();           //Z-буфер со спрайтами объектов
  //Конструктор
  Scene (double a1, double a2, double b, double fx, double fy) {
    cam = new Camera();
    cam.a1=a1;
    cam.a2=a2;
    cam.b=b;
    cam.focusX=fx;
    cam.focusY=fy;
  }
  //Добавление нового элемента в сцену
  void add(Obj obj) {
    obj.setNum(objects.size());
    objects.addElement(obj);
  }
  //Отрисовка сцены
  public void paint(Graphics g) {
    Dimension d = size();
    int dx = d.width;
    int dy = d.height;
    g.drawImage(data.offImage,0,0,this);
    if (!data.izobr) data.gc.drawImage(data.images[0],0,0,dx,dy,this);
    else {
      zb.reset();
      for(Enumeration e = objects.elements(); e.hasMoreElements(); ) {
        ((Obj)e.nextElement()).work(zb,cam,d);
      }
      for(Enumeration e = zb.zb.elements(); e.hasMoreElements(); ) {
        zBuffElem a = (zBuffElem)e.nextElement();
        Image im;
        if (a.sprite<9999) im=data.images[a.sprite];
        else im=a.image;
        data.gc.drawImage(im, (int)a.koord.x-a.width/2, (int)a.koord.y-a.height/2, a.width, a.height, this);
        if ((a.ramka)&&(data.currScene==2)&&(data.faza==0)) data.gc.drawImage(data.images[(int)(data.timer%4)+63], (int)a.koord.x-a.width/2, (int)a.koord.y-a.height/2, a.width, a.height, this);
      }
    }
//    test(g,d);
    if (data.currScene!=2) data.gc.drawImage(data.images[61],0,0,this);
    drawNameScene(data.gc);
    if (data.currScene==1) {
      data.gc.setColor(Color.white);
      data.gc.setFont(new Font("TimesRoman",Font.PLAIN,12));
      data.gc.drawString("Для управления героем используйте мышку. Для ускорения жмите любую клавишу.",2,398);
    }
    if (data.currScene==2) {
      if (data.faza>0) drTexts(data.gc,dx,dy);
      else drSluch(data.gc);
    }
//      data.gc.drawImage(data.images[62], dx/2-50, dy-30, this);
    data.timer++;
    data.frames++;
    if (System.currentTimeMillis()>(data.time+1000)) {
      data.time=System.currentTimeMillis();
      data.frames0=data.frames;
      data.frames=0;
    }
  }

  public void update(Graphics g) {
    paint(g);
  }
  //Обработка щелка мышки
  void mouse(int x, int y) {
    boolean b = true;
    for(int i=zb.zb.size()-1; b&&i>=0; i--) {
      zBuffElem el = (zBuffElem)zb.zb.elementAt(i);
      if ((el.koord.x-el.width/2<=x-location().x)&&(el.koord.x+el.width/2>=x-location().x)&&(el.koord.y-el.height/2<=y-location().y)&&(el.koord.y+el.height/2>=y-location().y)) {
        b=false;
        Obj obj = (Obj)objects.elementAt(el.number);
        obj.mouse(el, x-location().x-el.koord.x+el.width/2, y-location().y-el.koord.y+el.height/2, el.width, el.height);
      }
    }
  }
  void test(Graphics g, Dimension d) {
    g.setColor(Color.red);
    Point3d p = f.trans(new Point3d(0,0,0),cam,d);
    g.fillOval((int)p.x-2,(int)p.y-2,4,4);
    g.setColor(Color.red);
    p = f.trans(new Point3d(30,0,0),cam,d);
    g.fillOval((int)p.x-2,(int)p.y-2,4,4);
    g.setColor(Color.red);
    p = f.trans(new Point3d(-30,0,0),cam,d);
    g.fillOval((int)p.x-2,(int)p.y-2,4,4);
    g.setColor(Color.red);
    p = f.trans(new Point3d(0,30,0),cam,d);
    g.fillOval((int)p.x-2,(int)p.y-2,4,4);
    p = f.trans(new Point3d(0,-30,0),cam,d);
    g.fillOval((int)p.x-2,(int)p.y-2,4,4);
  }

  void drawNameScene(Graphics g) {
    g.setFont(new Font("TimesRoman",Font.BOLD,26));
    g.setColor(Color.white);
    switch(data.currScene) {
      case(0): {
        g.drawString("Как можно перейти дорогу",160,20);
        g.drawString("на перекрестке со светофором.",140,40);
        break;
      }
      case(1): {
        g.drawString("Тротуар: держись правой стороны.",140,20);
        break;
      }
      case(2): {
        g.drawString("",100,20);    //???????????????????
        break;
      }
      default: {
        g.drawString("Scene "+String.valueOf(data.currScene),200,20);
      }
    }
  }

  void drTexts(Graphics g, int dx, int dy) {
    g.setColor(data.col);
    g.setFont(new Font("TimesRoman",Font.BOLD,26));
    g.drawString(data.scene3.l.vivod.t1,50,30);
    g.setFont(new Font("TimesRoman",Font.BOLD,18));
    String s = data.scene3.l.vivod.t2;
    if (s!="") g.drawString(s+",",15,50);
    s = data.scene3.l.vivod.t3;
    if (s!="") g.drawString(s+".",15,65);
    g.drawString(data.text,15,85);
    int i = (int)(data.timer%10);
    if (i>4) i=10-i;
    i=2*i;
    g.drawRect(i, i, dx-1-2*i, dy-1-2*i);
    g.drawRect(i+1, i+1, dx-3-2*i, dy-3-2*i);
  }

  void drSluch(Graphics g) {
    if (!data.pusto) {
      g.setColor(Color.cyan);
      g.setFont(new Font("TimesRoman",Font.BOLD,26));
      g.drawString("Ситуация "+String.valueOf(data.aktiv+1)+":",50,30);
      g.setFont(new Font("TimesRoman",Font.BOLD,20));
      element el1 = ((And2)(data.scene3.l.right.v.elementAt(data.aktiv))).el1;
      element el2 = ((And2)(data.scene3.l.right.v.elementAt(data.aktiv))).el2;
      g.drawString(f.elToText(el1,true)+", ",15,50);
      g.drawString(f.elToText(el2,false)+".",15,65);

    }
  }
}

class Fon implements Obj {
  int num;
  int fon;
  int fon0=0;
  public void setNum(int n0) {
    num=n0;
  }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {}
  Fon(int f) {
    fon=f;
  }
  public void work(zBuff zb, Camera cam, Dimension d) {
    zBuffElem a = new zBuffElem();   //Это надо в отдельную функцию
    a.koord = new Point3d(300-(600-d.width)/2,200-(400-d.height)/2,999999);
    a.sprite=9999;
    a.image=data.fonIm[fon].Im[fon0];
    a.width=600;
    a.height=400;
    zb.add(a,num);
    if (data.speedHuman!=0) {
      if (!data.turbo) fon0++;
      else fon0+=2;
      if (fon0>=data.sizes[fon]) fon0=0;
    }
    data.lastSpeedHuman=data.speedHuman;
    if (!data.turbo) data.speedHuman=data.html[13];
    else (data.speedHuman=2*data.html[13]);
  }
}

//Интерфейс всех объектов сцены
interface Obj {
  void work(zBuff zb, Camera cam, Dimension d);
  void setNum(int n0);
  void mouse(zBuffElem el0, double x, double y, double w, double h);
}

class Car implements Obj {
  int num;
  public void setNum(int n0) { num=n0; }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {}
  double
    x=0, y=0, z=0,          //Координаты машины  - это надо к предку
    xs=0, ys=0, zs=0,       //Скорость машины
    xss=0, yss=0, zss=0,    //Ускорение машины
    a=0, b=0, c=0,          //Угловые координаты машины
    as=0, bs=0, cs=0,       //Угловая скорость машины
    ass=0, bss=0, css=0,    //Угловое ускорение машины
    sizeX=0, sizeY=0;
  int currSprite=1;
  int sprites[] = {1,2,3,4};
  boolean stop=false;
  public void work(zBuff zb, Camera cam, Dimension d) {
    if (!stop) {
      x+=xs; y+=ys; z+=zs;
      xs+=xss; ys+=yss; zs+=zss;
    }
    zBuffElem a = new zBuffElem();   //Это надо в отдельную функцию
    a.koord = f.trans(new Point3d(x,y,z),cam,d);
    a.sprite=currSprite;
    a.width=(int)(d.width*sizeX/a.koord.z);
    a.height=(int)(d.width*sizeY/a.koord.z);
    zb.add(a,num);
    work0();
  }
  void work0() {}
}

//Класс человека
class Human implements Obj {
  int num;
  boolean sizes=true;
  public void setNum(int n0) { num=n0; }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {}
  double
    x=0, y=0, z=0,          //Координаты человека
    ys = 0,
    ys2 = 0,
    sizeX, sizeY;
  Image im;
  int currSprite;
  public void work(zBuff zb, Camera cam, Dimension d) {
    y+=ys;
    y+=ys2;
    zBuffElem a = new zBuffElem();
    a.koord = f.trans(new Point3d(x,y,z),cam,d);
    a.sprite=currSprite;
    a.image=im;
    if (sizes==true) {
      a.width=(int)(d.width*sizeX/a.koord.z);
      a.height=(int)(d.width*sizeY/a.koord.z);
    }
    else {
      a.width=data.html[(int)sizeX];
      a.height=data.html[(int)sizeY];
    }
    zb.add(a,num);
    work0();
    work0(zb,cam,d);
  }
  void work0() {}
  void work0(zBuff zb, Camera cam, Dimension d) {}
}

//Класс светофора
class Sveto implements Obj {
  int num;
  public void setNum(int n0) { num=n0; }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {
    if ((data.faza!=0)||(((And2)data.scene3.l.left.v.firstElement()).el1.type==0)||(((And2)data.scene3.l.left.v.firstElement()).el2.type==0)) return;
    if ((data.colorSveto!=0)&&(data.colorSveto!=3)) data.colorSveto++;
    else data.colorSveto+=2;
    if (data.colorSveto>5) data.colorSveto=0;
    f.setSveto();
  }
  double
    x, y, z,          //Координаты светофора
    sizeX=8, sizeY=16;
  Sveto(double x0, double y0, double z0) {
    x=x0; y=y0; z=z0;
    data.colorSveto=Math.abs(data.r.nextInt()%6);
  }
  public void work(zBuff zb, Camera cam, Dimension d) {
    if (data.currScene==0) {
      int t = (int)(data.timer%200);
      if (t<70) data.colorSveto=0;
      else if (t<100) data.colorSveto=2;
      else if (t<170) data.colorSveto=3;
      else data.colorSveto=5;
    }
    zBuffElem a = new zBuffElem();
    a.koord = f.trans(new Point3d(x,y,z),cam,d);
    a.sprite=38+data.colorSveto;
    if (data.colorSveto==1) {
      if (data.timer%6>2) a.sprite=38;
    }
    if (data.colorSveto==4) {
      if (data.timer%6>2) a.sprite=41;
    }
    a.width=(int)(d.width*sizeX/a.koord.z);
    a.height=(int)(d.width*sizeY/a.koord.z);
    a.koord.y-=a.height/2;
    if ((((And2)data.scene3.l.left.v.firstElement()).el1.type==0)||(((And2)data.scene3.l.left.v.firstElement()).el2.type==0)) a.ramka=false;
    else a.ramka=true;
    zb.add(a,num);
    work0();
  }
  void work0() {}
}

//Класс человека
class Human123 implements Obj {
  boolean nogi;
  int golova;
  int doroga;
  int num;
  int indStatus=Math.abs(data.r.nextInt()%6);
  public void setNum(int n0) { num=n0; }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {
    if (data.faza!=0) return;
    if ((el0.sprite==10001)&&(((And2)data.scene3.l.left.v.firstElement()).el1.type!=3)&&(((And2)data.scene3.l.left.v.firstElement()).el2.type!=3)) {
      data.status++;
      if (data.status%3==0) data.status-=3;
    }
    if ((el0.sprite==10000)&&(y<2*h/3)&&(((And2)data.scene3.l.left.v.firstElement()).el1.type!=1)&&(((And2)data.scene3.l.left.v.firstElement()).el2.type!=1)) {
      data.mesto++;
      if (data.mesto==2) data.mesto=0;
    }
    if ((el0.sprite==9999)&&(((And2)data.scene3.l.left.v.firstElement()).el1.type!=2)&&(((And2)data.scene3.l.left.v.firstElement()).el2.type!=2)) {
      if (data.status<3) data.status+=3;
      else data.status-=3;
    }
    f.setHuman();
  }
  double
    x, y, z,          //Координаты человека
    sizeX=5, sizeY=15;
  Human123() {
    data.mesto=Math.abs(data.r.nextInt()%2);
    data.status=Math.abs(data.r.nextInt()%6);
  }
  Human123(int x0, int y0, int z0, int d) {
    x=x0; y=y0; z=z0;
    doroga=d;
  }
  public void work(zBuff zb, Camera cam, Dimension d) {
    if (data.currScene==2) {
      if (data.mesto==0) { x=0; y=12; z=-1; }
      else { x=18; y=12; z=0; }
      indStatus=data.status;
    }
    else {
      switch(doroga) {
        case(1): {
          if (((x!=18)||(data.colorSveto==0))&&(!f.testPlace((int)x-4,(int)y-3,3,6))) {
            x--;
            if (x<-50) x=50+Math.abs(data.r.nextInt()%50);
            nogi=!nogi;
          }
          else nogi=false;
          if ((x>3)&&(x<18)) golova=0;
          else if ((x>-18)&&(x<=3)) golova=2;
          else if ((x<-18)||(x>18)) golova=1;
          else {
            golova++;
            if (golova>2) golova=1;
          }
          indStatus=golova;
          if (nogi) indStatus+=3;
          if ((data.r.nextInt()%2==0)&&((x==20)||(x==-20))) doroga=2;
          break;
        }
        case(2): {
          if (((y!=7)||(data.colorSveto==3))&&(!f.testPlace((int)x-3,(int)y-4,6,3))) {
            y--;
            if (y<-50) y=50+Math.abs(data.r.nextInt()%50);
            nogi=!nogi;
          }
          else nogi=false;
          if ((y>1)&&(y<7)) golova=2;
          else if ((y>-5)&&(y<=1)) golova=0;
          else if ((y<-5)||(y>7)) golova=1;
          else {
            golova++;
            if (golova>2) golova=1;
          }
          indStatus=golova;
          if (nogi) indStatus+=3;
          if ((data.r.nextInt()%2==0)&&((y==12)||(y==-8))) doroga=1;
          break;
        }
      }
    }
    And2 aaa = (And2)data.scene3.l.left.v.firstElement();

    zBuffElem a = new zBuffElem();
    a.koord = f.trans(new Point3d(x,y,z),cam,d);
    a.sprite=9999;
    if (doroga==1) {
      if ((aaa.el1.type==2)||(aaa.el2.type==2))
        a.image=data.human3d[4+indStatus/3];
      else a.image=data.human3d[4+indStatus/3]; //Подсветка
    }
    else a.image=data.human3d2[4+indStatus/3];
    a.width=(int)(d.width*data.html[14]/a.koord.z);
    a.height=(int)(d.width*data.html[15]/a.koord.z);
    a.koord.y-=a.height/2;
    double x = a.koord.x;
    double y = a.koord.y;
    double z = a.koord.z;
    int dx = a.width;
    int dy = a.height;
    if ((((And2)data.scene3.l.left.v.firstElement()).el1.type==2)||(((And2)data.scene3.l.left.v.firstElement()).el2.type==2)) a.ramka=false;
    else a.ramka=true;
    zb.add(a,num);

    a = new zBuffElem();
    a.koord = new Point3d(x,y-dy,z);
    a.sprite=10000;
    if (doroga==1) {
      if ((aaa.el1.type==1)||(aaa.el2.type==1))
        a.image=data.human3d[0];
      else a.image=data.human3d[0]; //Подсветка
    }
    else a.image=data.human3d2[0];
    a.width=dx;
    a.height=dy;
    if ((((And2)data.scene3.l.left.v.firstElement()).el1.type==1)||(((And2)data.scene3.l.left.v.firstElement()).el2.type==1)) a.ramka=false;
    else a.ramka=true;
    zb.add(a,num);

    a = new zBuffElem();
    a.koord = new Point3d(x,y-2*dy,z);
    a.sprite=10001;
    a.image=data.images[0];
    if (doroga==1) {
      if ((aaa.el1.type==3)||(aaa.el2.type==3))
        a.image=data.human3d[indStatus%3+1];
      else a.image=data.human3d[indStatus%3+1];  //Подсветка
    }
    else a.image=data.human3d2[indStatus%3+1];
    a.width=dx;
    a.height=dy;
    if ((((And2)data.scene3.l.left.v.firstElement()).el1.type==3)||(((And2)data.scene3.l.left.v.firstElement()).el2.type==3)) a.ramka=false;
    else a.ramka=true;
    zb.add(a,num);

    work0();
  }
  void work0() {}
}

//Класс дома
class House implements Obj {
  int num;
  public void setNum(int n0) { num=n0; }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {}
  double
    x=0, y=0, z=0,          //Координаты дома
    sizeX, sizeY;
  int currSprite;
  public void work(zBuff zb, Camera cam, Dimension d) {
    zBuffElem a = new zBuffElem();
    a.koord = f.trans(new Point3d(x,y,z),cam,d);
    a.sprite=currSprite;
    a.width=(int)(d.width*sizeX/a.koord.z);
    a.height=(int)(d.width*sizeY/a.koord.z);
    zb.add(a,num);
    work0();
  }
  void work0() {}
}

/*
class House1 extends House {
  House1() {
    x=-10;   //-7?????
    y=-400;
    z=0;    //-1????
    sizeX=67.55;
    sizeY=12.65;
    currSprite=37;
  }
  public void work0() {
    y+=1;
    if (y>15) y=-400;
  }
}
*/

class Human0 extends Human {
  static int boom=0;
  Human0() {
    currSprite=63;
    x=0;
    y=0;
    z=0;
    ys=0;
    sizeX=0.1; sizeY=0.1;
  }
  void work0(zBuff zb, Camera cam, Dimension d) {
    currSprite=9999;
    im=data.human[data.fazaHuman];
    data.timeHuman++;
    if (((!data.turbo)&&(data.timeHuman>=data.html[8])) || ((data.turbo)&&(data.timeHuman>=data.html[8]/2))) {
      data.timeHuman=0;
      data.fazaHuman++;
      if (data.fazaHuman>=data.html[6]) data.fazaHuman=0;
    }
    if (boom==0) {
      sizes=false;
      sizeX=0; sizeY=1;
    }
    else {
      sizes=true;
      sizeX=10; sizeY=10;
      boom++;
      if (boom>10) boom=0;
    }
    zBuffElem a = new zBuffElem();
    a.koord = f.trans(new Point3d(x,y,z),cam,d);
    a.koord.x+=data.html[4];
    a.koord.y+=data.html[5];
    a.sprite=9999;
    if (data.moveFaza==0) a.image=data.dog[data.fazaDog];
    else a.image=data.dog2[data.fazaDog];
    data.timeDog++;
    if (data.timeDog>=data.html[9]) {
      data.timeDog=0;
      data.fazaDog++;
      if (data.fazaDog>=data.html[7]) data.fazaDog=0;
    }
    a.width=data.html[2];
    a.height=data.html[3];
    zb.add(a,num);

    if ( ((data.moveFaza==0)&&(System.currentTimeMillis()>data.timeMove+data.html[11])) || ((data.moveFaza==1)&&(System.currentTimeMillis()>data.timeMove+data.html[12])) ){
      data.timeMove=System.currentTimeMillis();
      data.moveFaza++;
    }
    if ((data.moveFaza>=2)&&(data.cursor>=10)) data.cursor-=10;
    x=(data.cursor-300)/30;
  }
}

class Human1 extends Human {
  int tip;
  int timer=0;
  int tip0;
  Human1() {
    tip=Math.abs(data.r.nextInt()%data.heros.length);
    tip0=0;
    x=10*data.r.nextDouble();
    if (data.heros[tip].speed>0) x=-x;
    y=-400*data.r.nextDouble();
    z=0;
  }
  void work0() {
    currSprite=9999;
    im = data.heros[tip].im[tip0];
    sizeX=data.heros[tip].width;
    sizeY=data.heros[tip].height;
    ys=data.heros[tip].speed;
    ys2=data.lastSpeedHuman;
    timer++;
    if (timer==data.heros[tip].pause) {
      timer=0;
      tip0++;
      if (tip0==data.heros[tip].im.length) tip0=0;
    }
    if ((y>-10)&&(x>(data.cursor-300)/30-5)&&(x<(data.cursor-300)/30+5)) {
      data.speedHuman=0;
      if (ys>0) ys=0;
    }
    if (y>0) {
      tip=Math.abs(data.r.nextInt()%data.heros.length);
      tip0=0;
      x=10*data.r.nextDouble();
      if (data.heros[tip].speed>0) x=-x;
      y=-400;
      z=0;
    }
  }
}

class Car1 extends Car {
  Car1(int im, double x0, double y0, double xs0, double ys0) {
    currSprite=im;
    x=x0; y=y0;
    xs=xs0; ys=ys0;
    sizeX=18; sizeY=12;
  }
  public void work0() {
    if (x<-100) x=100;
    if (x>100) x=-100;
    if (y<-100) y=100;
    if (y>100) y=-100;
  }
}

class Car2 extends Car {
  int time=0;
  Car2(int im, double x0, double y0, double xs0, double xss0, double ys0, double yss0) {
    currSprite=im;
    x=x0; y=y0;
    xs=xs0; xss=xss0;
    ys=ys0; yss=yss0;
    sizeX=24; sizeY=16;
  }
  public void work0() {
    if ((currSprite%5==0)&&(xs>-0.02)&&(xs<0.02)&&(ys>-0.02)&&(ys<0.02)) {
      switch(currSprite) {
        case(5): {currSprite=24; xss=-0.04; yss=0; stop=true; break;}
        case(10): {currSprite=9; xss=0; yss=+0.04; stop=true; break;}
        case(15): {currSprite=14; xss=+0.04; yss=0; stop=true; break;}
        case(20): {currSprite=19; xss=0; yss=-0.04; stop=true; break;}
      }
    }
    if (currSprite%5!=0) {
      time++;
      if (time>5) {
        time=0;
        currSprite--;
        if (currSprite%5==0) stop=false;
      }
    }
    if (x<-100) {
      x=100; xs=-2.8; xss=0.04;
    }
    if (x>100) {
      x=-100; xs=2.8; xss=-0.04;
    }
    if (y<-100) {
      y=100; ys=-2.8; yss=0.04;
    }
    if (y>100) {
      y=-100; ys=2.8; yss=-0.04;
    }
  }
}

class Car3 extends Car {
  int mashina;
  double x00,y00,z00;
  int type;
  int carFaza;
  int saveSprite=-1;
  boolean startTime=false;
  int time=0;
  boolean pause=false;
  Car3(int type0, double x0, double y0, double z0) {
    x00=x0; y00=y0; z00=z0;
    type=type0;
    sizeX=12; sizeY=8;
    reset();
    x=0;
  }
  void reset() {
    saveSprite=-1;
    int rand = Math.abs(data.r.nextInt()%3);
    if (rand==2) currSprite=type;
    else currSprite=43+type+4*rand;
    x=x00; y=y00; z=z00;
    carFaza=0;
    mashina=Math.abs(data.r.nextInt()%2);
  }
  public void work0() {
    if (mashina==0) {
      sizeX=12; sizeY=8;
    }
    else {
      sizeX=10.5; sizeY=7;
    }
    if (saveSprite!=-1) {
      currSprite=saveSprite;
      saveSprite=-1;
    }
    if (startTime) {
      time++;
      if (time==8) {
        time=0;
        startTime=false;
        currSprite=currSprite%4+1;
      }
    }
    pause=false;
    if ((Math.abs(x)>100)||(Math.abs(y)>100)) reset();
    if (currSprite==3||currSprite==46||currSprite==50) {
      if (((data.colorSveto<=2)&&(y==+20))||(f.testPlace((int)x-3,(int)y-12,6,11))) pause=true;
    }
    if (currSprite==1||currSprite==44||currSprite==48) {
      if (((data.colorSveto<=2)&&(y==-20))||(f.testPlace((int)x-3,(int)y+1,6,11))) pause=true;
    }
    if (currSprite==4||currSprite==47||currSprite==51) {
      if (((data.colorSveto>=3)&&(x==+30))||(f.testPlace((int)x-12,(int)y-3,11,6))) pause=true;
    }
    if (currSprite==2||currSprite==45||currSprite==49) {
      if (((data.colorSveto>=3)&&(x==-30))||(f.testPlace((int)x+1,(int)y-3,11,6))) pause=true;
    }
/*    if ((data.faza==1)&&(data.timer>=data.startTime+data.html[16])) {
      if (ok) {
        if (data.pusk) {
          data.col=Color.green;
          data.text2=" ВЕРНО";
        }
        else {
          data.col=Color.pink;
          data.text2="ЗАБЫЛИ?";
        }
      }
      else {
        data.col=Color.red;
        data.text2="НЕ ВЕРНО";
        if (data.pusk) data.scene3.err++;
      }
    }
*/
    int a1=2, a2=8;                           //Константы
    if ((!pause)&&((data.faza==1)||(data.currScene==0))) {
      switch(currSprite) {
        case(1): {
          y++; if ((y>=0)&&(carFaza==0)) carFaza++;
          break;
        }
        case(2): {
          x++; if ((x>=0)&&(carFaza==0)) carFaza++;
          break;
        }
        case(3): {
          y--; if ((y<=0)&&(carFaza==0)) carFaza++;
          break;
        }
        case(4): {
          x--; if ((x<=0)&&(carFaza==0)) carFaza++;
          break;
        }
        case(44): {
          y++;
          if ((y>=a1)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=45;
          }
          break;
        }
        case(45): {
          x++;
          if ((x>=a2)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=46;
          }
          break;
        }
        case(46): {
          y--;
          if ((y<=-a1)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=47;
          }
          break;
        }
        case(47): {
          x--;
          if ((x<=-a2)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=44;
          }
          break;
        }
        case(48): {
          y++;
          if ((y>=-a1)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=51;
          }
          break;
        }
        case(49): {
          x++;
          if ((x>=-a2)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=48;
          }
          break;
        }
        case(50): {
          y--;
          if ((y<=a1)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=49;
          }
          break;
        }
        case(51): {
          x--;
          if ((x<=a2)&&(carFaza==0)) {
            carFaza++;
            startTime=true;
            currSprite=50;
          }
          break;
        }
      }
    }
    saveSprite=currSprite;
    if ((((data.timer%2==0)&&(mashina==0))||((data.timer%2==1)&&(mashina==1)))&&(currSprite>=44)) currSprite=currSprite%4+1;
    if (mashina==1) {
      switch(currSprite) {
        case(1): {currSprite=67; break;}
        case(2): {currSprite=68; break;}
        case(3): {currSprite=69; break;}
        case(4): {currSprite=70; break;}
        case(44): {currSprite=71; break;}
        case(45): {currSprite=72; break;}
        case(46): {currSprite=73; break;}
        case(47): {currSprite=74; break;}
        case(48): {currSprite=75; break;}
        case(49): {currSprite=76; break;}
        case(50): {currSprite=77; break;}
        case(51): {currSprite=78; break;}
      }
    }
  }
}

class butt implements Obj {
  double x,y,w,h;
  int num;
  public void setNum(int n0) { num = n0; }
  public void mouse(zBuffElem el0, double x, double y, double w, double h) {}
  public void work(zBuff zb, Camera cam, Dimension d) {
    zBuffElem a = new zBuffElem();
    a.koord = new Point3d();
    a.koord.x = x+w/2;
    a.koord.y = y+h/2;
    a.koord.z = 0;
    work0(a);
    a.width=(int)w;
    a.height=(int)h;
    zb.add(a,num);
  }
  void work0(zBuffElem a) {}
}

//Класс конъюкции
class And {
  Vector data;
}

//Класс дизъюнктивной нормальной формы
class Dnf {
  Vector data;
}

//Класс логического утверждения
class logik {
  Dnf left;   //Причина
  Dnf rught;  //Следствие
}

//Класс элемента логики
class element extends Canvas{
  boolean dostup=true;
  Color c;
  int type;
  int value;
  Image off;
  Graphics gc;
  void setType(int t) {
    type=t;
  }
  void setValue(int v) {
    value=v;
  }
  void col(Color c0) {
    c=c0;
  }
  element(int t,int v, boolean d) {
    dostup=d;
    type=t;
    value=v;
  }
  public void update(Graphics g) {
    paint(g);
  }
  public void paint(Graphics g) {
    Dimension d = size();
    off=createImage(d.width, d.height);
    gc=off.getGraphics();
    gc.drawImage(data.elem[type].el[value],0,0,d.width,d.height,this);
    gc.setColor(c);
    gc.drawRect(0,0,d.width-2,d.height-2);
    gc.drawRect(1,1,d.width-4,d.height-4);
    g.drawImage(off,0,0,d.width-1,d.height-1,this);
  }
  public boolean mouseDown(Event evt, int x, int y) {
    if ((dostup)&&(data.faza==0)&&(c==Color.black)) {
      value++;
      if (value==data.elem[type].el.length) value=0;
      repaint();
    }
    return false;
  }
}

class ILI extends Canvas {
  boolean b;
  ILI(boolean b0) {
    b=b0;
    resize(100,10);
  }
  public void paint(Graphics g) {
    Dimension d = size();
    g.setColor(Color.black);
    if (b==true) {
      g.setFont(new Font("TimesRoman",Font.PLAIN,14));
      g.drawString("или",d.width/2-10,9);
    }
    else {
//      g.setFont(new Font("TimesRoman",Font.BOLD,18));
//      g.drawString("РЕШЕНИЕ:",3,12);
    }
  }
}

class reshenie extends Canvas {
  reshenie() {
    resize(100,14);
  }
  public void paint(Graphics g) {
    g.setFont(new Font("TimesRoman",Font.BOLD,18));
    g.drawString("Решение:",10,14);
  }
}

class And2 extends Panel {
  int num;
  boolean test=false;
  boolean dostup;
  boolean ili = true;
  element el1;
  element el2;
  And2(int n, int type1, int val1, boolean d1, int type2, int val2, boolean d2, boolean il) {
    ili = il;
    setLayout(new BorderLayout());
    if (ili) add("North", new ILI(true));
    else add("North", new ILI(false));
    Panel p = new Panel();
    p.setLayout(new GridLayout(1,2,1,1));
    el1 = new element(type1, val1, d1);
    p.add(el1);
    el2 = new element(type2, val2, d2);
    p.add(el2);
    add("Center",p);
    if (data.aktiv!=num) { el1.col(Color.lightGray); el2.col(Color.lightGray); }
    else {
      if (data.colAktiv==0) { el1.col(Color.black); el2.col(Color.black);}
      else if (data.colAktiv==1) {el1.col(Color.yellow); el2.col(Color.yellow);}
      else {el1.col(Color.red); el2.col(Color.red);}
    }
    dostup=d1;
    num=n;
  }
  public void paint(Graphics g) {
    if (data.aktiv!=num) { el1.col(Color.lightGray); el2.col(Color.lightGray); }
    else {
      if (data.colAktiv==0) { el1.col(Color.black); el2.col(Color.black);}
      else if (data.colAktiv==1) {el1.col(Color.yellow); el2.col(Color.yellow);}
      else {el1.col(Color.red); el2.col(Color.red);}
    }
    el1.repaint();
    el2.repaint();
  }
  public boolean mouseDown(Event evt, int x, int y) {
    if ((dostup)&&(data.faza==0)) {
      f.setAktiv(num);
    }
    return true;
  }
}

class dnf2 extends Canvas {
  int k;
  Image off;
  Graphics gc;
  Vector v = new Vector();
  dnf2(int i) {
    k=i;
  }

  public void update(Graphics g) {
    paint(g);
  }
  void paint2() {
    for(Enumeration e = v.elements(); e.hasMoreElements(); ) {
      And2 el = (And2)e.nextElement();
      el.repaint();
    }
  }

  public void paint(Graphics g) {
    off=createImage(size().width,size().height);
    gc=off.getGraphics();
    if (k==0) {
      String s1 = f.elToText(((And2)v.firstElement()).el1, true);
      String s2 = f.elToText(((And2)v.firstElement()).el2, false);
      gc.setColor(Color.black);
      gc.setFont(new Font("TimesRoman",Font.BOLD,18));
      gc.drawString("Задача "+String.valueOf(data.nt)+": "+s1+", "+s2+".",5,20);
      String t;
      switch(data.type) {
        case(1): {t="Что должен делать пешеход? Куда смотреть?"; break; }
        case(2): {t="Где находится пешеход? Куда он смотрит?"; break; }
        case(3): {t="Где находится пешеход? Что он дожен делать?"; break; }
        case(4): {t="Какой свет горит на светофоре? Куда смотрит пешеход?"; break; }
        case(5): {t="Какой свет горит на светофоре? Что должен делать пешеход?"; break; }
        default: t="Какой свет горит на светофоре? Где стоит пешеход?";
      }
      gc.drawString(t,5,40);
    }
    else {
      gc.setFont(new Font("TimesRoman",Font.BOLD,20));
      gc.setColor(Color.black);
      gc.drawString("Ваш ответ:",3,13);
      gc.setFont(new Font("TimesRoman",Font.PLAIN,12));
      gc.setColor(Color.blue);
      boolean next=false;
      for(int j=0; j<v.size(); j++) {
        And2 el = (And2)v.elementAt(j);
        el.repaint();                             //Зачем?
        if ((el.el1.value!=0)||(el.el2.value!=0)) {
          if (next) gc.drawString("ИЛИ",80,(j+1)*10);
          next=true;
          gc.drawString("( "+f.elToText(el.el1, false)+"  И  "+f.elToText(el.el2, false)+" )",115,(j+1)*10);
        }
      }
    }
    g.drawImage(off, 0, 0, size().width-1, size().height-1, this);
  }
}

class Vivod extends Canvas {
  Image off;
  Graphics gc;
  String t1 = "",
         t2 = "",
         t3 = "";
  And2 and2;
  public void update(Graphics g) {
    paint(g);
  }
  public void paint(Graphics g) {
    Dimension d = size();
    off=createImage(d.width, d.height);
    gc=off.getGraphics();
/*    gc.setFont(new Font("TimesRoman",Font.BOLD,20));
    gc.setColor(Color.black);
    gc.drawString("Результаты:",5,17);
    gc.setFont(new Font("TimesRoman",Font.BOLD,18));
    gc.setColor(Color.blue);
    gc.drawString(t1,120,17);
    gc.setFont(new Font("TimesRoman",Font.ITALIC,18));
    gc.setColor(new Color(128,0,128));
    if (t3=="") gc.drawString(t2,5,37);
    else gc.drawString(t2+"  И  "+t3+".",5,37);
*/
    gc.setFont(new Font("TimesRoman",Font.BOLD,20));
    gc.setColor(new Color(0,128,0));
    gc.drawString("Решено задач:",5,17);
    gc.drawString(String.valueOf(data.scene3.tot),150,17);
    gc.setColor(new Color(128,0,0));
    gc.drawString("Допущено ошибок:",185,17);
    gc.drawString(String.valueOf(data.scene3.err),380,17);
    g.drawImage(off,0,0,size().width-1, size().height-1, this);
  }
  void setText1(String t) {
    t1=t;
  }
  void setText2(String t) {
    t2=t;
  }
  void setText3(String t) {
    t3=t;
  }
}

class logik2 extends Panel{
/*  class if0 extends Canvas {
    public void paint(Graphics g) {
      Dimension d = size();
      g.setFont(new Font("TimesRoman",Font.BOLD,30));
      g.setColor(Color.black);
      g.drawString("Если",d.width/2-40,d.height/2+10);
    }
  }
  class then0 extends Canvas {
    public void paint(Graphics g) {
      Dimension d = size();
      g.setFont(new Font("TimesRoman",Font.BOLD,30));
      g.setColor(Color.black);
      g.drawString("То",d.width/2-25,d.height/2+10);
    }
  }
*/
  boolean ooo=false;
  dnf2 left = new dnf2(0);
  dnf2 right = new dnf2(1);
  Vivod vivod= new Vivod();
  logik2(int type1, int val1, int type2, int val2, int type3, int type4, int max) {
    setLayout(new BorderLayout());
    Panel p = new Panel();
    p.setLayout(new GridLayout(max,1));
    And2 a = new And2(999,type1, val1, false, type2, val2, false, false);
//    p.add(new if0());
//    p.add(a);
//    p.add(new then0());
    left.v.addElement(a);
    for(int i=0; i<max; i++) {
      if (i>0) a = new And2(i,type3,1,true,type4,1,true,true);
      else a = new And2(i,type3,2,true,type4,2,true,false);
      right.v.addElement(a);
      p.add((And2)right.v.lastElement());
    }
    create();
    Panel pp = new Panel();
    pp.setLayout(new BorderLayout());
    pp.add("Center",p);
    pp.add("North",new reshenie());
    add("East",pp);
    add("Center",data.scenes[2]);
    add("North",left);
    left.resize(50,50);
    p = new Panel();
    p.setLayout(new BorderLayout());
    data.cardsPanel1 = new Panel();
    data.cards1 = new CardLayout();
    data.cardsPanel1.setLayout(data.cards1);
    data.cardsPanel1.add("1", new Button("Проверить"));
    data.cardsPanel1.add("2", new Button("Исправить"));
    data.cardsPanel1.add("3", new Button("Следующая"));
    p.add("East",data.cardsPanel1);
    p.add("Center",vivod);
    Panel p0 = new Panel();
    p0.setLayout(new GridLayout(1,2));
    p0.add(new Button("Справка"));
    p0.add(new Button("Выход"));
    p.add("West",p0);
    add("South",p);
  }
  public void paint(Graphics g) {
    left.repaint();
    right.repaint();
    right.paint2();
    data.scenes[2].repaint();
  }
  void reset() {
    for(Enumeration e = right.v.elements(); e.hasMoreElements(); ) {
      And2 el = (And2)e.nextElement();
      el.test=false;
    }
  }
  void create() {
    int r = Math.abs(data.r.nextInt()%6)+1;
    int type1, type2, type3, type4;
    data.type=r;
    switch(r) {
      case(1): { type1=0 ; type2=1 ;type3=2 ;type4=3 ; break; }
      case(2): { type1=0 ; type2=2 ;type3=1 ;type4=3 ; break; }
      case(3): { type1=0 ; type2=3 ;type3=1 ;type4=2 ; break; }
      case(4): { type1=1 ; type2=2 ;type3=0 ;type4=3 ; break; }
      case(5): { type1=1 ; type2=3 ;type3=0 ;type4=2 ; break; }
      default: { type1=2 ; type2=3 ;type3=0 ;type4=1; }
    }
    element el1 = ((And2)left.v.firstElement()).el1;
    element el2 = ((And2)left.v.firstElement()).el2;
    el1.setType(type1);
    el1.setValue(Math.abs(data.r.nextInt()%(data.elem[type1].el.length-1))+1);
    el2.setType(type2);
    el2.setValue(Math.abs(data.r.nextInt()%(data.elem[type2].el.length-1))+1);
    f.setNt(r, el1.value, el2.value);
    for(Enumeration e = right.v.elements(); e.hasMoreElements(); ) {
      And2 a = (And2)e.nextElement();
      a.el1.type=type3;
      a.el1.value=0;
      a.el2.type=type4;
      a.el2.value=0;
    }
    repaint();
    vivod.setText1("");
    vivod.setText2("");
    vivod.setText3("");
    vivod.repaint();
  }
  void test() {
     And2 a1 = (And2)left.v.firstElement();
     for(int iii=0; iii<right.v.size(); iii++) {
       And2 a2 = (And2)right.v.elementAt(iii);
       int q1 = a2.el1.value;
       int q111=q1;
       int q2 = a2.el2.value;
       int q222=q2;
       if ((q1!=0)||(q2!=0)) {
         if (q1==0) {
           q1=1;
           switch(a2.el1.type) {
             case(0): {q111=4; break;}
             case(1): {q111=2; break;}
             case(2): {q111=2; break;}
             case(3): {q111=3; break;}
           }
         }
         if (q2==0) {
           q2=1;
           switch(a2.el2.type) {
             case(0): {q222=4; break;}
             case(1): {q222=2; break;}
             case(2): {q222=2; break;}
             case(3): {q222=3; break;}
           }
         }
         for(int q11=q1; q11<=q111; q11++) {
           for(int q22=q2; q22<=q222; q22++) {
             int zx[] = new int[4];
             zx[a1.el1.type]=a1.el1.value;
             zx[a1.el2.type]=a1.el2.value;
             zx[a2.el1.type]=q11;
             zx[a2.el2.type]=q22;
             boolean ok=false;
             for(int i=0; ((i<c.numRules)&&(!ok)); i++) {
               ok=true;
               for(int j=0; (j<4)&&ok; j++) {
                 if ((zx[j]!=data.pravila[i][j])&&(data.pravila[i][j]!=0)) ok=false;
               }
             }
             if (!ok) {
               data.cards1.show(data.cardsPanel1,"2");
               data.colAktiv=2;
               data.col=Color.red;
               vivod.setText1("Случай "+String.valueOf(iii+1)+" неверен:");
               vivod.setText2(f.elToText(a2.el1, true));
               vivod.setText3(f.elToText(a2.el2, false));
               f.setAktiv(iii);
               data.scene3.err++;
               vivod.repaint();
               if (data.izobr) {
                 f.pusk();
                 f.prichina();
               }
               else {
                 data.text="Такая ситуация невозможна!";
                 data.text2="НЕ ВЕРНО";
                 data.col=Color.red;
                 data.faza=2;
               }
               return;
             }
           }
         }
       }
     }
     And2 a2=(And2)right.v.firstElement();
     Vector vvv = new Vector();
     for(int iii=0; iii<c.numRules; iii++) {
       if ( ((data.pravila[iii][a1.el1.type]==a1.el1.value)||(data.pravila[iii][a1.el1.type]==0)) && ((data.pravila[iii][a1.el2.type]==a1.el2.value)||(data.pravila[iii][a1.el2.type]==0)) ) {
         for(int i=1; i<data.elem[a2.el1.type].el.length; i++) {
           int i0;
           if (data.pravila[iii][a2.el1.type]==0) i0=i;
           else i0=data.pravila[iii][a2.el1.type];
           for(int j=1; j<data.elem[a2.el2.type].el.length; j++) {
             int j0;
             if (data.pravila[iii][a2.el2.type]==0) j0=j;
             else j0=data.pravila[iii][a2.el2.type];
             group gr = new group();
             gr.aaa[a1.el1.type]=a1.el1.value;   //Не важно
             gr.aaa[a1.el2.type]=a1.el2.value;   //Не важно
             gr.aaa[a2.el1.type]=i0;
             gr.aaa[a2.el2.type]=j0;
             vvv.addElement(gr);
           }
         }
       }
     }
     for(Enumeration e = vvv.elements(); e.hasMoreElements(); ) {
       group aaa = (group)e.nextElement();
       boolean ok=false;
       for(Enumeration e2 = right.v.elements(); (!ok)&&e2.hasMoreElements(); ) {
         a2 = (And2)e2.nextElement();
         if ( ((aaa.aaa[a2.el1.type]==a2.el1.value)||(a2.el1.value==0)) && ((aaa.aaa[a2.el2.type]==a2.el2.value)||(a2.el2.value==0)) && ((a2.el1.value!=0)||(a2.el2.value!=0))) {
           ok=true;
         }
       }
       if (!ok) {
         data.cards1.show(data.cardsPanel1,"2");
         data.scene3.err++;
         data.col=Color.yellow;
         vivod.setText1("Вы забыли один из случаев:");
         element el = new element(a2.el1.type,aaa.aaa[a2.el1.type],true);
         element e2 = new element(a2.el2.type,aaa.aaa[a2.el2.type],true);
         vivod.setText2(f.elToText(el, true));
         vivod.setText3(f.elToText(e2, false));
         vivod.repaint();
         data.t1=a2.el1.type;
         data.v1=aaa.aaa[a2.el1.type];
         data.t2=a2.el2.type;
         data.v2=aaa.aaa[a2.el2.type];
         f.setAktiv(999);
         data.save=true;
         f.pusk();
         return;
       }
     }
     data.cards1.show(data.cardsPanel1,"3");
     data.faza=2;
     data.text="";
     data.col=Color.green;
     data.text2="ПОБЕДА!";
     if (!data.resheno) {
       vivod.setText1("Задача решена!");
       vivod.setText2("");
       vivod.setText3("");
       data.scene3.tot++;
       data.resheno=true;
     }
     else {
//       vivod.setText1("Эта задача Вами уже решена.");
//       vivod.setText2("Очко Вы уже получили. Решайте следующую задачу.");
     }
     vivod.repaint();
     return;
  }
}

class Scene3 extends Panel {
  Help hlp;
  CardLayout cards;
  Panel cardsPanel;
  int tot=0;
  int err=0;
  logik2 l;
  Scene3() {
    hlp = new Help();
    setLayout(new BorderLayout());
    add("Center",l = new logik2(0,1,1,1,3,2,c.max));
    Panel p = new Panel();
    p.setLayout(new GridLayout(1,3));
    cards = new CardLayout();
    cardsPanel = new Panel();
    cardsPanel.setLayout(cards);
    cardsPanel.add("1",new Button("Проверить"));
    cardsPanel.add("2",new Button("Следующий"));
    p.add(cardsPanel);
    p.add(new Button("Выход"));
//    add("South",p);
  }
  public void paint(Graphics g) {
    l.repaint();
  }
}


