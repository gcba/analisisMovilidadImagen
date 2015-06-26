// App Configs
String fileSessionName = "sessions/gmVirtualSensors_.csv";
Table   sessionFile;
boolean loadedSession = false;
boolean moveMap = true;
boolean mapShow = true;
boolean showSensores = true;



float latTop     = -34.52023578903147;
float latBottom  = -34.71085538182928;
float lonRight   = -58.33839787472311;
float lonLeft    = -58.53590826514903;


//Output Files
PrintWriter data;
PrintWriter sensorsFile;

int mapX = 0;
int mapY = 0;
int gIdC = 0;

PImage imgBase;
PGraphics sensoresLayer;
MercatorMap mercatorMap;

colorC actColor = new colorC((int)random(0,255),(int)random(0,255),(int)random(0,255));

ArrayList<Sensor> Sensores = new ArrayList<Sensor>();
ArrayList<Group> Groups = new ArrayList<Group>();
ArrayList<colorC> TrafficColors = new ArrayList<colorC> ();

int cTolerance = 5;

class colorC {
  public int r;
  public int g;
  public int b;
  colorC (int _r, int _g, int _b) {
    r=_r; 
    g=_g; 
    b=_b;
  }
}

class Sensor {
  public float lat,lon;
  public int x,y,id,gId;
  Sensor(int _id, int _gId, int _x, int _y) {
    y = _y;
    x = _x;
    gId = _gId;
    id  = _id;
    lat = map(y,0,2700,latTop,latBottom);
    lon = map(x,0,2300,lonLeft,lonRight);
  }
}

class Group{
  public int gId;
  public String gDesc; 
  public colorC gColor;
  Group(int _gId, String _gDesc){
    gDesc = _gDesc;
    gId   = _gId;
    gColor = new colorC((int)random(255),(int)random(255),(int)random(255));
  }
}


void dumpGroups(String _session){
 // groupsFile = createWriter("am_groups_conf"+_session+".conf");
}

void dumpSensors(String _session){
  sensorsFile = createWriter("am_sensors_conf"+_session+".conf");
}

String getActualTime(){
  String d = getActualTime(2);
  return d;
}


String getActualTime(int code){
  String d = " ";
  switch(code){
    case 1  : {d = year()+"-"+month()+"-"+day()+"T"+hour()+":"+minute()+":"+second()+"-03:00"; break;}
    case 2  : {d = year()+"-"+month()+"-"+day()+"T"+hour()+":"+minute()+":"+second()+"-03:00"; break;}
  }
  return d;
}

void initApp(){
  imgBase = loadImage("refMap.png");
  mapX = round((imgBase.width - width)/2);
  mapY = round((imgBase.height - height)/2); 
  sensoresLayer = createGraphics(imgBase.width,imgBase.height);
  sensoresLayer.beginDraw(); 
  //foo step!
  sensoresLayer.endDraw();
}

void setFColors() {
  //Valores Para Transito Rapido: 
  TrafficColors.add(new colorC(177, 221, 145));// TRANSITO RAPIDO 0
  TrafficColors.add(new colorC(165, 217, 125));// TRANSITO RAPIDO 1
  TrafficColors.add(new colorC(146, 209, 103));// TRANSITO RAPIDO 2
  TrafficColors.add(new colorC(130, 202, 79));// TRANSITO RAPIDO 3
  TrafficColors.add(new colorC(111, 111, 87));// TRANSITO RAPIDO 4
  TrafficColors.add(new colorC(202, 233, 178));// TRANSITO RAPIDO 5
  TrafficColors.add(new colorC(133, 203, 81));// TRANSITO RAPIDO 6
  TrafficColors.add(new colorC(187, 227, 158));// TRANSITO RAPIDO 7
  TrafficColors.add(new colorC(174, 202, 150));// TRANSITO RAPIDO 8
  TrafficColors.add(new colorC(154, 214, 114));// TRANSITO RAPIDO 9
  TrafficColors.add(new colorC(194, 229, 168));// TRANSITO RAPIDO 10
  TrafficColors.add(new colorC(170, 195, 144));// TRANSITO RAPIDO 11
  TrafficColors.add(new colorC(185, 206, 167));// TRANSITO RAPIDO 12
  TrafficColors.add(new colorC(148, 174, 134));// TRANSITO RAPIDO 13
  TrafficColors.add(new colorC(217, 239, 201));// TRANSITO RAPIDO 14
  
  //Valores Para Transito Normal: 
  TrafficColors.add(new colorC(240, 125, 2));// TRANSITO NORMAL 
  TrafficColors.add(new colorC(251, 221, 193));// TRANSITO NORMAL
  TrafficColors.add(new colorC(170, 220, 134));// TRANSITO NORMAL
  TrafficColors.add(new colorC(138, 207, 91));// TRANSITO NORMAL
  TrafficColors.add(new colorC(248, 190, 126));// TRANSITO NORMAL
  TrafficColors.add(new colorC(241, 142, 32));// TRANSITO NORMAL
  TrafficColors.add(new colorC(248, 198, 146));// TRANSITO NORMAL
  TrafficColors.add(new colorC(251, 216, 178));// TRANSITO NORMAL
  TrafficColors.add(new colorC(241, 126, 0));// TRANSITO NORMAL
  TrafficColors.add(new colorC(251, 214, 174));// TRANSITO NORMAL
  TrafficColors.add(new colorC(247, 190, 126));// TRANSITO NORMAL
  TrafficColors.add(new colorC(247, 198, 146));// TRANSITO NORMAL
  TrafficColors.add(new colorC(239, 182, 126));// TRANSITO NORMAL
  TrafficColors.add(new colorC(194, 229, 166));// TRANSITO NORMAL
  TrafficColors.add(new colorC(243, 158, 67));// TRANSITO NORMAL
  TrafficColors.add(new colorC(233, 246, 223));// TRANSITO LENTO
  TrafficColors.add(new colorC(210, 236, 190));// TRANSITO LENTO
  TrafficColors.add(new colorC(144, 128, 90));// TRANSITO NORMAL
  
  //Valores Para Transito Lento: 
  TrafficColors.add(new colorC(248, 176, 176));// TRANSITO LENTO 33
  TrafficColors.add(new colorC(251, 189, 189));// TRANSITO LENTO
  TrafficColors.add(new colorC(237, 63, 63));// TRANSITO LENTO
  TrafficColors.add(new colorC(241, 134, 16));// TRANSITO LENTO
  TrafficColors.add(new colorC(229, 16, 16));// TRANSITO LENTO
  TrafficColors.add(new colorC(244, 126,126));// TRANSITO LENTO
  TrafficColors.add(new colorC(229, 0, 0));// TRANSITO LENTO
  TrafficColors.add(new colorC(241, 96, 96));// TRANSITO LENTO
  TrafficColors.add(new colorC(237, 48, 48));// TRANSITO LENTO
  TrafficColors.add(new colorC(244, 158, 158));// TRANSITO LENTO
  TrafficColors.add(new colorC(244, 156, 156));// TRANSITO LENTO
  TrafficColors.add(new colorC(251, 207, 207));// TRANSITO LENTO
  TrafficColors.add(new colorC(244, 142, 142));// TRANSITO LENTO
  TrafficColors.add(new colorC(243, 111, 111));// TRANSITO LENTO
  TrafficColors.add(new colorC(243, 174, 174));// TRANSITO LENTO
  TrafficColors.add(new colorC(244, 173, 97));// TRANSITO LENTO
  TrafficColors.add(new colorC(207, 137, 137));// TRANSITO LENTO 49
  
  
  //Valores Para Transito Muy Lento: 
  TrafficColors.add(new colorC(141, 0, 10));// TRANSITO MUY LENTO 50
  TrafficColors.add(new colorC(158, 20, 20));// TRANSITO MUY LENTO
  TrafficColors.add(new colorC(190, 91, 91));// TRANSITO MUY LENTO
  TrafficColors.add(new colorC(159, 18, 18));// TRANSITO MUY LENTO
  TrafficColors.add(new colorC(156, 18, 18));// TRANSITO MUY LENTO
  TrafficColors.add(new colorC(175, 64, 64));// TRANSITO MUY LENTO
  TrafficColors.add(new colorC(141, 0, 10));// TRANSITO MUY LENTO 56
  
  
  //Valores Para Transito no-data: 
  TrafficColors.add(new colorC(246, 244, 238));// NO DATA 57
  TrafficColors.add(new colorC(244, 240, 240));// NO DATA
  TrafficColors.add(new colorC(255, 255, 255));// NO DATA
  TrafficColors.add(new colorC(223, 220, 209));// NO DATA
  TrafficColors.add(new colorC(238, 235, 230));// NO DATA
  TrafficColors.add(new colorC(231, 227, 219));// NO DATA
  TrafficColors.add(new colorC(243, 239, 237));// NO DATA
  TrafficColors.add(new colorC(248, 244, 241));// NO DATA
  
}

int matchColor(int _r, int _g, int _b) {
  int r = -1; 
  for (int i=0; i < TrafficColors.size (); i++) {
    int colorOK = 0;
    colorC tc4m =  TrafficColors.get(i);
    if (((_r >= tc4m.r-cTolerance) && (_r <= tc4m.r+cTolerance))) {
      colorOK++;
    }
    if (((_g >= tc4m.g-cTolerance) && (_g <= tc4m.g+cTolerance))) {
      colorOK++;
    }
    if (((_b >= tc4m.b-cTolerance) && (_b <= tc4m.b+cTolerance))) {
      colorOK++;
    }
    if (colorOK == 3) {
      r = i; 
      break;
    }
  }
  return r;
}
void removeSensor(){
  Sensores.remove(Sensores.size()-1);
  printPoints();
  
}


void saveSession(){
  if(Sensores.size() > 0){
    String tsession =getActualTime(); 
   /*"+tsession+"*/ 
      sensorsFile = createWriter(fileSessionName);
      sensorsFile.println("id,lat,lon,grupo,gdesc,x,y,gr,gg,gb");
      sensorsFile.flush();
      for(int i = 0; i < Sensores.size(); i++){
        Sensor s = Sensores.get(i);
        Group g = Groups.get(s.gId);
        /*** id | lat | lon | grupo | gdesc | x | y | gr | gg | gb ***/
        sensorsFile.println(s.id+","+s.lat+","+s.lon+","+s.gId+","+g.gDesc+","+s.x+","+s.y+","+g.gColor.r+","+g.gColor.g+","+g.gColor.b);
        sensorsFile.flush();  
      }
        
    println("Sucessful save!");
  }
}

void loadSession(){
  sessionFile = loadTable(fileSessionName,"header");
  for(TableRow sensors : sessionFile.rows ()){
    int x  = sensors.getInt("x");
    int y  = sensors.getInt("y");
    int    gId = sensors.getInt("grupo");
    String gD  = sensors.getString("gdesc");   
   /*no existe grupo lo creo*/
   if(!existGroup(gId)){
     Groups.add(new Group(gId,gD));
     //creo el grupo
   }
   addSensor(x,y,gId);
  }
  printPoints();
}

boolean existGroup(int gID){
  boolean r = false;
  for(int i=0; i < Groups.size(); i++){
    Group g = Groups.get(i);
    if(g.gId == gID){r = true; break;}
  }
  return r;
}

void eraseAllData(){
  for(int i= Sensores.size()-1; i > 0;i--){
    Sensores.remove(i);
  }
  for(int i=Groups.size()-1; i > 0 ;i--){
    Groups.remove(i);
  }
  removeSensor();
  printPoints();
}
String imgsFolder = "../../data";

String getNewImg(){
  java.io.File folder = new java.io.File(dataPath(imgsFolder));
  String r = ""; 
  String[] filenames = folder.list();
  for (int i = 0; i < filenames.length; i++) {
    if(filenames[i].indexOf(".png") > -1 && filenames[i].indexOf("_readed") == -1){r = filenames[i]; break;}
   }
   return r;
}
void evaluateSensors(){
  String ts = getActualTime(1);
  String m = getNewImg();
  if(m != ""){
  data = createWriter("dataSensores.csv");
  
  PImage mImg = loadImage(imgsFolder+"/"+m); 
  if(Sensores.size() > 0){
    for(int i = 0; i < Sensores.size();i++){
      int sv = -1;
      Sensor s = Sensores.get(i);
      color c = mImg.get(s.x,s.y);
      int et = matchColor((int)red(c),(int)green(c),(int)blue(c));
      if(et > -1){
        if(et >= 0 && et  < 15)  {sv = 0;}
        if(et >= 15 && et < 33)  {sv = 1;}
        if(et >= 33 && et < 50)  {sv = 2;}
        if(et >= 50 && et < 57)  {sv = 3;}
        if(et >= 57 && et < 65)  {sv = -1;}
      } 
      data.println(s.id+","+sv+",\""+ts+"\"");
    }
      
      File originalFile, newFile;
      String originalFileName, newFileName;
      originalFileName = imgsFolder+"/"+m; // the original name of the file
      originalFile = new File(originalFileName);
      newFileName = imgsFolder+"/"+ts+"_readed.png";
      newFile = new File(newFileName);
      originalFile.renameTo(newFile);
      println(">> Original Name: "+originalFileName);
      println(">> new Name:      "+newFileName);
  }
  }
}

