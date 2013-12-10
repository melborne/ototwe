var audio_ext = (function() {
  var audio = new Audio();
  var ext;
  if (audio.canPlayType('audio/mp3')=='maybe') { ext = 'mp3' }
  else if (audio.canPlayType('audio/ogg')=='maybe') { ext = 'ogg' };
  return ext;
})();

var Sound = {};
var context = new AudioContext();
Sound.gainNode = context.createGain();
Sound.gainNode.gain.value = 0.25;

var SAMPLE_URLS = ['../sound/E3p.' + audio_ext, '../sound/C3p.' + audio_ext];

Sound.play = function(urls) {
  var source = context.createBufferSource();
  var bufferLoader = new BufferLoader(
    context,
    urls,
    finishedLoading
    );
  bufferLoader.load();
};

Sound.volume = function(element) {
  var fraction = parseInt(element.value) / parseInt(element.max);
  this.gainNode.gain.value = fraction * fraction;
};

$('#volume').bind('change', function(event, ui) {
  Sound.volume(this);
});

function finishedLoading(bufferList) {
  for (var i=0; i < bufferList.length; i++) {
    var source = this.context.createBufferSource();
    source.buffer = bufferList[i];
    source.connect(Sound.gainNode);
    Sound.gainNode.connect(this.context.destination)
    source.start(0);
    this.source = source;
  }
}

function flashTweet (user, text) {
  var format = "<p class='tweet' style='display:none'><b style='color:green'>" + user + "</b>: " + text + "</p>"
  $("#tweetInner").prepend(format);
  $(".tweet").fadeIn(
    3000,
    function() { $(this).fadeOut(3000, function() { this.remove() }) }
   )
};

function updateClientCounter (clients) {
  $("#audience").val(clients);
};

var es = new EventSource(location.origin);

es.onmessage = function(event) {
  var data = JSON.parse(event.data);
  var clients = data.clients;
  var notes = data.notes;

  if (clients) {
    updateClientCounter(clients);
  };

  if (notes) {
    flashTweet(data.user, data.text);
  
    var urls = new Array();
    for (var i=0; i < notes.length; i++) {
      urls.push('../sound/' + notes[i] + '.' + audio_ext);
    };
    Sound.play(urls);
  };
};
