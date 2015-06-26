from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
import os, sys, time, datetime, subprocess, api

#CONFIGS!
visibleDebugger = False
timeBetweenCaptures = 30
bugFixed = True
imgFoleders = "./data/"

#Google maps query
mapQuery = "https://www.google.com.ar/maps/@-34.6155361,-58.4371677,14z/data=!5m1!1e1"

#JS Scripts
addJQuery =  """var jq = document.createElement('script'); 
				jq.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'; 
				document.getElementsByTagName('head')[0].appendChild(jq); 
			"""
cleanMap  = """
			var main_child = $('.widget-scene-canvas'); 
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

def getGoogleMapsPict():
	if visibleDebugger==True:
		driver = webdriver.Firefox()
	else:
		driver = webdriver.PhantomJS("./phantomjs/bin/phantomjs")
		driver.set_window_size(2300, 2700)
	driver.get(mapQuery)
	time.sleep(1)
	fileName = imgFoleders+actualTime()+'.png'
	driver.save_screenshot(fileName)
	driver.quit()
	print "Picture file: " + fileName
	


def actualTime():
	actTime = time.time()
	return datetime.datetime.fromtimestamp(actTime).strftime('%Y-%m-%d %H:%M:%S')


def pushDataToApi():
	print ">> Ejecuto pushDataToApi()"

def launchProcessing():
	print ">> Ejecuto launchProcessing()"


def main():
	try:
		while True:
			getGoogleMapsPict()
			launchProcessing()
			pushDataToApi();
			for t in xrange(0,timeBetweenCaptures):
				time.sleep(1)
			
	except KeyboardInterrupt:
		exit
		print " "
		print "...GoodBye!"
	
	


if __name__ == '__main__':
	print "Starting..."
	print ">> Getting google.maps imgs..."
	main()