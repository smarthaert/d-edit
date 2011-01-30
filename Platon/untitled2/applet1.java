package untitled2;

import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.util.*;
import java.awt.image.*;

public class applet1 extends Applet implements Runnable {
  boolean isStandalone = false;
  Thread workThread;

Image im1,im2,im3,im4,im5,im6,im7,im8;
int i=0;
Image im,imag;
Image pic0[] = new Image[7];
Image pic[] = new Image[7];

String fontList[];
Graphics gc;

//{Получаем список гарнитур для текста}

//fontList = getToolkit().getFontList();


//{******************************}
//     ФИЛЬТР ДЛЯ КАРТИНКИ
//{******************************}

  class blackfilter extends RGBImageFilter {
    int alpha;
    Color col;
    public blackfilter(int a, Color col0) {
      alpha=a;
      col=col0;
      canFilterIndexColorModel = false;
    }
    public int filterRGB(int x, int y, int rgb) {
      Color p = new Color(rgb);
      int r = p.getRed();
      int g = p.getGreen();
      int b = p.getBlue();
      if ((r<10)&&(g<10)&&(b<10)) return 0;
      else {
        int r1 = col.getRed();
        int g1 = col.getGreen();
        int b1 = col.getBlue();
        r = (r*(r1+1))>>8;
        g = (g*(g1+1))>>8;
        b = (b*(b1+1))>>8;
        return((alpha<<24)|(r<<16)|(g<<8)|(b));
      }
    }
  }

  Image BF(int alpha, Color col, Image im1) {
    ImageFilter filter = new blackfilter(alpha,col);
    ImageProducer src = im1.getSource();
    ImageProducer producer = new FilteredImageSource(src, filter);
    return createImage(producer);
  }

//{******************************}
//        КОНЕЦ ФИЛЬТРА
//{******************************}


  //Construct the applet
  public applet1() {
  }

  public void update(Graphics g) {
   paint(g);
  }



  public void paint(Graphics g){
    i=i+1;
    Graphics gr = im.getGraphics();
    gr.drawImage(imag,0,0,this);
    gr.setFont(new Font("TimesRoman",Font.BOLD,22));
    gr.drawString("Устройство гидравлического тормозного привода",150,30);
    gr.drawImage(pic[i],0,100,this);
    gr.drawImage(pic[i],500,100,this);
    gr.drawImage(pic[i],0,390,this);
    gr.drawImage(pic[i],500,390,this);
    if (i==5)  {
       i=0;
     }
    g.drawImage(im,0,0,this);

  }


  public void run() {
    while(true) {
      repaint();
      try { Thread.sleep(100); }
      catch (InterruptedException e) {}
    }
  }
  //Initialize the applet
  public void init() {
    im = createImage(1000,1000);

    // { Выдиляем память для картинок  }
    imag = getImage(getDocumentBase(),"font.jpg");
    pic0[0] = getImage(getDocumentBase(),"kol1.jpg");
    pic0[1] = getImage(getDocumentBase(),"kol2.jpg");
    pic0[2] = getImage(getDocumentBase(),"kol3.jpg");
    pic0[3] = getImage(getDocumentBase(),"kol4.jpg");
    pic0[4] = getImage(getDocumentBase(),"kol5.jpg");
    pic0[5] = getImage(getDocumentBase(),"kol6.jpg");
    pic0[6] = getImage(getDocumentBase(),"kol7.jpg");
    //  { Конец выделения памяти }

    // цикл для фильтрации картинки
    for(int i=0; i<7; i++) {
      pic[i]=BF(255,new Color(255,255,205),pic0[i]);
    }
    // конец цикла для фильтрации картинки
   // add(new Button("Start"));
  }

  public void start() {
    workThread = new Thread(this);
    workThread.start();
  }

  public void stop() {
    if (workThread != null) {
      workThread.stop();
    }
  }

    //Get Applet information
  public String getAppletInfo() {
    return "Applet Information";
  }

  //Get parameter info
  public String[][] getParameterInfo() {
    return null;
  }
}