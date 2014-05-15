
/**
 * Module dependencies.
 */

var util = require('util'),
    twitter = require('twitter');
var twit = new twitter({
    consumer_key: 'PUT YOUR KEY HERE',
    consumer_secret: 'PUT YOUR SECRET HERE',
    access_token_key: 'PUT YOUR KEY HERE',
    access_token_secret: 'PUT YOUR SECRET HERE'
});

exports.twit = twit;
