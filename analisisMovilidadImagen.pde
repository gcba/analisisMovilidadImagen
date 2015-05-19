import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Rectangle;
int points = 0;  
PImage screenshot; 
String time = "";
PrintWriter transRegs;
boolean save_data = false; 

class recordP {
  float x, y;
  float  r; 
  float  g; 
  float b;
  recordP(float _x, float _y, float _r, float _g, float _b) {
    x= _x;
    y= _y;
    r = _r;
    g = _g;
    b = _b;
  }
}
ArrayList<recordP> obPoints = new ArrayList<recordP>();

void setup() {q
  size(900, 1000);
  smooth();
  cursor(CROSS);
  setFColors();
  thread("requestData");
  do {} while(time.length() > 3);
  transRegs = createWriter("transito.csv");
  transRegs.println("id,estado,tiempo");
  frameRate(30);
}
void draw() {
  cursor(CROSS);
  if (frameCount % 30 == 0) {
    thread("requestData");
  }
  strokeWeight(0.5f);
  screenshot();
  //updateStreetStatus();
  if(frameCount % ONESECOND  == 0 ){
   if(save_data == true){updateStreetStatus(0);}
  }
  image(screenshot, 0, 0, width, height);
  color cross = screenshot.get(mouseX, mouseY);
  int crossColorID =  matchColor(red(cross), green(cross), blue(cross));
  if (crossColorID > -1 & crossColorID < 4) {
    colorC cc = TrafficColors.get(crossColorID);
    fill(cc.r, cc.g, cc.b, 250);
    ellipse(mouseX+8, mouseY+8, 10, 10);
  }

  for (int i = 0; i < obPoints.size (); i++) {
    recordP t = obPoints.get(i);
    fill(t.r, t.g, t.b);
    stroke(0);
    ellipse(t.x, t.y, 20, 20);
    fill(0);
    textSize(10);
    String nro = str(i);
    text(nro, t.x-(nro.length()-1 ), t.y+4);
    println("R: "+t.r+" G: "+t.g+" B: "+t.b);
    int cID =  matchColor(t.r, t.g, t.b);

    String trkPoint = " ";
    switch(cID) {
    case  0 :
      {
        trkPoint = "Transito RAPIDO"; 
        break;
      }
    case  1 :
      {
        trkPoint = "Transito NORMAL"; 
        break;
      }
    case  2 :
      {
        trkPoint = "Transito PESADO"; 
        break;
      }
    case  3 :
      {
        trkPoint = "Transito MUY PESADO"; 
        break;
      }
    }
  }
  printUI();
} 

void screenshot() {
  try {
    Robot robot_Screenshot = new Robot();
    screenshot = new PImage(robot_Screenshot.createScreenCapture
      (new Rectangle(0, 0, 900, 1000)));
  }
  catch (AWTException e) {
  }
}

void updateStreetStatus() {
  for (int i = 0; i < obPoints.size (); i++) {
    recordP tmp = obPoints.get(i);
    color ct = screenshot.get((int)tmp.x, (int)tmp.y);
    float nr = red(ct); 
    float ng = green(ct);  
    float nb = blue(ct);
    int cID =  matchColor(nr, ng, nb);
    if (cID > -1 & cID <= TrafficColors.size()) {
      colorC c4m = TrafficColors.get(cID); 
      if (tmp.r != c4m.r || tmp.g != c4m.g || tmp.b != c4m.b) {
        tmp.r = c4m.r;
        tmp.g = c4m.g; 
        tmp.b = c4m.b;
        obPoints.set(i, tmp);
        String trkPoint = " ";
        switch(cID) {
        case  0 : {trkPoint = "Transito RAPIDO"; break;}
        case  1 : {trkPoint = "Transito NORMAL"; break;}
        case  2 : {trkPoint = "Transito PESADO"; break;}
        case  3 : {trkPoint = "Transito MUY PESADO"; break;}
        }
        storedata(i, trkPoint);
      }
    }
  }
}



void updateStreetStatus(int code ) {
  for (int i = 0; i < obPoints.size (); i++) {
    recordP tmp = obPoints.get(i);
    color ct = screenshot.get((int)tmp.x, (int)tmp.y);
    float nr = red(ct); 
    float ng = green(ct);  
    float nb = blue(ct);
    int cID =  matchColor(nr, ng, nb);
    if (cID > -1 & cID <= TrafficColors.size()) {
      colorC c4m = TrafficColors.get(cID); 
     
        tmp.r = c4m.r;
        tmp.g = c4m.g; 
        tmp.b = c4m.b;
        obPoints.set(i, tmp);
        String trkPoint = " ";
        switch(cID) {
        case  0 : {trkPoint = "Transito RAPIDO"; break;}
        case  1 : {trkPoint = "Transito NORMAL"; break;}
        case  2 : {trkPoint = "Transito PESADO"; break;}
        case  3 : {trkPoint = "Transito MUY PESADO"; break;}
        }
        if(frameCount % ONEMINUTE == 0){storedata(i, trkPoint);}
        
      
    }
  }
}

void mousePressed() {
  float tx = mouseX; 
  float ty = mouseY;
  color ct = screenshot.get((int)tx, (int)ty);
  float r = red(ct); 
  float g = green(ct); 
  float b = blue(ct);
  println("Selected Color: r = "+r+", g = "+g+", b = "+b);
  int cID =  matchColor(r, g, b);
  if (cID > -1 & cID <= TrafficColors.size()) {
    println("Color ID: " + cID);
    colorC c = TrafficColors.get(cID);
    recordP tmp = new recordP((float)tx, (float)ty, c.r, c.g, c.b);
    obPoints.add(tmp);
    String trkPoint = " ";
    switch(cID) {
    case  0 :
      {
        trkPoint = "Transito RAPIDO"; 
        break;
      }
    case  1 :
      {
        trkPoint = "Transito NORMAL"; 
        break;
      }
    case  2 :
      {
        trkPoint = "Transito PESADO"; 
        break;
      }
    case  3 :
      {
        trkPoint = "Transito MUY PESADO"; 
        break;
      }
    }
    storedata(obPoints.size()-1, trkPoint);
  }
}

void keyPressed() {
  switch(keyCode) {
  case 'D':
    { 
      if (obPoints.size() > 0) {
        obPoints.remove(obPoints.size()-1);
      } 
      break;
    }
  case 'F': 
    {
      transRegs.flush();
      transRegs.close();
      exit();
      break;
    }
  case 'S': 
    save_data = !save_data;
  }
}



void storedata(int _id, String Status) {
  transRegs.println(_id+",\""+Status+"\",\""+time+"\"");
}

void requestData() {
  JSONObject json = loadJSONObject("http://time.jsontest.com/");
  time = json.getString("date")+" "+ json.getString("time");
}


int matchColor(float _r, float _g, float _b) {
  int r = -1; 
  for (int i=0; i < TrafficColors.size (); i++) {
    int colorOK = 0;
    colorC tc4m =  TrafficColors.get(i);
    if ( abs(_r-tc4m.r) <= cTolerance ) {
      colorOK++;
    }
    if ( abs(_g-tc4m.g) <= cTolerance ) {
      colorOK++;
    }
    if ( abs(_b-tc4m.b) <= cTolerance ) {
      colorOK++;
    }
    if (colorOK == 3) {
      r = i; 
      break;
    }
  }
  return r;
}

void printUI() {
  rectMode(CENTER);
  strokeWeight(1.5f);
  stroke(0,150);
  fill(0,50);
  rect(mod, height-100, (2*mod)*TrafficColors.size (), 50);
  for (int i= 0; i < TrafficColors.size (); i++) {
    colorC c = TrafficColors.get (i);
    fill(c.r,c.g,c.b);
    noStroke();
    rect(mod+mod*i, height-93, mod, 20);
    strokeWeight(1.5f);  
    textAlign(CENTER);
    fill(0);
    switch(i){
    case 0: {text("RAPIDO", mod+mod*i, height-105);break;}
    case 1: {text("NORMAL", mod+mod*i, height-105);break;}
    case 2: {text("LENTO", mod+mod*i, height-105);break;}
    case 3: {text("MUY LENTO", mod+mod*i, height-105);break;}
    case 4: {text("NO-DATA", mod+mod*i, height-105);break;}
  }
  }
}

