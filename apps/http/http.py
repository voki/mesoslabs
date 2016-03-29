import sys
import socket
import time
import BaseHTTPServer
import os
import json
import httplib



#print socket.gethostname()

HOST_NAME = socket.gethostname()
PORT_NUMBER = int(7777) 

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
	def do_HEAD(s):
		s.send_response(200)
		s.send_header("Content-type", "text/html")
		s.end_headers()
	def do_GET(s):
                try:
                  connection = httplib.HTTPConnection('httplink.marathon.mesos:10004')
                  headers = {'Content-type': 'application/json'}
                  connection.request('GET', '/', "", headers)
                  response = connection.getresponse()
                  data = json.loads(response.read()) 
                except IOError:
                  data = {'cid' : 'Connection Error...' } 
		s.send_response(200)
		s.send_header("Content-type", "text/html")
		s.end_headers()
		s.wfile.write("<html><head><title>MESOS Cluster Test</title></head>")
#		s.wfile.write("<body><h1> Container ID: %s | Host: %s | Mesos Port: %s | Exposed Port: %s </h1>" % (socket.gethostname(),os.environ['HOST'],os.environ['PORT_7777'],PORT_NUMBER))
                s.wfile.write("<body><h1> Container ID: %s | Exposed Port: %s </h1>" % (socket.gethostname(),PORT_NUMBER))

                s.wfile.write("<h1> Connected to: <span style=\"color: #FF0000;\"> %s </span></h1>" % data['cid'])
		s.wfile.write("</body></html>")

if __name__ == '__main__':
	server_class = BaseHTTPServer.HTTPServer
	httpd = server_class((HOST_NAME, PORT_NUMBER), MyHandler)
	print time.asctime(), "Server Starts - %s:%s" % (HOST_NAME, PORT_NUMBER)
	try:
		httpd.serve_forever()
	except KeyboardInterrupt:
		pass
	httpd.server_close()
	print time.asctime(), "Server Stops - %s:%s" % (HOST_NAME, PORT_NUMBER)
		
