require('coffee-script');
var muninn = require('muninn');
muninn.init(__dirname);
var Server = muninn.core.Server;
(new Server()).start();

