#!/usr/bin/python

__author__ = "Jeffrey Jose"

import sys, os
import simplejson as json

import tornado.ioloop
import tornado.web
import tornado.options
import tornado.websocket

tornado.options.define("port", default=8000, help="Run on the given port", type=int)

angularAppPath = os.path.abspath(os.path.dirname(__file__))

class Default(tornado.web.RequestHandler):
    '''
    If Tornado doesnt know what to do, let angular take care of the url.
    '''

    def get(self, path):
        '''
        HTTP GET Method handler
        '''
        self.redirect('/#%s' %  path, permanent = True)


class IndexHandler(tornado.web.RequestHandler):
    '''
    Handler to serve the template/index.html
    '''
    def get(self):
        '''
        HTTP GET Method handler
        '''
        with open(angularAppPath + "/index.html", 'r') as file:
            self.write(file.read())     

class StaticHandler(tornado.web.RequestHandler):
    '''
    Handler to serve everything inside static/ directory
    '''

    def get(self): 
        '''
        HTTP GET Method handler
        '''
        self.set_header('Content-Type', '')
        with open(angularAppPath + self.request.uri, 'r') as file:
            self.write(file.read())

class IP(tornado.web.RequestHandler):
    '''
    A sample JSON endpoint to get Hostname -> IP Address mapping

    Access this endpoint at http://localhost:<port>/ip/<hostname>

    ex: http://localhost:8080/ip/highnut or http://localhost:8080/ip/highnut,highfoo
    '''

    def get(self, hosts):
        '''
        HTTP GET Method handler
        '''
        import socket

        result = []

        for host in hosts.split(','):
            try:
                ip = socket.gethostbyname(host.strip())
            except:
                ip = '-na-'

            d = {'name': str(host), 'ip': ip}
            result.append(d)

        return self.write(json.dumps(result))

class wsIP(tornado.websocket.WebSocketHandler):
    '''
    A sample WebSocket endpoint that interprets every keystroke from the browser
    and see whether its a proper hostname or not.

    Access this endpoint at ws://localhost:<port>/ws/ip

    ex: ws://localhost:8080/ws/ip
    '''

    def open(self):
        '''
        Called when a WebSocket connection is established
        '''

    def on_message(self, message):
        '''
        Called when a client sends a message
        '''
        import socket

        input = json.loads(message)

        # Its a good pattern to return a list of dicts
        # as opposed to some other datastructure.
        result = []

        hosts = input['request']

        for host in hosts.split(','):

            if not host:
                continue

            try:
                socket.gethostbyname(host.strip())
            except:
                d = {'name': host, 'status': False}
            else:
                d = {'name': host, 'status': True}

            result.append(d)

        self.respond(input, result)

    def respond(self, input, result):
        '''
        A convenience function that packages the result
        into an object with corresponding input `callback_id`

        Since WebSocket results arent serial, `callback_id` 
        helps client correlate result with the input.
        '''

        output = {}
        output['callback_id'] = input['callback_id']
        output['data']        = result

        self.write_message(output)

    def on_close(self):
        '''
        Called when a WebSocket connection is dropped
        '''

handlers = [
    (r'/',                 IndexHandler), 
    (r'/static/.*',        StaticHandler), 
    (r'/ip/(?P<hosts>.*)', IP),
    (r'/ws/ip',            wsIP),
    (r'/(.*)',             Default),          # When you visit a non-existant link
]


if __name__ == "__main__":

    tornado.options.parse_command_line()

    # Turn debug on to have Tornado restart when you change this file
    # Recommended when you're developing. Dont forget to remove it
    # when you put this in production
    #
    #app = tornado.web.Application(handlers, debug = True)
    #

    app = tornado.web.Application(handlers)
    app.listen(tornado.options.options.port)

    print 'Tornado has started at %s' % tornado.options.options.port
    tornado.ioloop.IOLoop.instance().start()
