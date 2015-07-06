from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import os, sys, time, datetime, subprocess, api, csv, socket



#CONFIGS!
visibleDebugger = False
timeBetweenCaptures = 30
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


def getGoogleMapsPict():
	if visibleDebugger==True:
		driver = webdriver.Firefox()
	else:
		driver = webdriver.PhantomJS()
		driver.set_window_size(2300, 2700)
	driver.get(mapQuery)
	time.sleep(5)
	driver.execute_script(addJQuery)
	time.sleep(5)
	driver.execute_script(cleanMapPhantomJS)
	time.sleep(5)
	fileName = imgFoleders+actualTime()+'.png'
	driver.save_screenshot(fileName)
	driver.quit()
	print "Picture file: " + fileName
	


def actualTime():
	actTime = time.time()
	return datetime.datetime.fromtimestamp(actTime).strftime('%Y-%m-%d %H_%M_%S')

def is_connected():
  try:
    host = socket.gethostbyname(REMOTE_SERVER)
    s = socket.create_connection((host, 80), 2)
    return True
  except:
     print "Simon says: F*ck u internet!!"
  return False



def pushDataToApi(lastRegPushed):
	data = {}
	with open(DATAFILE,"rb") as csvfile:
		reader = csv.DictReader(csvfile)
		sensor_id = "nan"
		n = 1
		s = 0
		rowsCount = 0
		for row in reader:
			if(rowsCount > (lastRegPushed*activeSensors)-1):
				if (int(row['gId']) < 79 ):
					if (sensor_id != row['gId']):
						if(s > 0):
							response = api.Data.dynamic_create(data)
						data = {}
						data['id'] =row['gId']
						n = 1
						sensor_id = str(row['gId'])
						s+=1
					dataType = 'datatype'+str(n) 
					data[dataType] = row['datatype']
					sdata = 'data'+str(n)
					data[sdata] =  row['value']
					n += 1
			rowsCount += 1
		print "Sensores Actualizados: "+str(s)
	return lastRegPushed+1
		

def main():
	try:
		lastRegPushed = 0
		while True:
			if(is_connected() == False):
				time.sleep(1)
			else:
				getGoogleMapsPict()
				subprocess.Popen(['open', '-a', 'config_amov.app', '-n', '--args', '.config_amov/config_amov.app'])
				time.sleep(timeBetweenCaptures/2)
				lastRegPushed =  pushDataToApi(lastRegPushed)
				time.sleep(timeBetweenCaptures/2)
			
	except KeyboardInterrupt:
		exit
		print " "
		print "...GoodBye!"
	



if __name__ == '__main__':
	print ">> Getting google.maps imgs..."
	main()
