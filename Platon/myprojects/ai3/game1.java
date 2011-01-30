package ai3;

import java.awt.*;
import java.applet.*;
import java.util.*;
import java.math.*;
import java.awt.image.*;

class Game1 {
  sliderData s1 = new sliderData("Начальное количество камушков",c.currApples,c.minApples,c.maxApples, new Hlp(c.h2,300,100));
  sliderData s2 = new sliderData("До скольки можно брать за один ход",c.currMove,c.minMove,c.maxMove, new Hlp(c.h3,300,100));
  boxData b1 = new boxData("Последний взявший становится","победителем","проигравшим",true, new Hlp(c.h6, 300, 100));
  boxData b2 = new boxData("Первым ходит","компьютер","человек",false, new Hlp(c.h7,300,100));
  boxData b3 = new boxData("Компьютер играет с","человеком","компьютером",false, new Hlp(c.h8,300,100));
  textData t1 = new textData("Ваше имя","Игрок", new Hlp(c.h10,300,100));
  textData t2 = new textData("Имя компьютера","Компьютер", new Hlp(c.h11,300,100));
  sliderData sp = new sliderData("Скорость игры",2,0,7, new Hlp(c.h4,300,200));
  spisData mode1 = new spisData("Стратегия поощрения",c.ttt1, new Hlp(c.h12,300,150));
  spisData mode2 = new spisData("Стратегия наказания",c.ttt2, new Hlp(c.h13,300,150));
  sliderData sheres = new sliderData("Количество шариков каждого цвета в коробке",5,2,10, new Hlp(c.h5,300,100));
  boxData gr = new boxData("Уровень графики","Низкий","Высокий",false, new Hlp(c.h9,300,100));
  int speed;
  Vector svet;
  int p1, p2;
  int
      timeClose = 40,
      timeMove = 40,
      timeShake = 40,
      timeTake1 = 20,
      timeTake2 = 20,
      timeTake3 = 20,
      timePut1 = 20,
      timePut2 = 20,
      timePut3 = 20,
      timeClone = 20,
      timeDestr = 20,
      time_Bomb = 3,
      timeEating = 40;
  Options opt = new Options();
  Color colors[] = new Color[c.maxMove];
  boolean mannn;
  boolean winer;
  int Mode1 = 1;
  int Mode2 = 1;
  int apples, maxApples, maxMove;
  CardLayout cards = new CardLayout();
  Panel cardsPanel = new Panel();
  int status;
  Panel p;
  Menu menu; Pole pole; Butt butt;
  Table table,table2; Um um; Help help; Col col;
  Timer timer;
  GolLeft lg;
  GolRight rg;
  Ai ai[];
  boolean Detal = true;
  int faza = 0;
  int delApples = 0;
  boolean win;
  Image oreol[] = new Image[10*c.maxMove];
  int Mode10, Mode20;
  boolean change = false;
  int maxPobed;

  class Sharik {
    int x,y,z;
    int a,b;
    int forma;
    boolean svet;
    Sharik() {
      move();
      svet=false;
    }
    void move() {
      x=rrr.rand(c.xSize-c.sizeSharik)+c.sizeSharik/2;
      y=rrr.rand(c.ySize-c.sizeSharik)+c.sizeSharik/2;
      z=c.sizeSharik/2;
    }
  }
  class Svet {
    int x,y;
    int diam;
    int col;
    int im;
    Svet(Point3d p0, int diam0, int col0, int im0) {
      x=p0.x; y=p0.y;
      diam=diam0;
      col=col0;
      im=im0;
    }
  }
  class Korobok {
    Point3d k;
    int picture;
    double open;
    Vector shariki[];
    int color = 0;
    int im = 0;
    Korobok(int x0, int y0, int i) {
      k = new Point3d();
      k.x=x0; k.y=y0; k.z=0;
      picture = i;
      open=1;
    }
    void move() {
      int total=0;
      for(int i=0; i<shariki.length; i++) total+=shariki[i].size();
      int temp = rrr.rand(total)+1;
      total=shariki[0].size();
      for(color=1; temp>total; color++) total+=shariki[color].size();
      ((Sharik)(shariki[color-1].elementAt(0))).svet=true;
    }
    void add(int color) {
      shariki[color].addElement(new Sharik());
    }
    void reset() {
      color=0;
      for(int i=0; i<shariki.length; i++) {
        for(Enumeration e=shariki[i].elements(); e.hasMoreElements(); ) {
          Sharik s = (Sharik)e.nextElement();
          s.svet=false;
        }
      }
    }
    void draw(Camera cam, Graphics g, Dimension d) {
      DrawSqr(cam, k, c.xSize, c.ySize, 0, new Color(200,200,200),g,d);
      DrawSqr(cam, k, c.xSize, 0, -c.zSize, new Color(255,255,255),g,d);
      Point3d k0 = new Point3d();
      k0.x=k.x+c.xSize; k0.y=k.y; k0.z=k.z;
      Point3d k1 = new Point3d();
      k1.x=k.x; k1.y=k.y+c.ySize; k1.z=k.z;
      if (cam.a1<0) {
        DrawSqr(cam, k0,0,c.ySize,-c.zSize, new Color(225,225,225),g,d);
        if (open>0) DrawSh(cam,g,d);
        DrawSqr(cam, k,0,c.ySize,-c.zSize, new Color(225,225,225),g,d);
      }
      else {
        DrawSqr(cam, k,0,c.ySize,-c.zSize, new Color(150,150,150),g,d);
        if (open>0) DrawSh(cam,g,d);
        DrawSqr(cam, k0,0,c.ySize,-c.zSize, new Color(150,150,150),g,d);
      }
      DrawSqr(cam, k1,c.xSize,0,-c.zSize, new Color(255,255,0),g,d);
      k0.x=k.x;
      k0.y=k.y+(int)(c.ySize*open);
      k0.z=k.z;
      k1.x=k.x+c.xSize;
      k1.y=k.y+(int)(c.ySize*open);
      k1.z=k.z-c.zSize;
      DrawSqr(cam, k0,c.xSize,c.ySize,0,new Color(200,200,200),g,d);
      if (cam.a1<0) {
        DrawSqr(cam, k1, 0, c.ySize, c.zSize, new Color(225,225,225),g,d);
        DrawSqr(cam, k0, 0, c.ySize, -c.zSize, new Color(0,0,0),g,d);
      }
      else {
        DrawSqr(cam, k0, 0, c.ySize, -c.zSize, new Color(150,150,150),g,d);
        DrawSqr(cam, k1, 0, c.ySize, c.zSize, new Color(0,0,0),g,d);
      }
      DrawSqr(cam, k1,-c.xSize, c.ySize, 0, new Color(255,255,100),g,d);
      k0.z-=c.zSize;
      k0.y+=c.yyy;
      k0.x+=c.xxx;
      DrawNum(cam, k0,(c.xSize-3*c.xxx)/2,c.ySize-2*c.yyy, picture/10,g,d);
      k0.x+=(c.xSize-c.xxx)/2;
      DrawNum(cam,k0,(c.xSize-3*c.xxx)/2,c.ySize-2*c.yyy, picture%10,g,d);
    }

    void DrawSh1(Camera cam, Sharik s,Graphics g, Dimension d, int ccc, int i) {
      Point3d p = new Point3d();
      p.x=k.x+s.x;
      p.y=k.y+s.y;
      p.z=k.z+s.z;
      Point3d p0 = trans(cam, p,d);
      int diam = (int)(c.sizeSvet*c.sizeSharik*c.focus*d.width/p0.z);
      Svet sss = new Svet(p0, diam, ccc, i);
      svet.addElement(sss);
    }

    void DrawSh0(Camera cam, Sharik s,Graphics g, Dimension d) {
      Point3d p = new Point3d();
      p.x=k.x+s.x;
      p.y=k.y+s.y;
      p.z=k.z+s.z;
      Point3d p0 = trans(cam, p,d);
      int diam = (int)(c.sizeSharik*c.focus*d.width/p0.z);
      int polDiam=diam/2;
      if (Detal) { g.fillOval(p0.x-polDiam, p0.y-polDiam, diam, diam); }
      else {
        g.drawLine(p0.x-polDiam, p0.y-polDiam, p0.x+polDiam, p0.y+polDiam);
        g.drawLine(p0.x+polDiam, p0.y-polDiam, p0.x-polDiam, p0.y+polDiam);
      }
    }
    void DrawSh(Camera cam, Graphics g, Dimension d) {
      for(int i=0; i<shariki.length; i++) {
        g.setColor(colors[i]);
        for(Enumeration e=shariki[i].elements(); e.hasMoreElements(); ) {
          Sharik s = (Sharik)e.nextElement();
          if (s.svet) {
            DrawSh1(cam,s,g,d,i,im);
            im++;
            if (im==10) im=0;
          }
          else DrawSh0(cam,s,g,d);
        }
      }
    }
    void DrawNum(Camera cam,Point3d p, int xs, int ys, int i, Graphics g, Dimension d) {
      boolean d1,d2,d3,d4,d5,d6,d7;
      switch(i) {
        case(0): {
          d1=true; d2=true; d3=true; d4=false; d5=true; d6=true; d7=true;
          break;
        }
        case(1): {
          d1=false; d2=false; d3=true; d4=false; d5=false; d6=true; d7=false;
          break;
        }
        case(2): {
          d1=true; d2=false; d3=true; d4=true; d5=true; d6=false; d7=true;
          break;
        }
        case(3): {
          d1=true; d2=false; d3=true; d4=true; d5=false; d6=true; d7=true;
          break;
        }
        case(4): {
          d1=false; d2=true; d3=true; d4=true; d5=false; d6=true; d7=false;
          break;
        }
        case(5): {
          d1=true; d2=true; d3=false; d4=true; d5=false; d6=true; d7=true;
          break;
        }
        case(6): {
          d1=true; d2=true; d3=false; d4=true; d5=true; d6=true; d7=true;
          break;
        }
        case(7): {
          d1=true; d2=false; d3=true; d4=false; d5=false; d6=true; d7=false;
          break;
        }
        case(8): {
          d1=true; d2=true; d3=true; d4=true; d5=true; d6=true; d7=true;
          break;
        }
        default: {
          d1=true; d2=true; d3=true; d4=true; d5=false; d6=true; d7=true;
        }
      }
      Point3d p1 = new Point3d();
      Point3d p2 = new Point3d();
      p1.z=p.z; p2.z=p.z;
      if (d1) {
        p1.x=p.x;
        p1.y=p.y;
        p2.x=p.x+xs;
        p2.y=p.y;
        DrawSegment(cam, p1,p2,g,d);
      }
      if (d2) {
        p1.x=p.x;
        p1.y=p.y;
        p2.x=p.x;
        p2.y=p.y+ys/2;
        DrawSegment(cam, p1,p2,g,d);
      }
      if (d3) {
        p1.x=p.x+xs;
        p1.y=p.y;
        p2.x=p.x+xs;
        p2.y=p.y+ys/2;
        DrawSegment(cam, p1,p2,g,d);
      }
      if (d4) {
        p1.x=p.x;
        p1.y=p.y+ys/2;
        p2.x=p.x+xs;
        p2.y=p.y+ys/2;
        DrawSegment(cam, p1,p2,g,d);
      }
      if (d5) {
        p1.x=p.x;
        p1.y=p.y+ys/2;
        p2.x=p.x;
        p2.y=p.y+ys;
        DrawSegment(cam, p1,p2,g,d);
      }
      if (d6) {
        p1.x=p.x+xs;
        p1.y=p.y+ys/2;
        p2.x=p.x+xs;
        p2.y=p.y+ys;
        DrawSegment(cam, p1,p2,g,d);
      }
      if (d7) {
        p1.x=p.x;
        p1.y=p.y+ys;
        p2.x=p.x+xs;
        p2.y=p.y+ys;
        DrawSegment(cam, p1,p2,g,d);
      }
    }
    void DrawSegment(Camera cam, Point3d p1, Point3d p2, Graphics g, Dimension d) {
      Point3d p3 = trans(cam, p1,d);
      Point3d p4 = trans(cam, p2,d);
      g.setColor(new Color(0,0,0));
      g.drawLine(p3.x, p3.y, p4.x, p4.y);
    }
    void shake() {
      boolean space=true;
      for (int i=0; i<shariki.length; i++) {
        for(Enumeration e = shariki[i].elements(); e.hasMoreElements(); ) {
          ((Sharik)(e.nextElement())).move();
          space=false;
        }
      }
      if (space) {
        int r = rrr.rand(shariki.length);
        shariki[r].addElement(new Sharik());
      }
    }
  }
  void DrawSqr(Camera cam, Point3d p, int xSize, int ySize, int zSize, Color c, Graphics g, Dimension d) {
    Point3d p111=new Point3d();
    Point3d p222=new Point3d();
    Point3d p333=new Point3d();
    Point3d p444=new Point3d();
    p111.x=p.x; p111.y=p.y; p111.z=p.z;
    p222.x=p.x; p222.y=p.y; p222.z=p.z;
    p333.x=p.x; p333.y=p.y; p333.z=p.z;
    p444.x=p.x; p444.y=p.y; p444.z=p.z;
    if (zSize==0) {
      p222.x+=xSize;
      p333.x+=xSize; p333.y+=ySize;
      p444.y+=ySize;
    }
    if (ySize==0) {
      p222.x+=xSize;
      p333.x+=xSize; p333.z+=zSize;
      p444.z+=zSize;
    }
    if (xSize==0) {
      p222.z+=zSize;
      p333.z+=zSize; p333.y+=ySize;
      p444.y+=ySize;
    }
    Point3d p1 = trans(cam, p111,d);
    Point3d p2 = trans(cam, p222,d);
    Point3d p3 = trans(cam, p333,d);
    Point3d p4 = trans(cam, p444,d);
    Polygon poly = new Polygon();
    poly.addPoint(p1.x, p1.y);
    poly.addPoint(p2.x, p2.y);
    poly.addPoint(p3.x, p3.y);
    poly.addPoint(p4.x, p4.y);
    g.setColor(c);
    g.fillPolygon(poly);
  }
  class Ai {
    Korobok kor[];
    int xSize, ySize;
    Point3d koord;
    Camera cam = new Camera();
    Ai() {
      double temp = Math.sqrt(c.yStep*maxApples/c.xStep);
      int n=(int)temp;
      if ((int)temp!=temp) n++;
      int m = maxApples/n; if (maxApples%n!=0) m++;
      int x0 = -c.xStep*n/2;
      int x=x0;
      int y = -c.yStep*m/2;
      int cx=0;
      koord = new Point3d();
      koord.x=x-c.xBorder;
      koord.y=y-c.yBorder;
      koord.z=0;
      xSize=c.xStep*n+2*c.xBorder;
      ySize=c.yStep*m+2*c.yBorder;
      kor = new Korobok[maxApples];
      for(int i=0; i<maxApples; i++) {
        kor[i] = new Korobok(x,y,(i+1));
        x+=c.xStep;
        cx++;
        if (cx==n) { x=x0; y+=c.yStep; cx=0;}
        int kkk;
        if ((i+1)<maxMove) {kkk=i+1;}
          else {kkk=maxMove;}
        kor[i].shariki = new Vector[kkk];
        for(int j=0; j<kkk; j++) {
          kor[i].shariki[j] = new Vector();
          for(int k=0; k<sheres.slider.getValue(); k++) {
            kor[i].add(j);
          }
        }
        kor[i].reset();
      }
    }
    void pobeda() {
      switch(Mode1) {
        case(1): {
          for(int i=0; i<maxApples; i++) {
            if (kor[i].color!=0) {
              for(int j=0; j<kor[i].shariki.length; j++) {
                if ((j!=kor[i].color-1)&&(kor[i].shariki[j].size()>0)) {
                  kor[i].shariki[j].removeElementAt(0);
                  kor[i].add(kor[i].color-1);
                }
              }
              kor[i].reset();
            }
          }
          break;
        }
      }
    }
    void poragenie() {
      switch(Mode2) {
        case(1): {
          for(int i=0; i<maxApples; i++) {
            if (kor[i].color!=0) {
              for(int j=0; j<kor[i].shariki.length; j++) {
                if ((j!=kor[i].color-1)&&(kor[i].shariki[kor[i].color-1].size()>0)) {
                  kor[i].add(j);
                  kor[i].shariki[kor[i].color-1].removeElementAt(0);
                }
              }
              kor[i].reset();
            }
          }
          break;
        }
      }
    }
  }
  Game1() {
    colors[0] = new Color(255,0,0);
    colors[1] = new Color(0,255,0);
    colors[2] = new Color(0,0,255);
    colors[3] = new Color(255,0,255);
    colors[4] = new Color(255,200,0);
    colors[5] = new Color(0,255,255);
    colors[6] = new Color(255,255,0);
    p = new Panel();
    p.setLayout(new BorderLayout(0,5));
    p.add("North", help = new Help());
    Panel p0 = new Panel();
    p0.setLayout(new GridLayout(2,1,0,0));
    Panel p00 = new Panel();
    p00.setLayout(new GridLayout(1,2,2*c.zazor,0));
    p00.add(butt = new Butt());
    p00.add(table = new Table(0));
    p0.add(p00);
    p00 = new Panel();
    p00.setLayout(new BorderLayout());
    p00.add("South",menu = new Menu());
    p00.add("West",lg = new GolLeft());
    p00.add("East",rg = new GolRight());
    Panel p000 = new Panel();
    p000.setLayout(new BorderLayout());
    p000.add("South", pole = new Pole());
    Panel p0000 = new Panel();
    p0000.setLayout(new BorderLayout(5,10));
    p0000.add("West",timer = new Timer());
    p0000.add("Center",um = new Um());
    p0000.add("East",col = new Col());
    p000.add("Center",p0000);
    p00.add("Center",p000);
    p0.add(p00);
    p.add("Center",p0);
  }
  void initSpeed0(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13) {
    timeClose = i1;
    timeMove = i2;
    timeShake = i3;
    timeTake1 = i4;
    timeTake2 = i5;
    timeTake3 = i6;
    timePut1 = i7;
    timePut2 = i8;
    timePut3 = i9;
    timeClone = i10;
    timeDestr = i11;
    time_Bomb = i12;
    timeEating = i13;
  }
  void initSpeed(int i) {
    speed = i;
    timer.repaint();
    switch(i) {
      case(0): { initSpeed0(160,160,160,80,80,80,80,80,80,160,80, 8, 160); break; }
      case(1): { initSpeed0( 80, 80, 80,40,40,40,40,40,40, 80,40, 4, 80); break; }
      case(2): { initSpeed0( 40, 40, 40,20,20,20,20,20,20, 40,20, 2, 40); break; }
      case(3): { initSpeed0( 20, 20, 20,10,10,10,10,10,10, 20,10, 1, 20); break; }
      case(4): { initSpeed0(  1,  1,  1, 1, 1, 1, 1, 1, 1,  1, 1, 0, 1); break; }
      case(5): { speed = 999; break; }
      default: { speed = 1000; }
    }
  }
  void options() {
    opt.show();
  }
  void init() {
    maxApples=s1.slider.getValue();
    maxMove=s2.slider.getValue();
    ai = new Ai[2];
    ai[0] = new Ai();
    ai[1] = new Ai();
    mannn = (b3.g.getSelectedCheckbox()==b3.g1);
    winer = (b1.g.getSelectedCheckbox()==b1.g1);
    Detal = (gr.g.getSelectedCheckbox()==gr.g2);
    initSpeed(sp.slider.getValue());
    init_move();
    p1=0; p2=0;
    um.v = new Vector();
    if (mode1.ch.getSelectedItem()=="Клонирование") Mode1=1;
    if (mode1.ch.getSelectedItem()=="Перекрашивание") Mode1=2;
    if (mode1.ch.getSelectedItem()=="Нет") Mode1=3;
    if (mode2.ch.getSelectedItem()=="Уничтожение") Mode2=1;
    if (mode2.ch.getSelectedItem()=="Перекрашивание") Mode2=2;
    if (mode2.ch.getSelectedItem()=="Нет") Mode2=3;
    change = false;
    maxPobed=5;
    for(int i=0; i<c.maxMove; i++) col.aktiv[i]=false;
  }
  void init_move() {
    apples=maxApples;
    pole.start();
    pole.repaint();
    if (b2.g.getSelectedCheckbox()==b2.g1) {
      status=2;
      help.setText0("Начата новая игра. Ходит игрок 2.");
      butt.showButt();
    }
    else {
      status=0;
      help.setText0("Начата новая игра. Ходит игрок 1.");
      butt.showButt();
    }
    faza=0;
  }
  void take(int i) {
    if ((status==0)&&mannn) {
      delApples=i;
      status++;
      butt.showButt();
      lg.repaint();
    }
  }
  void endGame() {
    if (win) {
      help.setText0("Игрок1 ПОБЕДИЛ - поощрение игрока 1.");
      if (mannn) um.v.addElement(new Point(-1,0));
      else um.v.addElement(new Point(-1,1));
      p1++;
      if (p1>maxPobed) maxPobed*=2;
      lg.repaint(); rg.repaint();
    }
    else {
      help.setText0("Игрок1 ПРОИГРАЛ - наказание игрока 1.");
      if (mannn) um.v.addElement(new Point(+1,0));
      else um.v.addElement(new Point(+1,1));
      p2++;
      if (p2>maxPobed) maxPobed*=2;
      lg.repaint(); rg.repaint();
    }
    um.repaint();
  }
  void work() {
    if ((status<4)&&(change)) {
      Mode1=Mode10;
      Mode2=Mode20;
      change=false;
    }
    if (speed==999) help.setText("Включена сверх-скорость !");
    if (speed==1000) help.setText("Включена супер-сверх-скорость !!!");
    if ((speed==1000)&&(!mannn)) {
      if (status==2) { table.work(); apples-=delApples; }
      while(apples>0) {
        table2.work();
        apples-=delApples;
        if (apples==0) win=winer;
        else {
          table.work();
          apples-=delApples;
          if (apples==0) win=!winer;
        }
      }
      endGame();
      if (win) {
        faza=0; apples=0;
        while (faza!=999) table.poragenie();
        faza=0; apples=0;
        while (faza!=999) table2.pobeda();
      }
      else {
        faza=0; apples=0;
        while (faza!=999) table.pobeda();
        faza=0; apples=0;
        while (faza!=999) table2.poragenie();
      }
      init_move();
      table.repaint();
      table2.repaint();
      return;
    }
    switch (status) {
      case(0): {
        if (!mannn) {
          table2.work();
          if (faza==999) {
            status=1;
            faza=0;
            help.setText0("Игрок1 поедает яблоки");
            lg.repaint(); rg.repaint();
          }
        }
        break;
      }
      case(1): {
        pole.move();
        if (faza==999) {
          faza=0;
          if (apples>0) {
            status=2;
            help.setText0("Игрок2 думает - он берет шарик из коробка N"+String.valueOf(apples));
            lg.repaint(); rg.repaint();
          }
          else {
            win=winer;
            status=4;
            lg.repaint(); rg.repaint();
            endGame();
          }
        }
        break;
      }
      case(2): {
        table.work();
        if (faza==999) {
          status=3;
          faza=0;
          help.setText0("Игрок2 поедает яблоки");
          lg.repaint(); rg.repaint();
        }
        break;
      }
      case(3): {
        pole.move();
        if (faza==999) {
          faza=0;
          if (apples>0) {
            status=0;
            if (mannn) { help.setText0("Сейчас ваш ход."); butt.showButt();}
            else { help.setText0("Игрок1 думает - он берет шарик из коробка N"+String.valueOf(apples)); }
            lg.repaint(); rg.repaint();
          }
          else {
            win=!winer;
            status=4;
            lg.repaint(); rg.repaint();
            endGame();
          }
        }
        break;
      }
      case(4): {
        if (mannn) { table2.reset(); }
        else {
          if (win) { table2.pobeda(); }
            else { table2.poragenie(); };
        }
        if (faza==999) {
          apples=1;
          status=5;
          lg.repaint(); rg.repaint();
          faza=0;
          if (win) { help.setText0("Игрок2 ПРОИГРАЛ - наказание игрока 2."); }
          else { help.setText0("Игрок2 ПОБЕДИЛ - поощрение игрока 2."); }
        }
        break;
      }
      case(5): {
        if (win) { table.poragenie(); }
          else { table.pobeda(); }
        if (faza==999) { init_move(); lg.repaint(); rg.repaint();}
        break;
      }
    }
    table.repaint();
    if (!mannn) table2.repaint();
  }

  class Menu extends Panel {
    Menu() {
      setLayout(new GridLayout (0,6));
      add(new Button("ЧТО ЭТО ТАКОЕ"));
      add(new Button("Правила игры"));
      add(new Button("Новая игра"));
      add(new Button("Загрузить игру"));
      add(new Button("Сохранить игру"));
      add(new Button("Опции"));
    }
  }

  class Pole extends Panel {
    int dx,dy;
    int x, x0;
    int delta;
    Pole() {
      dy=30;
      setLayout(new FlowLayout(FlowLayout.CENTER,0,5));
      Hlp z = new Hlp(c.h19,300,100);
      z.resize(20,20);
      add(z);
    }
    void start() {
      x0=-dy*apples/2;
    }
    public void paint(Graphics g) {
      Dimension d = size();
      dx=d.width;
      dy=d.height;
      g.setColor(new Color(192,192,192));
      g.fillRect(0,0,dx,dy);
      g.setFont(new Font("TimesRoman",Font.BOLD,24));
      g.setColor(Color.white);
      if ((status<4)&&(apples>0)) {
        for(int i=0; i<(apples-delApples); i++) {
          g.drawImage(media.images[11], dx/2+x0+i*dy, 0, dy, dy, this);
        }
        for(int i=0; i<delApples; i++) {
          g.drawImage(media.images[11], dx/2+x+i*dy, 0, dy, dy, this);
        }
        switch(status) {
          case(0): {
            g.drawString(String.valueOf(apples), 5, dy-2);
            break;
          }
          case(1): {
            g.drawString(String.valueOf(apples)+" - "+String.valueOf(delApples)+" = "+String.valueOf(apples-delApples), 5, dy-2);
            break;
          }
          case(2): {
            g.drawString(String.valueOf(apples), dx-40, dy-2);
            break;
          }
          case(3): {
            g.drawString(String.valueOf(apples)+" - "+String.valueOf(delApples)+" = "+String.valueOf(apples-delApples), dx-120, dy-2);
            break;
          }
        }
      }
      else g.drawString("Игра окончена",dx/2-80,dy-5);
    }
    void move() {
      if (speed>=999) {
        apples-=delApples;
        delApples=0;
        faza=999;
        return;
      }
      switch(faza) {
        case(0): {
          if (status==1) {
            x=x0;
            x0+=dy*delApples;
            delta=-(dx/2+x+dy*delApples)/timeEating;
          }
          else {
            x=x0+dy*(apples-delApples);
            delta=(dx/2-x)/timeEating;
          }
          faza++;
        }
        case(1): {
          x+=delta;
          repaint();
          if ((x<=(-dx/2-dy*delApples))||(x>=dx/2)) {
            apples-=delApples;
            delApples=0;
            faza=999;
          }
          break;
        }
      }
    }
  }

  class Butt extends Panel {
    Butt() {
      cardsPanel.setLayout(cards);
      setLayout(new BorderLayout());
      add("Center",cardsPanel);
      Panel p;

      p = new Panel();
      p.add(new Label("Please wait"));
      cardsPanel.add("card0",p);

      for (int i=1; i<=c.maxMove; i++) {
        p = new Panel();
        p.setLayout(new GridLayout(0,1));
        for (int j=1; j<=i; j++) p.add(new Button(String.valueOf(j)));
        cardsPanel.add("card"+String.valueOf(i),p);
      }

      cardsPanel.add("card999",table2 = new Table(1));
    }
    void showButt() {
      if (mannn==false) {
        cards.show(cardsPanel,"card999");
        return;
      }
      if (status==0) {
        cards.show(cardsPanel,"card"+String.valueOf(Math.min(maxMove,apples)));
        return;
      }
      else {
        cards.show(cardsPanel,"card0");
        return;
      }
    }
  }

  class Table extends Panel {
    int iii;
    Dimension d = new Dimension(800,600); //???
    boolean info=false;
    int smerch = 0;
    int bomb = 0;
    int tok = 0;
    int xxx,yyy,size;
    Table(int i0) {
      iii=i0;
      setLayout(new FlowLayout(FlowLayout.RIGHT));
      Hlp z;
      if (iii==1) z = new Hlp(c.h16,300,100); 
      else z = new Hlp(c.h17,300,100);
      z.resize(20,20);
      add(z);
    }
    public void paint(Graphics g) {
      svet = new Vector();
      d = size();
      if ( (!info) || ((((c.baseA1_1-ai[iii].cam.a1)*(c.baseA1_1-ai[iii].cam.a1-ai[iii].cam.a1Step))>0)&&(((c.baseA1_2-ai[iii].cam.a1)*(c.baseA1_2-ai[iii].cam.a1-ai[iii].cam.a1Step))>0)) ) {
        ai[iii].cam.a1+=ai[iii].cam.a1Step;
        if (ai[iii].cam.a1<c.minA1) {ai[iii].cam.a1Step=(0.8*rrr.rand()+0.2)*c.maxA1Step;}
        if (ai[iii].cam.a1>c.maxA1) {ai[iii].cam.a1Step=-(0.8*rrr.rand()+0.2)*c.maxA1Step;}
      }
      if ( (!info) || (((c.baseA2-ai[iii].cam.a2)*(c.baseA2-ai[iii].cam.a2-ai[iii].cam.a2Step))>0) ) {
        ai[iii].cam.a2+=ai[iii].cam.a2Step;
        if (ai[iii].cam.a2<c.minA2) {ai[iii].cam.a2Step=(0.8*rrr.rand()+0.2)*c.maxA2Step;}
        if (ai[iii].cam.a2>c.maxA2) {ai[iii].cam.a2Step=-(0.8*rrr.rand()+0.2)*c.maxA2Step;}
      }
      double bKoef = ai[iii].ySize*c.focus/(ai[iii].cam.b+c.focus);
      if ( (!info) || (bKoef<c.baseBKoefMin) || (bKoef>c.baseBKoefMax) ) {
        ai[iii].cam.b+=ai[iii].cam.bStep;
        if ((bKoef>(c.maxBKoef))&&(ai[iii].cam.bStep<0)) ai[iii].cam.bStep=(int)((0.8*rrr.rand()+0.2)*c.maxBStep);
        if ((bKoef<(c.minBKoef))&&(ai[iii].cam.bStep>0)) ai[iii].cam.bStep=-(int)((0.8*rrr.rand()+0.2)*c.maxBStep);
      }
      Image offImage = createImage(d.width, d.height);
      Graphics gc=offImage.getGraphics();
      gc.setColor(Color.white);
      gc.fillRect(0,0,d.width, d.height);
      DrawSqr(ai[iii].cam, ai[iii].koord, ai[iii].xSize, ai[iii].ySize, 0, new Color(255,0,255), gc, d);
      Point3d p = new Point3d();
      p.x=ai[iii].koord.x;
      p.y=ai[iii].koord.y+ai[iii].ySize;
      p.z=ai[iii].koord.z;
      DrawSqr(ai[iii].cam, p, ai[iii].xSize, 0, c.stol, new Color(0,0,255),gc,d);
      if (ai[iii].cam.a1>0) p.x+=ai[iii].xSize;
      DrawSqr(ai[iii].cam, p, 0, -ai[iii].ySize, c.stol, new Color(0,255,255),gc,d);
      int x=10;
      for(int i=0; i<ai[iii].kor.length; i++) {
        ai[iii].kor[i].draw(ai[iii].cam,gc,d);
        gc.setColor(Color.black);
        gc.drawString(String.valueOf(i+1),x,10);
        int y=20;
        for(int j=0; j<ai[iii].kor[i].shariki.length; j++) {
           gc.setColor(colors[j]);
           gc.drawString( String.valueOf( ai[iii].kor[i].shariki[j].size() ), x,y);
           y+=10;
        }
        gc.setColor(new Color(0,0,0));
        gc.drawString(String.valueOf(ai[iii].kor[i].color),x,10*maxMove+20);
        x+=17;
      }
      gc.setColor(Color.lightGray);
      gc.drawLine(0,11,17*maxApples,11);
      gc.drawLine(0,10*maxMove+11,17*maxApples,10*maxMove+11);
      if (info) {
        p = new Point3d();
        p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
        p.y = ai[iii].kor[apples-1].k.y+c.ySize;
        p.z = ai[iii].kor[apples-1].k.z-c.zSize;
        p = trans(ai[iii].cam,p,d);
        gc.drawImage(media.images[6], p.x-(int)(d.width*c.sizeLupa/2), p.y-(int)(d.width*c.sizeLupa/2), (int)(d.width*c.sizeLupa), (int)(d.width*c.sizeLupa), this);
      }
      if (smerch!=0) {
        gc.drawImage(media.images[smerch+31], xxx-size/2, yyy-size/2, size, size, this);
      }
      if (bomb!=0) {
        gc.drawImage(media.images[bomb+21], xxx-size/2, yyy-size/2, size, size, this);
      }
      if (tok!=0) {
        gc.drawImage(media.images[tok+54], xxx-size/2, yyy-size/2, size, size, this);
      }
      for(Enumeration e = svet.elements(); e.hasMoreElements(); ) {
        Svet s = (Svet)(e.nextElement());
        gc.drawImage(oreol[10*s.col+s.im], s.x-s.diam/2, s.y-s.diam/2, s.diam, s.diam, this);
      }
      for(Enumeration e = svet.elements(); e.hasMoreElements(); ) {
        Svet s = (Svet)(e.nextElement());
        gc.setColor(colors[s.col]);
        gc.fillOval(s.x-s.diam/(2*c.sizeSvet), s.y-s.diam/(2*c.sizeSvet), s.diam/c.sizeSvet, s.diam/c.sizeSvet);
        gc.setColor(new Color(0,0,0));
        gc.drawOval(s.x-s.diam/(2*c.sizeSvet)-1, s.y-s.diam/(2*c.sizeSvet)-1, s.diam/c.sizeSvet+2, s.diam/c.sizeSvet+2);
      }
      gc.drawImage(media.images[51],0,0,d.width/10+1,d.height/10+1,this);
      gc.drawImage(media.images[52],9*d.width/10,0,d.width/10+1,d.height/10+1,this);
      gc.setColor(new Color(0,0,0));
      gc.drawLine(d.width/10,0,9*d.width/10,0);
      gc.setColor(new Color(0,0,0));
      gc.drawArc(0,0,d.width/5,d.height/5,90,90);
      gc.drawArc(8*d.width/10,0,d.width/5,d.height/5,0,90);
      if (iii==1) {
        gc.drawImage(media.images[54],9*d.width/10,9*d.height/10,d.width/10+1,d.height/10+1,this);
        gc.drawLine(0,d.height/10,0,d.height-1);
        gc.drawLine(d.width-1,d.height/10,d.width-1,9*d.height/10);
        gc.drawLine(c.sizeGol,d.height-1,9*d.width/10,d.height-1);
        gc.drawArc(8*d.width/10,8*d.height/10,d.width/5,d.height/5,270,90);
      }
      else {
        gc.drawImage(media.images[53],0,9*d.height/10,d.width/10+1,d.height/10+1,this);
        gc.drawLine(0,d.height/10,0,9*d.height/10);
        gc.drawLine(d.width-1,d.height/10,d.width-1,d.height-1);
        gc.drawLine(d.width/10,d.height-1,d.width-c.sizeGol,d.height-1);
        gc.drawArc(0,8*d.height/10,d.width/5,d.height/5,180,90);
      }
      g.drawImage(offImage,0,0,this);
    }
    public void update(Graphics g) {
      paint(g);
    }
    void work() {
      if (speed>=999) {
        ai[iii].kor[apples-1].shake();
        ai[iii].kor[apples-1].move();
        sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
        sharik.x=c.xSize/2;
        sharik.y=3*c.ySize/2;
        sharik.z=-c.zSize-c.sizeSharik/2;
        delApples=ai[iii].kor[apples-1].color;
        faza=999;
      }
      else {
        switch(faza) {
          case(0): { start(); break; }
          case(1): { close(); break; }
          case(2): { moveUp(); break; }
          case(3): { shake(); break; }
          case(4): { moveDown(); break; }
          case(5): { open(); break; }
          case(6): { take(); break; }
        }
      }
    }
    void start() {
      help.setText("Закрытие коробка");
      info=true;
      faza++;
    }

    void close() {
      ai[iii].kor[apples-1].open-=(1.0/timeClose);
      if (ai[iii].kor[apples-1].open<=0) {
        ai[iii].kor[apples-1].open=0;
        help.setText("Поднятие коробка");
        faza++;
      }
    }
    void moveUp() {
      ai[iii].kor[apples-1].k.z-=(c.up/timeMove);
      if (ai[iii].kor[apples-1].k.z<=-c.up) {
        koord=new Point3d();
        koord.x=ai[iii].kor[apples-1].k.x;
        koord.y=ai[iii].kor[apples-1].k.y;
        koord.z=ai[iii].kor[apples-1].k.z;
        time=0;
        help.setText("Тряска коробка");
        ai[iii].kor[apples-1].shake();
        faza++;
      }
    }
    int time;
    Point3d koord;
    void shake() {
      ai[iii].kor[apples-1].k.x=koord.x+rrr.rand(c.ampl)-c.ampl/2;
      ai[iii].kor[apples-1].k.y=koord.y+rrr.rand(c.ampl)-c.ampl/2;
      ai[iii].kor[apples-1].k.z=koord.z+rrr.rand(c.ampl)-c.ampl/2;
      time++;
      if (time>=timeShake) {
        ai[iii].kor[apples-1].k.x=koord.x;
        ai[iii].kor[apples-1].k.y=koord.y;
        ai[iii].kor[apples-1].k.z=koord.z;
        help.setText("Опускание коробка");
        faza++;
      }
    }
    void moveDown() {
      ai[iii].kor[apples-1].k.z+=(c.up/timeMove);
      if (ai[iii].kor[apples-1].k.z>=0) {
        ai[iii].kor[apples-1].k.z=0;
        help.setText("Открытие коробка");
        faza++;
      }
    }
    void open() {
      ai[iii].kor[apples-1].open+=(1.0/timeClose);
      if (ai[iii].kor[apples-1].open>=1) {
        ai[iii].kor[apples-1].open=1;
        ai[iii].kor[apples-1].move();
        sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
        dx=(0.5*c.xSize-sharik.x)/timeTake2;
        dy=(1.5*c.ySize-sharik.y)/timeTake2;
        faza0=0;
        help.setText("Поднятие шарика");
        faza++;
        col.aktiv[ai[iii].kor[apples-1].color-1]=true;
        col.repaint();
      }
    }
    int faza0;
    Sharik sharik, sharik2;
    double dx,dy;
    void take() {
      switch(faza0) {
        case(0): {
          sharik.z-=2*c.zSize/timeTake1;
          if (sharik.z<=-2*c.zSize) {
            help.setText("Перемещение шарика");
            faza0++;
          }
          break;
        }
        case(1): {
          sharik.x+=dx;
          sharik.y+=dy;
          if (sharik.y>=1.5*c.ySize) {
            help.setText("Опускание шарика");
            faza0++;
          }
          break;
        }
        case(2): {
          sharik.z+=(c.zSize-c.sizeSharik/2)/timeTake3;
          if (sharik.z>(-c.zSize-c.sizeSharik/2)) {
            delApples=ai[iii].kor[apples-1].color;
            faza=999;
            info=false;
            col.aktiv[ai[iii].kor[apples-1].color-1]=false;
            col.repaint();
          }
          break;
        }
      }
    }
    void reset() {
      for(int i=0; i<maxApples; i++) {
        if(ai[iii].kor[i].color!=0) {
          ((Sharik)(ai[iii].kor[i].shariki[ai[iii].kor[i].color-1].elementAt(0))).move();
          ai[iii].kor[i].reset();
        }
      }
      faza=999;
    }
    boolean ok;
    double koef;
    Vector vvv;
    int total;
    void pobeda() {
      switch(Mode1) {
        case(1): {
          if (speed>=999) {
            if (apples==0) apples++;
            while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
            if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
            else {
              sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
              sharik.x=c.xSize/2;
              sharik.y=c.ySize/3;
              sharik.z=-c.sizeSharik/2;
              if (ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()<c.maxBox) {
                sharik = new Sharik();
                sharik.x=c.xSize/2;
                sharik.y=2*c.ySize/3;
                sharik.z=-c.sizeSharik/2;
                ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].insertElementAt(sharik,0);
              }
              ai[iii].kor[apples-1].reset();
            }
            break;
          }
          switch(faza) {
            case(0): {
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                info=true;
                if (ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()==c.maxBox)
                  { help.setText("КОРОБОК ПЕРЕПОЛНЕН"); ok=false; faza=3; break; }
                else {
                  help.setText("Клонирование шарика");
                  smerch=0;
                  ok=true;
                  koef=0;
                  faza++;
                }
              }
            }
            case(1): {
              smerch++;
              if (smerch==6) smerch=1;
              koef+=1.0/timeClone;
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(koef*c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (koef>=1) {
                sharik.x=1*c.xSize/4;
                sharik.y=3*c.ySize/2;
                sharik.z=-c.zSize-c.sizeSharik/2;
                sharik2 = new Sharik();
                sharik2.x=3*c.xSize/4;
                sharik2.y=3*c.ySize/2;
                sharik2.z=-c.zSize-c.sizeSharik/2;
                ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].insertElementAt(sharik2,0);
                ((Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0))).svet=true;
                faza++;
              }
              break;
            }
            case(2): {
              smerch++;
              if (smerch==6) smerch=1;
              koef-=1.0/timeClone;
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(koef*c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (koef<=0) {
                smerch=0;
                help.setText("Поднятие шариков");
                faza++;
              }
              break;
            }
            case(3): {
              sharik.z-=(c.zSize-c.sizeSharik/2)/timePut1;
              if (ok) sharik2.z-=(c.zSize-c.sizeSharik/2)/timePut1;
              if (sharik.z<=(-2*c.zSize)) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(4): {
              sharik.y-=c.ySize/timePut2;
              if (ok) sharik2.y-=c.ySize/timePut2;
              if (sharik.y<=c.ySize/2) {
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(5): {
              sharik.z+=(2*c.zSize-c.sizeSharik/2)/timePut3;
              if (ok) sharik2.z+=(2*c.zSize-c.sizeSharik/2)/timePut3;
              if (sharik.z>=c.sizeSharik/2) {
                ai[iii].kor[apples-1].reset();
                faza=0;
              }
              break;
            }
          }
          break;
        }
        case(2): {
          if (speed>=999) {
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                Sharik s = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                s.x = c.xSize/2;
                s.y = c.ySize/2;
                s.z = -c.sizeSharik/2;
                for(int i=0; i<ai[iii].kor[apples-1].shariki.length; i++) {
                  if ((i!=(ai[iii].kor[apples-1].color-1))&&(ai[iii].kor[apples-1].shariki[i].size()>0)) {
                    Sharik sss = (Sharik)(ai[iii].kor[apples-1].shariki[i].elementAt(0));
                    if (ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()<c.maxBox) {
                      ai[iii].kor[apples-1].shariki[i].removeElementAt(0);
                      ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].insertElementAt(sss,0);
                    }
                    else help.setText("ПЕРЕПОЛНЕНИЕ");
                  }
                }
                ai[iii].kor[apples-1].reset();
              }
            break;
          }
          switch(faza) {
            case(0):{
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                vvv=new Vector();
                for(int i=0; i<ai[iii].kor[apples-1].shariki.length; i++) {
                  if ((i!=(ai[iii].kor[apples-1].color-1))&&(ai[iii].kor[apples-1].shariki[i].size()>0)) {
                    Sharik sss = (Sharik)(ai[iii].kor[apples-1].shariki[i].elementAt(0));
                    sss.svet=true;
                    vvv.addElement(sss);
                  }
                }
                info=true;
                ok=false;
                if (vvv.size()>0) {
                  help.setText("Поднятие шариков");
                  faza++;
                }
                else {
                  vvv.addElement((Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0)));
                  help.setText("Поднятие шариков (одного)");
                  faza=6;
                }
              }
            }
            case(1):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z-=2*c.zSize/timeTake2;
                if (sss.z<=-2*c.zSize) ok=true;
              }
              if (ok) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(2):{
              ok = true;
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                if (sss.y<3*c.ySize/2) {
                  sss.y+=c.ySize/timeTake3;
                  ok=false;
                }
              }
              if (ok) {
                ok = false;
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(3):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z+=c.zSize/timeTake2;
                if (sss.z>=-c.zSize-c.sizeSharik/2) ok=true;
              }
              if (ok) {
                help.setText("Подготовка к перекраске шариков");
                faza++;
                time=0;
                tok=0;
                koef=0;
              }
              break;
            }
            case(4):{
              tok++;
              if (tok==6) tok=1;
              koef+=1.0/timeClone;
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(koef*c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (koef>=1) {
                vvv = new Vector();
                vvv.addElement((Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0)));
                for(int i=0; i<ai[iii].kor[apples-1].shariki.length; i++) {
                  if ((i!=(ai[iii].kor[apples-1].color-1))&&(ai[iii].kor[apples-1].shariki[i].size()>0)) {
                    Sharik sss = (Sharik)(ai[iii].kor[apples-1].shariki[i].elementAt(0));
                    if (ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()<c.maxBox) {
                      ai[iii].kor[apples-1].shariki[i].removeElementAt(0);
                      ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].insertElementAt(sss,0);
                    }
                    else help.setText("ПЕРЕПОЛНЕНИЕ");
                    vvv.addElement(sss);
                  }
                }
                help.setText("Перекраска шариков завершена");
                faza++;
              }
              break;
            }
            case(5):{
              tok++;
              if (tok==6) tok=1;
              koef-=1.0/timeClone;
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(koef*c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (koef<=0) {
                tok=0;
                ok=false;
                help.setText("Поднятие шариков");
                faza++;
              }
              break;
            }
            case(6):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z-=c.zSize/timeTake2;
                if (sss.z<=-2*c.zSize) ok=true;
              }
              if (ok) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(7):{
              ok = true;
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                if (sss.y>c.ySize/2) {
                  sss.y-=c.ySize/timeTake3;
                  ok=false;
                }
              }
              if (ok) {
                ok = false;
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(8):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z+=2*c.zSize/timeTake2;
                if (sss.z>=-c.sizeSharik/2) ok=true;
              }
              if (ok) {
                faza=0;
                ai[iii].kor[apples-1].reset();
              }
              break;
            }

          }
          break;
        }
        case(3): {
          if (speed>=999) {
            if (apples==0) apples++;
            while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
            if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
            else {
              Sharik s = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
              s.x=c.xSize/2;
              s.y=c.ySize/2;
              s.z=-c.sizeSharik/2;
              ai[iii].kor[apples-1].reset();
            }
            break;
          }
          switch(faza) {
            case(0): {
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                info=true;
              }
            }
            case(1): {
              sharik.z-=(c.zSize-c.sizeSharik/2)/timePut1;
              if (ok) sharik2.z-=(c.zSize-c.sizeSharik/2)/timePut1;
              if (sharik.z<=(-2*c.zSize)) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(2): {
              sharik.y-=c.ySize/timePut2;
              if (ok) sharik2.y-=c.ySize/timePut2;
              if (sharik.y<=c.ySize/2) {
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(3): {
              sharik.z+=(2*c.zSize-c.sizeSharik/2)/timePut3;
              if (ok) sharik2.z+=(2*c.zSize-c.sizeSharik/2)/timePut3;
              if (sharik.z>=c.sizeSharik/2) {
                ai[iii].kor[apples-1].reset();
                faza=0;
              }
              break;
            }
          }
          break;
        }
      }
    }
    void poragenie() {
      switch(Mode2) {
        case(1): {
          if (speed>=999) {
            if (apples==0) apples++;
            while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
            if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
            else {
              ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].removeElementAt(0);
              ai[iii].kor[apples-1].reset();
            }
            break;
          }
          switch(faza) {
            case(0): {
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                help.setText("Уничтожение шарика");
                faza++;
                sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                time=0;
                info=true;
              }
            }
            case(1): {
              time++;
              if (time>=timeDestr) {
                ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].removeElementAt(0);
                ai[iii].kor[apples-1].reset();
                if (time_Bomb>0) {
                  bomb=0;
                  time=time_Bomb;
                  faza++;
                }
                else faza=0;
              }
              break;
            }
            case(2): {
              time++;
              if (time>time_Bomb) {bomb++; time=0;}
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (bomb==11) {
                bomb=0;
                faza=0;
              }
              break;
            }
          }
          break;
        }
        case(2): {
          if (speed>=999) {
            if (apples==0) apples++;
            while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
            if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
            else {
              Sharik s = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
              s.x=c.xSize/2;
              s.y=c.ySize/2;
              s.z=-c.sizeSharik/2;
              for(int i=0; (i<ai[iii].kor[apples-1].shariki.length)&&(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()>0); i++) {
                if (i!=ai[iii].kor[apples-1].color-1) {
                  Sharik sss = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                  if (ai[iii].kor[apples-1].shariki[i].size() < c.maxBox) {
                    ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].removeElementAt(0);
                    ai[iii].kor[apples-1].shariki[i].insertElementAt(sss,0);
                  }
                  else help.setText("ПЕРЕПОЛНЕНИЕ");
                }
              }
              ai[iii].kor[apples-1].reset();
            }
            break;
          }
          switch(faza) {
            case(0):{
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                vvv=new Vector();
                for(int i=1; (i<ai[iii].kor[apples-1].shariki.length)&&(i<ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()); i++) {
                  Sharik sss = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(i));
                  sss.svet=true;
                  vvv.addElement(sss);
                }
                info=true;
                ok=false;
                if (vvv.size()>0) {
                  help.setText("Поднятие шариков");
                  faza++;
                }
                else {
                  vvv.addElement((Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0)));
                  help.setText("Поднятие шариков (одного)");
                  faza=6;
                }
              }
            }
            case(1):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z-=2*c.zSize/timeTake1;
                if (sss.z<=-2*c.zSize) ok=true;
              }
              if (ok) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(2):{
              ok = true;
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                if (sss.y<3*c.ySize/2) {
                  sss.y+=c.ySize/timeTake2;
                  ok=false;
                }
              }
              if (ok) {
                ok = false;
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(3):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z+=c.zSize/timeTake3;
                if (sss.z>=-c.zSize-c.sizeSharik/2) ok=true;
              }
              if (ok) {
                help.setText("Подготовка к перекраске шариков");
                faza++;
                time=0;
                tok=0;
                koef=0;
              }
              break;
            }
            case(4):{
              tok++;
              if (tok==6) tok=1;
              koef+=1.0/timeClone;
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(koef*c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (koef>=1) {
                vvv = new Vector();
                for(int i=0; (i<ai[iii].kor[apples-1].shariki.length)&&(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()>0); i++) {
                  if (i!=ai[iii].kor[apples-1].color-1) {
                    Sharik sss = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                    if (ai[iii].kor[apples-1].shariki[i].size() < c.maxBox) {
                      ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].removeElementAt(0);
                      ai[iii].kor[apples-1].shariki[i].insertElementAt(sss,0);
                    }
                    else help.setText("ПЕРЕПОЛНЕНИЕ");
                    vvv.addElement(sss);
                  }
                }
                if (ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].size()>0) {
                  vvv.addElement((Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0)));
                }
                help.setText("Перекраска шариков завершена");
                faza++;
              }
              break;
            }
            case(5):{
              tok++;
              if (tok==6) tok=1;
              koef-=1.0/timeClone;
              Point3d p = new Point3d();
              p.x = ai[iii].kor[apples-1].k.x+c.xSize/2;
              p.y = ai[iii].kor[apples-1].k.y+3*c.ySize/2;
              p.z = ai[iii].kor[apples-1].k.z-c.zSize;
              p = trans(ai[iii].cam,p,d);
              xxx=p.x;
              yyy=p.y;
              size = (int)(koef*c.sizeSmerch*c.sizeSharik*c.focus*d.width/p.z);
              if (koef<=0) {
                tok=0;
                ok=false;
                help.setText("Поднятие шариков");
                faza++;
              }
              break;
            }
            case(6):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z-=c.zSize/timeTake2;
                if (sss.z<=-2*c.zSize) ok=true;
              }
              if (ok) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(7):{
              ok = true;
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                if (sss.y>c.ySize/2) {
                  sss.y-=c.ySize/timeTake3;
                  ok=false;
                }
              }
              if (ok) {
                ok = false;
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(8):{
              for(Enumeration e=vvv.elements(); e.hasMoreElements(); ) {
                Sharik sss =(Sharik)(e.nextElement());
                sss.z+=2*c.zSize/timeTake2;
                if (sss.z>=-c.sizeSharik/2) ok=true;
              }
              if (ok) {
                faza=0;
                ai[iii].kor[apples-1].reset();
              }
              break;
            }

          }
          break;
        }
        case(3): {
          if (speed>=999) {
            if (apples==0) apples++;
            while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
            if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
            else {
              Sharik s = (Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
              s.x=c.xSize/2;
              s.y=c.ySize/2;
              s.z=-c.sizeSharik/2;
              ai[iii].kor[apples-1].reset();
            }
            break;
          }
          switch(faza) {
            case(0): {
              if (apples==0) apples++;
              while ((ai[iii].kor[apples-1].color==0)&&(apples<maxApples)) apples++;
              if (ai[iii].kor[apples-1].color==0) { faza=999; info=false; break; }
              else {
                sharik=(Sharik)(ai[iii].kor[apples-1].shariki[ai[iii].kor[apples-1].color-1].elementAt(0));
                info=true;
              }
            }
            case(1): {
              sharik.z-=(c.zSize-c.sizeSharik/2)/timePut1;
              if (ok) sharik2.z-=(c.zSize-c.sizeSharik/2)/timePut1;
              if (sharik.z<=(-2*c.zSize)) {
                help.setText("Перемещение шариков");
                faza++;
              }
              break;
            }
            case(2): {
              sharik.y-=c.ySize/timePut2;
              if (ok) sharik2.y-=c.ySize/timePut2;
              if (sharik.y<=c.ySize/2) {
                help.setText("Опускание шариков");
                faza++;
              }
              break;
            }
            case(3): {
              sharik.z+=(2*c.zSize-c.sizeSharik/2)/timePut3;
              if (ok) sharik2.z+=(2*c.zSize-c.sizeSharik/2)/timePut3;
              if (sharik.z>=c.sizeSharik/2) {
                ai[iii].kor[apples-1].reset();
                faza=0;
              }
              break;
            }
          }
          break;
        }
      }
    }
  }

  class Camera {
    double a1=c.baseA1_1, a2=c.baseA2;
    int b=3000, bStep=300;
    double a1Step=0.1, a2Step=0.1;
  }

  Point3d trans(Camera cam, Point3d p0, Dimension d) {
    double tx=p0.x*Math.cos(cam.a1)-p0.y*Math.sin(cam.a1);
    double ty=p0.x*Math.sin(cam.a1)+p0.y*Math.cos(cam.a1);
    double tz=p0.z;
    double tx2=tx;
    double ty2=ty*Math.cos(cam.a2)-tz*Math.sin(cam.a2);
    double tz2=ty*Math.sin(cam.a2)+tz*Math.cos(cam.a2)+cam.b+c.focus;
    Point3d p = new Point3d();
    p.x=(int)((d.width*tx2*c.focus/tz2)+d.width/2);
    p.y=(int)((d.width*ty2*c.focus/tz2)+d.height/2);
    p.z=(int)(tz2);
    return p;
  }

  class Help extends Panel {
    String t0,t;
    Color c0,cc;
    Help() {
      resize(0,40);                 //??????????????????
      setLayout(new FlowLayout(FlowLayout.RIGHT));
      Hlp z = new Hlp(c.h14,300,100);
      z.resize(20,20);
      add(z);
      t0 = new String("Глобальная помощь");
      t = new String("Локальная помощь");
      c0 = Color.black;
      cc = Color.black;
    }

    public void paint(Graphics g) {
      Dimension d = size();
      g.setColor(Color.lightGray);
      g.fillRect(0, 0, d.width, d.height);
      g.setFont(new Font("TimesRoman", Font.BOLD, 20));
      g.setColor(c0);
      g.drawString(t0,5,d.height/2);
      g.setFont(new Font("TimesRoman", Font.ITALIC, 20));
      g.setColor(cc);
      g.drawString(t,5,d.height-3);
    }
    void setText0(String s) {
      t0 = s;
      c0 = new Color(rrr.rand(150), rrr.rand(150), rrr.rand(150));
      repaint();
    }
    void setText(String s) {
      t = s;
      cc = new Color(rrr.rand(150), rrr.rand(150), rrr.rand(150));
      repaint();
    }
  }

  class Um extends Panel {
    Vector v = new Vector();
    Um() {
      setLayout(new FlowLayout(FlowLayout.RIGHT));
      Hlp z = new Hlp(c.h18,300,100);
      z.resize(20,20);
      add(z);
    }
    public void paint(Graphics g) {
      Dimension d = size();
      int dx=d.width;
      int dy=d.height-5;
      g.setColor(new Color(240,240,240));
      int sy = v.size();
      sy+=10-(sy%10);
      int sx=2*sy;
      for(int i=1; i<sx; i++)
        g.drawLine(i*dx/sx, 0, i*dx/sx, dy-1);
      for(int i=1; i<sy; i++)
        g.drawLine(0, i*dy/sy, dx-1, i*dy/sy);
      g.setColor(new Color(0,0,0));
      g.drawLine(0, dy, dx-1, dy);
      g.drawLine(0, dy, 10, dy-5);
      g.drawLine(0, dy, 10, dy+4);
      g.drawLine(dx-1, dy, dx-10, dy-5);
      g.drawLine(dx-1, dy, dx-10, dy+4);
      g.drawLine(dx/2, 0, dx/2, dy-1);
      g.drawLine(dx/2, 0, dx/2-5, 10);
      g.drawLine(dx/2, 0, dx/2+5, 10);
      int x = 0;
      int y = 0;
      for(Enumeration e = v.elements(); e.hasMoreElements(); ) {
        Point p = (Point)(e.nextElement());
        if (p.y==0) { g.setColor(new Color(255,0,0)); }
        else { g.setColor(new Color(0,0,255)); }
        g.drawLine(dx/2+x*dx/sx, dy-y*dy/sy, dx/2+(x+p.x)*dx/sx, dy-(y+1)*dy/sy);
        y++;
        x+=p.x;
      }
      g.setColor(new Color(0,0,0));
      g.setFont(new Font("TimesRoman",Font.BOLD,18));
      g.drawString("Ум1",5,dy-5);
      g.drawString("Ум2",dx-40,dy-5);
      g.drawString("Время "+String.valueOf(v.size()), dx/2-35, 18);
    }
  }

  class Options extends Frame {
    sliderData sp0 = new sliderData("Скорость игры",3,0,7, new Hlp(c.h4,300,200));
    boxData b30 = new boxData("Компьютер играет с","человеком","компьютером",false, new Hlp(c.h8,300,100));
    boxData gr0 = new boxData("Уровень графики","Низкий","Высокий",false, new Hlp(c.h9,300,100));
    spisData mode10 = new spisData("Стратегия поощрения",c.ttt1, new Hlp(c.h12,300,150));
    spisData mode20 = new spisData("Стратегия наказания",c.ttt2, new Hlp(c.h13,300,150));
    Options() {
      super("Опции игры");
      resize(400,200);
      setLayout(new GridLayout(0,1));
      add(sp0);
      add(b30);
      add(mode10);
      add(mode20);
      add(gr0);
      Panel p = new Panel();
      p.setLayout(new GridLayout(1,2));
      p.add(new Button("Отмена"));
      p.add(new Button("Применить"));
      add(p);
    }
    public boolean action(Event evt, Object obj) {
      if (evt.target instanceof Button) {
        String label=(String)obj;
        if (label.equals("Отмена")) {
          hide();
          return true;
        }
        if (label.equals("Применить")) {
          initSpeed(sp0.slider.getValue());
          mannn = (b30.g.getSelectedCheckbox()==b30.g1);
          butt.showButt();
          Detal = (gr0.g.getSelectedCheckbox()==gr0.g2);
          if (mode10.ch.getSelectedItem()=="Клонирование") Mode10=1;
          if (mode10.ch.getSelectedItem()=="Перекрашивание") Mode10=2;
          if (mode10.ch.getSelectedItem()=="Нет") Mode10=3;
          if (mode20.ch.getSelectedItem()=="Уничтожение") Mode20=1;
          if (mode20.ch.getSelectedItem()=="Перекрашивание") Mode20=2;
          if (mode20.ch.getSelectedItem()=="Нет") Mode20=3;
          change=true;
          hide();
          return true;
        }
      }
      return false;
    }
  }

  class GolLeft extends Panel {
    GolLeft() {
      setLayout(new FlowLayout(FlowLayout.RIGHT,2,15));
      Hlp z = new Hlp(c.h21,300,100);
      z.resize(20,20);
      add(new Pusto(c.sizeGol-20-2*3));
      add(z);
    }
    public void paint(Graphics g) {
      Dimension d = size();
      g.setColor(Color.lightGray);
      g.fillRect(0,0,d.width,d.height);
      Image i,i2;
      if (status<4) {
        i=media.images[37+status];
        i2=media.images[7+status];
      }
      else {
        if (win) i=media.images[42];
        else i=media.images[43];
        if (status==4) i2=media.images[7];
        else i2=media.images[9];
      }
      g.drawImage(i, 0, d.height-d.width-1, d.width, d.width, this);
      g.setColor(Color.white);
      g.fillArc(0,-(d.height-d.width),d.width,2*(d.height-d.width),180,90);
      g.fillRect(d.width/2,0,d.width/2,d.height-d.width);
      g.setColor(Color.lightGray);
      g.fillArc(d.width/2,0,d.width,2*(d.height-d.width),90,90);
      g.setColor(Color.black);
      g.drawArc(0,-(d.height-d.width),d.width,2*(d.height-d.width),180,90);
      g.drawArc(d.width/2,0,d.width,2*(d.height-d.width),90,90);
      g.drawImage(i2,d.width/10,0,d.width/2,d.width,this);
      g.setColor(Color.cyan);
      g.fillOval(6*d.width/10,d.height-14*d.width/10,4*d.width/10,4*d.width/10);
      g.fillRect(7*d.width/10,40,2*d.width/10,d.height-12*d.width/10-40);
      g.setColor(Color.red);
      g.fillOval(65*d.width/100,d.height-135*d.width/100,3*d.width/10,3*d.width/10);
      int t=p1*(d.height-12*d.width/10-40)/maxPobed;
      g.fillRect(75*d.width/100,d.height-12*d.width/10-t,1*d.width/10,t);
      g.setFont(new Font("TimesRoman",Font.BOLD,20));
      g.setColor(new Color(0,0,0));
      g.drawString(String.valueOf(p1)+"*C",5, d.height-3*d.width/2);
    }
  }
  class GolRight extends Panel {
    GolRight() {
      setLayout(new FlowLayout(FlowLayout.RIGHT,2,15));
      Hlp z = new Hlp(c.h22,300,100);
      z.resize(20,20);
      add(z);
      add(new Pusto(c.sizeGol-20-2*3));
    }
    public void paint(Graphics g) {
      Dimension d = size();
      g.setColor(Color.lightGray);
      g.fillRect(0,0,d.width,d.height);
      Image i,i2;
      if (status<4) {
        i=media.images[44+status];
        if (status<2) {
          i2=media.images[9+status];
        }
        else {
          i2=media.images[5+status];
        }
      }
      else {
        if (!win) i=media.images[42];
        else i=media.images[43];
        if (status==5) i2=media.images[7];
        else i2=media.images[9];
      }
      g.drawImage(i, 0, d.height-d.width-1, d.width, d.width, this);
      g.setColor(Color.white);
      g.fillArc(0,-(d.height-d.width),d.width,2*(d.height-d.width),-90,90);
      g.fillRect(0,0,d.width/2,d.height-d.width);
      g.setColor(Color.lightGray);
      g.fillArc(-d.width/2,0,d.width,2*(d.height-d.width),0,90);
      g.setColor(Color.black);
      g.drawArc(0,-(d.height-d.width),d.width-1,2*(d.height-d.width),-90,90);
      g.drawArc(-d.width/2,0,d.width,2*(d.height-d.width),0,90);
      g.drawImage(i2,2*d.width/5,0,d.width/2,d.width,this);
      g.setColor(Color.cyan);
      g.fillOval(0,d.height-14*d.width/10,4*d.width/10,4*d.width/10);
      g.fillRect(1*d.width/10,40,2*d.width/10,d.height-12*d.width/10-40);
      g.setColor(Color.red);
      g.fillOval(5*d.width/100,d.height-135*d.width/100,3*d.width/10,3*d.width/10);
      int t=p2*(d.height-12*d.width/10-40)/maxPobed;
      g.fillRect(15*d.width/100,d.height-12*d.width/10-t,1*d.width/10,t);
      g.setFont(new Font("TimesRoman",Font.BOLD,20));
      g.setColor(new Color(0,0,0));
      g.drawString(String.valueOf(p2)+"*C",5, d.height-3*d.width/2);
    }
  }

  class Timer extends Panel {
    int dx,dy;
    int next=999;
    Timer() {
      setLayout(new FlowLayout(FlowLayout.RIGHT,5,5));
      Hlp z = new Hlp(c.h15,300,100);
      z.resize(20,20);
      add(new Pusto(125-3*5-20));
      add(z);
    }
    public void paint(Graphics g) {
      Dimension d = size();
      dx=d.width;
      dy=d.height;
      for(int i=0; i<8; i++) {
        switch(i) {
          case(0):
          case(1):
          case(2):
          case(3): { g.setColor(Color.green); break; }
          case(4): { g.setColor(Color.yellow); break; }
          case(5):
          case(6): { g.setColor(Color.red); break; }
          case(7): { g.setColor(Color.gray); break; }
        }
        g.fillArc(0,0,dx,dy,225-45*i,-45);
        g.setColor(Color.black);
        g.drawLine(dx/2,dy/2,ax(-225+45*i,1),ay(-225+45*i,1));
        if (i!=next) g.setFont(new Font("TimesRoman",Font.BOLD,14));
        else {
          g.setColor(Color.blue);
          g.setFont(new Font("TimesRoman",Font.BOLD,24));
        }
        if (i<7) g.drawString(String.valueOf(i),ax(-202+45*i,0.85),ay(-202+45*i,0.85)+7);
      }
      g.setColor(Color.gray);
      g.fillOval(dx/5, dy/5, 3*dx/5, 3*dy/5);
      g.setColor(Color.black);
      g.drawOval(0, 0, dx, dy);
      g.drawOval(dx/5, dy/5, 3*dx/5, 3*dy/5);
      int s = speed;
      if (s==999) s=5;
      if (s==1000) s=6;
      g.setColor(Color.pink);
      g.setFont(new Font("TimesRoman",Font.PLAIN,20));
      g.drawString("км/час",dx/2-30,65*dy/100);
      g.setColor(Color.white);
      g.fillArc(dx/5, dy/5, 3*dx/5, 3*dy/5, 225-45*s,-45);
      g.fillOval(9*dx/20, 9*dy/20, dx/10, dy/10);
    }
    int ax(int a, double d) {
      return (int)(dx*((1-d)/2+d*0.5*(1+Math.cos(3.1416*(a)/180))));
    }
    int ay(int a, double d) {
      return (int)(dy*((1-d)/2+d*0.5*(1+Math.sin(3.1416*(a)/180))));
    }
    public boolean mouseMove(Event evt, int x, int y) {
      x-=dx/2;
      y-=dy/2;
      if ((x>=0)&&(y>=0)&&(x>=y)) next=5;
      if ((x>=0)&&(y>=0)&&(x<y)) next=6;
      if ((x>=0)&&(y<0)&&(x>=-y)) next=4;
      if ((x>=0)&&(y<0)&&(x<-y)) next=3;
      if ((x<0)&&(y>=0)&&(-x>=y)) next=0;
      if ((x<0)&&(y>=0)&&(-x<y)) next=999;
      if ((x<0)&&(y<0)&&(-x>=-y)) next=1;
      if ((x<0)&&(y<0)&&(-x<-y)) next=2;
      repaint();
      return true;
    }
    public boolean mouseExit(Event evt, int x, int y) {
      next=999;
      repaint();
      return true;
    }
    public boolean mouseDown(Event evt, int x, int y) {
      if (next!=999) initSpeed(next);
      repaint();
      return true;
    }
  }

  class Col extends Panel {
    boolean aktiv[] = new boolean[c.maxMove];
    Col() {
      setLayout(new FlowLayout(FlowLayout.RIGHT,5,5));
      Hlp z = new Hlp(c.h20,300,100);
      z.resize(20,20);
      add(new Pusto(125-3*5-20));
      add(z);
    }
    public void paint(Graphics g) {
      Dimension d = size();
      int dx = d.width;
      int dy = d.height-3;
      for(int i=0; i<maxMove; i++) {
        g.setColor(colors[i]);
        g.fillRect(0, 3+i*dy/maxMove, dx, dy/maxMove);
        if (aktiv[i]) {
          g.setColor(Color.black);
          g.drawLine(6*dx/10,3+i*dy/maxMove,dx,3+(i+1)*dy/maxMove);
          g.drawLine(6*dx/10,3+(i+1)*dy/maxMove,dx,3+i*dy/maxMove);
          g.setColor(Color.black);
          g.setFont(new Font("TimesRoman",Font.BOLD,28));
        }
        else {
          g.setColor(Color.white);
          g.setFont(new Font("TimesRoman",Font.ITALIC,20));
        }
        String s = String.valueOf(i+1);
        g.drawString("Взять "+s, 5, 3+(i+1)*dy/maxMove-5);
      }
    }
  }

  class Pusto extends Canvas {
    Pusto(int size) {
      resize(size,0);
    }
  }
}


