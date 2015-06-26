#Nuevo script pseudo-hack google.maps
from selenium import webdriver
from PIL import Image
import sys, os, datetime, time


#def loadSensorsList():
QUERY = "https://www.google.com.ar/maps/@-34.6133463,-58.4389702,14z/data=!5m1!1e1"
TIME_BETWEEN_IMGS = 30 #en segundos
JQUERY = open("./jquery/jquery.js")
addJQuery = "var jq = document.createElement('script'); jq.src = \"https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js\"; document.getElementsByTagName(\'head\')[0].appendChild(jq); //jQuery.noConflict();"
cleanMap  = "var main_child = $(\'.widget-scene-canvas\'); var container = main_child.parent(); while (main_child.prop(\"tagName\") != \'BODY\') {console.log(container.prop(\"tagName\")); var siblings = main_child.siblings(); for (var i=0; i<siblings.length; i++) { $(siblings[i]).remove()} main_child = $(container); container = $(container.parent());}"

def getGoogleImgs():
	driver = webdriver.PhantomJS("./phantomjs/bin/phantomjs")
	driver.set_window_size(2300, 2700)
	driver.get(QUERY)
	time.sleep(5) #Espero 10 segundo download de la pagina
	driver.execute_script(addJQuery)
	print "JQuery Added!"
	time.sleep(2)#wait a few seconds..
	driver.execute_script(cleanMap)
	print "Canvas cleaned!"
	time.sleep(2)#wait a second...
	st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
	picName = st+'.png'
	
	driver.save_screenshot(picName)
	print "Saved screenshot named: "+picName
	driver.close()
	
def thowProcessing():
	pass
 
def pushDataInApi():
	pass


def main():
	try:
		while True:
			getGoogleImgs()
			thowProcessing()
			#msg = 'Next screenshot in: ' + TIME_BETWEEN_IMGS + 'segs.'
			#print msg
			for i in xrange(1,TIME_BETWEEN_IMGS):
				time.sleep(1)
	except  KeyboardInterrupt:
		exit
	


if __name__ == '__main__':
	print "Adquiriendo mapas..."
	main()
	print "GoodBye!"
