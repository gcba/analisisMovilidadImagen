class Sensor {
  public int nSensor;
  public float lat,lon;
  public int x,y,id,gId;
  Sensor(int _id, int _gId, int _x, int _y, int _nSensor) {
    y = _y;
    x = _x;
    gId = _gId;
    id  = _id;
    lat = map(y,0,2700,latTop,latBottom);
    lon = map(x,0,2300,lonLeft,lonRight);
    nSensor = _nSensor;
  }
}


class Group{
  public int gId;
  public int gDesc; 
  public colorC gColor;
  Group(int _gId, int _gDesc){
    gDesc = _gDesc;
    gId   = _gId;
    gColor = new colorC((int)random(255),(int)random(255),(int)random(255));
  }
}

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

