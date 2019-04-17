var assert = require('chai').assert;
var request = require('sync-request');

// puts .env into env
require('dotenv').config({silent: true, path: '.env'});

function required_env(key, example) {
  var v = null;
  if (typeof process.env[key] !== 'undefined') {
    v = process.env[key];
  } else {
    var err = key + ' not set. Please set in .env or environment';
    if (example) {
      err += ', e.g. export ' + key + '=' + example;
    }
    throw err;
  }
  return v;
}

var API_BASE_URL = required_env('API_BASE_URL', 'https://mysolution.exosite-staging.com');
var TEST_USER = required_env('TEST_USER', 'testuser@exosite.com');
var TEST_PASSWORD = required_env('TEST_PASSWORD', '3nfffno2-nks');

function api (method) {
  return function (path, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.headers['Connection'] = 'keep-alive';
    return request(method, API_BASE_URL + path, options);
  };
}

// blocking 'it'
var bit = function (label, fun) {
  it(label, function (done) { fun(); done(); });
};

var get = api('get');
var put = api('put');
var post = api('post');
var del = api('delete');

/*
get(path, options)

Request options:
  qs - an object containing querystring values to be appended to the uri
  headers - http headers (default: {})
  body - body for PATCH, POST and PUT requests. Must be a Buffer or String (only strings are accepted client side)
  json - sets body but to JSON representation of value and adds Content-type: application/json. Does not have any affect on how the response is treated.
  cache - Set this to 'file' to enable a local cache of content. A separate process is still spawned even for cache requests. This option is only used if running in node.js
  followRedirects - defaults to true but can be explicitly set to false on node.js to prevent then-request following redirects automatically.
  maxRedirects - sets the maximum number of redirects to follow before erroring on node.js (default: Infinity)
  gzip - defaults to true but can be explicitly set to false on node.js to prevent then-request automatically supporting the gzip encoding on responses.
  timeout (default: false) - times out if no response is returned within the given number of milliseconds.
  socketTimeout (default: false) - calls req.setTimeout internally which causes the request to timeout if no new data is seen for the given number of milliseconds. This option is ignored in the browser.
  retry (default: false) - retry GET requests. Set this to true to retry when the request errors or returns a status code greater than or equal to 400
  retryDelay (default: 200) - the delay between retries in milliseconds
  maxRetries (default: 5) - the number of times to retry before giving up.

Response:
  statusCode - a number representing the HTTP status code
  headers - http response headers
  body - a string if in the browser or a buffer if on the server
*/

var sn = '1';

describe('User', function () {
  before(function (done) {
    get('/debug-command/clean');
    done();
  });

  bit('create new user', function () {
    var res = put('/user/' + TEST_USER, {
      json: {password: TEST_PASSWORD}
    });

    assert.equal(res.statusCode, 200);
  });

  bit('create duplicate user', function () {
    var res = put('/user/' + TEST_USER, {
      json: {password: TEST_PASSWORD}
    });

    assert.equal(res.statusCode, 400);
  });

  bit('login without activation', function () {
    var res = post('/session', {
      json: {email: TEST_USER, password: TEST_PASSWORD}
    });

    assert.equal(res.statusCode, 400);
  });

  bit('login after activation', function () {
    get('/debug-command/activate');
    var res = post('/session', {
      json: {email: TEST_USER, password: TEST_PASSWORD}
    });
    assert.equal(res.statusCode, 200);
  });
});

describe('Provisioning', function () {
  var token;
  before('login to get token', function () {
    var res = post('/session', {
      json: {email: TEST_USER, password: TEST_PASSWORD}
    });
    assert.equal(res.statusCode, 200);
    token = JSON.parse(res.body).token;
  });
  before('remove claimed device', function () {
    post('/user/' + TEST_USER + '/lightbulbs', {
      json: {serialnumber: sn, link: false},
      headers: {'Cookie': 'sid=' + token}
    });
  });

  bit('claim a device', function () {
    var res = post('/user/' + TEST_USER + '/lightbulbs', {
      json: {serialnumber: sn, link: true},
      headers: {'Cookie': 'sid=' + token}
    });

    //console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
  bit('claim a device twice', function () {
    var res = post('/user/' + TEST_USER + '/lightbulbs', {
      json: {serialnumber: sn, link: true},
      headers: {'Cookie': 'sid=' + token}
    });

    assert.equal(res.statusCode, 409);
  });

  bit('read device status', function () {
    var res = get('/user/' + TEST_USER + '/lightbulbs', {
      headers: {'Cookie': 'sid=' + token}
    });

    //console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
});

describe('read/write device', function () {
  var token;
  before('login to get token', function () {
    var res = post('/session', {
      json: {email: TEST_USER, password: TEST_PASSWORD}
    });
    assert.equal(res.statusCode, 200);
    token = JSON.parse(res.body).token;
  });
  bit('write device', function () {
    var res = post('/lightbulb/' + sn, {
      json: {state: 0, hours: 6, temperature: 36.7},
      headers: {'Cookie': 'sid=' + token}
    });
    //console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
  bit('read device', function () {
    var res = get('/lightbulb/' + sn, {
      headers: {'Cookie': 'sid=' + token}
    });
    //console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
  bit('read all user\'s devices', function () {
    // test polling scenario.
    for (var i = 0; i < 2; i++) {
      var res = get('/user/' + TEST_USER + '/lightbulbs', {
        headers: {'Cookie': 'sid=' + token}
      });
    }
    //console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
});

describe('share device', function () {
  var token;
  before('login to get token', function () {
    var res = post('/session', {
      json: {email: TEST_USER, password: TEST_PASSWORD}
    });
    assert.equal(res.statusCode, 200);
    token = JSON.parse(res.body).token;
  });
  bit('share device to user', function () {
    var res = post('/user/' + TEST_USER + '/shared/', {
      json: {serialnumber: sn},
      headers: {'Cookie': 'sid=' + token}
    });
    console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
  bit('drop shared device to user', function () {
    var res = del('/user/' + TEST_USER + '/shared/' + sn, {
      headers: {'Cookie': 'sid=' + token, 'Content-Type': 'application/json'}
    });
    console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
  bit('get shared devices list', function () {
    var res = get('/user/' + TEST_USER + '/shared/', {
      headers: {'Cookie': 'sid=' + token}
    });
    console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
});

describe('alert user', function () {
  var token;
  before('login to get token', function () {
    var res = post('/session', {
      json: {email: TEST_USER, password: TEST_PASSWORD}
    });
    assert.equal(res.statusCode, 200);
    token = JSON.parse(res.body).token;
  });
  bit('alert user when device is off', function () {
    var res = post('/lightbulb/' + sn + '/alert', {
      json: {state:"off", timer:1, email: TEST_USER, active:true, message:"device is off"},
      headers: {'Cookie': 'sid=' + token}
    });
    console.log(res.body.toString());
    assert.equal(res.statusCode, 200);
  });
});
