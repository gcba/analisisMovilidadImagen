final static String fileSessionName = "gmVirtualSensors_.csv";
final static String defautlDataFIle = "dataSensores.csv";

Table tmpTable;

//Traffic Status
final static int NO_DATA   =  1;
final static int FTRAFFIC  =  2;
final static int NTRAFFIC  =  3;
final static int STRAFFIC  =  4;
final static int VSTRAFFIC =  5;

final String arGMT = "-03:00";

Table   sessionFile;
boolean loadedSession = false;
boolean moveMap = true;
boolean mapShow = true;
boolean showSensores = true;


//map bundle 
final static float latTop     = -34.52023578903147;
final static float latBottom  = -34.71085538182928;
final static float lonRight   = -58.33839787472311;
final static float lonLeft    = -58.53590826514903;

//Output Files
PrintWriter data;
PrintWriter sensorsFile;

final int cTolerance = 5;


int mapX = 0;
int mapY = 0;
int gIdC = 0;

PImage imgBase;
PGraphics sensoresLayer;
//PGraphics zoomImg;
colorC actColor = new colorC((int)random(0,255),(int)random(0,255),(int)random(0,255));

ArrayList<Sensor> Sensores = new ArrayList<Sensor>();
ArrayList<Group> Groups = new ArrayList<Group>();
