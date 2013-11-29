function play (key) {
  var filePath = '../sound/' + key + '.wav';
  var audio = new Audio(filePath);
  audio.play();
};

function flash_tweet (user, text) {
  var format = "<p class='tweet' style='display:none'><b style='color:green'>" + user + "</b>: " + text + "</p>"
  $("#tweetInner").prepend(format);
  $(".tweet").fadeIn(
    3000,
    function() { $(this).fadeOut(1500, function() { this.remove() }) }
   )
};

var es = new EventSource(location.origin);
es.onmessage = function(event) {
  var data = JSON.parse(event.data);
  var notes = data.notes;

  flash_tweet(data.user, data.text);
  
  for (var i=0; i < notes.length; i++) {
    play(notes[i]);
  };
};