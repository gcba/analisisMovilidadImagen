class colorC {
  public float r;
  public float g;
  public float b;
  colorC (float _r, float _g, float _b) {
    r=_r; 
    g=_g; 
    b=_b;
  }
}


//
ArrayList<colorC> TrafficColors = new ArrayList<colorC> ();

int cTolerance = 5;

void setFColors() {
  TrafficColors.add(new colorC(114, 197, 56));// TRANSITO RAPIDO
  TrafficColors.add(new colorC(236, 104, 0));// TRANSITO NORMAL
  TrafficColors.add(new colorC(224, 0, 0));// TRANSITO LENTO
  TrafficColors.add(new colorC(141, 0, 10));// TRANSITO MUY LENTO
  //TrafficColors.add(new colorC(228, 225, 210));// TRANSITO MUERTO
}
final int ONESECOND = 30;
final int ONEMINUTE = ONESECOND * 60;
float STOREDATAEVERY = ONESECOND;
int mod = 100; //MOD UI

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
final String ACTUALQUERRY = " https://www.google.com.ar/maps/@-34.5563021,-58.4509152,14z/data=!5m1!1e1";
//QUERY GOOGLEMAPS https://www.google.com.ar/maps/@-34.6019934,-58.3773241,16z/data=!5m1!1e1
//QUERY GOOGLEMAPS River-Cruzeiro: https://www.google.com.ar/maps/@-34.5511241,-58.4572881,15z/data=!5m1!1e1
final float LON_MIN = -58.474004;

final float LON_MAX = -58.430359;

final float LAT_MIN = -34.534740;
final float LAT_MAX = -34.567435;

//LEFTV LON -58.484175 RIGTH  LON -58.381006
//TOPV LAT -34.525088  BOTTOM LAT -34.576410
//GMQ https://www.google.com.ar/maps/@-34.5511241,-58.4572881,15z/data=!5m1!1e1

