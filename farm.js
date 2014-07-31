var debug = require('debug')('testbot:farm');
var formatter = require('formatter');
var spawn = require('child_process').spawn;
var path = require('path');
var qs = require('querystring');
var createUrl = formatter('http://localhost:{{ port }}/examples/{{ example }}.html?{{ qs }}');
var bots = {};

exports.stop = function(id) {
  var bot = bots[id];

  if (bot && typeof bot.kill == 'function') {
    bot.kill();
  }
};

exports.start = function(id, opts, callback) {
  var bot;
  var args = [
    '--console',
    '--no-first-run',
    '--enable-logging=stderr',
    '--use-fake-device-for-media-stream', // TODO: customize
    '--use-fake-ui-for-media-stream',
    '--user-data-dir=/tmp/' + id
  ];

  var example = ((opts || {}).example || 'main');
  var url = createUrl({
    port: parseInt(process.env.NODE_PORT, 10) || 6633,
    example: example,
    qs: qs.stringify(opts)
  });

  var spawnOpts = {
    env: {
      DISPLAY: ':99'
    }
  };

  // if the bot already exists, then close that process
  if (bots[id] && typeof bots[id].kill == 'function') {
    bots[id].kill();
  }

  debug('bot ' + id + ' url: ' + url);
  bot = bots[id] = spawn('google-chrome', args.concat([ url ]), spawnOpts);
  bot.on('close', function(code) {
    debug('bot ' + id + ' closed, code: ' + code);
  });

  callback(null, bot);
};
