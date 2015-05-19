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
float STOREDATAEVERY = 60 * ONESECOND;
int mod = 100; //MOD UI

//QUERY GOOGLEMAPS https://www.google.com.ar/maps/@-34.6019934,-58.3773241,16z/data=!5m1!1e1
