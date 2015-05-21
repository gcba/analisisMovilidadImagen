import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Rectangle;
import java.io.BufferedWriter;
import java.io.FileWriter;

int points = 0;  
PImage screenshot; 
String time = "";
PrintWriter transRegs;
boolean save_data = false; 


void setup() {
  size(900, 1000);
  smooth();
  cursor(CROSS);
  setFColors();
  String tsession = getActualTime();
  transRegs = createWriter("GMTraffic_"+tsession+".csv");
  
  transRegs.println("id,status,st_value,lat,lon,timestamp");
  transRegs.flush();
  frameRate(30);
}
void draw() {
  ellipseMode(CENTER);
  println("Mouse X: "+mouseX+" Mouse Y: "+mouseY);
  cursor(CROSS);
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
  String aTime = getActualTime("tsmode");
  for (int i = 0; i < obPoints.size (); i++) {
    recordP tmp = obPoints.get(i);
    color ct = screenshot.get((int)tmp.x, (int)tmp.y);
    float nr = red(ct); 
    float ng = green(ct);  
    float nb = blue(ct);
    int cID =  matchColor(nr, ng, nb);
    if (cID > -1 & cID <= TrafficColors.size()) {
      float lon = map(tmp.x,0.0f,894.0f,(float)LON_MIN,(float)LON_MAX);
      float lat = map(tmp.y,95.0f,982.0f,(float)LAT_MIN,(float)LAT_MAX);
      colorC c4m = TrafficColors.get(cID); 
      if (tmp.r != c4m.r || tmp.g != c4m.g || tmp.b != c4m.b) {
        tmp.r = c4m.r;
        tmp.g = c4m.g; 
        tmp.b = c4m.b;
        obPoints.set(i, tmp);
        String trkPoint = " ";
        int trkNum   = -1;
        switch(cID) {
        case  0 : {trkPoint = "Transito RAPIDO"; trkNum =1; break;}
        case  1 : {trkPoint = "Transito NORMAL"; trkNum =2; break;}
        case  2 : {trkPoint = "Transito LENTO"; trkNum =3; break;}
        case  3 : {trkPoint = "Transito MUY LENTO"; trkNum =4; break;}
        }
        storedata(i, trkPoint, trkNum, aTime,lat,lon);
      }
    }
  }
}



void updateStreetStatus(int code ) {
  String aTime = getActualTime("tsmode");
  for (int i = 0; i < obPoints.size (); i++) {
    recordP tmp = obPoints.get(i);
    color ct = screenshot.get((int)tmp.x, (int)tmp.y);
    float nr = red(ct); 
    float ng = green(ct);  
    float nb = blue(ct);
    int cID =  matchColor(nr, ng, nb);
    if (cID > -1 & cID <= TrafficColors.size()) {
      colorC c4m = TrafficColors.get(cID); 
        float lon = map(tmp.x,0.0f,894.0f,(float)LON_MIN,(float)LON_MAX);
        float lat = map(tmp.y,95.0f,982.0f,(float)LAT_MIN,(float)LAT_MAX);
        tmp.r = c4m.r;
        tmp.g = c4m.g; 
        tmp.b = c4m.b;
        obPoints.set(i, tmp);
        String trkPoint = " ";
        int    trkNum   = -1 ;
        switch(cID) {
        case  0 : {trkPoint = "Transito RAPIDO"; trkNum = 1; break;}
        case  1 : {trkPoint = "Transito NORMAL"; trkNum = 2; break;}
        case  2 : {trkPoint = "Transito LENTO"; trkNum = 3; break;}
        case  3 : {trkPoint = "Transito MUY LENTO"; trkNum = 1; break;}
        }
        if(frameCount % ONEMINUTE == 0){storedata(i, trkPoint,trkNum,aTime,lat,lon);}
        
      
    }
  }
}

void mousePressed() {
  String aTime = getActualTime("tsmode");
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
    float lon = map(tmp.x,0.0f,894.0f,(float)LON_MIN,(float)LON_MAX);
    float lat = map(tmp.y,95.0f,982.0f,(float)LAT_MIN,(float)LAT_MAX);
    obPoints.add(tmp);
    String trkPoint = " ";
    int    trkNum   = -1;
    switch(cID) {
    case  0 :
      {
        trkPoint = "Transito RAPIDO"; 
        trkNum   = 1;
        break;
      }
    case  1 :
      {
        trkPoint = "Transito NORMAL"; 
        trkNum   = 2;
        break;
      }
    case  2 :
      {
        trkPoint = "Transito LENTO"; 
        trkNum   = 3;
        break;
      }
    case  3 :
      {
        trkPoint = "Transito MUY LENTO";
        trkNum   = 4; 
        break;
      }
    }
    storedata(obPoints.size()-1, trkPoint,trkNum,aTime,lat,lon);
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



void storedata(int _id, String Status, int n, String _time, float lat, float lon) {
  ellipseMode(CORNER);
  fill(255,0,0);
  ellipse(50,200,20,20);
  transRegs.println(_id+",\""+Status+"\","+n+","+lat+","+lon+",\""+_time+"\"");
  transRegs.flush();
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
  if(save_data==true){
    fill(255,0,0);
    ellipse(50,height-93,20,20);
  }
  }
}

String getActualTime(){
  String d = hour()+"."+minute()+"."+second()+" "+day()+"-"+month()+"-"+year();
  return d;
}

String getActualTime(String mode){
  String d = hour()+":"+minute()+":"+second()+" "+day()+"/"+month()+"/"+year();
  return d;
}


