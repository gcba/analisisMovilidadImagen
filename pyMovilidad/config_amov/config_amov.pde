import java.io.File;

@ Override boolean displayable() {
  return false;
}


boolean ConfMode = false;
void setup() {
  size(1280, 720);
  cursor(CROSS);
  initApp();
   
 
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


