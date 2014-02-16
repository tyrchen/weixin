var express = require('express');
var webot = require('weixin-robot');
var configs = require('./configs');

var log = require('debug')('webot-example:log');
var verbose = require('debug')('webot-example:verbose');

var RedisStore = require('connect-redis')(express);

var app = express();

var wx_token = process.env.WX_TOKEN;

require('./rules')(webot);

webot.watch(app, { token: wx_token, path: '/' });

app.use(express.cookieParser());
app.use(express.session({ secret: process.env.SESS_SECRET, store: new RedisStore }));

var port = process.env.PORT;

app.listen(port, function(){
  log("Listening on %s", port);
});

if(!process.env.DEBUG){
  console.log("set env variable `DEBUG=webot-example:*` to display debug info.");
}
