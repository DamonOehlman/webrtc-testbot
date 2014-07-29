var server = require('http').createServer();
var app = require('firetruck')(server);
var port = parseInt(process.env.NODE_PORT, 10) || 6633;

app('/bot/:id', require('./actions'));

server.listen(port);
