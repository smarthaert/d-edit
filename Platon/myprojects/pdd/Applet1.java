package pdd;

import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import javax.swing.*;
import java.awt.image.*;

class asd extends Canvas {
  public void paint(Graphics g) {
    g.drawImage(data.offImage,0,0,590,390,this);
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
}

public class Applet1 extends Applet implements Runnable {

asd kkk = new asd();
Thread workThread;
CardLayout cards;
Panel cardsPanel;

  public void init() {
    data.html = new int[17];
    data.html[0]=getParam("humanWidth",100);
    data.html[1]=getParam("humanHeight",100);
    data.html[2]=getParam("dogWidth",100);
    data.html[3]=getParam("dogHeight",100);
    data.html[4]=getParam("dogX",100);
    data.html[5]=getParam("dogY",100);
    data.html[6]=getParam("humanNum",2);
    data.html[7]=getParam("dogNum",2);
    data.html[8]=getParam("humanSpeed",2);
    data.html[9]=getParam("dogSpeed",1);
    data.html[10]=getParam("totalHeros",5);
    data.html[11]=getParam("pauseDog1",3000);
    data.html[12]=getParam("pauseDog2",3000);
    data.html[13]=getParam("baseSpeed",1);
    data.html[14]=getParam("widthHuman3d",10);
    data.html[15]=getParam("heightHuman3d",10);
    data.html[16]=getParam("timeRun",100);
    int a = getParam("numHeros",0);
    data.heros=new hero[a];
    for(int i=0; i<a; i++) {
      data.heros[i] = new hero();
      data.heros[i].width=(double)getParam("width"+itoa(i),0)/1000;
      data.heros[i].height=(double)getParam("height"+itoa(i),0)/1000;
      data.heros[i].speed=(double)getParam("speed"+itoa(i),0)/1000;
      data.heros[i].pause=getParam("pause"+itoa(i),0);
      int b = getParam("numHero"+itoa(i),0);
      data.heros[i].im = new Image[b];
      for(int j=0; j<b; j++) {
        data.heros[i].im[j]=load_im("hero"+itoa(i)+"//image"+itoa(j)+".jpg");
      }
    }
    data.offImage=createImage(600,400); //????
    data.gc=data.offImage.getGraphics();
    initImages();
    initScenes();
    setLayout(new BorderLayout());
    cardsPanel = new Panel();
    cards = new CardLayout();
    cardsPanel.setLayout(cards);
    for(int i=0; i<c.numScenes; i++) {
      cardsPanel.add("scene"+itoa(i), data.scenes[i]);
    }
    cardsPanel.add("scene0002",data.scene3 = new Scene3());
    add("Center",cardsPanel);
    sled();
  }

  public void start() {
    workThread = new Thread(this);
    workThread.start();
  }

  public void run() {
    while(true) {
//      data.currScene++;
 //     if (data.currScene>=c.numScenes) data.currScene=0;
 //     cards.show(cardsPanel,"scene"+itoa(data.currScene));
      if (data.currScene<c.numScenes) data.scenes[data.currScene].repaint();
      else data.scene3.repaint();
      showStatus("Частота кадров: "+String.valueOf(data.frames0));
      try { Thread.sleep(c.sleepTime); }
      catch (InterruptedException e) {}
    }
  }

  public void stop() {
    if (workThread != null) {
      workThread.stop();
    }
  }

  public void destroy() {
  }

  //Преобразование числа в строку
  String itoa(int i) {
    String s = String.valueOf(i);
    switch(s.length()) {
      case(1): { s="000"+s; break; }
      case(2): { s="00"+s; break; }
      case(3): { s="0"+s; break; }
    }
    return s;
  }

  Image load_im(String name) {
    MediaTracker tracker = new MediaTracker(this);
    Image im = getImage(getDocumentBase(),name);
    ImageFilter filter = new MaskaFilter();
    ImageProducer src = im.getSource();
    ImageProducer producer = new FilteredImageSource(src, filter);
    Image res=createImage(producer);
    tracker.addImage(res,0);
    try {tracker.waitForAll();}
    catch (InterruptedException e) {}
    return res;
  }

  //Загрузка графики
  void initImages() {
    showStatus("Идет загрузка графики...");
    MediaTracker tracker = new MediaTracker(this);
    for (int i=0; i<c.numImages; i++) {
      Image im = getImage(getDocumentBase(),"image\\image"+itoa(i)+".jpg");
      ImageFilter filter = new MaskaFilter();
      ImageProducer src = im.getSource();
      ImageProducer producer = new FilteredImageSource(src, filter);
      data.images[i]=createImage(producer);
      tracker.addImage(data.images[i],0);
    }
    for(int i=0; i<c.numFones; i++) {
      data.fonIm[i] = new FonIm(data.sizes[i]);
      for(int j=0; j<data.sizes[i]; j++) {
        Image im = getImage(getDocumentBase(),"fon"+itoa(i)+"\\image"+itoa(j)+".jpg");
        tracker.addImage(im,0);
        try { tracker.waitForAll(); }
        catch (InterruptedException e) {}
        data.fonIm[i].Im[j] = createImage(600,400);
        Graphics g = data.fonIm[i].Im[j].getGraphics();
        g.drawImage(im,0,0,this);
      }
    }
    data.human=new Image[data.html[6]];
    for(int i=0; i<data.html[6]; i++) {
      Image im = getImage(getDocumentBase(),"human\\image"+itoa(i)+".jpg");
      ImageFilter filter = new MaskaFilter();
      ImageProducer src = im.getSource();
      ImageProducer producer = new FilteredImageSource(src, filter);
      data.human[i]=createImage(producer);
      tracker.addImage(data.human[i],0);
    }
    data.dog=new Image[data.html[7]];
    data.dog2=new Image[data.html[7]];
    for(int i=0; i<data.html[7]; i++) {
      Image im = getImage(getDocumentBase(),"dog\\image"+itoa(i)+".jpg");
      Image im2 = getImage(getDocumentBase(),"dog2\\image"+itoa(i)+".jpg");
      ImageFilter filter = new MaskaFilter();
      ImageProducer src = im.getSource();
      ImageProducer src2 = im2.getSource();
      ImageProducer producer = new FilteredImageSource(src, filter);
      ImageProducer producer2 = new FilteredImageSource(src2, filter);
      data.dog[i]=createImage(producer);
      tracker.addImage(data.dog[i],0);
      data.dog2[i]=createImage(producer2);
      tracker.addImage(data.dog2[i],0);
    }
    data.elem = new Elem0[4];
    data.elem[0] = new Elem0(5);
    data.elem[1] = new Elem0(3);
    data.elem[2] = new Elem0(3);
    data.elem[3] = new Elem0(4);
    data.elem[0].el[0] = getImage(getDocumentBase(),"sveto\\s_zero.jpg");
    tracker.addImage(data.elem[0].el[0],0);
    data.elem[0].el[1] = getImage(getDocumentBase(),"sveto\\s_red.gif");
    tracker.addImage(data.elem[0].el[1],0);
    data.elem[0].el[2] = getImage(getDocumentBase(),"sveto\\s_red_yellow.gif");
    tracker.addImage(data.elem[0].el[2],0);
    data.elem[0].el[3] = getImage(getDocumentBase(),"sveto\\s_green.gif");
    tracker.addImage(data.elem[0].el[3],0);
    data.elem[0].el[4] = getImage(getDocumentBase(),"sveto\\s_yellow.gif");
    tracker.addImage(data.elem[0].el[4],0);
    data.elem[1].el[0] = getImage(getDocumentBase(),"polog\\image0000.jpg");
    tracker.addImage(data.elem[1].el[0],0);
    data.elem[1].el[1] = getImage(getDocumentBase(),"polog\\image0001.jpg");
    tracker.addImage(data.elem[1].el[1],0);
    data.elem[1].el[2] = getImage(getDocumentBase(),"polog\\image0002.jpg");
    tracker.addImage(data.elem[1].el[2],0);
    data.elem[2].el[0] = getImage(getDocumentBase(),"nogi\\image0000.jpg");
    tracker.addImage(data.elem[2].el[0],0);
    data.elem[2].el[1] = getImage(getDocumentBase(),"nogi\\image0001.jpg");
    tracker.addImage(data.elem[2].el[1],0);
    data.elem[2].el[2] = getImage(getDocumentBase(),"nogi\\image0002.jpg");
    tracker.addImage(data.elem[2].el[2],0);
    data.elem[3].el[0] = getImage(getDocumentBase(),"golova\\image0000.jpg");
    tracker.addImage(data.elem[3].el[0],0);
    data.elem[3].el[1] = getImage(getDocumentBase(),"golova\\image0001.jpg");
    tracker.addImage(data.elem[3].el[1],0);
    data.elem[3].el[2] = getImage(getDocumentBase(),"golova\\image0002.jpg");
    tracker.addImage(data.elem[3].el[2],0);
    data.elem[3].el[3] = getImage(getDocumentBase(),"golova\\image0003.jpg");
    tracker.addImage(data.elem[3].el[3],0);
    for(int i=0; i<6; i++) {
      data.human3d[i] = load_im("human3d\\image"+itoa(i)+".jpg");
      data.human3d2[i] = load_im("human3d2\\image"+itoa(i)+".jpg");
    }
    try {tracker.waitForAll();}
    catch (InterruptedException e) {}
    showStatus("Графика загружена.");
  }

  void initScenes() {
    data.scenes[0] = new Scene(Math.PI/4, -54.7*Math.PI/180, 86.6, 1.2, 1.8);
    data.scenes[0].add(new Fon(0));
    data.scenes[0].add(data.cars[0] = new Car3(1,-8,-80,-1));
    data.scenes[0].add(data.cars[1] = new Car3(2,-80,+2,-1));
    data.scenes[0].add(data.cars[2] = new Car3(3,+8,+80,-1));
    data.scenes[0].add(data.cars[3] = new Car3(4,+80,-2,-1));
    data.scenes[0].add(data.cars[4] = new Car3(1,-8,-80,-1));
    data.scenes[0].add(data.cars[5] = new Car3(2,-80,+2,-1));
    data.scenes[0].add(data.cars[6] = new Car3(3,+8,+80,-1));
    data.scenes[0].add(data.cars[7] = new Car3(4,+80,-2,-1));
    data.scenes[0].add(data.cars[8] = new Car3(1,-8,-80,-1));
    data.scenes[0].add(data.cars[9] = new Car3(2,-80,+2,-1));
    data.scenes[0].add(data.cars[10] = new Car3(3,+8,+80,-1));
    data.scenes[0].add(data.cars[11] = new Car3(4,+80,-2,-1));
//    data.scenes[0].add(new Car2(5,0,100,0,0,2.8,-0.04));
    data.scenes[0].add(new Sveto(+16,+15,-1));
    data.scenes[0].add(new Sveto(+25,-6,-1));
    data.scenes[0].add(new Sveto(-25,+6,-1));
    data.scenes[0].add(new Sveto(-16,-15,-1));
    data.scenes[0].add(data.humans[0] = new Human123(-50,-8,0,1));
    data.scenes[0].add(data.humans[1] = new Human123(-50,12,0,1));
    data.scenes[0].add(data.humans[2] = new Human123(20,-50,0,2));
    data.scenes[0].add(data.humans[3] = new Human123(-20,-50,0,2));
    data.scenes[1] = new Scene(0, -74.5*Math.PI/180, 18.682, 1.2, 1.8);
    data.scenes[1].add(new Fon(1));
    data.scenes[1].add(new Human0());
    for(int i=0; i<data.html[10]; i++) {
      data.scenes[1].add(new Human1());
    }
//    data.scenes[1].add(new House1());
    data.scenes[2] = new Scene(Math.PI/4, -54.7*Math.PI/180, 86.6, 1.2, 1.8);
    data.scenes[2].add(new Fon(0));
    data.scenes[2].add(new Sveto(+17,+15,-1));
    data.scenes[2].add(new Sveto(+25,-7,-1));
    data.scenes[2].add(new Sveto(-25,+7,-1));
    data.scenes[2].add(new Sveto(-17,-15,-1));
    data.scenes[2].add(data.cars[0]);
    data.scenes[2].add(data.cars[1]);
    data.scenes[2].add(data.cars[2]);
    data.scenes[2].add(data.cars[3]);
    data.scenes[2].add(data.cars[4]);
    data.scenes[2].add(data.cars[5]);
    data.scenes[2].add(data.cars[6]);
    data.scenes[2].add(data.cars[7]);
    data.scenes[2].add(data.cars[8]);
    data.scenes[2].add(data.cars[9]);
    data.scenes[2].add(data.cars[10]);
    data.scenes[2].add(data.cars[11]);
    data.scenes[2].add(data.humans[0]);
//    data.scenes[2].add(new butt0(300,0,90,30));
//    data.scenes[2].add(new butt1(400,0,90,30));
  }

  class MaskaFilter extends RGBImageFilter {
    boolean maska=false;
    int rs, gs, bs,
        rb, gb, bb;
    public MaskaFilter() {
      canFilterIndexColorModel = false;
    }
    public int filterRGB(int x, int y, int rgb) {
      int r = ((rgb&0x00ff0000)>>16);
      int g = ((rgb&0x0000ff00)>>8);
      int b = ((rgb&0x000000ff));
      if ( (x==0) && (y==0) && ((r<=10)||(g<=10)||(b<=10)) ) {
        rs = r-c.colorSmooth; rb = r+c.colorSmooth;
        gs = g-c.colorSmooth; gb = g+c.colorSmooth;
        bs = b-c.colorSmooth; bb = b+c.colorSmooth;
        maska=true;
      }
      if (maska&&(r>rs)&&(r<rb)&&(g>gs)&&(g<gb)&&(b>bs)&&(b<bb)) return 0;
      else return rgb;
    }
  }

  public boolean mouseDown(Event evt, int x, int y) {
    if ((x<=100)&&(y<=30)) {
      data.currScene++;
      if (data.currScene==2) {
        sled();
        f.setAktiv(data.aktiv);                   //???
      }
      cards.show(cardsPanel,"scene"+itoa(data.currScene));
    }
/*    if ((data.text!="")&&(data.currScene==2)&&(y-data.scenes[2].location().y>=data.scenes[2].size().height-30)&&(x-data.scenes[2].location().x>=data.scenes[2].size().width/2-50)&&(x-data.scenes[2].location().x<=data.scenes[2].size().width/2+50)) {
      data.cards0.show(data.cardsPanel0,"a");  //////////////////////
      for(int i=0; i<c.maxCars; i++) {
        data.cars[i].reset();
      }
      data.faza=0;
      data.colAktiv=0;
      if (data.save) {
        f.setAktiv(0);
        data.save=false;
      }
      data.text="";
    } */
    else if (data.faza==0) data.scenes[data.currScene].mouse(x,y);
    return true;
  }

  public boolean mouseMove(Event evt, int x, int y) {
    data.cursor=x;
    data.moveFaza=0;
    data.timeMove=System.currentTimeMillis();
    return true;
  }

  void sled() {
    data.scene3.l.create();
    data.aktiv=0;
    f.gen_new();
//    data.scene3.cards.show(data.scene3.cardsPanel,"1");
    f.setAktiv(0);
    data.cards1.show(data.cardsPanel1,"1");
    data.resheno=false;
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label = (String)obj;
      if (label.equals("Следующая")) {
        data.cards1.show(data.cardsPanel1,"1");
        for(int i=0; i<c.maxCars; i++) {
          data.cars[i].reset();
        }
        data.faza=0;
        data.colAktiv=0;
        if (data.save) {
          f.setAktiv(0);
          data.save=false;
        }
        data.text="";
        sled();
        return true;
      }
      if (label.equals("Проверить")) {
        data.pusk=false;
///        data.cards0.show(data.cardsPanel0,"b"); ////////////////////////
        data.scene3.l.test();
        return true;
      }
      if (label.equals("Выше")) {
        if (data.aktiv!=0) f.setAktiv(data.aktiv-1);
        else f.setAktiv(c.max-1);
        return true;
      }
      if (label.equals("Ниже")) {
        if (data.aktiv!=(c.max-1)) f.setAktiv(data.aktiv+1);
        else f.setAktiv(0);
        return true;
      }
      if (label.equals("Выход")) {
        cards.show(cardsPanel,"scene0000");
        data.currScene=0;
        data.izobr=true;
        return true;
      }
      if (label.equals("Создать")) {
        if ((data.faza==0)||(data.faza==2)) {
          f.gen_new();
        }
        return true;
      }
      if (label.equals("Пуск")) {
        if (data.izobr==true) {
          data.pusk=true;
          f.pusk();
        }
        return true;
      }
      if (label.equals("Удалить")) {
        data.izobr=false;
        data.pusto=true;
        ((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el1.value=0;
        ((And2)data.scene3.l.right.v.elementAt(data.aktiv)).el2.value=0;
        return true;
      }
      if (label.equals("Исправить")) {
        data.cards1.show(data.cardsPanel1,"1");
        for(int i=0; i<c.maxCars; i++) {
          data.cars[i].reset();
        }
        data.faza=0;
        data.colAktiv=0;
        if (data.save) {
          f.setAktiv(0);
          data.save=false;
        }
        data.text="";
        return true;
      }
      if (label.equals("Справка")) {
        data.scene3.hlp.show();
        return true;
      }
      if (label.equals("")) {
        return true;
      }
    }
    return false;
  }

  public int getParam(String p, int d) {
    try {
      d = Integer.parseInt(getParameter(p));
    }
    catch (NumberFormatException e) {}
    return d;
  }

  public boolean keyDown(Event evt, int key) {
    if (key==32) data.turbo=true;
    return true;
  }

  public boolean keyUp(Event evt, int key) {
    if (key==32) data.turbo=false;
    return true;
  }
}

class Help extends Frame {
  Help() {
    super("Помощь");
    resize(300,200);
    hide();
    setLayout(new BorderLayout());
    add("Center",new TextArea(c.help));
    add("South",new Button("OK"));
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label = (String)obj;
      if (label.equals("OK")) {
        data.scene3.hlp.hide();
        return true;
      }
    }
    return false;
  }
}
