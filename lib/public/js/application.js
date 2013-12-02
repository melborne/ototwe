var audio_ext = (function() {
  var audio = new Audio();
  var ext;
  if (audio.canPlayType('audio/mp3')=='maybe') { ext = 'mp3' }
  else if (audio.canPlayType('audio/ogg')=='maybe') { ext = 'ogg' };
  return ext;
})();

var context = (function() {
  var cont;
  if(typeof(webkitAudioContext)!=="undefined") {
    cont = new webkitAudioContext()
  } else if(typeof(AudioContext)!=="undefined") {
    cont = new AudioContext();
  }
  return cont;
})();

var bufferLoader;

function playsound(urls) {
  bufferLoader = new BufferLoader(
    context,
    urls,
    finishedLoading
    );

  bufferLoader.load();
}

function finishedLoading(bufferList) {
  for (var i=0; i < bufferList.length; i++) {
    source = context.createBufferSource();
    source.buffer = bufferList[i];
    source.connect(context.destination);
    source.start(0);
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
    playsound(urls);
  };
};

