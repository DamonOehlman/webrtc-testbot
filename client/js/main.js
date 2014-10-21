var qs = require('querystring');
var defaults = require('cog/defaults');
var quickconnect = require('rtc-quickconnect');
var getUserMedia = require('getusermedia');
var normalice = require('normalice');

var params = defaults(qs.parse(location.search.slice(1)), {
  signaller: '//switchboard.rtc.io/',
  ice: []
});

var conference = require('rtc-quickconnect')(params.signaller, {
  room: params.room,
  ice: ([].concat(params.ice || [])).map(normalice),
  expectedLocalStreams: params.video ? 1 : 0
});

(params.channels || []).forEach(function(channel) {
  conference.createDataChannel(channel);
});


console.log('connecting to signaller: ' + params.signaller);
conference.on('call:started', function(id, pc) {
  console.log('call started with peer: ' + id);
  console.log('remote stream count: ' + pc.getRemoteStreams().length);
});

conference.on('call:ended', function(id) {
  console.log('call ended with peer: ' + id);
});

if (params.video) {
  getUserMedia({ audio: true, video: true }, function(err, stream) {
    if (err) {
      // TODO: report error
      return console.error(err);
    }

    conference.addStream(stream);
  });
}
