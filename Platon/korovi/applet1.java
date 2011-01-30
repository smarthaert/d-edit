package korovi;

import java.applet.*;
import java.awt.*;
import java.net.*;
import java.io.*;
import java.util.*;
import java.math.*;
import java.lang.*;

class label2 extends Canvas {
  String text="";
  String text2="";
  label2() {
    resize(65,65);
  }
  void setText(String t, String t2) {
    text=t;
    text2=t2;
    repaint();
  }
  public void paint(Graphics g) {
    g.drawString(text,15,20);
    g.drawString(text2,15,40);
    g.drawString("Решено задач: "+c.wins+". Пропущено задач: "+c.nexts+". Произведено попыток: "+c.trys,15,60);
  }
}

public class applet1 extends Applet {
  TextField vvod;
  TextArea vivod;
  label2 lab = new label2();
  int dlina=3;
  String slovo = "";
  int num=0;
  String msg[] = new String[100];
  int biki;
  int korovi;
  Image im;
  int numwords=0;
  String words[] = new String[100];
  String help[] = new String[100];
  boolean bili[] = new boolean[100];
  Random rand;
  URL docBase;

  public void init() {
    docBase=getDocumentBase();
    rand=new Random(hashCode());
    setLayout(new BorderLayout());
    Panel p = new Panel();
    p.setLayout(new GridLayout(1,3));
    p.add(vvod = new TextField());
    p.add(new Button("Проверить"));
    p.add(new Button("Новая игра"));
    p.add(new Button("Правила"));
    add("North",p);
    add("Center",vivod = new TextArea());
    add("South",lab = new label2());
    load(words,"words.txt");
    load(help,"help.txt");
    newgame();
  }

  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals("Проверить")) {
        c.trys++; lab.repaint();
        String s = vvod.getText();
        if ( s.length()!=dlina )
          msg[num]=s+" - неверная длина слова!";
        else {
          calc();
          if (korovi==dlina) {
            c.wins++; lab.repaint();
            win w = new win(im);
            newgame();
            return true;
          }
          msg[num]="Слово: "+s+"   Быков: "+biki+"   Коров: "+korovi;
        }
        num++;
        String txt="";
        vvod.setText("");
        for(int i=(num-1); i>=0; i--) {
          txt=txt+msg[i]+"\n";
        }
        vivod.setText(txt);
        return true;
      }
      if (label.equals("Новая игра")) {
        c.nexts++; lab.repaint();
        newgame();
        return true;
      }
      if (label.equals("Правила")) {
        help h = new help();
        return true;
      }
    }
    return false;
  }

  void newgame() {
    num=0;
    vivod.setText("");
    vvod.setText("");
    boolean d=true;
    int c=0;
    int a=0;
    while(d) {
      a = Math.abs(rand.nextInt())%numwords;
      c++;
      if ((c>1000)||(bili[a]==false)) d=false;
    }
    if (c>1000) { for(int i=0; i<numwords; i++) bili[i]=false; }
    bili[a]=true;
    slovo=words[a];
    dlina=slovo.length();
    String txt = "Введите слово из "+dlina+" букв. ";
    String txt2="Подсказка: "+help[a];
    lab.setText(txt,txt2);
    im=getImage(getDocumentBase(),"image"+a+".jpg");
  }

  void calc() {
    biki=0;
    korovi=0;
    String answer = vvod.getText();
    for(int i=0; i<dlina; i++) {
      char a = answer.charAt(i);
      char b = slovo.charAt(i);
      if (a==b) korovi++;
      else {
        for(int j=0; j<dlina; j++) {
          b=slovo.charAt(j);
          if (a==b) biki++;
        }
      }
    }
  }

  boolean testchar(char ch) {
    if ((ch>='a')&&(ch<='z')) return true;
    if ((ch>='A')&&(ch<='Z')) return true;
    if ((ch>='0')&&(ch<='9')) return true;
    if ((ch==' ')||(ch==',')||(ch=='.')||(ch==';')||(ch=='!')||(ch=='?')||(ch=='"')||(ch=='-')) return true;
    return false;
  }

  void load(String[] res, String filename) {
    StringBuffer st = new StringBuffer(1);
    try {
      URL u = new URL(docBase, filename);
      URLConnection uCon = u.openConnection();
      int length = uCon.getContentLength();
      if (length==0) throw new Exception();
      st = new StringBuffer(length);
      InputStream input = uCon.getInputStream();
      while (length != 0) {
        int c = input.read();
        st.append((char)c);
        length--;
      }
      input.close();
    }
    catch (Exception e) {}
/*
    StringBuffer st = new StringBuffer();
    try {
      DataInputStream is;
      is = new DataInputStream(new FileInputStream(filename));
      int c;
      while ((c = is.read()) != -1) st.append((char)c);
      is.close();
    }
    catch (Exception e) {};
*/
    String s = st.toString();
    int l = st.length();
    numwords=0;
    String txt="";
    boolean w=false;
    char a='x';
    for(int i=0; i<l; i++) {
      a = s.charAt(i);
      if (testchar(a)) {
        w=true;
        txt=txt+a;
      }
      else {
        if (w) {
          res[numwords]=txt;
          numwords++;
          txt="";
        }
        w=false;
      }
    }
    if (w) {
      res[numwords]=txt;
      numwords++;
    }
    for(int i=0; i<numwords; i++) bili[i]=false;
  }
}

class help extends Frame {
  help() {
    super("Правила");
    resize(400,200);
    setLayout(new BorderLayout());
    add("Center", new TextArea(c.help));
    add("South", new Button("Закрыть"));
    show();
  }
  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals("Закрыть")) {
        hide();
        return true;
      }
    }
    return false;
  }
}

class picture extends Canvas {
  Image im;
  picture(Image im0) {
    im=im0;
  }
  public void paint(Graphics g) {
    g.drawImage(im,0,0,this);
  }
}

class win extends Frame {
  win(Image im0) {
    super("Слово угадано!");
    resize(480,500);
    setLayout(new BorderLayout());
    add("Center", new picture(im0));
    add("South", new Button("Закрыть"));
    show();
  }
  public boolean action(Event evt, Object obj) {
    if (evt.target instanceof Button) {
      String label=(String)obj;
      if (label.equals("Закрыть")) {
        hide();
        return true;
      }
    }
    return false;
  }
}

class c {
  static final String help =
    "123 aaa\n"+
    "456 bbb\n"+
    "789 ccc\n";
  static int wins=0, nexts=0, trys=0;
}



