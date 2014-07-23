var server = require('http').createServer();
var app = require('firetruck')(server);

app('/bot/:id', require('./actions'));

server.listen(3000);
