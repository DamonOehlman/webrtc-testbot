var debug = require('debug')('testbot:farm');
var spawn = require('child_process').spawn;
var path = require('path');
var mkdirp = require('mkdirp');
var qs = require('querystring');
var bots = {};

exports.start = function(id, opts, callback) {
  var bot;
  var profiledir = path.resolve(__dirname, 'profiles', id);
  var args = [
    '--console',
    '--no-first-run',
    '--use-fake-device-for-media-stream', // TODO: customize
    '--use-fake-ui-for-media-stream',
    '--user-data-dir=' + profiledir
  ];

  var example = ((opts || {}).example || 'main');
  var url = 'http://localhost/examples/' + example + '.html?' + qs.stringify(opts);

  var spawnOpts = {
    env: {
      DISPLAY: ':99'
    }
  };

  // TODO: kill existing bot if it exists

  mkdirp(profiledir, function(err) {
    if (err) {
      return callback(err);
    }

    debug('bot ' + id + ' url: ' + url);
    bot = spawn('google-chrome', args.concat([ url ]), spawnOpts);

    callback();
  });
};
