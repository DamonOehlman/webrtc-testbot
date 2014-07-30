var concat = require('concat-stream');
var farm = require('./farm');

exports.GET = function(req) {
  this.json({ hi: 'there' });
};

exports.PUT = function(req) {
  var handler = this;

  req.pipe(concat(function(data) {
    try {
      data = JSON.parse(data.toString());
    }
    catch (e) {
      return handler.error(e);
    }

    farm.start(handler.params.id, data, function(err, bot) {
      if (err) {
        return handler.error(err);
      }

      handler.sse(function(writer) {
        bot.stdout.on('data', writer('stdout'));
        bot.stderr.on('data', writer('stderr'));
        bot.on('close', writer.close);
      });
    });
  }));
};
