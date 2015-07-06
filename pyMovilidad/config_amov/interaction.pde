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
    if(key =='G'){Groups.add(new Group(Groups.size(),Groups.size()));}
    if(key =='P'){showSensores = !showSensores;}
    if(key =='E'){eraseAllData();}
    if(key =='C'){evaluateSensors();}
    
  }
}


void mousePressed(){
     int x = mouseX+mapX; int y = mouseY+mapY; 
     color c = imgBase.get(x,y);
     int r = (int)red(c); int g =(int)green(c); int b = (int)blue(c); 
     //
     println("R:"+(int)red(c)+" G:"+(int)green(c)+" B:"+(int)blue(c));
    int cm = matchColor(r,g,b);  
    if(cm > -1){
      
     addSensor(x,y);
     printPoints();
    }
}
