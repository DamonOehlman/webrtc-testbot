var qs = require('querystring');
var defaults = require('cog/defaults');
var quickconnect = require('rtc-quickconnect');
var getUserMedia = require('getusermedia');

var params = defaults(qs.parse(location.search.slice(1)), {
  signaller: 'http://switchboard.rtc.io/'
});

var qc;

function connect(stream) {
  // create a quickconnect instance
  qc = require('rtc-quickconnect')(params.signaller, {
    room: params.room
  });

  (params.channels || []).forEach(function(channel) {
    qc.createDataChannel(channel);
  });

  if (stream) {
    qc.addStream(stream);
  }
}

if (params.video) {
  getUserMedia({ audio: true, video: true }, function(err, stream) {
    if (err) {
      // TODO: report error
      return;
    }

    connect(stream);
  });
}
else {
  connect();
}
