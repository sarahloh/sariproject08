
/**
 * Module dependencies.
 */

var path = require('path');
var twitter = require('./lib/twitter.js');
var twit = twitter.twit;
var filter = require('bad-words');

var WebSocketServer = require('ws').Server
  , http = require('http')
  , express = require('express')
  , app = express();

// all environments
app.set('port', process.env.PORT || 4000);
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(__dirname + '/public'));

app.get('/twitter', twit.gatekeeper('/login'));
app.get('/twauth', twit.login());

var server = http.createServer(app).listen(app.get('port'), function() {
  console.log('server running on port ' + app.get('port'));
});

var wss = new WebSocketServer({server: server});
wss.on('connection', function(ws) {
  var id = setInterval(function() {
  //  ws.send(JSON.stringify(process.memoryUsage()), function() { /* ignore errors */ });
  }, 100);
// Start streaming tweets containing #sariwit
  twit.stream('statuses/filter', {track: '#sariwit'}, function(stream) {
    stream.on('data', function(data) {
      var tweet = data.text;
      tweet = tweet.replace(/(\r\n|\n|\r)/gm,"");
      tweet = filter.clean(tweet);
      var photo = data.user.profile_image_url;
      photo = photo.replace("_normal","");
      var message = {
        tweet: tweet,
        photo: photo
      };
      ws.send(JSON.stringify(message));
      console.log(message);
    });
// Destroy stream
    //setTimeout(stream.destroy, 5000);
  });

  console.log('started client interval');
  ws.on('close', function() {
    console.log('stopping client interval');
    clearInterval(id);
  });
});
