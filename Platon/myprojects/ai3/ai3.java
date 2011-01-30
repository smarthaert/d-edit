package ai3;

import java.awt.*;
import java.applet.*;
import java.util.*;
import java.awt.image.*;

//ГЛАВНЫЙ КЛАСС АПЛЕТА

public class ai3 extends Applet implements Runnable {

  Thread workThread = null;
  long startTime = System.currentTimeMillis();
  int frames = 0;
  boolean save = true;
  int game = 0;
  CardLayout cards = new CardLayout();
  Panel cardsPanel = new Panel();
  String lastCard, currentCard, nextCard;
  Game1 g1 = new Game1();

  public void init() {
    initCards();                        //Инициализация карт
    initImages();                       //Инициализация графики
  }

  public void start() {
    workThread = new Thread(this);
    workThread.start();
  }

  public void run() {
    while (true) {
      switch (game) {
        case(1): { g1.work(); break; }
      }
      out_speed();
      try {Thread.sleep(c.sleepTime); }
      catch (InterruptedException e) {}
    }
  }

  public void update(Graphics g) {
    paint(g);
  }

  public void stop() {
    if (workThread != null) {
      workThread.stop();
    }
  }

  public void destroy() {
  }

  void out_speed() {
    frames++;
    if (System.currentTimeMillis()>=startTime+1000) {
      showStatus("Частота кадров: "+String.valueOf(frames)+" (норма 20)");
      startTime=System.currentTimeMillis();
      frames=0;
    }
  }

  void initCards() {
    cardsPanel.setLayout(cards);
    setLayout(new BorderLayout());
    add("Center",cardsPanel);
    Panel p, p0;

    p = new Panel();
    p.setLayout(new BorderLayout());
    p.add("Center", new firstHelp());
    p0 = new Panel();
    p0.setLayout(new GridLayout(1,2));
    p0.add(new Button("Новая игра"));
    p0.add(new Button("Загрузить игру"));
    p0.add(new Hlp(c.h1,300,100));
    p.add("South",p0);
    cardsPanel.add("card001",p);
    
    p = new Panel();
    p.setLayout(new BorderLayout());
    p.add("Center",new firstHelp());
    p0 = new Panel();
    p0.setLayout(new GridLayout(1,4));
    p0.add(new Button("Новая игра"));
    p0.add(new Button("Загрузить игру"));
    p0.add(new Button("Сохранить игру"));
    p0.add(new Button("Вернуться в игру"));
    p.add("South",p0);
    cardsPanel.add("card006",p);

    p = new Panel();
    p.setLayout(new GridLayout(0,1));
    p.add(new gamePanel(0,"Камушки",c.text1));
    p.add(new gamePanel(1,"Мини-пешки",c.text2));
    p.add(new gamePanel(2,"Крестики-нолики",c.text3));
    cardsPanel.add("card002",p);

    p = new Panel();
    p.setLayout(new BorderLayout());
    p.add("Center", new Label(c.textWarning, Label.CENTER));
    p.add("South",new yes_no());
    cardsPanel.add("card003",p);

    p = new Panel();
    p.setLayout(new GridLayout(0,1));
    p.add(g1.s1);
    p.add(g1.s2);
    p.add(g1.b1);
    p.add(g1.b2);
    p.add(g1.t1);
    p.add(g1.t2);
    p.add(g1.sheres);
    p.add(g1.sp);
    p.add(g1.b3);
    p.add(g1.mode1);
    p.add(g1.mode2);
    p.add(g1.gr);
    p.add(new yes_no());
    cardsPanel.add("card004",p);

    cardsPanel.add("card005",g1.p);

    p = new Panel();
    p.setLayout(new BorderLayout());
    p.add("Center",new Label("По техническим причинам эта кнопка не работает!",Label.CENTER));
    p.add("South",new Button("Вернуться"));
    cardsPanel.add("card999",p);

    showCard("card001");
  }

  class BlackFilter extends RGBImageFilter {
    int alpha;
    Color col;
    public BlackFilter(int a, Color col0) {
      alpha=a;
      col=col0;
      canFilterIndexColorModel = false;
    }
    public int filterRGB(int x, int y, int rgb) {
      Color p = new Color(rgb);
      int r = p.getRed();
      int g = p.getGreen();
      int b = p.getBlue();
      if ((r<c.blackColor)&&(g<c.blackColor)&&(b<c.blackColor)) return 0;
      else {
        int r1 = col.getRed();
        int g1 = col.getGreen();
        int b1 = col.getBlue();
//        r1 = 128+r1/2;
//        g1 = 128+g1/2;
//        b1 = 128+b1/2;
        r = (r*(r1+1))>>8;
        g = (g*(g1+1))>>8;
        b = (b*(b1+1))>>8;
        return((alpha<<24)|(r<<16)|(g<<8)|(b));
      }
    }
  }

  Image BF(int alpha, Color col, Image im1) {
    ImageFilter filter = new BlackFilter(alpha,col);
    ImageProducer src = im1.getSource();
    ImageProducer producer = new FilteredImageSource(src, filter);
    return createImage(producer);
  }

  void initImages() {
    MediaTracker tracker = new MediaTracker(this);
    showStatus("Идет загрузка графики...");
    for (int i=0; i<c.numImages; ++i) {
      String s = String.valueOf(i);
      if (s.length()==1) s="00"+s;
      else if (s.length()==2) s="0"+s;
      media.images[i]=getImage(getDocumentBase(),"image"+s+".jpg");
      tracker.addImage(media.images[i],0);
    }
    for(int i=0; i<c.maxMove; i++) {
      for(int j=0; j<10; j++) {
        g1.oreol[10*i+j] = BF(255, g1.colors[i], media.images[j+12]);
        tracker.addImage(g1.oreol[10*i+j],0);
      }
    }
    for (int i=6; i<12; i++) {
      media.images[i] = BF(255, new Color(255,255,255), media.images[i]);
      tracker.addImage(media.images[i],0);
    }
    for (int i=22; i<60; i++) {
      media.images[i] = BF(255, new Color(255,255,255), media.images[i]);
      tracker.addImage(media.images[i],0);
    }
    try { tracker.waitForAll(); }
    catch (InterruptedException e) { showStatus("Возникло прерывание!!!"); }
    showStatus("Графика загружена.");
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals("Новая игра")) {
        if (save) showCard("card002");
        else {
          lastCard=currentCard;
          nextCard="card002";
          showCard("card003");
        }
        return true;
      }
      if (label.equals("Вернуться")) {
        showCard(lastCard);
        return true;
      }
      if (label.equals("Продолжить")) {
        doWork();
        showCard(nextCard);
        return true;
      }
      if (label.equals("Камушки")) {
        lastCard="card002";
        nextCard="card005";
        showCard("card004");
        return true;
      }
      for(int i=1; i<=c.maxMove; i++) {
        if (label.equals(String.valueOf(i))) {
          g1.take(i);
          return true;
        }
      }
      if (label.equals("Опции")) {
        switch(game) {
          case(1): {
            g1.options();
          }
        }
        return true;
      }
      if (label.equals("ЧТО ЭТО ТАКОЕ")) {
        if (game==0) showCard("card001");
        else showCard("card006");
        return true;
      }
      if (label.equals("Вернуться в игру")) {
        switch(game) {
          case(1): {
            showCard("card005");
          }
        }
        return true;
      }
/*      if (label.equals("-")) {
        if (g1.speed==0) return true;
        if (g1.speed<=4) { g1.initSpeed(g1.speed-1); return true; }
        if (g1.speed==999) { g1.initSpeed(4); return true; }
        g1.initSpeed(5); return true;
      }
      if (label.equals("+")) {
        if (g1.speed==1000) return true;
        if (g1.speed==999) { g1.initSpeed(6); return true; }
        g1.initSpeed(g1.speed+1); return true;
      }
*/
      if (label.equals("XXX")) {
        return true;
      }
      lastCard=currentCard;
      showCard("card999");
      return true;
    }
    return false;
  }

  void showCard(String s) {
    cards.show(cardsPanel,s);
    currentCard=s;
  }

  void doWork() {
    if (nextCard=="card005") {
      g1.init();
      game=1;
      save=false;
    }
  }
  public Insets insets() {
    return new Insets(c.zazor,c.zazor,c.zazor,c.zazor);
  }
}
