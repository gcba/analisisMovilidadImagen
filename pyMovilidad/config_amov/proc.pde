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
    case 1  : {d = year()+"-"+month()+"-"+day()+"T"+hour()+":"+minute()+":"+second()+arGMT; break;}
    case 2  : {d = year()+"-"+month()+"-"+day()+"T"+hour()+":"+minute()+":"+second()+arGMT; break;}
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



int matchColor(int r, int g, int b){
  int response = -1;
  if(g == b && b == r){response = -1;}
  else if(g > b && g > r)
      {response = 0;}
  else if(r > b && g > b && g-b > 50)
      {response = 1;}
  else if(r > g && r > b && g >= b && r > 200|| (r>205 && g>115 && b>115))
      {response = 2;}
  else if(r > g && r > b && abs(b-g) < 20 && r < 200 )
      {response = 3;}
  return response;
}

void addSensor(int px,int py){
  if (Groups.size() == 0){
        Group g = new Group(Groups.size(),Groups.size());
         Groups.add(g);
       }
 Sensores.add(new Sensor(Sensores.size(), Groups.size()-1,px,py,(int)random(1000))); 
 printPoints();
}

void addSensor(int px,int py, int gId,int sn){
 Sensores.add(new Sensor(Sensores.size(), gId,px,py, sn)); 
 printPoints();
}


void printPoints(){
     sensoresLayer.beginDraw();
     sensoresLayer.clear(); 
     sensoresLayer.ellipseMode(CENTER);
     sensoresLayer.noStroke();
      Group g ;
     for(int i=0; i < Sensores.size(); i++){
       Sensor tempSen = Sensores.get(i); 
       g = Groups.get(tempSen.gId);
       sensoresLayer.fill(g.gColor.r,g.gColor.g,g.gColor.b);
       sensoresLayer.ellipse(tempSen.x,tempSen.y,10,10);
     }
     sensoresLayer.endDraw();
}

void exit(){
  println("CU!");
  super.exit();
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
  println(">> loading: "+fileSessionName+" (Seesion File)");
  sessionFile = loadTable(fileSessionName,"header");
  for(TableRow sensors : sessionFile.rows ()){
    int  x  = sensors.getInt("x");
    int  y  = sensors.getInt("y");
    int gId = sensors.getInt("grupo");
    int gD  = sensors.getInt("sensor_id"); 
    int ns  = sensors.getInt("datatype");
   /*no existe grupo lo creo*/
   if(!existGroup(gId)){
     Groups.add(new Group(gId,gD));
      print(".");
   }
   addSensor(x,y,gId,ns);
  }
  printPoints();
  print(" DONE!");
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


String imgsFolder = "";

String getNewImg(){
  java.io.File folder = new java.io.File(dataPath(imgsFolder));
  String r = ""; 
  String[] filenames = folder.list();
  for (int i = 0; i < filenames.length; i++) {
    if(filenames[i].indexOf(".png") > -1 && filenames[i].indexOf("_readed") == -1 && filenames[i].indexOf("refMap") < 0){r = filenames[i]; break;}
   }
   return r;
}

void readyForAppendCSV(){
  readyForAppendCSV(defautlDataFIle);
}

void readyForAppendCSV(String dataFile){
    tmpTable = loadTable(defautlDataFIle,"header");
}

void evaluateSensors(){
  String ts = getActualTime(1);
  String m = getNewImg();
  if(m != ""){
  readyForAppendCSV(); 
  PImage mImg = loadImage(m); 
  println(">> Analyzing: "+m+" (PNG File)");
  if(Sensores.size() > 0){
    for(int i = 0; i < Sensores.size();i++){
      int sv = -1;
      Sensor s = Sensores.get(i);
      color c = mImg.get(s.x,s.y);
      int et = matchColor((int)red(c),(int)green(c),(int)blue(c));
      if(et > -1){
        if(et == 0)  {sv = FTRAFFIC;}
        if(et == 1)  {sv = NTRAFFIC;}
        if(et == 2)  {sv = STRAFFIC;}
        if(et == 3)  {sv = VSTRAFFIC;}
        if(et == -1) {sv = NO_DATA;}
      } 
      TableRow newRow = tmpTable.addRow();
      Group g = Groups.get(s.gId);
      newRow.setInt("id",s.id);
      newRow.setInt("value",sv);
      newRow.setInt("gId",g.gDesc);
      newRow.setInt("datatype",s.nSensor);
      newRow.setString("refImg",m );
      newRow.setString("timestamp",ts);      
    }
      String nName = m.substring(0,m.indexOf(".png"));
      saveTable(tmpTable,defautlDataFIle);
      mImg.save("readed/"+nName+"_readed.png");
      println(">> "+m+" ->"+"readed/"+nName+"_readed.png");
      String fileName = dataPath(m);
      File f = new File(fileName);
      if (f.exists()) {
        f.delete();
      }
  }
  }
}

void removeSensor(){
  Sensores.remove(Sensores.size()-1);
  printPoints();
}

