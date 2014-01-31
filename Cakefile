#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Katra
#|
#| Muninn is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# cake utils
#
fs = require 'fs'
util = require 'util'
{exec} = require 'child_process'


#
# Build Source
#
#
task 'build:src', 'Build the coffee template', ->

  #
  # compile individual modules
  #
  exec 'coffee -o tmp -c src', ($err, $stdout, $stderr) ->

    util.log $err if $err if $err?
    util.log $stderr if $stderr if $stderr?
    util.log $stdout if $stdout if $stdout?
    util.log 'ok' unless $stdout?


    #
    # link the modules we compiled
    #
    #exec 'browserify --debug tmp/main.js | uglifyjs  > www/js/app.js', ($err, $stdout, $stderr) ->
    exec 'browserify --debug tmp/main.js  > www/js/app.js', ($err, $stdout, $stderr) ->

      util.log $err if $err if $err?
      util.log $stderr if $stderr if $stderr?
      util.log $stdout if $stdout if $stdout?
      util.log 'ok' unless $stdout?

#      exec 'browserify --debug --standalone liquid node_modules/huginn-liquid/lib/liquid.js | uglifyjs > www/js/hLiquid-0.0.6.min.js', ($err, $stdout, $stderr) ->
#
#        util.log $err if $err if $err?
#        util.log $stderr if $stderr if $stderr?
#        util.log $stdout if $stdout if $stdout?
#        util.log 'ok' unless $stdout?

