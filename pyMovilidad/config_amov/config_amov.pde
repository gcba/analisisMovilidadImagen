/*
** @ Override boolean displayable() {
  return false;
}
*/

boolean ConfMode = false;
void setup() {
  size(1280, 720);
  cursor(CROSS);
  setFColors();
  initApp();
  //mercatorMap = new MercatorMap(2300, 2700, latTop, latBottom, lonLeft, lonRight); 
 
}

void draw() {
  if(ConfMode == true){
  background(230);
  if(mapShow == true){image(imgBase,-mapX,-mapY);}
  //
  if(showSensores == true){image(sensoresLayer,-mapX,-mapY);}
  
  int x = mouseX+mapX; int y = mouseY+mapY; 
  color c = imgBase.get(x,y);
  int r = (int)red(c); int g =(int)green(c); int b = (int)blue(c);
  fill(c);
  noStroke();
 ellipse(mouseX+20,mouseY+20,20,20); 
  } else{
    loadSession();
    evaluateSensors();
    exit();
  }
}


void keyPressed() {
  if(key == CODED){
    if(keyCode == RIGHT){mapX+=10; if(mapX > 1020){mapX = 1020;}}
    if(keyCode == LEFT){mapX-=10; if(mapX < 0){mapX = 0;}}
    if(keyCode == DOWN){mapY+=10; if(mapY > 1979){mapY = 1979;}}
    if(keyCode == UP){mapY-=10; if(mapY < 0){mapY = 0;}}
  } else{
    if(key =='M'){mapShow=!mapShow;}
    if(key =='S'){saveSession();}
    if(key =='L'){loadSession();}
    if(key =='D'){removeSensor();}
    if(key =='G'){Groups.add(new Group(Groups.size(),"Grupo id: "+Groups.size()));}
    if(key =='P'){showSensores = !showSensores;}
    if(key =='E'){eraseAllData();}
    
  }
}


void mousePressed(){
     int x = mouseX+mapX; int y = mouseY+mapY; 
     color c = imgBase.get(x,y);
     int r = (int)red(c); int g =(int)green(c); int b = (int)blue(c);   
    if(matchColor(r,g,b) > -1){
     addSensor(x,y);
     printPoints();
    }
}

void addSensor(int px,int py){
  if (Groups.size() == 0){
        Group g = new Group(Groups.size(),"Grupo id: "+Groups.size());
         Groups.add(g);
       }
 Sensores.add(new Sensor(Sensores.size(), Groups.size()-1/* cambiar grupos */,px,py)); 
 printPoints();
}

void addSensor(int px,int py, int gId){
 Sensores.add(new Sensor(Sensores.size(), gId,px,py)); 
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
