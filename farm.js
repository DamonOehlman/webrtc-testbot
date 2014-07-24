var debug = require('debug')('testbot:farm');
var spawn = require('child_process').spawn;
var path = require('path');
var qs = require('querystring');
var bots = {};

exports.start = function(id, opts, callback) {
  var bot;
  var args = [
    '--console',
    '--no-first-run',
    '--use-fake-device-for-media-stream', // TODO: customize
    '--use-fake-ui-for-media-stream',
    '--user-data-dir=/tmp/' + id
  ];

  var example = ((opts || {}).example || 'main');
  var url = 'http://localhost:3000/examples/' + example + '.html?' + qs.stringify(opts);

  var spawnOpts = {
    env: {
      DISPLAY: ':99'
    }
  };

  debug('bot ' + id + ' url: ' + url);
  bot = spawn('google-chrome', args.concat([ url ]), spawnOpts);
  bot.on('close', function(code) {
    debug('bot ' + id + ' closed, code: ' + code);
  });

  bot.stdout.on('data', function (data) {
    console.log('stdout: ' + data);
  });

  bot.stderr.on('data', function (data) {
    console.log('stderr: ' + data);
  });

  callback();
};
