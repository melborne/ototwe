
function play (key) {
  var filePath = '../sound/' + key + '.wav';
  var audio = new Audio(filePath);
  audio.play();
};

var es = new EventSource(location.origin);
es.onmessage = function(event) {
  notes = JSON.parse(event.data);
  for (var i=0; i < notes.length; i++) {
    play(notes[i]);
  };
};