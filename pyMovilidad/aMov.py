from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import os, sys, time, datetime, subprocess, api, csv, socket, os.path
from os import rename 	



#CONFIGS!
visibleDebugger = False
timeBetweenCaptures = 120
activeSensors = 1102

bugFixed = True
imgFoleders = "./config_amov/config_amov.app/Contents/Java/data/"
DATAFILE    = "./config_amov/dataSensores.csv"

REMOTE_SERVER = "www.google.com.ar"



#Google maps query
mapQuery = "https://www.google.com.ar/maps/@-34.6155361,-58.4371677,14z/data=!5m1!1e1"

#JS Scripts
addJQuery =  """var jq = document.createElement('script'); 
				jq.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'; 
				document.getElementsByTagName('head')[0].appendChild(jq); 
				//
			"""

cleanMap  = """
			var main_child = $('#inproduct-guide-modal'); 
			var container = main_child.parent(); 
			for (var j = 0; j < 5 ; j++) {
				var siblings = main_child.siblings(); 
				for (var i=0; i<siblings.length; i++) { 
					$(siblings[i]).remove()
				} 
				main_child = $(container); 
				container = $(container.parent());
			}
			"""

cleanMapPhantomJS = """
					while( $( "#inproduct-guide-modal" ).length ){
					$("#inproduct-guide-modal").remove();
					}
					"""


def getGoogleMapsPict(retry = 0):
	print ">> Obteniendo imagenes de  google.maps..."
	try:
		if visibleDebugger==True:
			driver = webdriver.Firefox()
		else:
			driver = webdriver.PhantomJS()
			driver.set_window_size(2300, 2700)
			try:
				driver.get(mapQuery)
				time.sleep(5)
				driver.execute_script(addJQuery)
				time.sleep(5)
				driver.execute_script(cleanMapPhantomJS)
				time.sleep(5)
			except Exception as e:
				retry +=1
				msg = "FALLO PHANTOMJS,(%s))Reintentando (%d)" % e,retry
				log(msg)
				getGoogleMapsPict(retry)
		fileName = imgFoleders+actualTime()+'.png'
		driver.save_screenshot(fileName)
		driver.quit()
	except Exception , e:
		retry += 1
		msg = "FALLO PHANTOMJS, Reintentando (%d)" % retry
		log(msg)
		getGoogleMapsPict(retry)

	print "Picture file: " + fileName
	return fileName


def actualTime():
	actTime = time.time()
	return datetime.datetime.fromtimestamp(actTime).strftime('%Y-%m-%d %H_%M_%S')


SESSION = actualTime()



def is_connected():
  try:
    host = socket.gethostbyname(REMOTE_SERVER)
    s = socket.create_connection((host, 80), 2)
    return True
  except:
  	log("DESCONECTADO DE INTERNET")
  return False



def pushDataToApi(lastRegPushed):
	log("Pusheando datos a la api...")
	data = {}
	with open(DATAFILE,"rb") as csvfile:
		reader = csv.DictReader(csvfile)
		sensor_id = "nan"
		c = 1
		firstValue = True
		rowsCount = 0
		s = 0
		r = 1
		for row in reader:
			if(s >= lastRegPushed):	
				if(is_connected() == True):
					if(sensor_id != row['gId'] & firstValue != True):
						try:
							log("Pusheando sensor: %s " % str(row['gId']))
							response = api.Data.dynamic_create(data)
							log("Push CORRECTO sensor: %s" % str(row['gId'])
						except Exception as e:
							log("!!!! FALLO PUSH DEL SENSOR: %s !!!!" % str(row['gId'])
						sensor_id = row['gId']
						data = {}
						r = 1
					data = {
					'id%n'%r :sensor_id,
					'datatype%d' % r:row['datatype'],
					'data%d' % r : row['value'],
					}
					r+=1
					firstValue = False
				else:
					log('!!! FALLO CONEXION A INTERNET !!!')
			s += 1	
	return lastRegPushed+s

		

def clearDataSensorFile():
	if(os.path.isfile(DATAFILE)):
		busdf = 0
		nn = "./config_amov/dataSensores.csv.%d.old" % busdf
		while os.path.isfile(nn):
			busdf +=1 
			nn = "./config_amov/dataSensores.csv.%d.old" % busdf
		os.renames(DATAFILE,nn)
		with open(DATAFILE,'w') as sensorDB:
			sensorDB.write("id,value,gId,datatype,refImg,timestamp\n")
		sensorDB.close()
		log("Backup de Archivo datos \"%s\" salvado bajo el nombre: %s" % (DATAFILE,nn))



def main():
	try:
		log("Inicio de session")
		#clearDataSensorFile()
		lastRegPushed = 0
		while True:
			if(is_connected() == False):
				time.sleep(1)
			else:
				inTime = time.time()
				i = getGoogleMapsPict()
				if(os.path.isfile(i)):
					log("Analizando Imagen")
					pro = subprocess.Popen(['open', '-a', 'config_amov.app', '-n', '--args', '.config_amov/config_amov.app'])
					while os.path.isfile(i): 
						time.sleep(1)
					time.sleep(6)
				lastRegPushed =  pushDataToApi(lastRegPushed)
				wait_time = int(timeBetweenCaptures - (time.time()-inTime))
				if wait_time > 0:
					msg = ">> wait: "+str(wait_time)+" segundos."
					log(msg)
					time.sleep(wait_time) 
				else:
					msg = "** Desfasado en tiempo deseado por: "+str(abs(wait_time))+" segs **"
					log(msg)
	except KeyboardInterrupt as e:
		log("Sesion terminada (%s)" % e)
		exit

	

def log(errorMsg):
	now = actualTime()
	filelog = "gm_%s_logs.txt" % SESSION
	with open(filelog, 'a') as logFile:
		msg = ">> [%s]: %s \n" %(now,errorMsg)
		logFile.write(msg)
		print msg



if __name__ == '__main__':
	main()
