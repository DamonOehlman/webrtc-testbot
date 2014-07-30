var qs = require('querystring');
var defaults = require('cog/defaults');
var quickconnect = require('rtc-quickconnect');
var getUserMedia = require('getusermedia');
var normalice = require('normalice');

var params = defaults(qs.parse(location.search.slice(1)), {
  signaller: 'http://switchboard.rtc.io/',
  iceServers: []
});

var qc;

function connect(stream) {
  // create a quickconnect instance
  qc = require('rtc-quickconnect')(params.signaller, {
    room: params.room,
    iceServers: (params.iceServers || []).map(normalice)
  });

  (params.channels || []).forEach(function(channel) {
    qc.createDataChannel(channel);
  });

  if (stream) {
    qc.addStream(stream);
  }

  console.log('connecting to signaller');
  qc.on('call:started', function(id, pc) {
    console.log('call started with peer: ' + id);
    console.log('remote stream count: ' + pc.getRemoteStreams().length);
  });

  qc.on('call:ended', function(id) {
    console.log('call ended with peer: ' + id);
  });
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
