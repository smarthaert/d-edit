package ai3;

import java.awt.*;
import java.applet.*;
import java.util.*;

class media {
  static Image images[] = new Image[c.numImages];
  static AudioClip sounds[] = new AudioClip[c.numSounds];
}

class rrr {
  private static Random rnd = new Random();
  static int rand(int i) {
    return Math.abs(rnd.nextInt()) % i;
  }
  static double rand() {
    return rnd.nextDouble();
  }
}

