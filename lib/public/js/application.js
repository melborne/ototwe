var SOUND_PATH = '../sound/';
var AUDIO_EXT = (function() {
  var audio = new Audio();
  var ext = '';
  if (audio.canPlayType('audio/wav')=='maybe') { ext = 'wav' }
  else if (audio.canPlayType('audio/mp3')=='maybe') { ext = 'mp3' }
  else if (audio.canPlayType('audio/ogg')=='maybe') { ext = 'ogg' };
  return ext;
})();

function play (key) {
  var filePath = SOUND_PATH + key + '.' + AUDIO_EXT;
  var audio = new Audio(filePath);
  audio.play();
};

var es = new EventSource(location.origin);
es.onmessage = function(event) {
  play(event.data);
};