package ai;

import java.awt.*;
//import java.awt.event.*;
import java.applet.*;
//import javax.swing.*;
import java.awt.image.*;
import java.util.*;

public class ai extends Applet implements Runnable {
//  boolean isStandalone = false;
  Thread workThread = null;
  Dimension offSize;
  Image offImage;
  Graphics offGC;
  Image man, computer, s_red, s_yellow, s_green, s_red_yellow, apple;
  Font font1,font2,font3,font4;
  Panel p0,p1,p2,p3;
  static String info;
  static Random rand = new Random();
  int time=0;
  comp ai1,ai2;
  int move1,move2;
  static public String player1,player2;
  AudioClip aud[];
  Frame fr;
  int ttt;

  void end_game(int i) {
     if ((i==1&&game.winer)||(i==2&&!game.winer))
       new EndFrame(ai.player1+" (игрок 1) победил !!!");
     else new EndFrame(ai.player2+" (игрок 2) победил !!!");
  }

  public static final int x0=10, y0=10,
                          x1=10, y1=60,
                          x2=325, y2=60,
                          x3=10, y3=430,
                          pause=50;
  void makeDoubleBuffer(int width, int height) {
    offSize = new Dimension(width, height);
    offImage = createImage(width, height);
    offGC = offImage.getGraphics();
  }

  public Insets insets() {
    return new Insets(200,15,65,15);
  }

  String app(int i) {
    if (i==1) return(i+" яблоко");
    if (i<=4) return(i+" яблока");
    return(i+" яблок");
  }

  void init_audio() {
    aud=new AudioClip[9];
    for(int i=0; i<=8; i++)
    aud[i]=getAudioClip(getDocumentBase(),"e"+i+".au");
    inf(0);
  }

  void make_but() {
      setLayout(new GridLayout(rules.MaxMove,2,20,5));
      setFont(font3);
      for(int i=1; i<=rules.MaxMove; i++) {
        if (game.player1) {
          add(new Button("Я хочу съесть "+app(i)));
        }
        else {
          add(new Label("Сюда пока не смотреть !!!",Label.CENTER));
        }
        if (game.player2) {
          add(new Button(" Я хочу съесть "+app(i)));
        }
        else {
          add(new Label("Сюда пока не смотреть !!!",Label.CENTER));
        }
      }
  }

  //Initialize the applet
  public void init() {
    try  {
//      jbInit();
      fr = new InputFrame();
      player1="Алексей";
      player2="Транзистор";
      init_audio();
      MediaTracker tracker = new MediaTracker(this);
      man=getImage(getDocumentBase(),"man.gif"); tracker.addImage(man,0);
      computer=getImage(getDocumentBase(),"computer.gif"); tracker.addImage(computer,0);
      s_red=getImage(getDocumentBase(),"s_red.gif"); tracker.addImage(s_red,0);
      s_yellow=getImage(getDocumentBase(),"s_yellow.gif"); tracker.addImage(s_yellow,0);
      s_green=getImage(getDocumentBase(),"s_green.gif"); tracker.addImage(s_green,0);
      s_red_yellow=getImage(getDocumentBase(),"s_red_yellow.gif"); tracker.addImage(s_red_yellow,0);
      apple=getImage(getDocumentBase(),"apple.gif"); tracker.addImage(apple,0);
      try { tracker.waitForAll(); }
      catch (InterruptedException e) { }
      makeDoubleBuffer(640,480);
      font1= new Font("TimesNewRoman", Font.BOLD,30);
      font2= new Font("Courier", Font.ITALIC+Font.BOLD, 26);
      font3= new Font("TimesNewRoman", Font.ITALIC,20);
      font4= new Font("Courier", Font.BOLD, 24);
      ai1=new comp(); ai2=new comp();
      while(game.svetafor==4) {
        try {}
        catch(Exception e) {}
      }
      make_but();
      if (rules.first) { inf(7); }
      else { inf(5); }
    }
    catch(Exception e)  {
      e.printStackTrace();
    }
  }


  void inf(int i) {
    aud[i].play();
    switch(i) {
      case(1): {
        info=""+player1+", уберите руки от компьютера!";
        break;
      }
      case(2): {
        info=""+player2+", уберите руки от компьютера!";
        break;
      }
      case(3): {
        info=""+player1+", приятного аппетита!";
        break;
      }
      case(4): {
        info=""+player2+", приятного аппетита!";
        break;
      }
      case(5): {
        info="Сейчас компьютер думает.";
        break;
      }
      case(6): {
        info="Компьютер кушает.";
        break;
      }
      case(7): {
        info=""+player1+", Ваш ход";
        break;
      }
      case(8): {
        info="Больно много хочешь !";
        break;
      }
    }
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label = (String)obj;
      int l=0, r=0;
      for(int i=1; i<=rules.MaxMove; i++) {
        if (label.equals("Я хочу съесть "+app(i))) l=i;
        if (label.equals(" Я хочу съесть "+app(i))) r=i;
      }
      if (l==0&&r==0) return false;
      if (l!=0) {
        if (game.svetafor!=0) {
          inf(1);
          return true;
        }
        if (l>game.apples) {
          inf(8);
          return true;
        }
        game.svetafor=1;
        inf(3);
        move1=l;
      }
      else {
        if (game.svetafor!=2||r>game.apples) {
          inf(2);
          return true;
        }
        game.svetafor=3;
        inf(4);
        move2=r;
      }
      return true;
    }
    return false;
  }

/*
  //Component initialization
  private void jbInit() throws Exception {
    this.setSize(new Dimension(640,480));
  }

  //Get Applet information
  public String getAppletInfo() {
    return "Applet Information";
  }

  //Get parameter info
  public String[][] getParameterInfo() {
    return null;
  }
  // static initializer for setting look & feel
  static {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
      //UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
    }
    catch (Exception e) {}
  }   */

  public void update(Graphics g) {
    paint(g);
  }

  public void start() {
    workThread = new Thread(this);
    workThread.start();
  }

  public void run() {
    while (true) {
      if (game.svetafor<4) {
//        if (first) { make_but(); first=false; }
        repaint();
        if (game.svetafor==1) {
          fr.hide();
          if (time==0) time=100;
          time--;
          if (time==0) {game.svetafor=2; inf(5); game.apples-=move1;
            if (game.apples==0) end_game(1); }
        }
        if (game.svetafor==2) {
          if (time==0) time=100;
          time--;
          if (time==0) {game.svetafor=3; inf(6); move2=ai1.move();}
        }
        if (game.svetafor==3) {
          if (time==0) time=100;
          time--;
          if (time==0) {game.svetafor=0; inf(7); game.apples-=move2;
            if (game.apples==0) end_game(2); }
        }
      }
      try {Thread.sleep(pause);}
      catch (InterruptedException e) { }
    }
  }

  public void stop() {
//    workThread=null;
    if (workThread != null) {
      workThread.stop();
    }
  }


  public void paint(Graphics g) {
  if (game.svetafor<4) {
    offGC.setColor(Color.yellow);
    offGC.fill3DRect(x0,y0,620,40,true);
    offGC.fill3DRect(x1,y1,305,360,true);
    offGC.fill3DRect(x2,y2,305,360,true);
    offGC.fill3DRect(x3,y3,620,40,true);
    offGC.setFont(font2); offGC.setColor(Color.blue);
    if (game.player1) {
      offGC.drawImage(man,x1+5,y1+5,this);
      offGC.drawString("HUMAN",x1+130,y1+80);
    }
    else {
      offGC.drawImage(computer,x1-10,y1-25,this);
      offGC.drawString("COMPUTER",x1+110,y1+80);
    }
    if (game.player2) {
      offGC.drawImage(man,x2+5,y2+5,this);
      offGC.drawString("HUMAN",x2+130,y2+80);
    }
    else {
      offGC.drawImage(computer,x2-10,y2-25,this);
      offGC.drawString("COMPUTER",x2+110,y2+80);
    }
    offGC.setFont(font1); offGC.setColor(Color.magenta);
    offGC.drawString("Player 1",x1+120,y1+50);
    offGC.drawString("Player 2",x2+120,y2+50);
    offGC.setFont(font1); offGC.setColor(Color.black);
    offGC.drawString(player1,x1+110,y1+110);
    offGC.drawString(player2,x2+110,y2+110);
    Image sv1,sv2;
    switch (game.svetafor) {
      case(0): { sv1=s_green; sv2=s_red; break; }
      case(1): { sv1=s_yellow; sv2=s_red_yellow; break; }
      case(2): { sv1=s_red; sv2=s_green; break; }
      case(3): { sv1=s_red_yellow; sv2=s_yellow; break; }
      default: { sv1=s_red; sv2=s_red; }
    }
    offGC.drawImage(sv1,x1+245,y1+5,this);
    offGC.drawImage(sv2,x2+245,y2+5,this);
    int x_pos=320-15*game.apples;
    for(int i=0; i<game.apples; i++) {
      offGC.drawImage(apple,x_pos,10,this);
      x_pos+=30;
    }
    offGC.setFont(font4); offGC.setColor(Color.red);
    offGC.drawString("("+game.apples+") "+info,x3,y3+35);
    if (game.svetafor==1) {
      x_pos=320-15*game.apples;
      offGC.setFont(font1); offGC.setColor(Color.red);
      for(int i=0; i<move1; i++) {
         offGC.drawString("X",x_pos,50);
         x_pos+=30;
      }
    }
    if (game.svetafor==3) {
      x_pos=290+15*game.apples;
      offGC.setFont(font1); offGC.setColor(Color.blue);
      for(int i=0; i<move2; i++) {
         offGC.drawString("X",x_pos,50);
         x_pos-=30;
      }
    }
  }
    g.drawImage(offImage,0,0,this);
  }
}

class rules {
  static int apples=15;
  static int MaxMove=3;
  static boolean first=true;
  static boolean winer=true;
}

class game extends rules {
  static boolean player1=true;
  static boolean player2=false;
  static int svetafor=4;
  static int apples=15;
}

class comp extends game {
  int move() {
    return Math.abs(ai.rand.nextInt())%(Math.min(rules.MaxMove,game.apples))+1;
  }
}

class EndFrame extends Frame {
  EndFrame(String s) {
    super(s);
    resize(400,100);
    setLayout(new BorderLayout());
    add("Center",new Button("OK"));
    ai.info="Работа программы ЗАВЕРШЕНА !!!";
    repaint();
    game.svetafor=4;
    show();
  }
  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
//       ai.workThread=null;
       hide();
       return true;
    }
    return false;
  }
}

class InputFrame extends Frame {

  Slider apps,MM;
  box pl1, pl2, first,winer;
  nam name1,name2;

  InputFrame() {
    super("Ввод данных об игре");
    resize(500,300);
    setLayout(new GridLayout(9,1,5,5));
    add(apps = new Slider("Количество яблок:",10,6,15));
    add(MM = new Slider("Максимум за один ход:",3,2,5));
    add(winer = new box("Последний съевший является:","Победителем","Проигравшим",true));
    add(name1 = new nam("Имя первого игрока:","Alex"));
    add(name2 = new nam("Имя второго игрока:","AMD K6-2"));
    add(pl1 = new box("Первым игроком является:","Человек","Компьютер",true));
    add(pl2 = new box("Вторым игроком является:","Человек","Компьютер",false));
    add(first = new box("Игру начинает:","Первый игрок","Второй игрок",true));
    add(new Button("OK"));
    show();
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals("OK")) {
        rules.apples=apps.slider.getValue();
        game.apples=rules.apples;
        rules.MaxMove=MM.slider.getValue();
        rules.winer=winer.b1.getState();
        game.player1=pl1.b1.getState();
        game.player2=pl2.b1.getState();
        game.first=first.b1.getState();
        ai.player1=name1.t.getText();
        ai.player2=name2.t.getText();
        game.svetafor=0;
        hide();
        return true;
      }
    }
    return false;
  }
}

class Slider extends Panel {
  Scrollbar slider;
  Label value;

  Slider(String name, int i, int min, int max) {
    setLayout(new GridLayout(1,2));
    add(new Label(name));
    add(value=new Label(String.valueOf(i), Label.CENTER));
    add(slider=new Scrollbar(Scrollbar.HORIZONTAL,i,0,min,max));
  }

  public boolean handleEvent(Event evt) {
    if (evt.target.equals(slider)) {
      int i=slider.getValue();
      value.setText(String.valueOf(i));
    }
    return true;
  }

  public Dimension preferredSize() {
    return new Dimension(400,30);
  }
}

class box extends Panel {

  CheckboxGroup g;
  Checkbox b1,b2;

  box(String s, String s1, String s2, boolean b) {
    setLayout(new GridLayout(1,3));
    g = new CheckboxGroup();
    add(new Label(s));
    b1 = new Checkbox(s1,g,b); add(b1);
    b2 = new Checkbox(s2,g,!b); add(b2);
  }
}

class nam extends Panel {

  TextField t;

  nam(String s1, String s2) {
    setLayout(new GridLayout(1,2));
    t = new TextField(s2,15);
    add(new Label(s1));
    add(t);
  }
}
