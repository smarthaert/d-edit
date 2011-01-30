package platon;

import java.awt.*;
import java.awt.event.*;
import java.applet.*;

class help extends Frame {
  help() {
    super("Справка");
    resize(100,100);
    setLayout(new BorderLayout());
    add("South",new Button("Ok"));
    show();
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals("Ok")) {
        hide();
        return true;
      }
    }
    return false;
  }
}

class figure extends Canvas {

  int x=0;

  public void paint(Graphics g) {
    g.drawLine(x,0,100,100);
  }
}

public class applet1 extends Applet {

figure fig;

final int numItems = 6;
final String menuItems[] = {
"a1",
"a2",
"a3",
"a4",
"a5",
"a6"
};

  public void init() {
    setLayout(new BorderLayout());
    Panel p1 = new Panel();
    p1.setLayout(new GridLayout(6,1));
    for(int i=0; i<numItems; i++) {
      p1.add(new Button(menuItems[i]));
    }
    add("West",p1);
    add("Center",fig=new figure());
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals(menuItems[0])) {
        fig.x=100;
        fig.repaint();
        return true;
      }
      if (label.equals(menuItems[1])) {
        fig.x=200;
        fig.repaint();
        return true;
      }
      if (label.equals(menuItems[2])) {
        fig.x=300;
        fig.repaint();
        return true;
      }
      if (label.equals(menuItems[5])) {
        new help();
        return true;
      }
    }
    return false;
  }

}