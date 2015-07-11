app = require('../app')
debug = require('debug')('express-boilerplate:server')
http = require('http')

port = process.env.PORT or '3000'
app.set('port', port)

server = http.createServer(app)
server.listen(port)
