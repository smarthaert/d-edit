package ai3;

import java.awt.*;
import java.applet.*;
import java.util.*;

class yes_no extends Panel {
  yes_no() {
    setLayout(new GridLayout(1,2));
    add(new Button("Вернуться"));
    add(new Button("Продолжить"));
  }
}

class gamePanel extends Panel {
  gamePanel(int picture, String button, String text) {
    setLayout(new BorderLayout());
    add("Center",new TextArea(text));
    Panel p = new Panel();
    p.setLayout(new BorderLayout());
    p.add("Center",new image(picture,120,120));
    p.add("South", new Button(button));
    add("West",p);
  }
}

class sliderData extends Panel {
  Scrollbar slider;
  Label value;
  sliderData(String text, int curr, int min, int max, Hlp hlp) {
    hlp.resize(50,50);
    setLayout(new BorderLayout());
    Panel p = new Panel();
    p.setLayout(new GridLayout(1,2));
    Panel p0 = new Panel();
    p0.setLayout(new BorderLayout());
    p0.add("Center",new Label(text));
    p0.add("East",value = new Label(String.valueOf(curr)));
    p.add(p0);
    p.add(slider = new Scrollbar(Scrollbar.HORIZONTAL, curr, 0, min, max));
    add("Center",p);
    add("East",hlp);
  }
  public boolean handleEvent(Event evt) {
    if (evt.target.equals(slider)) {
      value.setText(String.valueOf(slider.getValue()));
    }
    return true;
  }
}

class boxData extends Panel {
  CheckboxGroup g = new CheckboxGroup();
  Checkbox g1,g2;
  boxData(String text1, String text2, String text3, boolean b, Hlp hlp) {
    hlp.resize(50,50);
    setLayout(new BorderLayout());
    Panel p = new Panel();
    p.setLayout(new GridLayout(1,3));
    p.add(new Label(text1));
    p.add(g1=new Checkbox(text2,g,b));
    p.add(g2=new Checkbox(text3,g,!b));
    add("Center",p);
    add("East",hlp);
  }
}

class textData extends Panel {
  TextField t;
  textData(String text1, String text2, Hlp hlp) {
    hlp.resize(50,50);
    setLayout(new BorderLayout());
    Panel p = new Panel();
    p.setLayout(new GridLayout(1,2));
    p.add(new Label(text1));
    p.add(t = new TextField(text2));
    add("Center",p);
    add("East",hlp);
  }
}

class spisData extends Panel {
  Choice ch = new Choice();
  spisData(String text, String ttt[], Hlp hlp) {
    hlp.resize(50,50);
    setLayout(new BorderLayout());
    Panel p = new Panel();
    for(int i=0; i<ttt.length; i++) {
      ch.addItem(ttt[i]);
    }
    p.setLayout(new GridLayout(1,2));
    p.add(new Label(text));
    p.add(ch);
    add("Center",p);
    add("East",hlp);
  }
}

class image extends Canvas {
  int i;
  image(int i0) {
    i=i0;
  }
  image(int i0, int x_size, int y_size) {
    i=i0;
    resize(x_size, y_size);
  }
  public void paint(Graphics g) {
    Dimension d = size();
    g.drawImage(media.images[i], 0, 0, d.width, d.height, this);
  }
}

class Hlp extends Canvas {
  Okno o;
  int xxx,yyy;
  Hlp(String text, int x, int y) {
    o = new Okno(text,x,y);
    xxx=x; yyy=y;
  }
  public void paint(Graphics g) {
    Dimension d = size();
    g.setColor(Color.green);
    g.fillRect(0,0,d.width-1,d.height-1);
    g.setColor(Color.red);
    g.drawRect(0,0,d.width-1,d.height-1);
    g.setColor(Color.blue);
    g.setFont(new Font("TimesRoman",Font.BOLD,20));
    g.drawString("?",d.width/2-5,d.height/2+5);
  }
  class Okno extends Frame {
    Okno(String text, int x, int y) {
      super("Всплывающая помощь");
      resize(x,y);
      setLayout(new BorderLayout());
      add("Center",new TextArea(text));
    }
  }
  public boolean mouseEnter(Event evt, int x, int y) {
    Point p = getLocationOnScreen();
    Dimension q = new Dimension();
    q.width=800;                      //??????????????????????????????????????????
    q.height=600;
    Dimension d = size();
    if ((p.x>=q.width/2)&&(p.y>=q.height/2)) o.setLocation(p.x-xxx, p.y-yyy);
    if ((p.x>=q.width/2)&&(p.y<q.height/2)) o.setLocation(p.x-xxx, p.y+d.height);
    if ((p.x<q.width/2)&&(p.y>=q.height/2)) o.setLocation(p.x+d.width, p.y-yyy);
    if ((p.x<q.width/2)&&(p.y<q.height/2)) o.setLocation(p.x+d.width, p.y+d.height);
    o.show();
    return true;
  }
  public boolean mouseExit(Event evt, int x, int y) {
    o.hide();
    return true;
  }
}

class firstHelp extends Canvas {
  Dimension d;
  int page=1;
  public void paint(Graphics g) {
    d = size();
    Image offImage = createImage(d.width,d.height);
    Graphics gc = offImage.getGraphics();
    switch(page%3) {
      case(1): {gc.drawImage(media.images[3],0,0,d.width-1,d.height-1,this); break;}
      case(2): {gc.drawImage(media.images[4],0,0,d.width-1,d.height-1,this); break;}
      case(0): {gc.drawImage(media.images[5],0,0,d.width-1,d.height-1,this); break;}
    }
    gc.setFont(new Font("TimesRoman",Font.BOLD,24));
    gc.setColor(Color.black);
    gc.drawString("Назад",0,d.height-3);
    gc.drawString("Вперед",d.width-100,d.height-3);
    for(int i=1; i<=c.numPages; i++) {
      if (i==page) gc.setColor(Color.red);
      else gc.setColor(Color.black);
      gc.drawString(String.valueOf(i), 95+(int)((i-0.5)*(d.width-200)/c.numPages),d.height-3);
    }
    switch(page) {
      case(1): {
        gc.setFont(new Font("TimesRoman",Font.BOLD,20));
        gc.setColor(Color.blue);
        gc.drawString(c.text001,0,30);
        gc.drawString(c.text002,0,60);
        gc.drawString(c.text003,0,90);
        gc.setFont(new Font("TimesRoman",Font.ITALIC,16));
        gc.setColor(Color.black);
        gc.drawString(c.text004,0,150);
        gc.drawString(c.text005,0,170);
        gc.drawString(c.text006,0,180);
        gc.drawString(c.text007,0,190);
        break;
      }
    }
    g.drawImage(offImage,0,0,this);
  }

  public void update(Graphics g) {
    paint(g);
  }

  public boolean mouseDown(Event evt, int x, int y) {
    d = size();
    if (y>=(d.height-25)) {
      if ((x<100)&&(page>1)) page--;
      if ((x>=(d.width-100))&&(page<c.numPages)) page++;
      for(int i=0; i<c.numPages; i++) {
        if ( (x>=(100+i*(d.width-200)/c.numPages)) && (x<(100+(i+1)*(d.width-200)/c.numPages)) )
          page=(i+1);
      }
      repaint();
    }
    return true;
  }
}
